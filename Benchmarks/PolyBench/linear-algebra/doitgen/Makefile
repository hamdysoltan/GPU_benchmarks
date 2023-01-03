EXECUTABLE := doitgen.out
CUFILES := doitgen.cu
PATH_TO_UTILS := ../../utilities

GENCODE_SM80 := -gencode=arch=compute_80,code=\"sm_80,compute_80\"



ARCH = $(GENCODE_SM80)
#ARCH := -arch=sm_70
NVCC_FLAGS += -Xptxas -O3

all:
	nvcc $(NVCC_FLAGS) $(ARCH) ${CUFILES} -I${PATH_TO_UTILS} -o ${EXECUTABLE}  
clean:
	rm -f *~ *.out