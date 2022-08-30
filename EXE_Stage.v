
`timescale 1ns/1ns

module EXE_Stage(input clk,rst,input WB_EN_IN,MEM_R_EN_IN,MEM_W_EN_IN,B,S,
                     input [3:0] EXE_CMD, input [31:0] PC,Val_Rn,Val_Rm,ALU_Res_Reg,Result_WB,
                     input imm,input[11:0] Shift_operand, input[23:0] Signed_imm24,
                     input [3:0]SR,input[1:0] Sel_src1,Sel_src2,
                     output [31:0]ALU_Res,Branch_Address,Mux2_out,output [3:0] status_out);
  wire MEM_CMD;
  wire [31:0] Val2;
  wire [3:0] status;
  wire [31:0] ALU_in1;

 
  assign MEM_CMD = MEM_R_EN_IN | MEM_W_EN_IN;
  
  adder Adder({{6{Signed_imm24[23]}},Signed_imm24, 2'b0} ,PC, Branch_Address);
  Val2Generator g1(Mux2_out,imm,MEM_CMD,Shift_operand,Val2);
  ALU alu(ALU_in1,Val2,EXE_CMD,SR[1],status,ALU_Res); 
  Status_Register sr(clk,rst,S,status,status_out);//{N,Z,C,V}
  
  assign ALU_in1 = (Sel_src1 == 2'b00)? Val_Rn : (Sel_src1 == 2'b01) ? 
  ALU_Res_Reg : (Sel_src1 == 2'b10) ? Result_WB : Val_Rn ;
  
  assign Mux2_out = (Sel_src2 == 2'b00)? Val_Rm : (Sel_src2 == 2'b01) ? 
  ALU_Res_Reg : (Sel_src2 == 2'b10) ? Result_WB : Val_Rm ;
  
endmodule
    
 // TODO Mode bayad 00 bashe   age B branche mish intori kard k ld = (S& ~B & ~MEM_CMD)
module Status_Register(input clk,rst,S,input [3:0] status_in,output reg [3:0]status_out);

  always@(negedge clk,posedge rst)begin
    if (rst)
      status_out <= 4'b0;
    else if (S)
      status_out <= status_in;
   end
endmodule 


      
    

