`timescale 1ns/1ns
module Val2Generator(input [31:0] Val_Rm,input imm, MEM_CMD,input [11:0] Shift_operand,output reg[31:0] Val2);
   reg [31:0] val2_temp;
   integer i;
   
   always @(*)begin
     if(MEM_CMD)
       Val2 = {{20{Shift_operand[11]}},Shift_operand};
     else if(imm) begin
       val2_temp = {24'b0, Shift_operand[7:0]};
       
       for(i=0; i< {Shift_operand[11:8],1'b0}; i=i+1) begin
         val2_temp = {val2_temp[0],val2_temp[31:1]};
       end
       
       Val2 = val2_temp;
     end 
     else begin
            Val2 = Val_Rm;
            case (Shift_operand[6:5])
                00: Val2 = Val_Rm << Shift_operand[11:7];
              
                01: Val2 = Val_Rm >> Shift_operand[11:7];
              
                10: Val2 = Val_Rm >>> Shift_operand[11:7];
               
                11: begin
                    Val2 = Val_Rm;
                    for (i=0; i< Shift_operand[11:7]; i=i+1) begin
                        Val2 = {Val2[0], Val2[31:1]};
                    end
                end
            endcase
      end   
       
  end
 endmodule

        
