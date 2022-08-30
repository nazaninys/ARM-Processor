`timescale 1ns/1ns

module mux #(parameter size)(input [size:0] inp1, inp2,input select, output[size:0] out);
  assign out = select ? inp2 : inp1;
endmodule
