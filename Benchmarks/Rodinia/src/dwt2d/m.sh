# Collecting for all kernels and store them in text file

file_01='results_nsight.csv'
file_02='results_final.csv'
exec_file='dwt2d  -d 1920x1080 rgb.bmp out_img.dwt'
#echo exec_file
if find   $file_01  ;then
   rm $file_01
fi
#Specify a function - we should get this from the apconfig.py
STR="fdwt97Kernel"
#nv-nsight-cu-cli   --kernel-id ::$STR:8   --kernel-id ::$STR:8 --metrics  gpu__compute_memory_access_throughput.sum.pct_of_peak_sustained_active   ./$exec_file  >>$file_01
#::foo:2   func foo - second invcations
# GPU_Events
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:   --kernel-id ::regex:^.*$STR$: --metrics  gpu__compute_memory_access_throughput.sum.pct_of_peak_sustained_active   ./$exec_file  >>$file_01
if find   $file_02  ;then
   rm $file_02
fi

# For Memories
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__ctas_launched.sum   ./$exec_file  >>$file_01
 #sm__warps_active.avg.pct_of_peak_sustained_active,
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  l1tex__t_sector_hit_rate.pct,l1tex__t_sector_pipe_lsu_mem_global_op_ld_hit_rate.pct,lts__t_sector_hit_rate.pct   ./$exec_file  >>$file_01
 #,lts__t_sector_op_read_hit_rate.pct
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__warps_active,sm__warps_launched    ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__sass_inst_executed_op_global_ld.sum,sm__sass_inst_executed_op_global_st.sum,sm__sass_inst_executed_op_global.sum    ./$exec_file  >>$file_01
 
#lts__t_requests.sum
#l1tex__t_requests.sum
#lts__t_request_hit_rate.pct
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__ctas_launched_total.max    ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__ctas_active.max     ./$exec_file  >>$file_01
#sm__threads_launched
# GPU_Events
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__cycles_active.min,gpu__cycles_active.max,gpu__cycles_elapsed.max,gpu__time_duration.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__cycles_active.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__cycles_active.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__cycles_elapsed.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__cycles_elapsed.max   ./$exec_file  >>$file_01 
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__cycles_active.min   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__cycles_active.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__cycles_active.avg   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__cycles_elapsed.avg   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__time_duration.avg  ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_access_throughput.sum.pct_of_peak_sustained_active   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_access_throughput.sum.pct_of_peak_sustained_elapsed   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_access_throughput.max.pct_of_peak_sustained_active   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_access_throughput.max.pct_of_peak_sustained_elapsed   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_throughput.max.pct_of_peak_sustained_active   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  gpu__compute_memory_throughput.max.pct_of_peak_sustained_elapsed   ./$exec_file  >>$file_01

# Tensor_Events

#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  kernel-regex-base --metrics  sm__inst_executed_pipe_tensor_op_hmma.max     ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.max,sm__inst_executed_pipe_tensor_op_dmma.max,sm__inst_executed_pipe_tensor_op_imma.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.sum,sm__inst_executed_pipe_tensor_op_dmma.sum,sm__inst_executed_pipe_tensor_op_imma.sum   ./$exec_file  >>$file_01

#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.sum     ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_dmma.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_imma.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_bmma.sum   ./$exec_file  >>$file_01

nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_cycles_active.max,sm__pipe_tensor_op_dmma_cycles_active.max,sm__pipe_tensor_op_hmma_cycles_active.max,sm__pipe_tensor_op_imma_cycles_active.max   ./$exec_file  >>$file_01
 
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_op_dmma_cycles_active.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_op_hmma_cycles_active.max     ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_op_imma_cycles_active.max   ./$exec_file  >>$file_01

nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_cycles_active.sum,sm__pipe_tensor_op_dmma_cycles_active.sum,sm__pipe_tensor_op_hmma_cycles_active.sum,sm__pipe_tensor_op_imma_cycles_active.sum   ./$exec_file  >>$file_01

#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_tensor_op_bmma_cycles_active.sum   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.sum.per_cycle_active   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_tensor_op_hmma.sum.per_second   ./$exec_file  >>$file_01

# Memories_Events
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  dram__cycles_active.max,dram__cycles_elapsed.max,sm__pipe_shared_cycles_active.max,dram__bytes_read.max,dram__bytes.max,lts__cycles_active.max,lts__cycles_elapsed.max,lts__throughput.max     ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  dram__cycles_elapsed.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_shared_cycles_active.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  dram__bytes_read.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  dram__bytes.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  lts__cycles_active.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  lts__cycles_elapsed.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  lts__throughput.max   ./$exec_file  >>$file_01

#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sass__inst_executed_global_stores   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sass__inst_executed_local_loads   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sass__inst_executed_local_stores   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sass__inst_executed_shared_loads     ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sass__inst_executed_shared_stores   ./$exec_file  >>$file_01


nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed.sum   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed.max   ./$exec_file  >>$file_01
 
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_op_ldsm.max     ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_adu.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_cbu.max   ./$exec_file  >>$file_01
#nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_fp16.max   ./$exec_file  >>$file_01

nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_alu.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_fma.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__inst_executed_pipe_fp64.max   ./$exec_file  >>$file_01
 

nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_alu_cycles_active.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_fma_cycles_active.max   ./$exec_file  >>$file_01
nv-nsight-cu-cli   --kernel-id ::regex:^.*$STR$:  --csv  --metrics  sm__pipe_fp64_cycles_active.max   ./$exec_file  >>$file_01



#The following parameters are needed to be modeled in our tool
  #smsp__inst_executed_pipe_fp64.avg.pct_of_peak_sustained_active
  #dram__bytes_read.sum.per_second

while IFS=, read -r f1 f2 f3 f4 f5  f6  f7  f8  f9 f10 f11 f12 f13 f14 f15
do
  #if [[ $STR == *"$line"* ]]; then
  if grep -q $STR <<< $f5; then
    #echo "It's there."
    #echo "$f13"  >>$file_02
    echo "$f13,$f15,$f14" >> $file_02

  fi
  
done < "$file_01"
#echo "The gl hit_rate,"---","$x" >> $file_02