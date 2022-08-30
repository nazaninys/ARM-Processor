module Cache(input clk, rst, input [16:0] address, input [63:0] w_data, input read_en,
             input write_en, input invalid, output [31:0] r_data, output hit);

  wire [9:0] tag;
  wire offset, hit0, hit1;
  wire [5:0] index;
  assign tag = address[16:7];
  assign index = address[6:1];
  assign offset = address[0];
  reg [31:0] data0 [0:1][0:63];
  reg [31:0] data1 [0:1][0:63];
  reg [9:0] tag0 [0:63];
  reg [9:0] tag1 [0:63];
  reg valid0 [0:63];
  reg valid1 [0:63];
  reg used [0:63] ;
  integer i;
  initial begin
    for (i = 0; i <= 63; i = i + 1) begin
      valid0[i] = 1'b0;
      valid1[i] = 1'b0;
      tag0[i] = 10'b0;
      tag1[i] = 10'b0;
      used[i] = 1'b0;
    end
  end
 
  assign hit0 = (tag0[index] == tag) && valid0[index];
  assign hit1 = (tag1[index] == tag) && valid1[index];
  assign hit = hit0 || hit1;
  assign r_data = (hit0) ? data0[offset][index] : data1[offset][index];
  
  always @(posedge clk) begin
    if (read_en) begin
      if (hit0)
        used[index] <= 1'b1;
      if (hit1) 
        used[index] <= 1'b0;
    end
  end
  
  always @(posedge clk) begin
    if (invalid && hit) begin
      if (hit0 == 1'b1) begin
        valid0[index] <= 1'b0;
        used[index] <= 1'b0;
      end
      else if(hit1 == 1'b1) begin
        valid1[index] <= 1'b0;
        used[index] <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if (write_en) begin
      if (used[index] == 1'b0) begin
        data0[1][index] <= w_data[63:32];
        data0[0][index] <= w_data[31:0];
        tag0[index] <= tag;
        valid0[index] <= 1'b1;
        used[index] <= 1'b1;
      end
      else if (used[index] == 1'b1) begin
        data1[1][index] <= w_data[63:32];
        data1[0][index] <= w_data[31:0];
        tag1[index] <= tag;
        valid1[index] <= 1'b1;
        used[index] <= 1'b0;
      end
    end
  end
  
  
  
endmodule