#/bin/bash

set -e

source $XILINX_VIVADO/settings64.sh
GLBL_FILE="$XILINX_VIVADO/data/verilog/src/glbl.v"

echo "Launching simulation"
xvlog -sv -L unisims_ver dsptest.srcs/sources_1/new/trafficlight_package.sv dsptest.srcs/sources_1/new/Task4.sv dsptest.srcs/sim_1/new/Task4_tb.sv 
xvlog "$GLBL_FILE"

xelab -top trafficlight_controller_tb -top glbl -snapshot trafficlight_controller_sim -L unisims_ver
xsim trafficlight_controller_sim -tclbatch runtime.tcl
echo "Simulation finished"

