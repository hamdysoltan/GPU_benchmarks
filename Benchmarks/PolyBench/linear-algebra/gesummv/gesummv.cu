/**
 * gesummv.cu: This file is part of the PolyBench/GPU 1.0 test suite.
 *
 *
 * Contact: Scott Grauer-Gray <sgrauerg@gmail.com>
 * Will Killian <killian@udel.edu>
 * Louis-Noel Pouchet <pouchet@cse.ohio-state.edu>
 * Web address: http://www.cse.ohio-state.edu/~pouchet/software/polybench/GPU
 */

#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <cuda.h>

#define POLYBENCH_TIME 1

#include "gesummv.cuh"
#include <polybench.h>
#include <polybenchUtilFuncts.h>

//define the error threshold for the results "not matching"
#define PERCENT_DIFF_ERROR_THRESHOLD 0.05

#define GPU_DEVICE 0

/* Declared constant values for ALPHA and BETA (same as values in PolyBench 2.0) */
#define ALPHA 43532.0f
#define BETA 12313.0f

#define RUN_ON_CPU
FILE* fp ;

void gesummv(int n, DATA_TYPE alpha, DATA_TYPE beta, DATA_TYPE POLYBENCH_2D(A,NI,NI,n,n), DATA_TYPE POLYBENCH_2D(B,NI,NI,n,n), DATA_TYPE POLYBENCH_1D(tmp,NI,n),
		DATA_TYPE POLYBENCH_1D(x,NI,n), DATA_TYPE POLYBENCH_1D(y,NI,n))
{
	int i, j;
	
	for (i = 0; i < _PB_N; i++)
	{
		tmp[i] = 0;
		y[i] = 0;
		for (j = 0; j < _PB_N; j++)
		{
			tmp[i] = A[i][j] * x[j] + tmp[i];
			y[i] = B[i][j] * x[j] + y[i];
		}
		
		y[i] = alpha * tmp[i] + beta * y[i];
	}
}


void init(int n, DATA_TYPE *alpha, DATA_TYPE *beta, DATA_TYPE POLYBENCH_2D(A,NI,NI,n,n), DATA_TYPE POLYBENCH_2D(B,NI,NI,n,n), 
	DATA_TYPE POLYBENCH_1D(x,NI,n))
{
  	int i, j;

	*alpha = 43532;
	*beta = 12313;

 	for (i = 0; i < n; i++)
    	{
    		x[i] = ((DATA_TYPE) i) / NI;
      	
		for (j = 0; j < n; j++) 
		{
			A[i][j] = ((DATA_TYPE) i*j) / NI;
			B[i][j] = ((DATA_TYPE) i*j) / n;
		}
    }
}


