#!/usr/bin/env python
import scipy.io as sio
import numpy as np
import os
import sys
import string
from subroutine import maxPool3DMat, createFolder

dataRoot     = '/home/hzhang57/NEW_WORLD/Project_2_ROOT/DATA'
trecvidFolder = '/home/data/MED'
###----------only modify this part-----------------------
fmt = '.mat'
tarFmt = '.7z'
feature = 'DRN50_L3D'
dataSet = 'MED14_Test'
###---------------------------------------------
fileList   = os.path.join(trecvidFolder, 'STRUCTURE', dataSet+'.txt')
featureFolder = os.path.join(trecvidFolder,'Features', dataSet, feature)
createFolder(os.path.join(dataRoot, 'Tar_SPMAX'))
createFolder(os.path.join(dataRoot, 'Tar_STA'))
createFolder(os.path.join(dataRoot, 'Tar_SPMAX', dataSet))
createFolder(os.path.join(dataRoot, 'Tar_STA', dataSet))
outFolder     = os.path.join(dataRoot, 'Tar_SPMAX',dataSet, feature)
staFolder     = os.path.join(dataRoot, 'Tar_STA',dataSet, feature)
createFolder(outFolder)
createFolder(staFolder)

ArgvLen = len(sys.argv)
if ArgvLen!= 3:
	print ("-" * 30)
	print("Number of argv is not correct\n please specify start and end number")
	print ("-" * 30)
	exit(0)
stLine = string.atoi(sys.argv[1])
edLine = string.atoi(sys.argv[2])
cntRange = range(stLine-1, edLine)
fid = open(fileList)
vidList = fid.readlines()
vidNum  = len(vidList)
Disp = '|' + str(vidNum) + '|' + str(edLine) + '----' + str(stLine -1) + ':'
for cnt in cntRange:
	print Disp + str(cnt)
	vid = vidList[cnt].strip()
	outFeatPath = os.path.join(outFolder, vid + fmt)
	outTarPath = os.path.join(outFolder, vid + '.7z')
	if os.path.exists(outTarPath):
		continue
	else:
		vidFeatFile = os.path.join(featureFolder, vid + tarFmt)
		cmd1 = '7z x ' + vidFeatFile + ' -o./temp/'
		os.system(cmd1)
		vidTempFile =  os.path.join('./temp', vid + fmt)
		vidMatTemp  = sio.loadmat(vidTempFile)
		cmd2 = 'rm ./temp/' + vid + fmt
		os.system(cmd2) 
		######################################
		vidMat      = vidMatTemp['F3D']
		######################################
		[Dim, H, nW] = vidMat.shape
		n = nW / H
		for sigKF in range(1, n+1):
			id1 = sigKF * H
			id2 = sigKF * H - H
			sigFeat = vidMat[:,:,id2:id1]
			sp1   = maxPool3DMat(sigFeat, (28,28),4)
			sp2   = maxPool3DMat(sigFeat, (24,24),4)
			sp3   = maxPool3DMat(sigFeat, (20,20),4)
			sp4   = maxPool3DMat(sigFeat, (8,8),4)
			spFeat = np.concatenate((sp1, sp2, sp3, sp4),axis=0)
			if sigKF == 1:
				vidFeat = np.array(spFeat)
			else:
				vidFeat = np.concatenate((vidFeat, spFeat), axis=0)
		staFile = os.path.join( staFolder, vid + '.mat')
		matShape = vidFeat.shape
		kfcnt   = matShape[0]
		sio.savemat(staFile, {'kfcnt':kfcnt})
		sio.savemat(outFeatPath, {'vidFeat':vidFeat})
		tempTar = './temp/' + vid + '.7z'
		cmd2 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + tempTar + ' ' + outFeatPath
		cmd3 = 'rm '+ outFeatPath
		cmd4 = 'mv ' +  tempTar + ' ' + outTarPath
		os.system(cmd2 + '\n' + cmd3 + '\n' + cmd4 + '\n')
		#os.system(cmd3)
		#os.system(cmd4)

