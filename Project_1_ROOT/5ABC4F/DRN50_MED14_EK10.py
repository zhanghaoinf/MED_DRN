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
MODEL_FILE = os.path.join( DATA_ROOT , 'ResNet_50_deploy.prototxt' )
PRETRAINED = os.path.join( DATA_ROOT , 'ResNet_50.caffemodel' )
#caffe.set_device(1)
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
DataSet = 'E021-E040_10Ex'
InputFolder  = os.path.join(tv_root, 'VIDEO_ORIGINAL_KF',DataSet)
FileList     = os.path.join(tv_root,'STRUCTURE' ,DataSet + '.txt')
OutputFolder_5A= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5A/')
OutputFolder_5B= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5B/')
OutputFolder_5C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5C/')
OutputFolder_4F= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4F/')
OutputFolder_pool5 = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_pool5/')
OutputFolder_fc    = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_fc/')
OutputFolder_prob  = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_prob/')
createFolder(OutputFolder_5A)
createFolder(OutputFolder_5B)
createFolder(OutputFolder_5C)
createFolder(OutputFolder_4F)
createFolder(OutputFolder_pool5)
createFolder(OutputFolder_fc)
createFolder(OutputFolder_prob)
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
	OutFeat_5A = os.path.join(OutputFolder_5A, Vid+'.mat')
	OutFeat_5B = os.path.join(OutputFolder_5B, Vid+'.mat')
	OutFeat_5C = os.path.join(OutputFolder_5C, Vid+'.mat')
	OutFeat_4F = os.path.join(OutputFolder_4F, Vid+'.mat')
	OutFeat_pool5 = os.path.join(OutputFolder_pool5, Vid+'.mat')
	OutFeat_fc    = os.path.join(OutputFolder_fc, Vid+'.mat')
	OutFeat_prob  = os.path.join(OutputFolder_prob, Vid+'.mat')
	########################################################
	Images = os.listdir(VideoFolder)
	maxFrame = min(500, len(Images))
	
	##################
	if not os.path.exists(OutFeat_5C.replace('mat','7z')):
		for cnt in range(1, maxFrame+1):
			SingleImage = Vid + '_' + str(cnt) + '_OKF.jpg'
			ImgPath = os.path.join(VideoFolder, SingleImage)
			InputImage = caffe.io.load_image(ImgPath)
			net.blobs['data'].data[...] = transformer.preprocess('data',InputImage)
			feat5 ={}
			feat4 ={}
			out = net.forward()
			res5c = (net.blobs['res5c'].data[0])
			res5b =  (net.blobs['res5b'].data[0])
			res5a =  (net.blobs['res5a'].data[0])
			res4f =  (net.blobs['res4f'].data[0])
			pool5 =  (net.blobs['pool5'].data[0]).ravel()
			#print pool5.shape
			fc    =  (net.blobs['fc1000'].data[0])
			prob  = (net.blobs['prob'].data[0])
			#print prob[0]
			#print fc[0]
			#print pool5[0]
			#print res2a[0,0,0]
			#print fc.shape
			#print res2a.shape
			if cnt == 1:
				vidProb = np.array([prob]);	
				vidFc   = np.array([fc]);
				vidPool5 = np.array([pool5]);
	
				vid4f    = np.array(res4f);

				vid5a    = np.array(res5a);
				vid5b    = np.array(res5b);
				vid5c    = np.array(res5c);
			else:
				vidProb = np.vstack((vidProb, prob))
				vidFc   = np.vstack((vidFc,   fc))
				vidPool5 = np.vstack((vidPool5, pool5))
				vid4f    = np.concatenate((vid4f, res4f), axis=2)
	
				vid5a    = np.concatenate((vid5a, res5a), axis=2)
				vid5b    = np.concatenate((vid5b, res5b), axis=2)
				vid5c    = np.concatenate((vid5c, res5c), axis=2)
			#print vidFc
		sio.savemat(OutFeat_prob, {'prob':vidProb})
		sio.savemat(OutFeat_fc, {'fc':vidFc})
		sio.savemat(OutFeat_pool5, {'pool5':vidPool5})

		sio.savemat(OutFeat_4F, {'F4F':vid4f})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_4F.replace('.mat','.7z') + ' ' + OutFeat_4F
		cmd2 = 'rm ' + OutFeat_4F
		os.system(cmd1)
		os.system(cmd2)

		sio.savemat(OutFeat_5A, {'F5A':vid5a})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_5A.replace('.mat','.7z') + ' ' + OutFeat_5A
		cmd2 = 'rm ' + OutFeat_5A
		os.system(cmd1)
		os.system(cmd2)

		sio.savemat(OutFeat_5B, {'F5B':vid5b})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_5B.replace('.mat','.7z') + ' ' + OutFeat_5B
		cmd2 = 'rm ' + OutFeat_5B
		os.system(cmd1)
		os.system(cmd2)

		sio.savemat(OutFeat_5C, {'F5C':vid5c})
		cmd1 = '7za a -t7z -m0=LZMA2 -mmt=10 ' + OutFeat_5C.replace('.mat','.7z') + ' ' + OutFeat_5C
		cmd2 = 'rm ' + OutFeat_5C
		os.system(cmd1)
		os.system(cmd2)
		#cmd2 = 'rm ' + OutFeat_prob
		#os.system(cmd1)
		#os.system(cmd2)
		#
print 'Finish'



