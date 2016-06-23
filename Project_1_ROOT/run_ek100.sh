#!/bin/bash
nohup python -u ./DRN50_MED14_EK100.py 1 300    > ./log/EK100_1 &
nohup python -u ./DRN50_MED14_EK100.py 300 600    > ./log/EK100_2 &
nohup python -u ./DRN50_MED14_EK100.py 600 900    > ./log/EK100_3 &
nohup python -u ./DRN50_MED14_EK100.py 900 1200    > ./log/EK100_4 &
nohup python -u ./DRN50_MED14_EK100.py 1200 1500 > ./log/EK100_5 &
nohup python -u ./DRN50_MED14_EK100.py 1500 1800 > ./log/EK100_6 &
nohup python -u ./DRN50_MED14_EK100.py 1800 2100 > ./log/EK100_7 &
nohup python -u ./DRN50_MED14_EK100.py 2100 2400 > ./log/EK100_8 &
nohup python -u ./DRN50_MED14_EK100.py 2400 2700 > ./log/EK100_9 &
nohup python -u ./DRN50_MED14_EK100.py 2700 3000 > ./log/EK100_10 &
