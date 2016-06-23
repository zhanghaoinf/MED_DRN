#!/usr/bin/env python
import numpy as np
import scipy.io as sio
import sys
import math
import string
ArgvLen = len(sys.argv)
if ArgvLen != 3:
	print ("-"*30)
	print ("Num of argv not correct\n please specify batch and total batch")
	print ("-"*30)
batch = string.atoi(sys.argv[1])
totalBatch = string.atoi(sys.argv[2])


f = open('./Params/DRN50_L5C_1B_list.txt','r')
lines = f.readlines()
f.close()
featNum = len(lines)
dvd = math.floor( featNum / totalBatch)
st = int( dvd * batch - dvd + 1)
ed = int(dvd * batch)
if batch == totalBatch:
	ed = max(ed, featNum)

Dim = 2048
FeatMat = np.zeros((ed - st + 1, Dim))

cnt = 0
for sig in range(st-1, ed):
	print "|%d-%d|%d" % ( st-1, ed-1, sig)
	sigLine = lines[sig]
	sigLine = sigLine.strip()
	[featPath, kfSig] = sigLine.split(':')
	kfSig = int(kfSig)
	temp = sio.loadmat(featPath)
	Feat = temp['vidFeat']
	FeatMat[cnt,:] = Feat[kfSig-1,:]
	cnt = cnt + 1
savePath = './Params/FeatMat_DRN50_L5C_'+ str(batch) +'.mat'
sio.savemat(savePath,{'FeatMat':FeatMat})
