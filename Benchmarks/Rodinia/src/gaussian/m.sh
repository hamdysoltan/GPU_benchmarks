#!/bin/sh
file="a.csv"
m=956
while [ "$m" -lt 8132 ]
do
    LD_PRELOAD=~/bb_trace/tracer.so ./gaussian -s $m 
    echo $m"," >> $file
    
    m=`expr $m + 2`
done
#LD_PRELOAD=~/tr/tracer.so ./gaussian -s $m 
