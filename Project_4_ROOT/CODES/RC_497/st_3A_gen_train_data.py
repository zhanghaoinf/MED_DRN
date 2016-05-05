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


if __name__ == '__main__':
    convert_to_db()
