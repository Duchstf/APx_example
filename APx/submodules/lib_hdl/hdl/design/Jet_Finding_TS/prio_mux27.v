`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2018 01:01:37 PM
// Design Name: 
// Module Name: prio_mux27
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


module prio_mux27
#(
  parameter WIDTH = 32
)
(
   input clk,
   input [4:0] sel,
   input [WIDTH-1:0] i0,
   input [WIDTH-1:0] i1,
   input [WIDTH-1:0] i2,
   input [WIDTH-1:0] i3,
   input [WIDTH-1:0] i4,
   input [WIDTH-1:0] i5,
   input [WIDTH-1:0] i6,
   input [WIDTH-1:0] i7,
   input [WIDTH-1:0] i8,
   input [WIDTH-1:0] i9,
   input [WIDTH-1:0] i10,
   input [WIDTH-1:0] i11,
   input [WIDTH-1:0] i12,
   input [WIDTH-1:0] i13,
   input [WIDTH-1:0] i14,
   input [WIDTH-1:0] i15,
   input [WIDTH-1:0] i16,
   input [WIDTH-1:0] i17,
   input [WIDTH-1:0] i18,
   input [WIDTH-1:0] i19,
   input [WIDTH-1:0] i20,
   input [WIDTH-1:0] i21,
   input [WIDTH-1:0] i22,
   input [WIDTH-1:0] i23,
   input [WIDTH-1:0] i24,
   input [WIDTH-1:0] i25,
   input [WIDTH-1:0] i26,
   
   output reg [WIDTH-1:0] o
   );
   
   always @(posedge clk) begin
     case(sel)
       5'b00000: o <= i0;
       5'b00001: o <= i1;
       5'b00010: o <= i2;
       5'b00011: o <= i3;
       5'b00100: o <= i4;
       5'b00101: o <= i5;
       5'b00110: o <= i6;
       5'b00111: o <= i7;
       5'b01000: o <= i8;
       5'b01001: o <= i9;
       5'b01010: o <= i10;
       5'b01011: o <= i11;
       5'b01100: o <= i12;
       5'b01101: o <= i13;
       5'b01110: o <= i14;
       5'b01111: o <= i15;
       5'b10000: o <= i16;
       5'b10001: o <= i17;
       5'b10010: o <= i18;
       5'b10011: o <= i19;
       5'b10100: o <= i20;
       5'b10101: o <= i21;
       5'b10110: o <= i22;
       5'b10111: o <= i23;
       5'b11000: o <= i24;
       5'b11001: o <= i25;
       5'b11010: o <= i26;
       default: o <= 32'hxxxxxxxx;
     endcase
   end

endmodule