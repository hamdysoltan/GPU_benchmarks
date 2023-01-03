#!/bin/sh
m=1000
n=250
q=5
x=0
file="a.csv"
while [ "$m" -lt 50000 ]
do

    n=250
    while [ "$n" -lt 2000 ]
    do
    q=5
        while [ "$q" -lt 100 ]
        do
            LD_PRELOAD=~/tr/tracer.so ./pathfinder $m $n $q
            q=`expr $q + 5`
            echo $m","$n","$q >> $file      
        done
        n=`expr $n + 50`
    done
    m=`expr $m + 500`
done
