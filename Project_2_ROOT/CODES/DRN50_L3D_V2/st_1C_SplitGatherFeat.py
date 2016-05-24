#!/usr/bin/env python
import numpy as np
import scipy.io as sio
import sys
import math
import string
import os
from subroutine import createFolder
ArgvLen = len(sys.argv)
if ArgvLen != 3:
	print ("-"*30)
	print ("Num of argv not correct\n please specify batch and total batch")
	print ("-"*30)
batch = string.atoi(sys.argv[1])
cbatch = sys.argv[1]
totalBatch = string.atoi(sys.argv[2])

feaType = 'DRN50_L3D'
f = open('./Params/' + feaType +'_1B_list.txt','r')
lines = f.readlines()
f.close()
featNum = len(lines)
dvd = math.floor( featNum / totalBatch)
st = int( dvd * batch - dvd + 1)
ed = int(dvd * batch)
if batch == totalBatch:
	ed = max(ed, featNum)

Dim = 512
FeatMat = np.zeros((ed - st + 1, Dim))
createFolder('./temp_1C/' + cbatch)
cnt = 0
for sig in range(st-1, ed):
	print "|%d-%d|%d" % ( st-1, ed-1, sig)
	sigLine = lines[sig]
	sigLine = sigLine.strip()
	[featPath, kfSig] = sigLine.split(':')
	kfSig = int(kfSig)
	cmd1 = '7z x ' + featPath + ' -o./temp_1C/' + cbatch + '/'
	os.system(cmd1)
	strTemp = featPath.split("/")
	exFeatFile = os.path.join( './temp_1C',cbatch, strTemp[-1].replace('7z','mat'))
	temp = sio.loadmat(exFeatFile)
	cmd2 = 'rm ' + exFeatFile
	os.system(cmd2)
	Feat = temp['vidFeat']
	print Feat.shape
	print kfSig
	FeatMat[cnt,:] = Feat[kfSig-1,:]
	cnt = cnt + 1
savePath = './Params/FeatMat_'+feaType+'_'+ str(batch) +'.mat'
sio.savemat(savePath,{'FeatMat':FeatMat})
