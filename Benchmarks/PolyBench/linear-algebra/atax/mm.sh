m1=32
x=1024
while [ "$m1" -lt "$x" ]
do
m2=64
    while [ "$m2" -lt "$x" ] 
    do
        make N1=$m1 N2=$m2 
        LD_PRELOAD=~/bb_trace/tracer.so ./atax.out
        m2=`expr $m2 + 2`      
    done
    m1=`expr $m1 + 2`
done

