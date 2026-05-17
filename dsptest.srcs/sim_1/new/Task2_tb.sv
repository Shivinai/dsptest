`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2026 05:19:37 PM
// Design Name: 
// Module Name: asix_mux_tb
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


module asix_mux_tb();

parameter WIDTH = 32;
parameter N = 2;

logic CLK;
logic [N-1:0][WIDTH-1:0] S_TDATA;
logic [N-1:0] S_TVALID;
logic [N-1:0] S_TLAST;
logic [N-1:0] S_TREADY;
logic [WIDTH-1:0] M_TDATA;
logic M_TVALID;
logic M_TLAST;
logic M_TREADY;
logic [$clog2(N)-1:0] SEL;

axis_mux #(
    .WIDTH(WIDTH),
    .N(N)
) dut (
    .S_TDATA(S_TDATA),
    .S_TVALID(S_TVALID),
    .S_TLAST(S_TLAST),
    .S_TREADY(S_TREADY),
    .M_TDATA(M_TDATA),
    .M_TVALID(M_TVALID),
    .M_TLAST(M_TLAST),
    .M_TREADY(M_TREADY),
    .SEL(SEL)
);

initial CLK = 0;
always #5 CLK = ~CLK;

task drive_channel(input int CHAN, input logic [WIDTH-1:0] DATA_WORKLOAD, input logic LAST_WORKLOAD);
    @(posedge CLK);
    S_TVALID[CHAN] <= 1'b1;
    S_TDATA[CHAN] <= DATA_WORKLOAD;
    S_TLAST[CHAN] <= LAST_WORKLOAD;
endtask;

task clear_channels();
    S_TVALID <= '0;
    S_TLAST <= '0;
endtask;

logic [WIDTH-1:0] TEST_WORKLOAD[$];
logic [WIDTH-1:0] TEMP_DATA;
int CNT = 0;

initial begin

    S_TDATA  <= '0;
    S_TVALID <= '0;
    S_TLAST  <= '0;
    M_TREADY <= 1'b0;
    SEL <= '0;
    
    @(posedge CLK);
    
    $display("Test 1");
    SEL <= 0;
    M_TREADY <= 1'b1;
    
    repeat(10) begin
        TEMP_DATA = $urandom();
        TEST_WORKLOAD.push_back(TEMP_DATA);
        
        S_TDATA[1] <= $urandom();
        S_TVALID[1] <= 1'b1;
        
        drive_channel(0, TEMP_DATA, 1'b0);
        @(posedge CLK);
        
        #1;
        TEMP_DATA = TEST_WORKLOAD.pop_front();
        
        if (M_TDATA !== TEMP_DATA) begin
            $error("MISMATCH CHANNEL0 | Expected data %h, got %h", TEMP_DATA, M_TDATA);
            CNT++;
        end else if (M_TVALID !== 1'b1) begin
            $error("MISMATCH CHANNEL0 | M_TVALID is not 1");
            CNT++;
        end else if (S_TREADY[1] !== 1'b0) begin
            $error("Inactive channel 1 tready is not 0");
            CNT++;
        end else begin
            $display("MATCH CHANNEL0 | Passed: %h", M_TDATA);
        end
        
        clear_channels();
    end
    
    $display("Test 2");
    SEL <= 1;
    
    repeat(10) begin
        TEMP_DATA = $urandom();
        TEST_WORKLOAD.push_back(TEMP_DATA);
        
        S_TDATA[0] <= $urandom();
        S_TVALID[0] <= 1'b1;
        
        drive_channel(1, TEMP_DATA, 1'b1);
        @(posedge CLK);
        
        #1; 
        TEMP_DATA = TEST_WORKLOAD.pop_front();
        
        if (M_TDATA !== TEMP_DATA) begin
            $error("MISMATCH CHANNEL1 | Expected data %h, got %h", TEMP_DATA, M_TDATA);
            CNT++;
        end else if (M_TLAST !== 1'b1) begin
            $error("MISMATCH CHHANNEL1 | m_tlast did not transfer to master");
            CNT++;
        end else begin
            $display("MATCH CHANNEL1 | Passed: %h with tlast", M_TDATA);
        end
        
        clear_channels();
    end

    $display("Test 3");
    M_TREADY <= 1'b0;
    TEMP_DATA = 32'h0451_DEAD;
    
    drive_channel(1, TEMP_DATA, 1'b0);
    @(posedge CLK);
    
    #1;
    if (M_TVALID !== 1'b1) begin
        $error("m_tvalid dropped while m_tready is 0");
        CNT++;
    end else if (S_TREADY[1] !== 1'b0) begin
        $error("s_tready[1] did not drop to 0");
        CNT++;
    end else if (M_TDATA !== TEMP_DATA) begin
        $error("Data corrupted during stall");
        CNT++;
    end else begin
        $display("It's all good, man");
    end
    
    M_TREADY <= 1'b1;
    clear_channels();
    @(posedge CLK);
    

    if (CNT == 0) begin
        $display("All tests passed");
    end else begin
        $display("Got %d errors", CNT);
    end
    
    $finish;

end

endmodule
