`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2016 03:56:50 AM
// Design Name: 
// Module Name: prio_mux8
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module prio_mux8
 #(
  parameter WIDTH = 32
)
(
   input clk,
   input [3:0] sel,
   input [WIDTH-1:0] i0,
   input [WIDTH-1:0] i1,
   input [WIDTH-1:0] i2,
   input [WIDTH-1:0] i3,
   input [WIDTH-1:0] i4,
   input [WIDTH-1:0] i5,
   input [WIDTH-1:0] i6,
   input [WIDTH-1:0] i7,
   
   output reg [WIDTH-1:0] o
   );
   
   always @(posedge clk) begin
     case(sel)
       4'b0000: o <= i0;
       4'b0001: o <= i1;
       4'b0010: o <= i2;
       4'b0011: o <= i3;
       4'b0100: o <= i4;
       4'b0101: o <= i5;
       4'b0110: o <= i6;
       4'b0111: o <= i7;
       default: o <= 0;//32'hxxxxxxxx;
     endcase
   end

endmodule
