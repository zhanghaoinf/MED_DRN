#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import string
import os
import pickle
import scipy.io as sio
import scipy
from subroutine import createFolder
# Make sure that caffe is on the python path:
caffe_root = '/home/hzhang57/DRN/caffe_b59/' # this file is expected to be in {caffe_root}/example
import sys
sys.path.insert(0,caffe_root + 'python')
import caffe

# Set the right path to your model definition file, pretrained model weights
# and the image you would like to classify
DATA_ROOT = '/home/hzhang57/DRN/DRN_Model/'
tv_root   = '/home/data/MED'
MODEL_FILE = os.path.join( DATA_ROOT , 'ResNet_50_deploy.prototxt' )
PRETRAINED = os.path.join( DATA_ROOT , 'ResNet_50.caffemodel' )
caffe.set_device(1)
caffe.set_mode_gpu()
#caffe.set_mode_cpu()
net = caffe.Net(MODEL_FILE, PRETRAINED, caffe.TEST)

# input preprocessing: 'data' is the name of the input blob == net.inputs[0]
transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
transformer.set_transpose('data',(2,0,1))
transformer.set_mean('data',np.load(DATA_ROOT + 'ResNet_mean.npy').mean(1).mean(1))
transformer.set_raw_scale('data',255)
transformer.set_channel_swap('data',(2,1,0))
net.blobs['data'].reshape(1,3,224,224)
############# DATA Set ##################### This part is defined by user #################33
Fmt = 'jpg'
FeatFmt = 'txt'
DataSet = 'E021-E040_100Ex'
InputFolder  = os.path.join(tv_root, 'VIDEO_ORIGINAL_KF',DataSet)
FileList     = os.path.join(tv_root,'STRUCTURE' ,DataSet + '.txt')
OutputFolder_3D= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L3D/')
OutputFolder_2C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L2C/')
createFolder(OutputFolder_3D)
createFolder(OutputFolder_2C)
#############################################################################################

ArgvLen = len(sys.argv)
if ArgvLen !=3:
	print ("-"*30)
	print ("Number of argv not correct\n please specify start and end number")
	print ("-"*30)
	exit(0)
StartLine = string.atoi(sys.argv[1])
EndLine   = string.atoi(sys.argv[2])
CntRange  = range(StartLine-1, EndLine)
Fid = open(FileList)
VidLists = Fid.readlines()
VidNum   = len(VidLists)
Dispp = '|' + str(VidNum) + '|' +str(EndLine) + "----" + str(StartLine-1) + ":"
for Cnt in CntRange:
	print Dispp + str(Cnt)
	Vid = VidLists[Cnt].strip()
	VideoFolder = os.path.join(InputFolder, Vid)

	OutFeat_3D = os.path.join(OutputFolder_3D, Vid+'.mat')
	OutFeat_2C = os.path.join(OutputFolder_2C, Vid+'.mat')
	########################################################
	Images = os.listdir(VideoFolder)
	maxFrame = min(500, len(Images))
	
	##################
	if not os.path.exists(OutFeat_2C.replace('.mat','.7z')):
		for cnt in range(1, maxFrame+1):
			SingleImage = Vid + '_' + str(cnt) + '_OKF.jpg'
			ImgPath = os.path.join(VideoFolder, SingleImage)
			InputImage = caffe.io.load_image(ImgPath)
			net.blobs['data'].data[...] = transformer.preprocess('data',InputImage)
			out = net.forward()
			res3d =  (net.blobs['res3d'].data[0])
			res2c =  (net.blobs['res2c'].data[0])
			if cnt == 1:
				vid3d    = np.array(res3d);
				vid2c    = np.array(res2c);
			else:
				vid3d    = np.concatenate((vid3d, res3d), axis=2)
				vid2c    = np.concatenate((vid2c, res2c), axis=2)
			#print vidFc
		sio.savemat(OutFeat_3D, {'F3D':vid3d})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_3D.replace('.mat', '.7z') + ' ' + OutFeat_3D
		cmd2 = 'rm ' + OutFeat_3D
		os.system(cmd1)
		os.system(cmd2)

		sio.savemat(OutFeat_2C, {'F2C':vid2c})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_2C.replace('.mat', '.7z') + ' ' + OutFeat_2C
		cmd2 = 'rm ' + OutFeat_2C
		os.system(cmd1)
		os.system(cmd2)
print 'Finish'



