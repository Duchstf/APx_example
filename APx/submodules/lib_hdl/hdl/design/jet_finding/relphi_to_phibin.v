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

//Convert the relative phi + initial phi sector to the phi bin
module relphi_to_phibin (
                 input clk, 
                 input reset,
                 input [11:0] rel_phi,
		 input [4:0] start_phi,
                 output reg [4:0] phi_bin   //register to improve timing performance
    );
    reg [4:0] rel_phi_bin_reg; //eta reg; used to be wire
    reg [4:0] rel_phi_bin_reg1; //delay
   //Lookup table, file is included in the Vivado project (was generated from python script '/home/mapsa/fpga/eta_mem_gen.py')
   /*
    Memory #( .INIT_FILE ("relphimemfile.dat"), //.dat file has been updated to work for eta
              .RAM_WIDTH (5),  //there are 24 eta bins, so 5 bits are required for eta
              .RAM_DEPTH (4096)  //only use the first 12 bits of t
             ) tmem 
             (
              .addra(12'b0),
              .addrb(rel_phi), //data stored at t's value in the file will be the correct eta bin
              .dina (5'b0),
              .clka (clk),
              .clkb (clk),
              .wea (1'b0),
              .enb (1'b1),
              .rstb (reset),
              .regceb (1'b1),
              .doutb (rel_phi_bin_w)
            );
   */
   always @(posedge clk) begin
	if(rel_phi[11] == 1) begin //negative side
		if(11'b11111111111-rel_phi[10:0] > 11'b01010101010) begin
			rel_phi_bin_reg <= 5'b00000;
		end
		else if(11'b11111111111-rel_phi[10:0] < 11'b01010101010) begin
			rel_phi_bin_reg <= 5'b00001;
		end
	end
	else if(rel_phi[11] == 0) begin //positive side
		if(rel_phi[10:0] < 11'b01010101010) begin
			rel_phi_bin_reg <= 5'b00001;
		end
		else if(rel_phi[10:0] > 11'b01010101010) begin
			rel_phi_bin_reg <= 5'b00010;
		end
	end
        rel_phi_bin_reg1 <= rel_phi_bin_reg + start_phi;
	phi_bin <= rel_phi_bin_reg1;

   end
endmodule

