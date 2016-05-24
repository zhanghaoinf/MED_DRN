#!/bin/bash

MAX=100
cmd="./st_1C_SplitGatherFeat.py"
log="./LOG/"
for (( i = 2; i <= MAX; i ++ ))
do
	nohup $cmd $i $MAX > $log"1C_"$i &
done
