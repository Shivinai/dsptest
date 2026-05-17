#/bin/bash

set -e

source $XILINX_VIVADO/settings64.sh
GLBL_FILE="$XILINX_VIVADO/data/verilog/src/glbl.v"

echo "Launching simulation"
xvlog -sv -L unisims_ver dsptest.srcs/sources_1/new/Task2.sv dsptest.srcs/sim_1/new/Task2_tb.sv
xvlog "$GLBL_FILE"

xelab -top asix_mux_tb -top glbl -snapshot asix_mux_sim -L unisims_ver
xsim asix_mux_sim -tclbatch runtime.tcl
echo "Simulation finished"