void compareResults(int n, DATA_TYPE POLYBENCH_1D(y,NI,n), DATA_TYPE POLYBENCH_1D(y_outputFromGpu,NI,n))
{
	int i, fail;
	fail = 0;
	
	for (i=0; i<n; i++) 
	{
		if (percentDiff(y[i], y_outputFromGpu[i]) > PERCENT_DIFF_ERROR_THRESHOLD) 
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


__global__ void gesummv_kernel(int n, DATA_TYPE alpha, DATA_TYPE beta, DATA_TYPE* A, DATA_TYPE* B, DATA_TYPE* tmp, DATA_TYPE* x, DATA_TYPE* y)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;

	if (i < _PB_N)
	{
		int j;
		for(j = 0; j < _PB_N; j++)
		{	
			tmp[i] += A[i * NI + j] * x[j];
			y[i] += B[i * NI + j] * x[j];
		}
		y[i] = alpha * tmp[i] + beta  * y[i];
	}
}

void gesummvCuda(int n, DATA_TYPE alpha, DATA_TYPE beta, DATA_TYPE POLYBENCH_2D(A,NI,NI,n,n), DATA_TYPE POLYBENCH_2D(B,NI,NI,n,n), 
		DATA_TYPE POLYBENCH_1D(tmp,NI,n), DATA_TYPE POLYBENCH_1D(x,NI,n), DATA_TYPE POLYBENCH_1D(y,NI,n),  
		DATA_TYPE POLYBENCH_1D(y_outputFromGpu,NI,n))
{
	DATA_TYPE *A_gpu;
	DATA_TYPE *B_gpu;
	DATA_TYPE *x_gpu;
	DATA_TYPE *y_gpu;
	DATA_TYPE *tmp_gpu;

	cudaMalloc((void **)&A_gpu, sizeof(DATA_TYPE) * NI * NI);
	cudaMalloc((void **)&B_gpu, sizeof(DATA_TYPE) * NI * NI);
	cudaMalloc((void **)&x_gpu, sizeof(DATA_TYPE) * NI);
	cudaMalloc((void **)&y_gpu, sizeof(DATA_TYPE) * NI);
	cudaMalloc((void **)&tmp_gpu, sizeof(DATA_TYPE) * NI);
	
	cudaMemcpy(A_gpu, A, sizeof(DATA_TYPE) * NI * NI, cudaMemcpyHostToDevice);
	cudaMemcpy(B_gpu, B, sizeof(DATA_TYPE) * NI * NI, cudaMemcpyHostToDevice);
	cudaMemcpy(x_gpu, x, sizeof(DATA_TYPE) * NI, cudaMemcpyHostToDevice);
	cudaMemcpy(y_gpu, y, sizeof(DATA_TYPE) * NI, cudaMemcpyHostToDevice);
	cudaMemcpy(tmp_gpu, tmp, sizeof(DATA_TYPE) * NI, cudaMemcpyHostToDevice);

	dim3 block(DIM_THREAD_BLOCK_X, DIM_THREAD_BLOCK_Y);
	dim3 grid((unsigned int)ceil( ((float)NI) / ((float)block.x) ), 1);


	/* Start timer. */
  	polybench_start_instruments;

	gesummv_kernel<<< grid, block>>>(n, alpha, beta, A_gpu, B_gpu, tmp_gpu, x_gpu, y_gpu);
	cudaDeviceSynchronize();

	/* Stop and print timer. */
	printf("GPU Time in seconds:\n");
  	polybench_stop_instruments;
 	polybench_print_instruments;

	cudaMemcpy(y_outputFromGpu, y_gpu, sizeof(DATA_TYPE) * NI, cudaMemcpyDeviceToHost);
}


/* DCE code. Must scan the entire live-out data.
   Can be used also to check the correctness of the output. */
// static
// void print_array(int n,
// 		 DATA_TYPE POLYBENICH_1D(y,NI,n))

// {
//   int i;

//   for (i = 0; i < n; i++) {
//     fprintf (stderr, DATA_PRINITF_MODIFIER, y[i]);
//     if (i % 20 == 0) fprintf (stderr, "\n");
//   }
// }


int main(int argc, char *argv[])
{
	/* Retrieve problem size. */
	int n = NI;
	fp = fopen("a.csv", "a");
     if (!fp) {
        // Error in file opening
        printf("Can't open file\n");
        
    }
	fprintf(fp, "%d\n", NI);
	/* Variable declaration/allocation. */
	DATA_TYPE alpha;
	DATA_TYPE beta;
	POLYBENCH_2D_ARRAY_DECL(A,DATA_TYPE,NI,NI,n,n);
	POLYBENCH_2D_ARRAY_DECL(B,DATA_TYPE,NI,NI,n,n);
	POLYBENCH_1D_ARRAY_DECL(tmp,DATA_TYPE,NI,n);
	POLYBENCH_1D_ARRAY_DECL(x,DATA_TYPE,NI,n);
	POLYBENCH_1D_ARRAY_DECL(y,DATA_TYPE,NI,n);
	POLYBENCH_1D_ARRAY_DECL(y_outputFromGpu,DATA_TYPE,NI,n);

	init(n, &alpha, &beta, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(B), POLYBENCH_ARRAY(x));
	
	GPU_argv_init();
	gesummvCuda(n, alpha, beta, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(B), POLYBENCH_ARRAY(tmp), POLYBENCH_ARRAY(x), POLYBENCH_ARRAY(y),  
		POLYBENCH_ARRAY(y_outputFromGpu));
	
	// #ifdef RUN_ON_CPU

	// 	/* Start timer. */
	//   	polybench_start_instruments;

	// 	gesummv(n, alpha, beta, POLYBENCH_ARRAY(A), POLYBENCH_ARRAY(B), POLYBENCH_ARRAY(tmp), POLYBENCH_ARRAY(x), POLYBENCH_ARRAY(y));
		
	// 	/* Stop and print timer. */
	// 	printf("CPU Time in seconds:\n");
	//   	polybench_stop_instruments;
	//  	polybench_print_instruments;
	
	// 	compareResults(n, POLYBENCH_ARRAY(y), POLYBENCH_ARRAY(y_outputFromGpu));

	// #else //prevent dead code elimination

	// 	polybench_prevent_dce(print_array(n, POLYBENCH_ARRAY(y_outputFromGpu)));

	// #endif //RUN_ON_CPU


	POLYBENCH_FREE_ARRAY(A);
	POLYBENCH_FREE_ARRAY(B);  
	POLYBENCH_FREE_ARRAY(tmp);
	POLYBENCH_FREE_ARRAY(x);  
	POLYBENCH_FREE_ARRAY(y);
	POLYBENCH_FREE_ARRAY(y_outputFromGpu);

	return 0;
}

#include <polybench.c>