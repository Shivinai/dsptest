`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 06:18:35 PM
// Design Name: 
// Module Name: Task1_tb
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


module sync_fifo_tb();

parameter WIDTH = 16;
    
logic CLK;
logic RESET;
    
logic WRITE_ENABLE;
logic READ_ENABLE;
logic  [WIDTH-1:0] DIN;
logic   [WIDTH-1:0] DOUT;
          
logic FULL;
logic EMPTY;

sync_fifo #(
    .WIDTH(WIDTH)   
) dut (
    .CLK(CLK),
    .RESET(RESET),
    .WRITE_ENABLE(WRITE_ENABLE),
    .READ_ENABLE(READ_ENABLE),
    .DIN(DIN),
    .DOUT(DOUT),
    .FULL(FULL),
    .EMPTY(EMPTY)
);

initial CLK = 0;
always #5 CLK = ~CLK;

task write_data(input logic [WIDTH-1:0] DATA_WORKLOAD);
    @(posedge CLK);
    WRITE_ENABLE <= 1'b1;
    DIN <= DATA_WORKLOAD;
    @(posedge CLK);
    WRITE_ENABLE <= 1'b0;
endtask;

task read_data();
    @(posedge CLK);
    READ_ENABLE <= 1'b1;
    @(posedge CLK);
    READ_ENABLE <= 1'b0;
endtask;

logic [WIDTH-1:0] TEST_WORKLOAD[$];
logic [WIDTH-1:0] TEMP_DATA;
int CNT = 0;

initial begin
    RESET <= 1'b1;
    WRITE_ENABLE <= 1'b0;
    READ_ENABLE <= 1'b0;
    DIN <= '0;
    
    #100;    
    RESET <= 1'b0;
    @(posedge CLK);
    
    $display("Filling FIFO with random data");
    repeat(1024) begin
        TEMP_DATA = $urandom();
        TEST_WORKLOAD.push_back(TEMP_DATA);
        write_data(TEMP_DATA);
        @(posedge CLK);
    end
    
    $display("Comparing sent and received data");
    while(TEST_WORKLOAD.size() > 0) begin
        read_data();
        @(posedge CLK);
        
        TEMP_DATA = TEST_WORKLOAD.pop_front();
        
        if (DOUT !== TEMP_DATA) begin
            $error("MISMATCH | Expected %h, got %h", TEMP_DATA, DOUT);
            CNT++;
        end else begin
            $display("MATCH | Expected %h, got %h", TEMP_DATA, DOUT);
        end
    end
        
    if (EMPTY == 1'b1) begin
        $display("FIFO empty");
    end else begin
        $error("FIFO is not empty");
    end
    
    if (CNT == 0) begin
        $display("All tests passed");
    end else begin
        $display("Got %d errrors", CNT);
    end
    
    $finish;
    
    end;
    
endmodule
