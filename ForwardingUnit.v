`timescale 1ns/1ns
module Forwarding_Unit(input en_forwarding,input [3:0]src1,src2,input Mem_WB_EN,WB_WB_EN,input [3:0] Mem_Dest,WB_Dest,
                      output reg [1:0] Sel_src1,Sel_src2);
       always@(*)begin
         {Sel_src1,Sel_src2} = 4'b0;
         if(en_forwarding)begin
            if(Mem_WB_EN && Mem_Dest == src1)
               Sel_src1 = 2'b01;
            else if(WB_WB_EN && WB_Dest == src1)
               Sel_src1 = 2'b10;
            if(Mem_WB_EN && Mem_Dest == src2)
                Sel_src2 = 2'b01;
            else if(WB_WB_EN && WB_Dest == src2)
                Sel_src2 = 2'b10;
         end
      end
           
endmodule

