#include "capi-vadd.h"
// Create Work Element Descriptor (WED) for AFU 
vadd_wed* create_wed(unsigned problem_size)
{
  vadd_wed *wed;
  posix_memalign((void**) &wed, CXL_ALIGNMENT, sizeof(*wed));
  // The datatype for this AFU is unsigned
  unsigned num_elements = CXL_ALIGNMENT/sizeof(unsigned);
  // Determine the number of cache lines needed for output data. 
  // Write_na only supports data transfers of power of 2.
  // Reserving the last cache line for each array ensures no data corruption 
  unsigned cache_lines = (problem_size%num_elements==0) ? 
      (problem_size/num_elements):(problem_size/num_elements+1); 
  wed->size = problem_size;
  posix_memalign(&wed->input1, CXL_ALIGNMENT, cache_lines*CXL_ALIGNMENT);
  posix_memalign(&wed->input2, CXL_ALIGNMENT, cache_lines*CXL_ALIGNMENT);
  posix_memalign(&wed->output, CXL_ALIGNMENT, cache_lines*CXL_ALIGNMENT);
  // Set initial values for done flag and clock_count
  // The AFU will write to these values upon completion 
  wed->done = 0;
  wed->clock_count = 0;

  return wed;
}
// Free our WED
void free_wed(vadd_wed *wed)
{
  free(wed->input1);
  free(wed->input2);
  free(wed->output);
  free(wed);
  return;
}

int main(int argc, char *argv[])
{
  // Number of elements in each array. Default size is 128
  unsigned problem_size = (argc>1) ? atoi(argv[1]):128;
  printf("Problem size: %d\n", problem_size);
  struct cxl_afu_h *afu;
  // Open the AFU on the FPGA. Currently hard-coded to afu0.0d
  afu = cxl_afu_open_dev("/dev/cxl/afu0.0d");
  if (!afu)
  {
    printf("ERROR: Failed to open AFU\n");
    return -1;
  }

  printf("Creating Work Element Descriptor\n");
  // Create a WED for the AFU
  vadd_wed *wed = create_wed(problem_size);
  // Display the values that are sent to the FPGA
  // These values will appear in the simulator when using PSLSE
  printf("WED: %p\n", wed);
  printf("Size: %X\n", wed->size);
  printf("input1: %p\n", wed->input1);
  printf("input2: %p\n", wed->input2);
  printf("output: %p\n", wed->output);
  int i;
  // Pointers to set the input arrays
  // WED has void pointers. This AFU uses unsigned numbers
  unsigned *input1 = (unsigned*) wed->input1;
  unsigned *input2 = (unsigned*) wed->input2;
  for (i=0; i<problem_size; i++)
  {
    input1[i] = i;
    input2[i] = i;
  }
  // Attach to the AFU. WED is sent to the FPGA
  cxl_afu_attach(afu, (__u64) wed);
  // Wait for the AFU to write to done
  printf("Waiting for done\n");
  while (!wed->done) sleep(1);

  printf("AFU finished\n");

  printf("Clock count: %lX\n", wed->clock_count);
  // Elapsed time for the AFU in us. (250 MHz clock)
  printf("Runtime %f us\n", (double) wed->clock_count/250.0);
  // Check AFU output
  unsigned errors = 0;
  unsigned *output = wed->output;
  printf("output: %p\n", output);
  for (i=0; i<problem_size; i++)
  {
    if(output[i] != 2*i)
    {
      printf("out%i: %X\n", i, output[i]);
      errors++;
    }
  }

  printf("Test %s\n", (errors==0)? "PASS":"FAIL");

  cxl_afu_free(afu);
  free_wed(wed);
  return 0;
}

