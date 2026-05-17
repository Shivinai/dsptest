`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 03:24:28 PM
// Design Name: 
// Module Name: axis_mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axis_mux#(
        parameter WIDTH = 32,
        parameter N = 2
    )(
        input logic [N-1:0][WIDTH-1:0] S_TDATA,
        input logic [N-1:0] S_TVALID,
        input logic [N-1:0] S_TLAST,
        output logic [N-1:0] S_TREADY,
        
        output logic [WIDTH-1:0] M_TDATA,
        output logic M_TVALID,
        output logic M_TLAST,
        input logic M_TREADY,
        
        input logic [$clog2(N)-1:0] SEL
    );
    

always_comb begin
    S_TREADY = '0;
    
    M_TVALID = S_TVALID[SEL];
    
    if(S_TVALID[SEL]) begin
        M_TDATA = S_TDATA[SEL];
        M_TLAST = S_TLAST[SEL];
    end else begin
        M_TDATA = '0;
        M_TLAST = '0;
    end
    
    S_TREADY[SEL] = M_TREADY;
end

endmodule
