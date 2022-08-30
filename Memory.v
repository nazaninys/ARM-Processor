`timescale 1ns/1ns

module SRAM_Controller(input clk,rst,write_en,read_en,input[31:0] address,writeData,
    output [63:0] readData,output ready,inout [63:0] SRAM_DQ,output [16:0] SRAM_ADDR,
    output SRAM_WE_N);
    
    wire [63:0] localRegOut;
    wire ld;
    reg [2:0] counterOut;
    
    assign ld = 1'b1;
    LocalReg c1(clk,rst,ld,SRAM_DQ,localRegOut);
    assign readData = localRegOut;
    
    wire [31:0] addr;
    assign addr = address - 32'd1024;
    assign SRAM_ADDR = addr[18:2];
    
    assign SRAM_DQ = write_en ? writeData : 64'bz;
    
    assign SRAM_WE_N = ~write_en;
    
    assign ready = (read_en || write_en) && (counterOut < 3'b101) ?  1'b0 : 1'b1;
    
    
    always@(posedge clk,posedge rst)begin
      if(rst)
        counterOut <= 3'b000;
      else if((counterOut < 3'b101) && (read_en || write_en))
        counterOut <= counterOut + 1 ;
      else
        counterOut <= 3'b000;
    end
  
endmodule


module LocalReg(input clk,rst,ld,input [63:0] in,output reg [63:0] out);
    always@(posedge clk,posedge rst)begin
      if(rst)
        out <= 32'b0;
      else if(ld)
        out <= in;
    end
endmodule

module Cache_Controller(input clk, rst, input [31:0] address, writeData, input MEM_R_EN, 
                        MEM_W_EN, output reg [31:0] rdata, output ready, 
                        output reg [31:0] sram_address, sram_wdata, output reg write, read,
                        input [63:0] sram_rdata, input sram_ready);

  wire [16:0] cache_address;
  
  wire [31:0] addr;
  assign addr = address - 32'd1024;
  assign cache_address = addr[17:2];
  wire [31:0] cache_rdata;
  reg cache_write_en, cache_read_en;
  wire cache_hit, cache_invalid;
  
  Cache m1 (clk, rst, cache_address, sram_rdata, cache_read_en, cache_write_en, cache_invalid,
            cache_rdata, cache_hit);
  reg[1:0] ps, ns;
  always @(posedge clk, posedge rst) begin
    if (rst) ps <= 2'b0;
    else ps <= ns;
  end   
    
  always @(*) begin
    ns = ps;
    rdata = 32'bz;
    sram_address = 64'bz;
    sram_wdata = 64'bz;
    {write, read} = 2'b0;
    {cache_write_en, cache_read_en} = 2'b0;
    case (ps)
      2'b00 : begin 
       if (MEM_R_EN && ~cache_hit) ns = 2'b01;
       else if(MEM_W_EN) ns = 2'b10;
       rdata = (cache_hit) ? cache_rdata : 32'bz;
       cache_read_en = 1'b1;
      end
      2'b01 : begin
       if (sram_ready) ns = 2'b0;
       rdata = (sram_ready) ? (cache_address[0] ? sram_rdata[63:32] : sram_rdata[31:0]) : 32'bz;
       sram_address = address;
       read = 1'b1;
       cache_write_en = sram_ready;
      end
      2'b10 : begin 
        if (sram_ready) ns = 2'b0;
        sram_address = address;
        sram_wdata = writeData;
        write = 1'b1;
      end
    endcase
  end
          
  assign ready = (ns == 2'b0);
  assign cache_invalid = (ps == 2'b10);
             
endmodule
