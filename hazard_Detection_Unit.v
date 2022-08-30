`timescale 1ns/1ns
module hazard_Detection_Unit(input forwarding_EN,input [3:0] src1,src2,Exe_Dest,
  input Exe_WB_EN,EXE_Mem_R_EN,input [3:0] Mem_Dest,input Mem_WB_EN,input has_src1,Two_src,
  output reg hazard_Detected);
        
    always@(*)begin  
          hazard_Detected = 1'b0; 
   
          if(~forwarding_EN) begin      
            if(has_src1)begin 
                 if((src1 == Exe_Dest) && Exe_WB_EN)
                   hazard_Detected = 1'b1;
                 if((src1 == Mem_Dest) && Mem_WB_EN)
                   hazard_Detected = 1'b1;         
            end
            if(Two_src) begin
                if((src2 == Exe_Dest) && Exe_WB_EN)
                   hazard_Detected = 1'b1;
                if((src2 == Mem_Dest) && Mem_WB_EN)
                   hazard_Detected = 1'b1;  
            end
          end
          if(forwarding_EN && EXE_Mem_R_EN)begin
             if((has_src1 && Exe_Dest == src1) || (Two_src && Exe_Dest == src2))
                hazard_Detected = 1'b1;
          end
   end                         
endmodule

