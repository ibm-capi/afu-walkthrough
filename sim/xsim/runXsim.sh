#!/bin/bash

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SRC=${ROOT_DIR}/../../vadd
PSLSE_DIR=/home/${USER}/pslse/afu_driver/src

cd $ROOT_DIR

xvhdl $SRC/vadd_pkg.vhd
xvhdl $SRC/mmio.vhd
xvhdl $SRC/job.vhd
xvhdl $SRC/datapath.vhd
xvhdl $SRC/afu.vhd
xelab -svlog ${PSLSE_DIR}/../verilog/top.v -sv_root $PSLSE_DIR -sv_lib libdpi -debug all
xsim -g work.top

