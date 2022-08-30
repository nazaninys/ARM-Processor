`timescale 1ns/1ns
module IF_Stage_Reg(input clk, rst, freeze, flush, input[31:0] PC_in, Instruction_in,
                    output reg [31:0] PC, Instruction);
  


  always @(posedge clk, posedge rst) begin
    if(rst) begin 
      PC <= 32'b0;
      Instruction <= 32'b0;
    end
    
    else if (flush) begin
      PC <= 32'b0;
      Instruction <= 32'b0;
    end
    
    else if(freeze == 1'b0)begin
        PC <= PC_in;
        Instruction <= Instruction_in;
    end
  end
endmodule
