#!/usr/bin/env python
import scipy.io as sio
import numpy as np
import os
import sys
import string
import time
import scipy.ndimage
from subFun import  createFolder, linmap, spPool3DSig
from subroutine import maxPool3DMat
tvFolder = '/home/data/MED/'
dataRoot = '/home/hzhang57/NEW_WORLD/Project_2_ROOT/DATA'
bbFolder = '/home/hzhang57/NEW_WORLD/Project_5_ROOT/DATA/REGION'
################### Only modify this part##################
tarFmt = '.7z'
feat = 'DRN50_L5A'
featIdx = 'F5A'
dataSet = 'E021-E040_10Ex'
featRange = [1 , 7] 
##########################################################
fileList   = os.path.join(tvFolder, 'STRUCTURE', dataSet + '.txt')
featFolder = os.path.join(tvFolder, 'Features', dataSet, feat) 
bbSetFolder= os.path.join(bbFolder, dataSet, 'BOUND_BOX')

createFolder(os.path.join(dataRoot, 'FastSP'))
createFolder(os.path.join(dataRoot, 'FastSP', dataSet))
outFolder  = os.path.join(dataRoot, 'FastSP', dataSet, feat)
createFolder(outFolder)

createFolder(os.path.join(dataRoot, 'FastSTA'))
createFolder(os.path.join(dataRoot, 'FastSTA', dataSet))
staFolder = os.path.join(dataRoot, 'FastSTA', dataSet, feat)
createFolder(staFolder)

ArgvLen = len(sys.argv)

if ArgvLen != 3:
	print ("-"*30)
	print("Number of argv is not correct\n Please specify start and end number")
	print("-"*30)
	exit(0)

stLine = string.atoi(sys.argv[1])
edLine = string.atoi(sys.argv[2])
cntRange = range(stLine -1, edLine)
fid = open(fileList, 'r')
vidList = fid.readlines()
fid.close()
vidNum  = len(vidList)
Disp = '|' + str(vidNum) + '|' + str(edLine) + '-' + str(stLine - 1) + '-'
for cnt in cntRange:
	vid = vidList[cnt].strip()
	# print vid
	vidBBFolder   = os.path.join(bbFolder,dataSet,'BOUND_BOX', vid)
	vidOutMat     = os.path.join(outFolder, vid + '.mat')
	outTarPath    = os.path.join(outFolder, vid + '.7z')
	if os.path.exists(outTarPath) and not (os.path.exists(vidOutMat)):
		continue
	else:
		vidFeatFile = os.path.join(featFolder, vid + '.7z')
		cmd1 = '7z x ' + vidFeatFile + ' -o./temp/'
		os.system(cmd1)
		vidTempFile = os.path.join('./temp', vid + '.mat')
		vidMatTemp  = sio.loadmat(vidTempFile)
		cmd2 = 'rm ./temp/' + vid + '.mat'
		os.system(cmd2)
		###########################################
		vidMat = vidMatTemp[featIdx]
		###########################################
		[Dim, H, nW] = vidMat.shape
		n = nW / H
		for sigKF in range(1, n+1):
			if sigKF % 2 == 0:
				continue
			else:
				id1 = sigKF * H
				id2 = sigKF * H - H
				sigFeat = vidMat[:,:, id2:id1]
				bbKF = os.path.join(vidBBFolder, vid + '_'+ str(sigKF) +'_OKF.mat') 
				temp = sio.loadmat(bbKF)
				boxes= temp['boxes']
				# mapping form [1-368] [1-480] to [1-7][1-7]
				mapBox = np.zeros(boxes.shape)
				mapBox[:,0] = np.floor(linmap(boxes[:,0], [1,360], featRange))
				mapBox[:,1] = np.floor(linmap(boxes[:,1], [1,480], featRange))
				mapBox[:,2] = np.floor(linmap(boxes[:,2], [1,360], featRange))
				mapBox[:,3] = np.floor(linmap(boxes[:,3], [1,480], featRange))
				for bcnt in range(0, len(boxes)):
					print Disp + str(cnt) + '|' + str(sigKF) + '/' +  str(n) + '|' + str(bcnt) + '/' + str(len(boxes))
					#print mapBox[bcnt,:]
					spFeat = spPool3DSig(sigFeat, mapBox[bcnt,:])
					[Dim, xAxis, yAxis] = spFeat.shape
					# bilinear Enlarge
					spStaFeat = scipy.ndimage.interpolation.zoom(spFeat, [1, float(7)/xAxis, float(7)/yAxis])			
					# SPP & Save
					sp1 = maxPool3DMat(spStaFeat, (7,7),1)
					sp2 = maxPool3DMat(spStaFeat, (6,6),1)
					sp3 = maxPool3DMat(spStaFeat, (5,5),1)
					sp4 = maxPool3DMat(spStaFeat, (2,2),1)
					spAll = np.concatenate((sp1, sp2, sp3, sp4), axis =0)
					if (sigKF == 1) and (bcnt == 0):
						vidFeat = np.array(spAll) 
					else:
						vidFeat = np.concatenate((vidFeat, spAll), axis=0 )
		staFile = os.path.join(staFolder, vid + '.mat')
		matShape = vidFeat.shape
		kfcnt    = matShape[0]
		sio.savemat(staFile, {'kfcnt':kfcnt})
		sio.savemat(vidOutMat, {'vidFeat':vidFeat})
		tempTar = './temp/' + vid + '.7z'
		cmd2 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + tempTar + ' ' + vidOutMat
		cmd3 = 'rm ' + vidOutMat
		cmd4 = 'mv ' + tempTar + ' ' +outTarPath
		os.system(cmd2 + '\n' + cmd3 + '\n' + cmd4 + '\n')
