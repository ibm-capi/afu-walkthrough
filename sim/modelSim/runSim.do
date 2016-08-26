set DPI_DIR /home/khill/pslse_src/pslse/afu_driver/src

vsim work.top -sv_lib ${DPI_DIR}/libdpi
do dpiwave.do
run 100us

