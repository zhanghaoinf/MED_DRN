#!/usr/bin/env python
import scipy.io as sio
import numpy as np
import os
import sys
import string
import time
from subFun import createFolder, linmap, spPool3DSig
dataRoot = '/home/hzhang57/NEW_WORLD/Project_3_ROOT/DATA'
tvFolder = '/home/hzhang57/Data/MED/'
###---------------------- Only modify this part -----------------------------------
fmt = '.mat'
#feat = 'DRN50_L2A'
#featIdx = 'F2A'
#feat = 'DRN50_L3A'
#featIdx = 'F3A'
feat = 'DRN50_L4F'
featIdx = 'F4F'
#feat = 'DRN50_L5C'
#featIdx = 'F5C'

#featRange = [1, 56]
#featRange = [1, 28]
featRange = [1, 14]
#featRange = [1, 7]

dataSet = 'Event_BG'
###--------------------------------------------------------------------------------
fileList = os.path.join(tvFolder, 'STRUCTURE',   dataSet+'.txt')
featFolder = os.path.join(dataRoot, 'Features',  dataSet, feat)
bbFolder   = os.path.join(dataRoot, 'BOUND_BOX', dataSet)
outFolder  = os.path.join(dataRoot, 'FastFeatRaw',dataSet, feat)
createFolder(outFolder)
ArgvLen = len(sys.argv)
if ArgvLen !=3:
	print("-"*30)
	print("Number of argv is not correct\n please specify start and end number") 
	print("-"*30)
	exit(0)

stLine = string.atoi(sys.argv[1])
edLine = string.atoi(sys.argv[2])
cntRange = range(stLine-1, edLine)
fid = open(fileList)
vidList = fid.readlines()
vidNum  = len(vidList)
Disp = '|'+ str(vidNum) + '|' + str(edLine) + '-----' + str(stLine -1) + ':'
for  cnt in cntRange:
	vid = vidList[cnt].strip()
	#print vid
	vidFeatFolder = os.path.join(featFolder, vid)
	vidBBFolder   = os.path.join(bbFolder, vid)
	vidOutFolder  = os.path.join(outFolder, vid)
	createFolder(vidOutFolder)
	feats = os.listdir(vidFeatFolder)
	frameCnt = 1
	for sigFeat in feats:
		sigFeatPath = os.path.join(vidFeatFolder, sigFeat)
		sigBBPath   = os.path.join(vidBBFolder, sigFeat)
		if  (os.path.exists(sigFeatPath)) and os.path.exists(sigBBPath):
			print Disp + str(cnt) + ' Frame ' + str(frameCnt) + ' of ' + str(len(feats))
			frameCnt = frameCnt + 1
			temp = sio.loadmat(sigFeatPath)
			Feat5 = temp[featIdx]
			temp = sio.loadmat(sigBBPath)
			boxes = temp['boxes']
			# mapping from [1-368] [1-480] to [1-7][1-7]
			mapBox = np.zeros(boxes.shape)
			mapBox[:,0] = np.floor(linmap(boxes[:,0], [1, 360],featRange))
			n = len(mapBox[:,0])
			mapBox[:,1] = np.floor(linmap(boxes[:,1], [1, 480],featRange))
			mapBox[:,2] = np.ceil(linmap(boxes[:,2], [1, 360], featRange))
			mapBox[:,3] = np.ceil(linmap(boxes[:,3], [1, 480], featRange))
			#tic =  time.clock()
			for bcnt in range(0,n):
				spFeat = spPool3DSig(Feat5, mapBox[bcnt,:])
				sigFeatOut  = os.path.join(vidOutFolder, sigFeat.replace('.mat','_'+str(bcnt+1)) + '.mat')
				sio.savemat(sigFeatOut, {featIdx: spFeat})

			#toc = time.clock()
			#print toc - tic

