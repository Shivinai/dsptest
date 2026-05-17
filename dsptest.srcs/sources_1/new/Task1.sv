`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/16/2026 04:18:12 PM
// Design Name: 
// Module Name: Task1
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


module sync_fifo #(
        parameter WIDTH = 16
    )(
      input logic CLK,
      input logic RESET,
      
      input logic WRITE_ENABLE,
      input logic READ_ENABLE,
      input logic  [WIDTH-1:0] DIN,
      
      output logic   [WIDTH-1:0] DOUT,
      output logic FULL,
      output logic EMPTY
    );
    
logic [10:0] WRITE_PTR;
logic [10:0] READ_PTR;

logic [31:0] TEMP_IN;
logic [31:0] TEMP_OUT;

assign TEMP_IN = { {(32-WIDTH){1'b0} }, DIN};
assign DOUT = TEMP_OUT[WIDTH-1:0];

assign EMPTY = (WRITE_PTR == READ_PTR);
assign FULL = (WRITE_PTR[10] != READ_PTR[10]) && (WRITE_PTR[9:0] == READ_PTR[9:0]);

always_ff @(posedge CLK) begin
    if (RESET) begin
        WRITE_PTR <= '0;
        READ_PTR <= '0;
    end else begin
        if (WRITE_ENABLE && !FULL) begin
            WRITE_PTR <= WRITE_PTR + 1'b1;
        end
        
        if (READ_ENABLE && !EMPTY) begin
            READ_PTR <= READ_PTR +1'b1;
        end
    end
end

logic  [14:0] WRITE_ADDRESS;
logic [14:0] READ_ADDRESS;

assign WRITE_ADDRESS = {WRITE_PTR[9:0], 5'b00000};
assign READ_ADDRESS = {READ_PTR[9:0], 5'b00000};

// RAMB36E2: 36K-bit Configurable Synchronous Block RAM
//           UltraScale
// Xilinx HDL Language Template, version 2021.1

RAMB36E2 #(
   // CASCADE_ORDER_A, CASCADE_ORDER_B: "FIRST", "MIDDLE", "LAST", "NONE"
   .CASCADE_ORDER_A("NONE"),
   .CASCADE_ORDER_B("NONE"),
   // CLOCK_DOMAINS: "COMMON", "INDEPENDENT"
   .CLOCK_DOMAINS("COMMON"),
   // Collision check: "ALL", "GENERATE_X_ONLY", "NONE", "WARNING_ONLY"
   .SIM_COLLISION_CHECK("ALL"),
   // DOA_REG, DOB_REG: Optional output register (0, 1)
   .DOA_REG(0),
   .DOB_REG(0),
   // ENADDRENA/ENADDRENB: Address enable pin enable, "TRUE", "FALSE"
   .ENADDRENA("FALSE"),
   .ENADDRENB("FALSE"),
   // EN_ECC_PIPE: ECC pipeline register, "TRUE"/"FALSE"
   .EN_ECC_PIPE("FALSE"),
   // EN_ECC_READ: Enable ECC decoder, "TRUE"/"FALSE"
   .EN_ECC_READ("FALSE"),
   // EN_ECC_WRITE: Enable ECC encoder, "TRUE"/"FALSE"
   .EN_ECC_WRITE("FALSE"),   
   // INIT_A, INIT_B: Initial values on output ports
   .INIT_A(36'h000000000),
   .INIT_B(36'h000000000),
   // Initialization File: RAM initialization file
   .INIT_FILE("NONE"),
   // Programmable Inversion Attributes: Specifies the use of the built-in programmable inversion
   .IS_CLKARDCLK_INVERTED(1'b0),
   .IS_CLKBWRCLK_INVERTED(1'b0),
   .IS_ENARDEN_INVERTED(1'b0),
   .IS_ENBWREN_INVERTED(1'b0),
   .IS_RSTRAMARSTRAM_INVERTED(1'b0),
   .IS_RSTRAMB_INVERTED(1'b0),
   .IS_RSTREGARSTREG_INVERTED(1'b0),
   .IS_RSTREGB_INVERTED(1'b0),
   // RDADDRCHANGE: Disable memory access when output value does not change ("TRUE", "FALSE")
   .RDADDRCHANGEA("FALSE"),
   .RDADDRCHANGEB("FALSE"),
   // READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
   .READ_WIDTH_A(36),                                                                 // 0-9
   .READ_WIDTH_B(36),                                                                 // 0-9
   .WRITE_WIDTH_A(36),                                                                // 0-9
   .WRITE_WIDTH_B(36),                                                                // 0-9
   // RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG", "REGCE")
   .RSTREG_PRIORITY_A("RSTREG"),
   .RSTREG_PRIORITY_B("RSTREG"),
   // SRVAL_A, SRVAL_B: Set/reset value for output
   .SRVAL_A(36'h000000000),
   .SRVAL_B(36'h000000000),
   // Sleep Async: Sleep function asynchronous or synchronous ("TRUE", "FALSE")
   .SLEEP_ASYNC("FALSE"),
   // WriteMode: "WRITE_FIRST", "NO_CHANGE", "READ_FIRST"
   .WRITE_MODE_A("NO_CHANGE"),
   .WRITE_MODE_B("NO_CHANGE")
)
RAMB36E2_inst (
   // Cascade Signals outputs: Multi-BRAM cascade signals
   .CASDOUTA(),               // 32-bit output: Port A cascade output data
   .CASDOUTB(),               // 32-bit output: Port B cascade output data
   .CASDOUTPA(),             // 4-bit output: Port A cascade output parity data
   .CASDOUTPB(),             // 4-bit output: Port B cascade output parity data
   .CASOUTDBITERR(),     // 1-bit output: DBITERR cascade output
   .CASOUTSBITERR(),     // 1-bit output: SBITERR cascade output
   // ECC Signals outputs: Error Correction Circuitry ports
   .DBITERR(),                 // 1-bit output: Double bit error status
   .ECCPARITY(),             // 8-bit output: Generated error correction parity
   .RDADDRECC(),             // 9-bit output: ECC Read Address
   .SBITERR(),                 // 1-bit output: Single bit error status
   // Port A Data outputs: Port A data
   .DOUTADOUT(),             // 32-bit output: Port A Data/LSB data
   .DOUTPADOUTP(),         // 4-bit output: Port A parity/LSB parity
   // Port B Data outputs: Port B data
   .DOUTBDOUT(TEMP_OUT),             // 32-bit output: Port B data/MSB data
   .DOUTPBDOUTP(),         // 4-bit output: Port B parity/MSB parity
   // Cascade Signals inputs: Multi-BRAM cascade signals
   .CASDIMUXA(1'b0),             // 1-bit input: Port A input data (0=DINA, 1=CASDINA)
   .CASDIMUXB(1'b0),             // 1-bit input: Port B input data (0=DINB, 1=CASDINB)
   .CASDINA('0),                 // 32-bit input: Port A cascade input data
   .CASDINB('0),                 // 32-bit input: Port B cascade input data
   .CASDINPA('0),               // 4-bit input: Port A cascade input parity data
   .CASDINPB('0),               // 4-bit input: Port B cascade input parity data
   .CASDOMUXA(1'b0),             // 1-bit input: Port A unregistered data (0=BRAM data, 1=CASDINA)
   .CASDOMUXB(1'b0),             // 1-bit input: Port B unregistered data (0=BRAM data, 1=CASDINB)
   .CASDOMUXEN_A(1'b1),       // 1-bit input: Port A unregistered output data enable
   .CASDOMUXEN_B(1'b1),       // 1-bit input: Port B unregistered output data enable
   .CASINDBITERR(1'b0),       // 1-bit input: DBITERR cascade input
   .CASINSBITERR(1'b0),       // 1-bit input: SBITERR cascade input
   .CASOREGIMUXA(1'b0),       // 1-bit input: Port A registered data (0=BRAM data, 1=CASDINA)
   .CASOREGIMUXB(1'b0),       // 1-bit input: Port B registered data (0=BRAM data, 1=CASDINB)
   .CASOREGIMUXEN_A(1'b1), // 1-bit input: Port A registered output data enable
   .CASOREGIMUXEN_B(1'b1), // 1-bit input: Port B registered output data enable
   // ECC Signals inputs: Error Correction Circuitry ports
   .ECCPIPECE(1'b0),             // 1-bit input: ECC Pipeline Register Enable
   .INJECTDBITERR(1'b0),     // 1-bit input: Inject a double-bit error
   .INJECTSBITERR(1'b0),
   // Port A Address/Control Signals inputs: Port A address and control signals
   .ADDRARDADDR(WRITE_ADDRESS),         // 15-bit input: A/Read port address
   .ADDRENA(1'b1),                 // 1-bit input: Active-High A/Read port address enable
   .CLKARDCLK(CLK),             // 1-bit input: A/Read port clock
   .ENARDEN(WRITE_ENABLE && !FULL),                 // 1-bit input: Port A enable/Read enable
   .REGCEAREGCE(1'b0),         // 1-bit input: Port A register enable/Register enable
   .RSTRAMARSTRAM(RESET),     // 1-bit input: Port A set/reset
   .RSTREGARSTREG(RESET),     // 1-bit input: Port A register set/reset
   .SLEEP(1'b0),                     // 1-bit input: Sleep Mode
   .WEA(4'b1111),                         // 4-bit input: Port A write enable
   // Port A Data inputs: Port A data
   .DINADIN(TEMP_IN),                 // 32-bit input: Port A data/LSB data
   .DINPADINP(4'b0000),             // 4-bit input: Port A parity/LSB parity
   // Port B Address/Control Signals inputs: Port B address and control signals
   .ADDRBWRADDR(READ_ADDRESS),         // 15-bit input: B/Write port address
   .ADDRENB(1'b1),                 // 1-bit input: Active-High B/Write port address enable
   .CLKBWRCLK(CLK),             // 1-bit input: B/Write port clock
   .ENBWREN(READ_ENABLE && !EMPTY),                 // 1-bit input: Port B enable/Write enable
   .REGCEB(1'b0),                   // 1-bit input: Port B register enable
   .RSTRAMB(RESET),                 // 1-bit input: Port B set/reset
   .RSTREGB(RESET),                 // 1-bit input: Port B register set/reset
   .WEBWE(8'b00000000),                     // 8-bit input: Port B write enable/Write enable
   // Port B Data inputs: Port B data
   .DINBDIN('0),                 // 32-bit input: Port B data/MSB data
   .DINPBDINP('0)              // 4-bit input: Port B parity/MSB parity
);

// End of RAMB36E2_inst instantiation

endmodule
