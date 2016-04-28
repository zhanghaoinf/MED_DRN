#!/usr/bin/python

import colorsys
import csv
import random
import os
import sys
import shutil
from PIL import Image

def convert_to_db():
    if os.path.exists('./Param/SIN-train.leveldb'):
        shutil.rmtree('./Param/SIN-train.leveldb')
    os.system('/home/hzhang57/caffe/build/tools/convert_imageset.bin -shuffle  ../../DATA/SIN_346/SPosSamples/ ./Param/train.txt ./Param/SIN-train.leveldb')


if __name__ == '__main__':
    convert_to_db()
