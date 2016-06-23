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
OutputFolder_5A= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5A/')
OutputFolder_5B= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5B/')
OutputFolder_5C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L5C/')
OutputFolder_4A= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4A/')
OutputFolder_4B= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4B/')
OutputFolder_4C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4C/')
OutputFolder_4D= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4D/')
OutputFolder_4E= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4E/')
OutputFolder_4F= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L4F/')
OutputFolder_3A= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L3A/')
OutputFolder_3B= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L3B/')
OutputFolder_3C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L3C/')
OutputFolder_3D= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L3D/')
OutputFolder_2A= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L2A/')
OutputFolder_2B= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L2B/')
OutputFolder_2C= os.path.join( tv_root,'Features/' ,DataSet ,'DRN50_L2C/')
OutputFolder_pool5 = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_pool5/')
OutputFolder_fc    = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_fc/')
OutputFolder_prob  = os.path.join( tv_root,'Features/' ,DataSet,'DRN50_prob/')
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
	OutFeat_4A = os.path.join(OutputFolder_4A, Vid+'.mat')
	OutFeat_4B = os.path.join(OutputFolder_4B, Vid+'.mat')
	OutFeat_4C = os.path.join(OutputFolder_4C, Vid+'.mat')
	OutFeat_4D = os.path.join(OutputFolder_4D, Vid+'.mat')
	OutFeat_4E = os.path.join(OutputFolder_4E, Vid+'.mat')
	OutFeat_4F = os.path.join(OutputFolder_4F, Vid+'.mat')
	OutFeat_3A = os.path.join(OutputFolder_3A, Vid+'.mat')
	OutFeat_3B = os.path.join(OutputFolder_3B, Vid+'.mat')
	OutFeat_3C = os.path.join(OutputFolder_3C, Vid+'.mat')
	OutFeat_3D = os.path.join(OutputFolder_3D, Vid+'.mat')
	OutFeat_2A = os.path.join(OutputFolder_2A, Vid+'.mat')
	OutFeat_2B = os.path.join(OutputFolder_2B, Vid+'.mat')
	OutFeat_2C = os.path.join(OutputFolder_2C, Vid+'.mat')
	OutFeat_pool5 = os.path.join(OutputFolder_pool5, Vid+'.mat')
	OutFeat_fc    = os.path.join(OutputFolder_fc, Vid+'.mat')
	OutFeat_prob  = os.path.join(OutputFolder_prob, Vid+'.mat')
	########################################################
	Images = os.listdir(VideoFolder)
	maxFrame = min(500, len(Images))
	
	##################
	if not os.path.exists(OutFeat_5C):
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
				vid2a    = np.array(res2a);
				vid2b    = np.array(res2b);
				vid2c    = np.array(res2c);
	
				vid3a    = np.array(res3a);
				vid3b    = np.array(res3b);
				vid3c    = np.array(res3c);
	
				vid4a    = np.array(res4a);
				vid4b    = np.array(res4b);
				vid4c    = np.array(res4c);
	
				vid4d    = np.array(res4d);
				vid4e    = np.array(res4e);
				vid4f    = np.array(res4f);

				vid5a    = np.array(res5a);
				vid5b    = np.array(res5b);
				vid5c    = np.array(res5c);
			else:
				vidProb = np.vstack((vidProb, prob))
				vidFc   = np.vstack((vidFc,   fc))
				vidPool5 = np.vstack((vidPool5, pool5))
				vid2a    = np.concatenate((vid2a, res2a), axis=2)
				vid2b    = np.concatenate((vid2b, res2b), axis=2)
				vid2c    = np.concatenate((vid2c, res2c), axis=2)
			
				vid3a    = np.concatenate((vid3a, res3a), axis=2)
				vid3b    = np.concatenate((vid3b, res3b), axis=2)
				vid3c    = np.concatenate((vid3c, res3c), axis=2)

				vid4a    = np.concatenate((vid4a, res4a), axis=2)
				vid4b    = np.concatenate((vid4b, res4b), axis=2)
				vid4c    = np.concatenate((vid4c, res4c), axis=2)

				vid4d    = np.concatenate((vid4d, res4d), axis=2)
				vid4e    = np.concatenate((vid4e, res4e), axis=2)
				vid4f    = np.concatenate((vid4f, res4f), axis=2)
	
				vid5a    = np.concatenate((vid5a, res5a), axis=2)
				vid5b    = np.concatenate((vid5b, res5b), axis=2)
				vid5c    = np.concatenate((vid5c, res5c), axis=2)
			#print vidFc
		sio.savemat(OutFeat_prob, {'prob':vidProb})
		sio.savemat(OutFeat_fc, {'fc':vidFc})
		sio.savemat(OutFeat_pool5, {'pool5':vidPool5})
		#sio.savemat(OutFeat_2A, {'F2A':vid2a})
		#sio.savemat(OutFeat_2B, {'F2B':vid2b})
		#sio.savemat(OutFeat_2C, {'F2C':vid2c})

		#sio.savemat(OutFeat_3A, {'F3A':vid3a})
		#sio.savemat(OutFeat_3B, {'F3B':vid3b})
		sio.savemat(OutFeat_3C, {'F3C':vid3c})

		#sio.savemat(OutFeat_4A, {'F4A':vid4a})
		#sio.savemat(OutFeat_4B, {'F4B':vid4b})
		sio.savemat(OutFeat_4C, {'F4C':vid4c})

		#sio.savemat(OutFeat_4D, {'F4D':vid4d})
		#sio.savemat(OutFeat_4E, {'F4E':vid4e})
		sio.savemat(OutFeat_4F, {'F4F':vid4f})

		sio.savemat(OutFeat_5A, {'F5A':vid5a})
		sio.savemat(OutFeat_5B, {'F5B':vid5b})
		sio.savemat(OutFeat_5C, {'F5C':vid5c})
		#cmd2 = 'rm ' + OutFeat_prob
		#os.system(cmd1)
		#os.system(cmd2)
		#
print 'Finish'



