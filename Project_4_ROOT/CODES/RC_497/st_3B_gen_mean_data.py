#!/usr/bin/python

import colorsys
import csv
import random
import os
import sys
import shutil
from PIL import Image

def convert_to_db():
    if os.path.exists('./Param/RC-train.leveldb'):
        shutil.rmtree('./Param/RC-train.leveldb')
    os.system('/home/hzhang57/caffe/build/tools/convert_imageset.bin -shuffle  ../../DATA/RC_497/PosSamples/ ./Param/train.txt ./Param/RC-train.leveldb')

def compute_mean():
	os.system('/home/hzhang57/caffe/build/tools/compute_image_mean.bin ./Param/RC-train.leveldb ./Param/mean.binaryproto')
if __name__ == '__main__':
    compute_mean()
