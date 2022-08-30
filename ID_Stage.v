`timescale 1ns/1ns

module ID_Stage(input clk, rst, input [31:0] Instruction, Result_WB, input writeBackEn, input [3:0] Dest_wb,
                input hazard, input [3:0] SR, output WB_EN, MEM_R_EN, MEM_W_EN, B, S,has_src1,
                output [3:0] EXE_CMD, output[31:0] Val_Rn, Val_Rm, output imm, output[11:0] Shift_operand,
                output [23:0] Signed_imm_24, output [3:0] Dest, src1, src2, output Two_src,
                 output[31:0] reg1, reg2, reg3, reg4);
  wire [3:0] regFile_src2;
  wire condout;
  wire S_c, MEM_R_EN_c, MEM_W_EN_c, WB_EN_c, B_c;
  wire [3:0] EXE_CMD_c;
  wire sel;
  wire [8:0] muxout;
  ControlUnit c1 (Instruction[27:26], Instruction[24:21], Instruction[20], S_c,has_src1, EXE_CMD_c, 
                  MEM_R_EN_c, MEM_W_EN_c, WB_EN_c, B_c);
  RegisterFile c2 (clk, rst, Instruction[19:16], regFile_src2, Dest_wb, Result_WB, writeBackEn, Val_Rn, Val_Rm,
                   reg1, reg2, reg3, reg4);
  Condition_Check c3 (Instruction[31:28], SR[3], SR[2], SR[1], SR[0], condout);
  mux #(3) c4 (Instruction[3:0],Instruction[15:12], MEM_W_EN_c, regFile_src2);
  mux #(8) c5 ({S_c, MEM_R_EN_c, MEM_W_EN_c, WB_EN_c, B_c, EXE_CMD_c}, 9'b0, sel, muxout);
  assign sel = hazard | (~condout);
  assign {S, MEM_R_EN, MEM_W_EN, WB_EN, B, EXE_CMD} = muxout;
  assign src1 = Instruction[19:16];
  assign src2 = regFile_src2;
  assign Two_src = (~Instruction[25]) | MEM_W_EN;
	assign Shift_operand = Instruction[11:0];
	assign Dest = Instruction[15:12];
	assign Signed_imm_24 = Instruction[23:0];
	///inam mese signalaye controller bayad bere tu mux?
  assign imm = Instruction[25];
endmodule
  
  


module RegisterFile(input clk, rst, input [3:0] src1, src2, Dest_wb, 
                    input [31:0] Result_WB, input writeBackEn, output [31:0] reg1, reg2, 
                    output[31:0] r1, r2, r3, r4);
      
  integer i;
  reg [31:0] regs [0:14];
  assign reg1 = regs[src1];
  assign reg2 = regs[src2];
  assign r1 = regs[1];
  assign r2 = regs[2];
  assign r3 = regs[3];
  assign r4 = regs[4];
  always @(negedge clk, posedge rst) begin
    if (rst) begin
      for (i=0; i<14; i=i+1)
        regs[i] <= i;
    end
    else if (writeBackEn) begin
      regs[Dest_wb] <= Result_WB;
    end
    
     
  end
endmodule


module ControlUnit(input [1:0] mode, input[3:0] OpCode, input S,
                    output Sout,has_src1, output reg [3:0] exec_cmd, output reg mem_read, mem_write, WB_Enable, B);
  assign Sout = S;
  assign has_src1 = ~((OpCode == 4'b1101) || (OpCode == 4'b1111) || mode == 2'b10) ;
  
  always @(mode, OpCode, S) begin
    {exec_cmd, mem_read, mem_write, WB_Enable, B} = 8'b0;
    if (mode == 2'b00) begin
      case (OpCode)
        4'b1101 : begin exec_cmd = 4'b0001; WB_Enable = 1'b1; end
        4'b1111 : begin exec_cmd = 4'b1001; WB_Enable = 1'b1; end
        4'b0100 : begin exec_cmd = 4'b0010; WB_Enable = 1'b1; end
        4'b0101 : begin exec_cmd = 4'b0011; WB_Enable = 1'b1; end
        4'b0010 : begin exec_cmd = 4'b0100; WB_Enable = 1'b1; end
        4'b0110 : begin exec_cmd = 4'b0101; WB_Enable = 1'b1; end
        4'b0000 : begin exec_cmd = 4'b0110; WB_Enable = 1'b1; end
        4'b1100 : begin exec_cmd = 4'b0111; WB_Enable = 1'b1; end
        4'b0001 : begin exec_cmd = 4'b1000; WB_Enable = 1'b1; end
        4'b1010 : begin exec_cmd = 4'b0100; WB_Enable = 1'b0; end
        4'b1000 : begin exec_cmd = 4'b0110; WB_Enable = 1'b0; end
      endcase
    end
    else if (mode == 2'b01) begin 
      exec_cmd = 4'b0010;
      if(S == 1) begin mem_read = 1'b1; WB_Enable = 1'b1; end
      else begin mem_write = 1'b1; WB_Enable = 1'b0; end
    end
    else begin exec_cmd = 4'bx; B = 1'b1; WB_Enable = 1'b0; end
  end
endmodule

module Condition_Check(input [3:0] cond, input N, Z, C, V, output reg condout);
  always @(*) begin
    condout = 1'b0;
    case(cond)
      4'b0000 : condout = (Z == 1) ? 1'b1 : 1'b0;
      4'b0001 : condout = (Z == 0) ? 1'b1 : 1'b0;
      4'b0010 : condout = (C == 1) ? 1'b1 : 1'b0;
      4'b0011 : condout = (C == 0) ? 1'b1 : 1'b0;
      4'b0100 : condout = (N == 1) ? 1'b1 : 1'b0;
      4'b0101 : condout = (N == 0) ? 1'b1 : 1'b0;
      4'b0110 : condout = (V == 1) ? 1'b1 : 1'b0;
      4'b0111 : condout = (V == 0) ? 1'b1 : 1'b0;
      4'b1000 : condout = (C == 1 && Z == 0) ? 1'b1 : 1'b0;
      4'b1001 : condout = (C == 0 || Z == 1) ? 1'b1 : 1'b0;
      4'b1010 : condout = (N == V) ? 1'b1 : 1'b0;
      4'b1011 : condout = (N != V) ? 1'b1 : 1'b0;
      4'b1100 : condout = (Z == 0 && N == V) ? 1'b1 : 1'b0;
      4'b1101 : condout = (Z == 1 || N != V) ? 1'b1 : 1'b0;
      4'b1110 : condout = 1'b1;
    endcase
  end
endmodule

    
    
  
      
    
