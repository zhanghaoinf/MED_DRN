#!/usr/bin/env sh
TOOLS=/home/hzhang57/DRN/caffe_b59/build/tools
SOLVER=-solver
PARAM=/home/hzhang57/NEW_WORLD/Project_4_ROOT/CODES/RC_497/Param
DRN=/home/hzhang57/DRN/DRN_Model
WEIGHT=-weights
GLOG_logtostderr=1 $TOOLS/caffe train $SOLVER $PARAM/Ssolver.prototxt $WEIGHT $DRN/ResNet_50.caffemodel -gpu 0 2>CAFFE_LOG.txt
