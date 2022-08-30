`timescale 1ns/1ns
module test();
  reg clk=0, rst,forwarding_EN=1'b1;
  reg SRAM_clk = 0;
  wire SRAM_WE_N;
  wire [16:0] SRAM_ADDR;
  wire [31:0] inst, pc, reg1, reg2, reg3, reg4;
  wire [63:0] SRAM_DQ;

  ARM cut (clk,rst,forwarding_EN, SRAM_DQ,SRAM_WE_N, SRAM_ADDR, inst, pc, reg1, reg2, reg3, reg4);
  SRAM sram(SRAM_clk,rst,SRAM_WE_N,SRAM_ADDR,SRAM_DQ);
  
  always #10 clk = ~clk;
  always #20 SRAM_clk = ~SRAM_clk;
  initial begin
    #40 rst = 1'b1; 
    #40 rst = 1'b0;
    #30000 $stop;
  end
endmodule

