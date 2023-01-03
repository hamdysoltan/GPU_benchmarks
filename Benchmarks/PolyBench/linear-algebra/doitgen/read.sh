file_02='kernel_1_SASS_g2.out'
file_01='kernel1_tool.csv'
STR=("achieved active warps per SM","achieved occupancy","unified L1 cache hit rate","unified L1 cache hit rate for read transactions (global memory accesses)"\
,"L2 cache hit rate","GMEM read requests","GMEM write requests","GMEM total requests","GMEM read transactions",\
"GMEM write transactions","GMEM total transactions","number of read transactions per read requests".\
"number of write transactions per write requests","L2 read transactions","L2 write transactions","L2 total transactions",\
"DRAM total transactions","GPU active cycles (min)","GPU active cycles (max)","SM active cycles (sum)",\
"SM elapsed cycles (sum)","Warp instructions executed","Thread instructions executed","Instructions executed per clock cycle (IPC)",\
"Clock cycles per instruction (CPI)","Total instructions executed per seconds (MIPS)","Kernel execution time",\
"Total_Tensoe_Core_Instructions/SM","Total_Tensoe_Core_Instructions/GPU","Active Cycles for each data type per SM",\
"Active Cycles for each data type per GPU","The Alu instructions","The Alu Active_Cycles","The FMA instructions",\
"The FMA Active_Cycles","The F64 instructions","The F64 Active_Cycles")
if find   $file_01  ;then
   rm $file_01
fi

while IFS=':',',' read -r f1 f2 f3 f4 f5  f6  f7  f8  f9 f10 f11 f12 f13 f14 f15
do
    #for i in "${STR[@]}"
    #do
        
        #if grep -q $i <<< $f1; then
            #echo "It's there."
            #echo "$f13"  >>$file_02
            echo "$f1,$f2"," " >> $file_01
            #echo "$i"

        #fi

    #done
  #if [[ $STR == *"$line"* ]]; then

  
done < "$file_02"