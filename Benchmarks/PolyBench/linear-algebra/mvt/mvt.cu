/**
 * mvt.cu: This file is part of the PolyBench/GPU 1.0 test suite.
 *
 *
 * Contact: Scott Grauer-Gray <sgrauerg@gmail.com>
 * Will Killian <killian@udel.edu>
 * Louis-Noel Pouchet <pouchet@cse.ohio-state.edu>
 * Web address: http://www.cse.ohio-state.edu/~pouchet/software/polybench/GPU
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <assert.h>
#include <unistd.h>
#include <sys/time.h>
#include <cuda.h>

#define POLYBENCH_TIME 1

#include "mvt.cuh"
#include <polybench.h>
#include <polybenchUtilFuncts.h>

//define the error threshold for the results "not matching"
#define PERCENT_DIFF_ERROR_THRESHOLD 0.05

#define GPU_DEVICE 0

#define RUN_ON_CPU


void init_array(int n, DATA_TYPE POLYBENCH_2D(A, N, N, n, n), DATA_TYPE POLYBENCH_1D(x1, N, n), DATA_TYPE POLYBENCH_1D(x2, N, n), DATA_TYPE POLYBENCH_1D(y1, N, n), DATA_TYPE POLYBENCH_1D(y2, N, n))
{
	int i, j;

	for (i = 0; i < n; i++)
	{
		x1[i] = ((DATA_TYPE) i) / N;
		x2[i] = ((DATA_TYPE) i + 1) / N;
		y1[i] = ((DATA_TYPE) i + 3) / N;
		y2[i] = ((DATA_TYPE) i + 4) / N;
		for (j = 0; j < n; j++)
		{
			A[i][j] = ((DATA_TYPE) i*j) / N;
		}
	}
}



void runMvt(int n, DATA_TYPE POLYBENCH_2D(a, N, N, n, n), DATA_TYPE POLYBENCH_1D(x1, N, n), DATA_TYPE POLYBENCH_1D(x2, N, n), DATA_TYPE POLYBENCH_1D(y1, N, n), DATA_TYPE POLYBENCH_1D(y2, N, n))
{
	int i, j;
	
	for (i=0; i<_PB_N; i++) 
	{
		for (j=0; j<N; j++) 
		{
       		x1[i] = x1[i] + a[i][j] * y1[j];
        	}
    	}
	
	for (i=0; i<_PB_N; i++) 
	{
		for (j=0; j<_PB_N; j++) 
		{
 		      	x2[i] = x2[i] + a[j][i] * y2[j];
      		}
    	}
}


void compareResults(int n, DATA_TYPE POLYBENCH_1D(x1, N, n), DATA_TYPE POLYBENCH_1D(x1_outputFromGpu, N, n), DATA_TYPE POLYBENCH_1D(x2, N, n), DATA_TYPE POLYBENCH_1D(x2_outputFromGpu, N, n))
{
	int i, fail;
	fail = 0;
	
	for (i=0; i<n; i++) 
	{
		if (percentDiff(x1[i], x1_outputFromGpu[i]) > PERCENT_DIFF_ERROR_THRESHOLD)
		{
			fail++;
		}

		if (percentDiff(x2[i], x2_outputFromGpu[i]) > PERCENT_DIFF_ERROR_THRESHOLD)
		{
			fail++;
		}
	}
	
	// Print results
	printf("Non-Matching CPU-GPU Outputs Beyond Error Threshold of %4.2f Percent: %d\n", PERCENT_DIFF_ERROR_THRESHOLD, fail);
}


void GPU_argv_init()
{
	cudaDeviceProp deviceProp;
	cudaGetDeviceProperties(&deviceProp, GPU_DEVICE);
	printf("setting device %d with name %s\n",GPU_DEVICE,deviceProp.name);
	cudaSetDevice( GPU_DEVICE );
}


__global__ void mvt_kernel1(int n, DATA_TYPE *a, DATA_TYPE *x1, DATA_TYPE *y_1)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;

	if (i < _PB_N)
	{
		int j;
		for(j=0; j < _PB_N; j++)
		{
			x1[i] += a[i * N + j] * y_1[j];
		}
	}
}


__global__ void mvt_kernel2(int n, DATA_TYPE *a, DATA_TYPE *x2, DATA_TYPE *y_2)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;

	if (i < _PB_N)
	{
		int j;
		for(j=0; j < _PB_N; j++)
		{
			x2[i] += a[j * N + i] * y_2[j];	
		}
	}
}

void mvtCuda(int n, DATA_TYPE POLYBENCH_2D(a, N, N, n, n), DATA_TYPE POLYBENCH_1D(x1, N, n), DATA_TYPE POLYBENCH_1D(x2, N, n), DATA_TYPE POLYBENCH_1D(y_1, N, n), DATA_TYPE POLYBENCH_1D(y_2, N, n), 
			DATA_TYPE POLYBENCH_1D(x1_outputFromGpu, N, n), DATA_TYPE POLYBENCH_1D(x2_outputFromGpu, N, n))
{
	DATA_TYPE* a_gpu;
	DATA_TYPE* x1_gpu;
	DATA_TYPE* x2_gpu;
	DATA_TYPE* y_1_gpu;
	DATA_TYPE* y_2_gpu;

	cudaMalloc((void **)&a_gpu, sizeof(DATA_TYPE) * N * N);
	cudaMalloc((void **)&x1_gpu, sizeof(DATA_TYPE) * N);
	cudaMalloc((void **)&x2_gpu, sizeof(DATA_TYPE) * N);
	cudaMalloc((void **)&y_1_gpu, sizeof(DATA_TYPE) * N);
	cudaMalloc((void **)&y_2_gpu, sizeof(DATA_TYPE) * N);
	cudaMemcpy(a_gpu, a, sizeof(DATA_TYPE) * N * N, cudaMemcpyHostToDevice);
	cudaMemcpy(x1_gpu, x1, sizeof(DATA_TYPE) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(x2_gpu, x2, sizeof(DATA_TYPE) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(y_1_gpu, y_1, sizeof(DATA_TYPE) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(y_2_gpu, y_2, sizeof(DATA_TYPE) * N, cudaMemcpyHostToDevice);
	
	dim3 block(DIM_THREAD_BLOCK_X, DIM_THREAD_BLOCK_Y);
	dim3 grid((size_t)ceil((float)N/ ((float)DIM_THREAD_BLOCK_X)), 1);






	cudaStream_t stream;
	cudaStreamCreate(&stream);                                                                  // Create CUDA stream

	cudaDeviceProp prop;                                                                        // CUDA device properties variable
	cudaGetDeviceProperties( &prop, GPU_DEVICE);                                                 // Query GPU properties
	size_t size = min( int(prop.l2CacheSize * 0.75) , prop.persistingL2CacheMaxSize );
	cudaDeviceSetLimit( cudaLimitPersistingL2CacheSize, size);                                  // set-aside 3/4 of L2 cache for persisting accesses or the max allowed

	size_t window_size = min(prop.accessPolicyMaxWindowSize, 2097152); //2 MB                        // Select minimum of user defined num_bytes and max window size.

	cudaStreamAttrValue stream_attribute1,stream_attribute2;                                                       // Stream level attributes data structure
	stream_attribute1.accessPolicyWindow.base_ptr  = reinterpret_cast<DATA_TYPE*>(a_gpu);               // Global Memory data pointer
	stream_attribute1.accessPolicyWindow.num_bytes = window_size;                                // Number of bytes for persistence access
	stream_attribute1.accessPolicyWindow.hitRatio  = 1;                                        // Hint for cache hit ratio
	stream_attribute1.accessPolicyWindow.hitProp   = cudaAccessPropertyPersisting;               // Persistence Property
	stream_attribute1.accessPolicyWindow.missProp  = cudaAccessPropertyStreaming;                // Type of access property on cache miss
    //cudaStreamAttrID cudaStreamAttributeAccessPolicyWindow; 
	cudaStreamSetAttribute(stream, cudaStreamAttributeAccessPolicyWindow, &stream_attribute1);   // Set the attributes to a CUDA Stream

	//for(int i = 0; i < 10; i++) {
	//	cuda_kernelA<<<grid_size,block_size,0,stream>>>(data1);                                 // This data1 is used by a kernel multiple times
	//}                                                                                           // [data1 + num_bytes) benefits from L2 persistence
	//cuda_kernelB<<<grid_size,block_size,0,stream>>>(data1);                                     // A different kernel in the same stream can also benefit
																								// from the persistence of data1
	//The following instrs are for disabling the presistence
	stream_attribute1.accessPolicyWindow.num_bytes = 0;                                          // Setting the window size to 0 disable it
	cudaStreamSetAttribute(stream, cudaStreamAttributeAccessPolicyWindow, &stream_attribute1);   // Overwrite the access policy attribute to a CUDA Stream
	cudaCtxResetPersistingL2Cache();                                                            // Remove any persistent lines in L2 

	//cuda_kernelC<<<grid_size,block_size,0,stream>>>(data2);                                     // data2 can now benefit from full L2 in normal mode
    //----Ending  

	int gridd1=ceil((float)N/ ((float)DIM_THREAD_BLOCK_X));
	int blockx=DIM_THREAD_BLOCK_X;int blocky=DIM_THREAD_BLOCK_Y;
	printf("\n\n The blocks count is %d . The threads count_x is %d and the count_y is %d \n\n",gridd1,blockx,blocky);
	/* Start timer. */
  	polybench_start_instruments;
	
	mvt_kernel1<<<grid,block,0,stream>>>(n, a_gpu,x1_gpu,y_1_gpu);
	mvt_kernel2<<<grid,block,0,stream>>>(n, a_gpu,x2_gpu,y_2_gpu);
	cudaDeviceSynchronize();

	/* Stop and print timer. */
	printf("GPU Time in seconds:\n");
  	polybench_stop_instruments;
 	polybench_print_instruments;
	
	cudaMemcpy(x1_outputFromGpu, x1_gpu, sizeof(DATA_TYPE) * N, cudaMemcpyDeviceToHost);
	cudaMemcpy(x2_outputFromGpu, x2_gpu, sizeof(DATA_TYPE) * N, cudaMemcpyDeviceToHost);    
	
	cudaFree(a_gpu);
	cudaFree(x1_gpu);
	cudaFree(x2_gpu);
	cudaFree(y_1_gpu);
	cudaFree(y_2_gpu);
}


