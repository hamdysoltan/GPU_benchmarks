#!/bin/sh
file="a.csv"
m=5274
n=32
x=0
while [ "$m" -lt 16000 ]
do
    make N1=$m N2=16 
    LD_PRELOAD=~/tr/tracer.so ./gramschmidt.out 
    echo $m"," >> $file
    m=`expr $m + 2`      
done
