#/bin/bash

set -e

source $XILINX_VIVADO/settings64.sh
GLBL_FILE="$XILINX_VIVADO/data/verilog/src/glbl.v"

echo "Launching simulation"
xvlog -sv -L unisims_ver dsptest.srcs/sources_1/new/Task3.sv dsptest.srcs/sources_1/new/sync.sv dsptest.srcs/sim_1/new/Task3_tb.sv
xvlog "$GLBL_FILE"

xelab -top cdc_tb -top glbl -snapshot cdc_sim -L unisims_ver
xsim cdc_sim -tclbatch runtime.tcl
echo "Simulation finished"

