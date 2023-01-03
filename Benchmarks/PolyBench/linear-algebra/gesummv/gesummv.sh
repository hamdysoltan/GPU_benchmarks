#!/bin/sh

m=4
while [ "$m" -lt 8192 ]
do
    make N1=$m 
    LD_PRELOAD=~/tr/tracer.so ./gesummv.out 
    m=`expr $m + 2`
done

