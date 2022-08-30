`timescale 1ns/1ns

module EXE_Stage_Reg (input clk, rst,  freeze, flush, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN
                    , input [31:0] ALU_Res_IN,Mux2_out,
                     input[3:0] Dest_IN, output WB_EN, MEM_R_EN, MEM_W_EN,
                     output [31:0] Val_Rm,ALU_Res, output [3:0] Dest);
  
  
  register #(2) c1 (clk, rst, freeze, 1'b0, {WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN}, {WB_EN, MEM_R_EN, MEM_W_EN});
  register #(31) c2 (clk, rst, freeze, 1'b0,ALU_Res_IN,ALU_Res);
  register #(31) c3 (clk, rst, freeze, 1'b0, Mux2_out,Val_Rm);
  register #(3) c4 (clk, rst, freeze, 1'b0, Dest_IN, Dest);
endmodule
  
  






