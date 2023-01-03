#!/bin/sh
file="a.csv"
m1=32  #to 64
m2=32 #to 512
m3=32  # 32768
while [ "$m1" -lt 2048 ]
do
    m2=32
    while [ "$m2" -lt 2048 ]
    do
        m3=32
        while [ "$m3" -lt 2048 ]
        do
             
            make N1=$m1 N2=$m2 N3=$m3 
            LD_PRELOAD=~/tr/tracer.so ./doitgen.out
            #echo $n","$ds","$k","  >> $file
    
            m3=`expr $m3 + 64`
        done
        m2=`expr $m2 + 64`
    done
    m1=`expr $m1 + 64`
done

