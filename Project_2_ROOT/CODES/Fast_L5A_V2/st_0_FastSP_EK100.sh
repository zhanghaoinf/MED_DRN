#!/bin/bash

MAX=50
Range=60
cmd="python -u ./st_1_FastSP_EK100.py"
log="./LOG/"
for (( i = 1; i <= MAX; i ++ ))
do
	st=$(($i * $Range))
	ed=$(($i * $Range -$Range + 1))
	nohup $cmd $ed $st > $log"EK100_"$i &
done
