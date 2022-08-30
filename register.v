`timescale 1ns/1ns

module register #(parameter size) (input clk, rst, freeze, flush, input[size:0] inp, output reg[size:0] out);
  always @(posedge clk, posedge rst) begin
    if(rst || flush) 
      out <= 0;
    else if(freeze == 1'b0)
       out <= inp;
  end
endmodule

