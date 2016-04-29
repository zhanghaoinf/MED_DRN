#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import string
import os
caffe_root = '/home/hzhang57/DRN/caffe_b59/'
import sys
sys.path.insert(0, caffe_root + 'python')
import caffe

if len(sys.argv)!=3:
	print "Usage: python convert_proto2npy.py proto.mean out (npy)"
	sys.exit()

blob = caffe.proto.caffe_pb2.BlobProto()
data = open(sys.argv[1],'rb').read()
blob.ParseFromString(data)
arr  = np.array(caffe.io.blobproto_to_array(blob))
out  = arr[0]
np.save(sys.argv[2], out)
