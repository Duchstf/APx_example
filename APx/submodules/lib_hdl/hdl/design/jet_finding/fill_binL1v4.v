`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2018 02:48:05 PM
// Design Name: 
// Module Name: fill_binL1v4
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

//fill histogram with pt of incoming tracks
module fill_binL1v4 
    (
      input clk,
      input reset,
      input [8:0] E_add, //pT track coming in
      input bitx, //special track?
      input clustering, //whether or not we started clustering. If true, then we are just going to be writing 0 to reset for next event. After data is read, we immediately write a 0 so that it does not cause a problem the next time around
      input [4:0] writeeta, //eta address that we want to write to
      input [4:0] readeta, //eta address we want to read from
      input add_valid, //whether the track that is coming in is a valid track
      output [8:0] E_tot, //pT total of the bin that we asked for
      output [4:0] ntrx, //number of tracks
      output [3:0] xcount //number of special tracks
      //////////DEBUGGING///////////////
      ,
      output [8:0] tot_pt_out,
      output [8:0] old_pt_out,
      output     add_val3_out,
      output [8:0] new_pt2_out,
      output [8:0] ptout_out,
      output wea_out,
      output [4:0] re_out
    );
    
    //add valid track delays
    reg add_val1, add_val2, add_val3, add_val4, add_val5, add_val6, add_val7;
    reg wea; //write enable
    reg [4:0] eta1, eta2, eta3, eta4, eta5, eta6, eta7;
    reg [8:0] new_pt, new_pt1, new_pt2;
    reg new_x, x_1, x_2;
  
  //use 18 bits to make sure overflow doesn't occur 
    reg [17:0] tot_pt, tot_pt1, tot_pt2, tot_pt3, tot_pt4;
  //also count ntracks and ntracks of type x.  
    reg [9:0] tot_ntrx, tot_ntrx1, tot_ntrx2, tot_ntrx3;
    reg [7:0] tot_nx, tot_nx1, tot_nx2, tot_nx3;
    wire [17:0] cell_out; 
    wire [8:0] ptout = cell_out[17:9];
    wire [4:0] ntrks = cell_out[8:4];
    wire [3:0] nx = cell_out[3:0];
    wire [8:0] pt_upd = (tot_pt[17:9] == 9'b0 ? tot_pt[8:0] : 9'b111111111);
    wire [4:0] trk_upd = (tot_ntrx[9:5] == 5'b0 ? tot_ntrx[4:0] : 5'b11111);
    wire [3:0] x_upd = (tot_nx[7:4] == 4'b0 ? tot_nx[3:0] : 4'b1111);
    wire [17:0] cell_upd = {pt_upd, trk_upd, x_upd};
    wire update = wea;
    wire [4:0] re = (clustering? readeta: writeeta); //eta to read from

//old pt, before new track came in.
    reg [17:0] old_pt, old_pt1;
    reg [9:0] old_ntrx, old_ntrx1;
    reg [7:0] old_nx, old_nx1;
    reg reset1;
    reg [4:0] readeta1; //readeta delayed by 1
    
    always @(posedge clk) begin
        readeta1 <= readeta;
        eta1 <= writeeta;
        eta2 <= eta1;
        eta3 <= eta2;
        eta4 <= eta3;
        eta5 <= eta4;
        eta6 <= eta5;
        eta7 <= eta6;
        new_pt <= E_add;
        new_x <= bitx;
        new_pt1 <= new_pt;
        x_1 <= new_x;
        new_pt2 <= new_pt1;
        x_2 <= x_1;
        add_val1 <= add_valid;
        add_val2 <= add_val1;
        add_val3 <= add_val2;
        add_val4 <= add_val3;
        add_val5 <= add_val4;
        add_val6 <= add_val5;
        add_val7 <= add_val6;
        tot_pt1 <= tot_pt;
        tot_pt2 <= tot_pt1;
        tot_pt3 <= tot_pt2;
        tot_pt4 <= tot_pt3;
        
        tot_ntrx1 <= tot_ntrx;
        tot_ntrx2 <= tot_ntrx1;
        tot_ntrx3 <= tot_ntrx2;
        tot_nx1 <= tot_nx;
        tot_nx2 <= tot_nx1;
        tot_nx3 <= tot_nx2;
        reset1 <= reset;
      //set value of old_pt (what was there already)
        if(reset1) begin
            old_pt <= 0;
            old_ntrx <= 0;
            old_nx <= 0;
        end
       //if same eta on consecutive clocks
        else if(add_val3 & eta2 == eta3) begin
            old_pt <= old_pt + new_pt2;
            old_ntrx <= old_ntrx + 1;
            old_nx <= old_nx + {7'b0, x_2};
        end
       //if one clock between 
        else if(add_val4 & eta2 == eta4) begin
            old_pt <= tot_pt;
            old_ntrx <= tot_ntrx;
            old_nx <= tot_nx;
        end
      //if two clocks between
        else if(add_val5 & eta2 == eta5) begin
            old_pt <= tot_pt1;
            old_ntrx <= tot_ntrx1;
            old_nx <= tot_nx1;
        end
      //if three clocks between
        else if(add_val6 & eta2 == eta6) begin
            old_pt <= tot_pt2;
            old_ntrx <= tot_ntrx2;
            old_nx <= tot_nx2;
        end

        else begin
            old_pt <= (ptout == 0? 18'b0: {9'b0, ptout});
            old_ntrx <= ntrks;
            old_nx <= nx;
        end
        
      //set total pt (new pT to write to memory)
        if(reset1) begin
            wea <= 0;
        end
        else if(clustering) begin
            wea <= 1'b1;
            tot_pt <= 0;
            tot_ntrx <= 0;
            tot_nx <= 0;
        end
        else begin
            tot_pt <= new_pt2 + old_pt;
            tot_ntrx <= old_ntrx + 1;   //increment for every track
            tot_nx <= old_nx + {7'b0, x_2}; //increment only if bitx (delayed by 2) is true
            if(add_val3) begin
                 wea <= 1'b1;
            end
            else begin
                wea <= 1'b0;
            end
        end
    end
    
    //if in clustering state, just write 0 to whichever eta address was recently read from 
    //  (no new tracks are coming in, so just write 0s to prepare for next event).
    //   Otherwise, read from the requested eta, delayed by 4.
    wire [4:0] addra = (clustering? readeta1 : eta4);
    
    //histogram of pT, ntracks, and nx_tracks (concatenated together)
    Memory #(                                                                    
                   .RAM_WIDTH(18),
                   .RAM_DEPTH(32),
                   .RAM_PERFORMANCE("HIGH_PERFORMANCE")
                 ) histogram
                 (
                   .clka(clk),
                   .clkb(clk),
                   .addra(addra), 
                   .dina(cell_upd),
                   .wea(update),     
                   .rstb(reset),
                   .enb(1'b1),
                   .regceb(1'b1),
                   .addrb(re),  
                   .doutb(cell_out)  
         );

         reg [8:0] Etot;
         reg [4:0] ntx;
         reg [3:0] x_cnt;
         //if pt overflowed past 9 bits, assign E_tot to maximum.
         always @(posedge clk) begin
            ntx <= ntrks;
            x_cnt <= nx;
            Etot <= ptout;
         end
         
     assign E_tot = Etot;
     assign ntrx =  ntx;
     assign xcount = x_cnt;
     
     /////////DEBUGGING/////////////////
     assign tot_pt_out = tot_pt[8:0];
     assign old_pt_out = old_pt;
     assign add_val3_out = add_val3;
     assign new_pt2_out = new_pt2;
     assign ptout_out = ptout;
     assign wea_out = wea;
     assign re_out = re;
     ////////////////////////////////////
endmodule
