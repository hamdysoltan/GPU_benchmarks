#!/bin/sh

m=32
while [ "$m" -lt 4096 ]
do
    make clean
    make N1=$m 
    LD_PRELOAD=~/bb_trace/tracer.so ./lu.out 
    m=`expr $m + 2`
    #echo ' $m '
done

