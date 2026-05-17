`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 06:52:09 PM
// Design Name: 
// Module Name: toggle_sync
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


module toggle_sync(
        input logic CLK_SRC,
        input logic RESET,
        input logic PULSE_IN,
        input logic CLK_DEST,
        
        output logic PULSE_OUT
    );
    
logic TOGGLE;
logic [2:0] SYNC;

always_ff @(posedge CLK_SRC or posedge RESET) begin
    if (RESET) begin
        TOGGLE <= 1'b0;
    end else if (PULSE_IN) begin
        TOGGLE <= ~TOGGLE;
    end
end

always_ff @(posedge CLK_DEST or posedge RESET) begin
    if (RESET) begin
        SYNC <= 3'b000;
    end else begin
        SYNC <= {SYNC[1:0], TOGGLE};
    end
end

assign PULSE_OUT = SYNC[2] ^ SYNC[1];

endmodule
