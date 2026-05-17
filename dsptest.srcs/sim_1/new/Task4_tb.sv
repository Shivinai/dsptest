`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 09:21:25 PM
// Design Name: 
// Module Name: trafficlight_controller_tb
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

import trafficlight_package::*;

module trafficlight_controller_tb();

parameter BLINK = 5;
parameter RED = 20;
parameter YELLOW = 10;
parameter GREEN = 30;

logic CLK;
logic RESET;
logic START;
LIGHT_SIGNAL_T LIGHT;

trafficlight_controller #(
    .BLINK(BLINK),
    .RED(RED),
    .YELLOW(YELLOW),
    .GREEN(GREEN)
) dut (
    .CLK(CLK),
    .RESET(RESET),
    .START(START),
    .LIGHT(LIGHT)
);

initial CLK = 0;
always #5 CLK = ~CLK;

task pulse_start();
    @(posedge CLK);
    START <= 1'b1;
    @(posedge CLK);
    START <= 1'b0;
endtask

int CNT = 0;
LIGHT_SIGNAL_T LIGHT_QUEUE[$];
int DURATION_QUEUE[$];

LIGHT_SIGNAL_T TEMP_LIGHT;
int TEMP_DUR;

initial begin
    RESET <= 1'b1;
    START <= 1'b0;
    
    #50;
    @(posedge CLK);
    RESET <= 1'b0;
    
    $display("Test 1");
    repeat(4) begin
        TEMP_LIGHT = LIGHT;
        repeat(BLINK) @(posedge CLK);
        #1; 
        
        if (LIGHT === TEMP_LIGHT) begin
            $error("MISMATCH | Idle blinking failed to toggle after %0d cycles", BLINK);
            CNT++;
        end else begin
            $display("MATCH | Idle blinking toggled successfully");
        end
    end
    
    $display("Test 2"); 
    LIGHT_QUEUE.push_back(SIGNAL_RED);    
    DURATION_QUEUE.push_back(RED);
    LIGHT_QUEUE.push_back(SIGNAL_YELLOW); 
    DURATION_QUEUE.push_back(YELLOW);
    LIGHT_QUEUE.push_back(SIGNAL_GREEN);  
    DURATION_QUEUE.push_back(GREEN);
    LIGHT_QUEUE.push_back(SIGNAL_YELLOW); 
    DURATION_QUEUE.push_back(YELLOW);
    LIGHT_QUEUE.push_back(SIGNAL_RED);    
    DURATION_QUEUE.push_back(RED);
    
    pulse_start();
    
    repeat(5) begin
        TEMP_LIGHT = LIGHT_QUEUE.pop_front();
        TEMP_DUR = DURATION_QUEUE.pop_front();
        
        @(posedge CLK);
        #1;
        
        if (LIGHT !== TEMP_LIGHT) begin
            $error("MISMATCH | Expected state %b, got %b", TEMP_LIGHT, LIGHT);
            CNT++;
        end else begin
            $display("MATCH | Light %b switched successfully", TEMP_LIGHT);
        end
        
        if (TEMP_DUR > 1) begin
            repeat(TEMP_DUR - 1) @(posedge CLK);
        end
    end
    
    if (CNT !== 0) begin
        $display("Got %0d errors", CNT);
    end else begin
        $display("All tests passed");
    end
    
    $finish;
end

endmodule

