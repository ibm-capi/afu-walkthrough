#!/bin/bash
SRC=/home/khill/pslse_projects/vadd-walkthrough/vadd
ROOT_DIR=/home/khill/pslse_src/pslse/afu_driver/src
xvhdl $SRC/vadd_pkg.vhd
xvhdl $SRC/mmio.vhd
xvhdl $SRC/job.vhd
xvhdl $SRC/datapath.vhd
xvhdl $SRC/afu.vhd
xelab -svlog $SRC/top.v -sv_root $ROOT_DIR -sv_lib libdpi -debug all
xsim -g work.top

