`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 01:20:47 AM
// Design Name: 
// Module Name: trafficlight_package
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


package trafficlight_package;

    typedef enum logic [2:0] {
        SIGNAL_OFF = 3'b000,
        SIGNAL_RED = 3'b100,
        SIGNAL_YELLOW = 3'b010,
        SIGNAL_GREEN = 3'b001
    } LIGHT_SIGNAL_T;
    
    typedef enum logic [2:0] {
        STATE_IDLE,
        STATE_RED_1,
        STATE_YELLOW_1,
        STATE_GREEN,
        STATE_YELLOW_2,
        STATE_RED_2
    } FSM_STATE_T;

endpackage
