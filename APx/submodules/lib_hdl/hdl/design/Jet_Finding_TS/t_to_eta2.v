`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2017 01:35:22 PM
// Design Name: 
// Module Name: t_to_eta2
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

//Convert t to etabin, with help from data file.
module t_to_eta(
                 input clk, 
                 input reset,
                 input [15:0] t,
                 output reg [4:0] eta   //register to improve timing performance
    );
    reg [4:0] eta_reg; //eta reg; used to be wire
    reg [4:0] eta_start;
    reg [4:0] eta_d; //delay
   //Lookup table, file is included in the Vivado project (was generated from python script '/home/mapsa/fpga/eta_mem_gen.py')
   /*
    Memory #( .INIT_FILE ("etamemfile.dat"), //.dat file has been updated to work for eta
              .RAM_WIDTH (5),  //there are 24 eta bins, so 5 bits are required for eta
              .RAM_DEPTH (4096)  //only use the first 12 bits of t
             ) tmem 
             (
              .addra(16'b0),
              .addrb(t), //data stored at t's value in the file will be the correct eta bin
              .dina (5'b0),
              .clka (clk),
              .clkb (clk),
              .wea (1'b0),
              .enb (1'b1),
              .rstb (reset),
              .regceb (1'b1),
              .doutb (eta_w)
            );
   */
          
   always @(posedge clk) begin
       if(t[15] == 1) begin //negative side
           eta_start <= t[14:13]*3;
       end
       else if(t[15] == 0) begin //positive side
           eta_start <= (5'b00100 + t[14:13])*3;
       end
       
       if(t[12:0] < 13'b0101010101010) begin //relative eta 0
           eta_reg <= 5'b00000;
       end
       else if(t[12:0] < 13'b1010101010100) begin //relative eta 1
           eta_reg <= 5'b00001;
       end
       else begin //relative eta 2
           eta_reg <= 5'b00010;
       end

        eta_d <= eta_start + eta_reg;
        eta <= eta_d;
   end
endmodule
