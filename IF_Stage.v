`timescale 1ns/1ns
module IF_Stage(input clk, rst, freeze, branch_taken, input[31:0] branchAddr, output [31:0] PC, Instruction);
  wire [31:0]  muxout, pcout;
  mux #(31) m1 (PC, branchAddr, branch_taken, muxout);
  PCounter m2 (muxout, clk, rst, freeze, pcout);
  InstMem m3 (pcout, Instruction);
  adder m4 ({29'b0, 3'b100}, pcout, PC);
endmodule
  

module adder (input [31:0] in1, in2, output[31:0] out);
  assign out = in1 + in2;
endmodule





module PCounter(input [31:0] Pcin, input clk, rst, freeze, output reg[31:0] Pcout);
  always @(posedge clk, posedge rst) begin
    if (rst) Pcout <= 32'b0;
    else if (freeze == 1'b0)
      Pcout <= Pcin;
 // else Pcout<= Pcin;
  end
endmodule


module InstMem(input [31:0] Address, output [31:0] instruction);
  reg [31:0] memory[0:199];
  initial begin
    $readmemb("inst.txt", memory);
  end
  assign instruction = memory[Address[31:2]];
endmodule
