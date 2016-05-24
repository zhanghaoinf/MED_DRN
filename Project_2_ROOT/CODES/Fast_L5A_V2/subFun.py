import scipy.io as sio
import numpy as np
import os

def createFolder(folderPath):
	if os.path.isdir(folderPath):
		pass
	else:
		os.mkdir(folderPath)

def linmap(vin, oRange, dRange):
	a = float(oRange[0])
	b = float(oRange[1])
	c = float(dRange[0])
	d = float(dRange[1])
	vout = ((c+d) + (d-c)*((2*vin - (a+b))/(b-a)))/2
	return vout

def spPool3D(Mat, Masks):
	# Mat is an N-by-Dim1-by-Dim2 Dimension
	# Spatial Pooling is applied on Dim1-by-Dim2 Dimension
	# Return M-by-N vector
	matShape = Mat.shape
	N 	 = matShape[0]
	Dim1 	 = matShape[1]
	Dim2	 = matShape[2]
	M = len(Masks)
	outMat = np.zeros((M,N))
	for nM in range(0,M):
		sigMask = Masks[nM]
		x1 = sigMask[0]-1
		y1 = sigMask[1]-1
		x2 = sigMask[2]-1
		y2 = sigMask[3]-1
		for nCnt in range(0,N):
			sigMat = Mat[nCnt] 
			temp = sigMat[x1:x2+1, y1:y2+1]
			outMat[nM, nCnt] = np.max(temp)
	return outMat


def spPool3DSig(Mat, Mask):
	# Mat is an N-by-Dim1-by-Dim2 Dimension
	# Spatial Pooling is applied on Dim1-by-Dim2 Dimension
	matShape = Mat.shape
	N 	 = matShape[0]
	Dim1 	 = matShape[1]
	Dim2	 = matShape[2]
	x1 = Mask[0]-1
	y1 = Mask[1]-1
	x2 = Mask[2]-1
	y2 = Mask[3]-1
	outMat = Mat[:,x1:x2+1, y1:y2+1]
	return outMat

