#!/bin/bash
nohup python -u st_0_spMax_EK100_TAR.py 1    1000 > ./LOG/EK100_1.txt &
nohup python -u st_0_spMax_EK100_TAR.py 1000 2000 > ./LOG/EK100_2.txt &
nohup python -u st_0_spMax_EK100_TAR.py 2000 3000 > ./LOG/EK100_3.txt &
