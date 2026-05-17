#/bin/bash

set -e

source $XILINX_VIVADO/settings64.sh
GLBL_FILE="$XILINX_VIVADO/data/verilog/src/glbl.v"

echo "Launching simulation"
xvlog -sv -L unisims_ver dsptest.srcs/sources_1/new/Task1.sv dsptest.srcs/sim_1/new/Task1_tb.sv
xvlog "$GLBL_FILE"

xelab -top sync_fifo_tb -top glbl -snapshot sync_fifo_sim -L unisims_ver
xsim sync_fifo_sim -tclbatch runtime.tcl
echo "Simulation finished"

