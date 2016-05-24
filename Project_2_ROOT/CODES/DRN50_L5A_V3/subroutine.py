import scipy.io as sio
import numpy as np
import os

def maxPool3DMat(Mat, Mask, Stride):
	# Mat is an N-by-Dim1-by-Dim2 matrix
	# MaxPooling is applied on Dim1-by-Dim2 Dimension
	# Return M-by-N vector
	matShape = Mat.shape
	N = matShape[0]
	Dim1 = matShape[1]
	Dim2 = matShape[2]
	# x (y) is number of sliding window in x (y) axes
	x = (Dim1 - Mask[0]) / Stride + 1
	y = (Dim2 - Mask[1]) / Stride + 1
	M = x * y
	outMat = np.zeros((M, N))
	for nCnt in range(0, N):
		sigMat = Mat[nCnt]
		i = 0
		for xCnt in range(0,x):
			for yCnt in range(0, y):
				temp = sigMat[xCnt*Stride: xCnt*Stride+Mask[0], yCnt*Stride:yCnt*Stride+Mask[1]]
				outMat[i,nCnt] = np.max(temp)
				i = i + 1
	return outMat

def createFolder(folderPath):
	if os.path.isdir(folderPath):
		pass
	else:
		os.mkdir(folderPath)
