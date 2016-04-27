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
tv_root   = '/home/hzhang57/Data/MED'
currentData = '/home/hzhang57/NEW_WORLD/Project_3_ROOT/DATA/'
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
DataSet = 'Event_BG'
InputFolder  = os.path.join(tv_root, 'VIDEO_ORIGINAL_KF',DataSet)
FileList     = os.path.join(tv_root,'STRUCTURE' ,DataSet + '.txt')
OutputFolder_5A= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L5A/')
OutputFolder_5B= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L5B/')
OutputFolder_5C= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L5C/')
OutputFolder_4A= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4A/')
OutputFolder_4B= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4B/')
OutputFolder_4C= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4C/')
OutputFolder_4D= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4D/')
OutputFolder_4E= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4E/')
OutputFolder_4F= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L4F/')
OutputFolder_3A= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L3A/')
OutputFolder_3B= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L3B/')
OutputFolder_3C= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L3C/')
OutputFolder_3D= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L3D/')
OutputFolder_2A= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L2A/')
OutputFolder_2B= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L2B/')
OutputFolder_2C= os.path.join( currentData,'Features/' ,DataSet ,'DRN50_L2C/')
createFolder(OutputFolder_5A)
createFolder(OutputFolder_5B)
createFolder(OutputFolder_5C)
createFolder(OutputFolder_4A)
createFolder(OutputFolder_4B)
createFolder(OutputFolder_4C)
createFolder(OutputFolder_4D)
createFolder(OutputFolder_4E)
createFolder(OutputFolder_4F)
createFolder(OutputFolder_3A)
createFolder(OutputFolder_3B)
createFolder(OutputFolder_3C)
createFolder(OutputFolder_3D)
createFolder(OutputFolder_2A)
createFolder(OutputFolder_2B)
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

	#print VideoFolder#####################################
	OutFeat_5A = os.path.join(OutputFolder_5A, Vid+'/')
	createFolder(OutFeat_5A)
	OutFeat_5B = os.path.join(OutputFolder_5B, Vid+'/')
	createFolder(OutFeat_5B)
	OutFeat_5C = os.path.join(OutputFolder_5C, Vid+'/')
	createFolder(OutFeat_5C)
	OutFeat_4A = os.path.join(OutputFolder_4A, Vid+'/')
	createFolder(OutFeat_4A)
	OutFeat_4B = os.path.join(OutputFolder_4B, Vid+'/')
	createFolder(OutFeat_4B)
	OutFeat_4C = os.path.join(OutputFolder_4C, Vid+'/')
	createFolder(OutFeat_4C)
	OutFeat_4D = os.path.join(OutputFolder_4D, Vid+'/')
	createFolder(OutFeat_4D)
	OutFeat_4E = os.path.join(OutputFolder_4E, Vid+'/')
	createFolder(OutFeat_4E)
	OutFeat_4F = os.path.join(OutputFolder_4F, Vid+'/')
	createFolder(OutFeat_4F)
	OutFeat_3A = os.path.join(OutputFolder_3A, Vid+'/')
	createFolder(OutFeat_3A)
	OutFeat_3B = os.path.join(OutputFolder_3B, Vid+'/')
	createFolder(OutFeat_3B)
	OutFeat_3C = os.path.join(OutputFolder_3C, Vid+'/')
	createFolder(OutFeat_3C)
	OutFeat_3D = os.path.join(OutputFolder_3D, Vid+'/')
	createFolder(OutFeat_3D)
	OutFeat_2A = os.path.join(OutputFolder_2A, Vid+'/')
	createFolder(OutFeat_2A)
	OutFeat_2B = os.path.join(OutputFolder_2B, Vid+'/')
	createFolder(OutFeat_2B)
	OutFeat_2C = os.path.join(OutputFolder_2C, Vid+'/')
	createFolder(OutFeat_2C)
	########################################################
	Images = os.listdir(VideoFolder)
	maxFrame = min(500, len(Images))
	
	##################
	for SingleImage in Images:
		ImgPath = os.path.join(VideoFolder, SingleImage)
		outName = SingleImage.replace('.jpg','.mat')
		InputImage = caffe.io.load_image(ImgPath)
		net.blobs['data'].data[...] = transformer.preprocess('data',InputImage)
		out = net.forward()
		res5c =  (net.blobs['res5c'].data[0])
		res5b =  (net.blobs['res5b'].data[0])
		res5a =  (net.blobs['res5a'].data[0])
		res4f =  (net.blobs['res4f'].data[0])
		res4e =  (net.blobs['res4e'].data[0])
		res4d =  (net.blobs['res4d'].data[0])
		res4c =  (net.blobs['res4c'].data[0])
		res4b =  (net.blobs['res4b'].data[0])
		res4a =  (net.blobs['res4a'].data[0])
		res3d =  (net.blobs['res3d'].data[0])
		res3c =  (net.blobs['res3c'].data[0])
		res3b =  (net.blobs['res3b'].data[0])
		res3a =  (net.blobs['res3a'].data[0])
		res2c =  (net.blobs['res2c'].data[0])
		res2b =  (net.blobs['res2b'].data[0])
		res2a =  (net.blobs['res2a'].data[0])
		sio.savemat(OutFeat_2A+outName, {'F2A':res2a})
		sio.savemat(OutFeat_2B+outName, {'F2B':res2b})
		sio.savemat(OutFeat_2C+outName, {'F2C':res2c})
		sio.savemat(OutFeat_3A+outName, {'F3A':res3a})
		sio.savemat(OutFeat_3B+outName, {'F3B':res3b})
		sio.savemat(OutFeat_3C+outName, {'F3C':res3c})
		sio.savemat(OutFeat_3D+outName, {'F3D':res3d})
		sio.savemat(OutFeat_4A+outName, {'F4A':res4a})
		sio.savemat(OutFeat_4B+outName, {'F4B':res4b})
		sio.savemat(OutFeat_4C+outName, {'F4C':res4c})
		sio.savemat(OutFeat_4D+outName, {'F4D':res4d})
		sio.savemat(OutFeat_4E+outName, {'F4E':res4e})
		sio.savemat(OutFeat_4F+outName, {'F4F':res4f})
		sio.savemat(OutFeat_5A+outName, {'F5A':res5a})
		sio.savemat(OutFeat_5B+outName, {'F5B':res5b})
		sio.savemat(OutFeat_5C+outName, {'F5C':res5c})
print 'Finish'



