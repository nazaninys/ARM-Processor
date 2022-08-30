`timescale 1ns/1ns
module MEM_reg(input clk, rst, freeze, WB_en_in, MEM_R_en_in, input[31:0] ALU_result_in, Mem_read_value_in,
               input [3:0] Dest_in, output WB_en, MEM_R_en, output[31:0] ALU_result, Mem_read_value,
               output [3:0] Dest);
               

  register #(1) c1 (clk, rst, freeze, 1'b0, {WB_en_in, MEM_R_en_in}, {WB_en, MEM_R_en});              
  register #(63) c2 (clk, rst, freeze, 1'b0, {ALU_result_in, Mem_read_value_in}, {ALU_result, Mem_read_value});
  register #(3) c3 (clk, rst, freeze, 1'b0, Dest_in, Dest);
endmodule





