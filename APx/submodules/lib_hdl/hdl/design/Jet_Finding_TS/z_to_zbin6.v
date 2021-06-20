`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2018 12:31:52 AM
// Design Name: 
// Module Name: z_to_zbin6
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

//find correct zbins from input of 12 bits of z.
module z_to_zbin6(
                 input clk, 
                 input reset,
                 input [11:0] z,
                 output reg [3:0] zbin1,   //register to improve timing.
                 output reg [3:0] zbin2
    );
    
   reg [11:0] z_1, z_2; //z delayed by 1, 2 clks.
   reg z_big, z_vbig; //is z big? Is it very big?
   
   //zbin1, zbin2
   reg [3:0] zb1, zb2;
    
   always @(posedge clk) begin
    z_1 <= z; //z delayed by 1
    z_2 <= z_1;    //z delayed by 2
    z_big <= z[10:0] > 11'b01010101011; //true if -10cm <z< 0 or z>5cm
    z_vbig <= z[10:0] > 11'b10101010101; //true if -5cm <z<0 or z>10cm
    
    if(z_1[11]) begin //negative side
        zb1 <= z_vbig? 4'b0000 : 4'b0000; //even zbin 0 or 2?
        zb2 <= z_big?  4'b0000 : 4'b0000; //also in zbin 1 or too small?
    end
    else begin
        zb1 <= z_big? 4'b0000 : 4'b0000; //even zbin 2 or 4?
        zb2 <= z_vbig? 4'b0000 : 4'b0000; //also in zbin 3 or too large?
    end
    
  //extra delay to time up with t_to_eta converter.
    if(reset) begin
        zbin1 <= 0;
        zbin2 <= 0;
    end
    else begin
        zbin1 <= zb1;
        zbin2 <= zb2;
    end
   end
            
endmodule

