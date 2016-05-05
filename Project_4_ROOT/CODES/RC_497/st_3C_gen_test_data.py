#!/usr/bin/python

import colorsys
import csv
import random
import os
import sys
import shutil
from PIL import Image

def convert_to_db():
    if os.path.exists('./Param/RC-test.leveldb'):
        shutil.rmtree('./Param/RC-test.leveldb')
    os.system('/home/hzhang57/caffe/build/tools/convert_imageset.bin -shuffle  ../../DATA/RC_497/ValSamples/ ./Param/test.txt ./Param/RC-test.leveldb')


if __name__ == '__main__':
    convert_to_db()
