#GENCODE_SM70 := -gencode=arch=compute_70,code=\"sm_70,compute_70\"
#GENCODE_SM75 := -gencode=arch=compute_75,code=\"sm_75,compute_75\"
GENCODE_SM80 := -gencode=arch=compute_80,code=\"sm_80,compute_80\"
ARCH = $(GENCODE_SM80) # $(GENCODE_SM75) $(GENCODE_SM70)
#ARCH := -arch=sm_70
NVCC_FLAGS += -Xptxas -O3
CUDA_PATH ?= /software/GPU/Cuda/11.3.1
#nvcc -w -I$(CUDA_PATH)/extras/CUPTI/include -L$(CUDA_PATH)/extras/CUPTI/lib64 -L$(CUDA_PATH)/lib -L$(CUDA_PATH)/lib64 -lcuda -lcupti 
#nvcc $(NVCC_FLAGS) $(ARCH) ${CUFILES} -I${PATH_TO_UTILS} -I$(CUDA_PATH)/extras/CUPTI/include  -L$(CUDA_PATH)/extras/CUPTI/lib64 -L$(CUDA_PATH)/lib -L$(CUDA_PATH)/lib64 -lcuda -lcupti  -o ${EXECUTABLE} 

all:
	nvcc $(NVCC_FLAGS) $(ARCH) ${CUFILES} -I${PATH_TO_UTILS} -o ${EXECUTABLE} 
clean:
	rm -f *~ *.out