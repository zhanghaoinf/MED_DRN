#!/bin/bash
nohup python -u st_0_spMax_bg_TAR.py 1    1000 > ./LOG/bg_1.txt &
nohup python -u st_0_spMax_bg_TAR.py 1000 2000 > ./LOG/bg_2.txt &
nohup python -u st_0_spMax_bg_TAR.py 2000 3000 > ./LOG/bg_3.txt &
nohup python -u st_0_spMax_bg_TAR.py 3000 4000 > ./LOG/bg_4.txt &
nohup python -u st_0_spMax_bg_TAR.py 4000 5000 > ./LOG/bg_5.txt &
