EXECUTABLE := gemver.out
CUFILES := gemver.cu
PATH_TO_UTILS := ../../utilities



include ${PATH_TO_UTILS}/common.mk


#GENCODE_SM80 := -gencode=arch=compute_80,code=\"sm_80,compute_80\"
#ARCH = $(GENCODE_SM80) 
#ARCH := -arch=sm_70
#NVCC_FLAGS += -Xptxas -O3

#all:
#	nvcc $(NVCC_FLAGS) $(ARCH) ${CUFILES} -I${PATH_TO_UTILS} -o ${EXECUTABLE}  -DN=256
#clean:
#	rm -f *~ *.out