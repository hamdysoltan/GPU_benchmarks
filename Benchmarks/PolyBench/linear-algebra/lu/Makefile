#GENCODE_SM70 := -gencode=arch=compute_70,code=\"sm_70,compute_70\"
GENCODE_SM75 := -gencode=arch=compute_80,code=\"sm_80,compute_80\"
EXECUTABLE := lu.out
CUFILES := lu.cu
PATH_TO_UTILS := ../../utilities

ARCH = $(GENCODE_SM70) $(GENCODE_SM75)
#ARCH := -arch=sm_70
NVCC_FLAGS += -Xptxas -O3

all:
	nvcc $(NVCC_FLAGS) $(ARCH) ${CUFILES} -I${PATH_TO_UTILS} -o ${EXECUTABLE}  -DN=$(N1)  
clean:
	rm -f *~ *.out
