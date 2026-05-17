`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 08:58:24 PM
// Design Name: 
// Module Name: trafficlight_controller
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

module trafficlight_controller#(
        parameter BLINK = 5,
        parameter RED = 20,
        parameter YELLOW = 10,
        parameter GREEN = 30
    )(
        input logic CLK,
        input logic RESET,
        input logic START,
        
        output LIGHT_SIGNAL_T LIGHT
    );
    
    FSM_STATE_T STATE;
    logic [15:0] TIMER;
    logic [15:0] BLINKER;
    logic BLINK_STATE;
    logic REPEATER;
    
always_ff @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        STATE <= STATE_IDLE;
        TIMER <= '0;
        BLINKER <= '0;
        BLINK_STATE <= 1'b0;
        REPEATER <= 1'b0;
    end else begin
        if (BLINKER < BLINK-1) begin
            BLINKER <= BLINKER + 1'b1;
        end else begin
            BLINKER <= '0;
            BLINK_STATE <= ~BLINK_STATE;
        end
        
        case (STATE)
            STATE_IDLE: begin
                TIMER <= '0;
                if (START) begin
                    STATE <= STATE_RED_1;
                    TIMER <= '0;
                end
            end
            
            STATE_RED_1: begin
                if (TIMER < RED - 1) TIMER <= TIMER + 1'b1;
                    else begin STATE <= STATE_YELLOW_1; TIMER <= '0; end
                end

            STATE_YELLOW_1: begin
                if (TIMER < YELLOW - 1) TIMER <= TIMER + 1'b1;
                else begin STATE <= STATE_GREEN; TIMER <= '0; end
            end

            STATE_GREEN: begin
                if (TIMER < GREEN - 1) TIMER <= TIMER + 1'b1;
                else begin STATE <= STATE_YELLOW_2; TIMER <= '0; end
            end

            STATE_YELLOW_2: begin
                if (START) REPEATER <= 1'b1; 
                    
                if (TIMER < YELLOW - 1) TIMER <= TIMER + 1'b1;
                else begin STATE <= STATE_RED_2; TIMER <= '0; end
            end

            STATE_RED_2: begin
                if (START) REPEATER <= 1'b1;
                    
                if (TIMER < RED - 1) TIMER <= TIMER + 1'b1;
                else begin
                    if (REPEATER) begin
                        STATE <= STATE_YELLOW_2; 
                        REPEATER <= 1'b0;   
                    end else begin
                        STATE <= STATE_IDLE;    
                    end
                    TIMER <= '0;
                end
            end
        endcase
    end
end

always_comb begin
    case (STATE)
        STATE_IDLE: LIGHT = BLINK_STATE ? SIGNAL_YELLOW : SIGNAL_OFF;
        STATE_RED_1: LIGHT = SIGNAL_RED;
        STATE_YELLOW_1: LIGHT = SIGNAL_YELLOW;
        STATE_GREEN: LIGHT = SIGNAL_GREEN;
        STATE_YELLOW_2: LIGHT = SIGNAL_YELLOW;
        STATE_RED_2: LIGHT = SIGNAL_RED;
        default: LIGHT = SIGNAL_OFF;
    endcase
end

endmodule
