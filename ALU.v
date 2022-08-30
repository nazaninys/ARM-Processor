`timescale 1ns/1ns
module ALU(input [31:0] val1,val2, input[3:0] EXE_CMD,input carry_in,output [3:0] status, output [31:0] ALU_Res);
  reg V,C;
  wire Z,N;
  reg [31:0] temp_res;
  wire [32:0] not_cin ;
  
  assign not_cin = carry_in ? 33'b0 : 33'd1;
  assign ALU_Res = temp_res;
  assign status = {N,Z,C,V};
  assign N = ALU_Res[31];
  assign Z = ALU_Res == 32'b0;
  
  always @(*) begin
    {C,V,temp_res} = 34'b0;
    case (EXE_CMD)
      //MOV
      4'b0001: temp_res = val2;
      //MVN
      4'b1001: temp_res = ~val2;
      //ADD LDR STR
      4'b0010: begin 
                  {C,temp_res} = val1 + val2;
                   V = (val1[31] == val2[31]) & (val1[31] != temp_res[31]);
               end
      //ADC
      4'b0011: begin
                  {C,temp_res} = val1 + val2 + carry_in;
                  V = (val1[31] == val2[31]) & (val1[31] != temp_res[31]);
                end
      //SUB CMP
      4'b0100: begin 
                  {C,temp_res} = val1 - val2;
                  V = (val1[31] != val2[31]) & (val1[31] != temp_res[31]);
                end
      //SBC
      4'b0101: begin
                  {C,temp_res} = val1 - val2 - not_cin;
                  V = (val1[31] != val2[31]) & (val1[31] != temp_res[31]);
                end
        
      //AND TST
      4'b0110: temp_res = val1 & val2;
      //ORR
      4'b0111: temp_res = val1 | val2;
      //EOR
      4'b1000: temp_res = val1 ^ val2;
    endcase
  end
endmodule  


