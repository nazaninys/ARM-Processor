`timescale 1ns/1ns
module ARM (input clk, rst,forwarding_EN,inout [63:0] SRAM_DQ,
 output SRAM_WE_N,output [16:0] SRAM_ADDR, output [31:0] inst, cur_pc, reg1, reg2, reg3, reg4);
 
  wire ready;
  wire IF_freeze,freeze, branch_taken, flush;
  wire has_src1;
  wire [1:0] Sel_src1,Sel_src2;
  wire [31:0] branchAddr, PC_IN, Instruction_IN, PC, PC_out, Instruction;
  wire [31:0] Result_WB, Val_Rn, Val_Rm, Val_Rn_IN, Val_Rm_IN, ALU_Res_IN, ALU_Res, Val_Rm_exout;
  wire writeBackEn, hazard, imm_IN, imm;
  wire [3:0] Dest_wb, SR, SR_out, EXE_CMD, EXE_CMD_IN, Dest_IN, Dest, src1, src2, Dest_exout;
  wire [3:0] src1_idout,src2_idout;
  wire  WB_EN, MEM_R_EN, MEM_W_EN, B, S, Two_src;
  wire  WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN;
  wire [11:0] Shift_operand_IN, Shift_operand;
  wire [23:0] Signed_imm_24_IN, Signed_imm_24;
  wire WB_EN_exout ,MEM_R_EN_exout ,MEM_W_EN_exout;
  wire [3:0] status_out, Dest_memout;
  wire [31:0] Mem_result, ALU_Res_memout, Mem_result_memout,Mux2_out;
  wire WB_EN_memout, MEM_R_EN_memout;
  wire [31:0] sram_address;
  wire [31:0] sram_wdata;
  wire sram_write_en, sram_read_en;
  wire [63:0] sram_rdata; 
  assign inst = Instruction;
  assign cur_pc = PC_IN;
  // hazard
  wire cache_ready;
  assign IF_freeze = hazard || freeze;
  assign freeze = ~cache_ready;
  assign flush = B;
  IF_Stage c1 (clk, rst, IF_freeze, flush,  branchAddr, PC_IN, Instruction_IN);
  
  IF_Stage_Reg c2 (clk, rst, IF_freeze, flush, PC_IN, Instruction_IN, PC, Instruction);
  
  ID_Stage c3 (clk, rst, Instruction, Result_WB, WB_EN_memout, Dest_memout, hazard, status_out, 
               WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN, has_src1,
               EXE_CMD_IN, Val_Rn_IN, Val_Rm_IN, imm_IN, Shift_operand_IN,
               Signed_imm_24_IN, Dest_IN, src1, src2, Two_src, reg1, reg2, reg3, reg4);
               
  ID_Stage_Reg c4 (clk, rst, freeze, flush, WB_EN_IN, MEM_R_EN_IN, MEM_W_EN_IN, B_IN, S_IN,
                   EXE_CMD_IN,src1,src2, PC, Val_Rn_IN, Val_Rm_IN,
                   imm_IN, Shift_operand_IN, Signed_imm_24_IN,
                   Dest_IN,status_out, WB_EN, MEM_R_EN, MEM_W_EN, B, S,
                   EXE_CMD,src1_idout,src2_idout, PC_out, Val_Rn, Val_Rm, imm, Shift_operand, Signed_imm_24,
                   Dest, SR_out);
                   
  EXE_Stage c5 (clk,rst, WB_EN,MEM_R_EN,MEM_W_EN,B,S,
                     EXE_CMD, PC_out,Val_Rn,Val_Rm,ALU_Res,Result_WB,
                     imm,Shift_operand, Signed_imm_24, SR_out,Sel_src1,Sel_src2,
                     ALU_Res_IN,branchAddr,Mux2_out, status_out);
                     
  EXE_Stage_Reg c6 (clk, rst,freeze, flush, WB_EN, MEM_R_EN, MEM_W_EN,
                    ALU_Res_IN,Mux2_out,
                     Dest, WB_EN_exout, MEM_R_EN_exout, MEM_W_EN_exout,
                     Val_Rm_exout, ALU_Res, Dest_exout);
  
  
 // Memory c7 (clk, rst, MEM_R_EN_exout, MEM_W_EN_exout, ALU_Res, Val_Rm_exout, Mem_result);

  MEM_reg c8 (clk, rst,freeze, WB_EN_exout, MEM_R_EN_exout, ALU_Res, Mem_result,
              Dest_exout, WB_EN_memout, MEM_R_EN_memout, ALU_Res_memout, Mem_result_memout,
              Dest_memout);
              
  WB_stage c9 (ALU_Res_memout, Mem_result_memout, MEM_R_EN_memout, Result_WB);
  
  hazard_Detection_Unit c10 (forwarding_EN, src1, src2, Dest, WB_EN, MEM_R_EN, Dest_exout, WB_EN_exout,
                             has_src1,Two_src, hazard);
  Forwarding_Unit c11(forwarding_EN,src1_idout,src2_idout,WB_EN_exout,WB_EN_memout,Dest_exout,Dest_memout,
                     Sel_src1,Sel_src2);
 
  SRAM_Controller c12 (clk, rst, sram_write_en, sram_read_en, sram_address, sram_wdata, 
                       sram_rdata, sram_ready, SRAM_DQ, SRAM_ADDR, SRAM_WE_N);
        
  Cache_Controller c13(clk, rst, ALU_Res, Val_Rm_exout, MEM_R_EN_exout, MEM_W_EN_exout,
                       Mem_result, cache_ready, sram_address, sram_wdata, sram_write_en,
                       sram_read_en, sram_rdata, sram_ready);
                             
endmodule