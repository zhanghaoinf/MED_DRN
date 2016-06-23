#!/bin/bash
nohup python -u ./DRN50_MED14_EK10.py 1 100    > ./log/EK10_1 &
nohup python -u ./DRN50_MED14_EK10.py 100 200    > ./log/EK10_2 &
nohup python -u ./DRN50_MED14_EK10.py 200 300    > ./log/EK10_3 &
nohup python -u ./DRN50_MED14_EK10.py 300 400    > ./log/EK10_4 &
