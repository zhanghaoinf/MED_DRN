#!/bin/bash

MAX=50
Range=100
cmd="python -u ./st_1_FastSP_BG.py"
log="./LOG/"
NULL="/dev/null"
for (( i = 1; i <= MAX; i ++ ))
do
	st=$(($i * $Range))
	ed=$(($i * $Range -$Range + 1))
	nohup $cmd $ed $st > $log"BG_"$i &
	#nohup $cmd $ed $st > $NULL &
done