/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
// static
// void print_array(int n,
// 		 DATA_TYPE POLYBENCH_1D(x1,N,n),
// 		 DATA_TYPE POLYBENCH_1D(x2,N,n))

// {
//   int i;

//   for (i = 0; i < n; i++) {
//     fprintf (stderr, DATA_PRINTF_MODIFIER, x1[i]);
//     fprintf (stderr, DATA_PRINTF_MODIFIER, x2[i]);
//     if (i % 20 == 0) fprintf (stderr, "\n");
//   }
// }


int main(int argc, char *argv[])
{
	int n = N;

	POLYBENCH_2D_ARRAY_DECL(a,DATA_TYPE,N,N,n,n);
	POLYBENCH_1D_ARRAY_DECL(x1,DATA_TYPE,N,n);
	POLYBENCH_1D_ARRAY_DECL(x2,DATA_TYPE,N,n);
	POLYBENCH_1D_ARRAY_DECL(x1_outputFromGpu,DATA_TYPE,N,n);
	POLYBENCH_1D_ARRAY_DECL(x2_outputFromGpu,DATA_TYPE,N,n);
	POLYBENCH_1D_ARRAY_DECL(y_1,DATA_TYPE,N,n);
	POLYBENCH_1D_ARRAY_DECL(y_2,DATA_TYPE,N,n);

	init_array(n, POLYBENCH_ARRAY(a), POLYBENCH_ARRAY(x1), POLYBENCH_ARRAY(x2), POLYBENCH_ARRAY(y_1), POLYBENCH_ARRAY(y_2));
	
	GPU_argv_init();

	mvtCuda(n, POLYBENCH_ARRAY(a), POLYBENCH_ARRAY(x1), POLYBENCH_ARRAY(x2), POLYBENCH_ARRAY(y_1), POLYBENCH_ARRAY(y_2), POLYBENCH_ARRAY(x1_outputFromGpu), POLYBENCH_ARRAY(x2_outputFromGpu));

	// #ifdef RUN_ON_CPU
	
	// 	/* Start timer. */
	//   	polybench_start_instruments;

	// 	//run the algorithm on the CPU
	// 	runMvt(n, POLYBENCH_ARRAY(a), POLYBENCH_ARRAY(x1), POLYBENCH_ARRAY(x2), POLYBENCH_ARRAY(y_1), POLYBENCH_ARRAY(y_2));

	// 	/* Stop and print timer. */
	// 	printf("CPU Time in seconds:\n");
	//   	polybench_stop_instruments;
	//  	polybench_print_instruments;
	
	// 	compareResults(n, POLYBENCH_ARRAY(x1), POLYBENCH_ARRAY(x1_outputFromGpu), POLYBENCH_ARRAY(x2), POLYBENCH_ARRAY(x2_outputFromGpu));

	// #else //prevent dead code elimination

	// 	polybench_prevent_dce(print_array(n, POLYBENCH_ARRAY(x1_outputFromGpu), POLYBENCH_ARRAY(x2_outputFromGpu)));

	// #endif //RUN_ON_CPU

	POLYBENCH_FREE_ARRAY(a);
	POLYBENCH_FREE_ARRAY(x1);
	POLYBENCH_FREE_ARRAY(x2);
	POLYBENCH_FREE_ARRAY(x1_outputFromGpu);
	POLYBENCH_FREE_ARRAY(x2_outputFromGpu);
	POLYBENCH_FREE_ARRAY(y_1);
	POLYBENCH_FREE_ARRAY(y_2);

  	return 0;
}

#include <polybench.c>