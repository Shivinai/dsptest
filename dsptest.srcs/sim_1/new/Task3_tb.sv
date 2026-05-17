`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 07:28:49 PM
// Design Name: 
// Module Name: cdc_tb
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


module cdc_tb();

parameter WIDTH = 32;

logic RESET;
logic CLK_SRC;
logic CLK_DEST;
logic [WIDTH-1:0] DIN;
logic [WIDTH-1:0] DOUT;
logic LOAD;
logic VALID;

cdc #(
    .WIDTH(WIDTH)
) dut (
    .CLK_SRC(CLK_SRC),
    .CLK_DEST(CLK_DEST),
    .RESET(RESET),
    .DIN(DIN),
    .DOUT(DOUT),
    .LOAD(LOAD),
    .VALID(VALID)
);

initial CLK_SRC = 0;
always #5 CLK_SRC = ~CLK_SRC;

initial CLK_DEST = 0;
always #15 CLK_DEST = ~CLK_DEST;

task load_data(output logic [WIDTH-1:0] DATA_WORKLOAD);
    @(posedge CLK_SRC);
    DATA_WORKLOAD = $urandom(); 
    TEST_WORKLOAD.push_back(DATA_WORKLOAD);
    LOAD = 1'b1;
    @(posedge CLK_SRC);
    LOAD = 1'b0;
endtask;

int CNT = 0;
logic [WIDTH-1:0] TEST_WORKLOAD[$];
logic [WIDTH-1:0] TEMP_DATA;

initial begin
    RESET <= 1'b1;
    DIN <= '0;
    LOAD <= '0;
    
    #10;
    RESET <= 1'b0;
    
    $display("Test 1");
    repeat(10) begin
        load_data(DIN);
        
        @(posedge VALID);
        #1
        TEMP_DATA = TEST_WORKLOAD.pop_front();
        
        if (DOUT !== TEMP_DATA) begin
            $error("MISMATCH | Expected %h, got %h", TEMP_DATA, DOUT);
            CNT++;
        end else if (VALID !== 1'b1) begin
            $error("MISMATCH | VALID is not 1");
            CNT++;
        end else begin
            $display("MATCH | Passed: %h", DOUT);
        end
        
        #50;
    end
    
    $display("Test 2");
    repeat(10) begin
        load_data(DIN);
            
        @(posedge VALID);
        @(posedge CLK_DEST);
        #1
        
        if (VALID !== 1'b0) begin
            $error("MISMATCH | VALID did not drop to 0 after CLK_DEST cycle");
            CNT++;
        end else begin
            $display("MATCH | VALID was set to 0");
        end 
    end
    
    if (CNT !== 1'b0) begin
        $display("Got %h errors", CNT);
    end else begin
        $display("All tests passed");
    end
    
    $finish;
    
end

endmodule