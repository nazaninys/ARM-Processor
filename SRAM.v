`timescale 1ns/1ns

module SRAM(input CLK,RST,SRAM_WE_N,input [16:0] SRAM_ADDR,inout [63:0] SRAM_DQ);
  reg [31:0] memory [0:511];
  assign #30 SRAM_DQ = SRAM_WE_N ? {memory[{SRAM_ADDR[16:1], 1'b1}], memory[{SRAM_ADDR[16:1], 1'b0}]}: 64'bz;
  always@(posedge CLK)begin
    if(~SRAM_WE_N)begin
      memory[SRAM_ADDR] = SRAM_DQ[31:0];
    end
  end
endmodule
