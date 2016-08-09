/*
 * Copyright 2016 International Business Machines
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef _CAPI_VADD_H_
#define _CAPI_VADD_H_

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "libcxl.h"
// AFU data uses 128 byte alignment
#define CXL_ALIGNMENT 128

typedef struct
{
  // Problem size
  __u64 size;
  // Input arrays
  void *input1;
  void *input2;
  // Output arrays
  void *output;
  // Done flag. Marked volatile to block compiler optimizations
  __u64 volatile done;
  // Elasped execution time in clock cycles (AFU uses 250 MHz clock)
  __u64 clock_count;
  // reserve entire 128 byte cache line
  __u64 reserved01;
  __u64 reserved02;
  __u64 reserved03;
  __u64 reserved04;
  __u64 reserved05;
  __u64 reserved06;
  __u64 reserved07;
  __u64 reserved08;
  __u64 reserved09;
  __u64 reserved10;

} vadd_wed;

#endif

