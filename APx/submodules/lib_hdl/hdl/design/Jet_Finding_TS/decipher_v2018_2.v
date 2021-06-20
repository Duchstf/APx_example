`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2018 01:36:47 PM
// Design Name: 
// Module Name: decipher_v2018_2
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

//This module takes the raw track data for one phibin and converts it to usable form.
module decipher_v2018_2
#(parameter NPHI = 27)
    (
    input clk,
    input valid, //true if valid track
    input reset,
    input [95:0] clust_in, //should be named track_in
    input [4:0] phi_sector,
    output [27:0] track //just parts of track that we want
    );
    parameter NPHI1 = NPHI-1; //if we want to change this, change it in the top file  
    
    reg [95:0] pre_track; //track with raw values
    reg valid1; //valid delayed by 1
    reg bitx, bitx_1, bitx_2; //arbitrary bit for another count, ie displaced, tight, etc.
    reg [4:0] phi_sector_reg;
    always@(posedge clk) begin //delays
        pre_track <= clust_in;
	phi_sector_reg <= phi_sector;
        valid1 <= valid;
        bitx <= pre_track[95];
        bitx_1 <= bitx;
        bitx_2 <= bitx_1;
    end
    
    //track pT inverse (actually just track pT for now but may change to 1/pT)
    wire [13:0] track_pt_inv = pre_track[13:0]; //actually just track_pt (inv happens beforehand)
    //track t (to be converted to eta)
    wire [15:0] track_t = pre_track[42:27]; //for us is just track_eta
     
    //converted values 
    wire [8:0] track_pt;
    wire [4:0] track_eta; //this is really the eta bin
    
/*     //Get pT out of pTinverse
    pTinverse_to_pT inv1 (
                            .clk(clk),
                            .reset(reset),
                            .pTinverse(track_pt_inv),
                            .pT(track_pt)
                          );*/
  //actually pT is coming in itself. No need to take inverse (as of now).
    //convert 16 bits of pT to just 9
 //Now updated to convert 15 bits of pT to 9 bits
    pt16_to_9 pt9 (
        .clk(clk),
        .reset(reset),
        .valid(valid1),
        .pt_in(track_pt_inv),
        .pt_out(track_pt)    
    );
        
     //Get eta out of t                     
    t_to_eta t2eta1 ( //this now finds the eta bin from the eta input
                        .clk(clk),
                        .reset(reset),
                        .t (track_t),
                        .eta (track_eta)
                      );
    
    wire [11:0] track_z = pre_track[54:43];
    wire [3:0] zbin1;
    wire [3:0] zbin2;
     
    //Get zbins out of z.
    // 2 zbins for each track (they're overlapping). 
    z_to_zbin6/*8*/ z2zb ( .clk(clk),
                      .reset(reset),
                      .z(track_z),
                      .zbin1(zbin1),
                      .zbin2(zbin2)     
                    ); 

    wire [11:0] rel_phi = pre_track[26:15];
    wire [4:0] phi_bin;
    relphi_to_phibin rp2pb (
    	.clk(clk),
    	.reset(reset),
    	.rel_phi(rel_phi),
	.start_phi(phi_sector_reg),
    	.phi_bin(phi_bin)
    );
     //output track is 28 bits: phibin(5), zbin1(4), zbin2(4), etabin(5), pT(9), special bit(1)               
    assign track = {phi_bin, zbin1, zbin2, track_eta, track_pt, bitx_2}; 
   
endmodule
