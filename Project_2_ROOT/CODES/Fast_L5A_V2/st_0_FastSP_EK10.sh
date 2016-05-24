#!/bin/bash

MAX=100
Range=4
cmd="python -u ./st_1_FastSP_EK10.py"
log="./LOG/"
for (( i = 2; i <= MAX; i ++ ))
do
	st=$(($i * $Range))
	ed=$(($i * $Range -$Range + 1))
	nohup $cmd $ed $st > $log"EK10_"$i &
done
