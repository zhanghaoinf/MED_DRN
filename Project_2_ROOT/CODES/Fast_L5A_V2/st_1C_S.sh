#!/bin/bash

MAX=100
cmd="./st_1C_SplitGatherFeat.py"
log="./LOG/"
for (( i = 1; i <= MAX; i ++ ))
do
	nohup python -u $cmd $i $MAX > $log"1C_"$i &
done
