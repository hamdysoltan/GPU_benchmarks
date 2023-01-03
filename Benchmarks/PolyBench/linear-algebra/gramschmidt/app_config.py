kernel_1 = {

	"kernel_name"			: "gramschmidt_kernel1",
	"num_registers"			: 29,
	"shared_mem_bytes"		: 0,
	"grid_size"			: 128,
	"block_size"			: 256,
	"cuda_stream_id"		: 0
}

kernel_2 = {

	"kernel_name"			: "gramschmidt_kernel2",
	"num_registers"			: 15,
	"shared_mem_bytes"		: 0,
	"grid_size"			: 128,
	"block_size"			: 256,
	"cuda_stream_id"		: 0
}

kernel_3 = {

	"kernel_name"			: "gramschmidt_kernel3",
	"num_registers"			: 28,
	"shared_mem_bytes"		: 0,
	"grid_size"			: 128,
	"block_size"			: 256,
	"cuda_stream_id"		: 0
}

app_kernels_id = [1, 2, 3]