`timescale 1ns/1ns

module ID_Stage_Reg (input clk, rst, freeze, flush, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN,
                     input [3:0] EXE_CMD_IN,src1_IN,src2_IN,input [31:0] PC_IN, input [31:0] Val_Rn_IN, Val_Rm_IN,
                     input imm_IN, input [11:0] Shift_operand_IN, input[23:0] Signed_imm_24_IN,
                     input[3:0] Dest_IN, SR_IN, output  WB_EN, MEM_R_EN, MEM_W_EN, B, S,
                     output [3:0] EXE_CMD,src1,src2, output  [31:0] PC, output [31:0] Val_Rn, Val_Rm,
                     output imm, output [11:0] Shift_operand, output [23:0] Signed_imm_24,
                     output [3:0]Dest, SR_out);
  
  register #(5) c1 (clk, rst, freeze, flush, {WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN, imm_IN}, {WB_EN, MEM_R_EN, MEM_W_EN, B, S, imm});
  register #(3) c2 (clk, rst, freeze, flush, EXE_CMD_IN, EXE_CMD);
  register #(31) c3 (clk, rst, freeze, flush, PC_IN, PC);
  register #(63) c4 (clk, rst, freeze, flush, {Val_Rn_IN, Val_Rm_IN}, {Val_Rn, Val_Rm});
  register #(11) c5 (clk, rst, freeze, flush, Shift_operand_IN, Shift_operand);
  register #(23) c6 (clk, rst,  freeze, flush, Signed_imm_24_IN, Signed_imm_24) ;
  register #(7) c7 (clk, rst, freeze, flush, {Dest_IN, SR_IN}, {Dest, SR_out});
  register #(7)  c8 (clk,rst, freeze, flush,{src1_IN,src2_IN},{src1,src2});
endmodule
  
  





