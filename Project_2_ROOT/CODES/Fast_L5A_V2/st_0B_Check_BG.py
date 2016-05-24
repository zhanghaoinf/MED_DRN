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
dataSet = 'Event_BG'
featRange = [1 , 7] 
##########################################################
fileList   = os.path.join(tvFolder, 'STRUCTURE', dataSet + '.txt')
outFolder  = os.path.join(dataRoot, 'FastSP', dataSet, feat)
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
	outTarPath    = os.path.join(outFolder, vid + '.7z')
	cmd1 = '7z x ' + outTarPath + ' -o./temp/'
	os.system(cmd1)
	vidTempFile = os.path.join('./temp', vid + '.mat')
	cmd2 = 'rm ./temp/' + vid + '.mat'
	os.system(cmd2)
