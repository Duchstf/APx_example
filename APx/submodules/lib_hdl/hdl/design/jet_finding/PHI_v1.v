`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2018 09:05:12 AM
// Design Name: 
// Module Name: PHI_v1
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

module PHI_v1
#(
    parameter ZBIN   = 4'b0000,
    parameter PHIBIN = 5'b00000, //length of ZBIN and ETABIN change from input type. Check what it should be
    parameter NETA = 24,
    parameter pTbits = 9
   )
   (
    input clk,
    input bramclk,                              
    input reset,
    input rstb,                                 
    input start,
    input stop,
    input mj_ready, //is merge_jets ready for us to do Layer 1 clustering (and send the data over)?
    
    //for negative eta values
    input [4:0] track_phi_ne,
    input [3:0] zbin1_ne,
    input [3:0] zbin2_ne,
    input [4:0] track_eta_ne,
    input [8:0] track_pt_ne,
    input       bitx_ne,

    //for positive eta values
    input [4:0] track_phi_pe,
    input [3:0] zbin1_pe,
    input [3:0] zbin2_pe,
    input [4:0] track_eta_pe,
    input [8:0] track_pt_pe,
    input       bitx_pe,
  
    output [22:0] L1_cluster_out,
    output L1_cluster_valid,
    
    output reg done, //whether or not we're done
    output filled //true when in the clustering state (histogram is filled)
    
    //DEBUGGING//////////
    ,
    output [3:0] state_out,
    output [8:0] pT1_out,
    output [4:0] curr_eta_out,
    output [8:0] curr_E_out,
    output       avr_out,
    output [8:0] jet_pt_out,
    output [4:0] jet_eta_out,
    output [8:0] my_E_out,
    output [8:0] left_E_out,
    output [8:0] right_E_out,
    output [8:0] right2E_out,
    output       jvalid_out,
    output [8:0] jpt_out,
    output [4:0] my_eta_out,
    output [3:0] cstate_out,
    output [8:0] tot_pt_out,
    output [8:0] old_pt_out,
    output       add_val3_out,
    output [8:0] new_pt2_out,
    output [8:0] ptout_out,
    output       clustering_out,
    output       wea_out,
    output [4:0] re_out,
    output [4:0] readeta_out
   ////////////////////////
   );
    
    parameter NETA1 = NETA-1;
    parameter NETA2 = NETA-2;

    //little state machine
    parameter IDLE = 4'b0001; //idle
    parameter READ = 4'b0010; //reading in tracks
    parameter DONE = 4'b0100; // done reading tracks and filling histogram
    parameter WAIT = 4'b1000; // wait for L1 clustering to finish
        
    reg start1, start2, start3, start4, start5, start6, start7, start8;
    reg stop1, stop2;
    reg [3:0] Dcount;
    reg [3:0] state = IDLE;
    reg initc;
    reg clustering;
    wire all_done;
    wire restart = reset | start;
    always @(posedge clk) begin
      if(restart) begin
        done <= 1'b0;
        state<=IDLE;
        initc <= 0;
      end
      else begin
        case(state) 
      //waiting for start signal 
        IDLE : begin
          clustering <= 1'b0;
          Dcount <= 0;
          done <= done;
          if(start4)
            state <= READ;
          else
            state <= IDLE;
        end
      //reading in tracks 
        READ : begin
          done <= 1'b0;
          if(stop1) begin //if stop, we're done reading
            state <= DONE;
          end
          else
            state <= READ;       
        end
       //done reading in tracks
        DONE : begin
        //wait 7 clks before starting to cluster
          done <= 1'b0;
          if(Dcount == 4'b0111) begin
            clustering <= 1'b1;
            Dcount <= Dcount + 1;
          end
          else if(Dcount == 4'b1001) begin
            if(mj_ready) begin 
                state <= WAIT;
                initc <= 1;
             end //if mj isn't ready yet, just keep Dcount the same and wait for it to be ready
             else begin
                state <= DONE;
             end
          end
          else begin
            Dcount <= Dcount +1;
            state <= DONE;
            initc <= 0;
          end
        end
       //wait for L1 clustering to finish
        WAIT : begin
          Dcount <= 0; //for next time
          initc <= 0; //only want it on for 1 clk
          if(all_done) begin
            done <= 1'b1;
            state <= IDLE;
          end
          else begin
            done <= 1'b0;
            state <= WAIT;
          end
        end
        endcase
      end
    end
    
    wire reset_j = reset | start;
   
   //does the incoming track belong to my zbin?
    wire right_z_ne = (zbin1_ne == ZBIN | zbin2_ne == ZBIN);
    wire right_z_pe = (zbin1_pe == ZBIN | zbin2_pe == ZBIN);

    wire right_phi_ne = (track_phi_ne == PHIBIN);
    wire right_phi_pe = (track_phi_pe == PHIBIN);
   
    reg [8:0] pT_ne, pT1_ne;
    reg [8:0] pT_pe, pT1_pe;

    reg right_z_reg_ne; //right_z delayed by 1
    reg right_z_reg_pe; //right_z delayed by 1
    reg right_phi_reg_ne; //right_phi delayed by 1
    reg right_phi_reg_pe; //right_phi delayed by 1
    reg [4:0] etabin1_ne; //delay
    reg [4:0] etabin1_pe; //delay
    reg avr_ne; //add_valid reg
    reg avr_pe; //add_valid reg
    reg [4:0] eta_in_ne; //eta bin
    reg [4:0] eta_in_pe; //eta bin
    wire [4:0] curr_eta; //eta bin that we are reading from the histogram
    reg [4:0] curr_eta1;
    reg [4:0] curr_eta2;
    reg [4:0] curr_eta3;
    reg [4:0] curr_eta4;
    reg [4:0] curr_eta5;
    reg [4:0] curr_eta6;
    wire [4:0] writeeta_ne = eta_in_ne; //eta address that we are writing to
    wire [4:0] writeeta_pe = eta_in_pe; //eta address that we are writing to
    reg state01; //true only when state[0] delayed by 1 is true 
    reg bitx_1_ne, bitx_2_ne; //delays on the special bit
    reg bitx_1_pe, bitx_2_pe; //delays on the special bit
    
    always @(posedge clk) begin
     //delay start by a few clocks to allow track conversion at top module 
       start1 <= start;
       start2 <= start1;
       start3 <= start2;
       start4 <= start3;
       start5 <= start4;
       start6 <= start5;
       start7 <= start6;
       start8 <= start7;
       
       curr_eta1 <= curr_eta;
       curr_eta2 <= curr_eta1;
       curr_eta3 <= curr_eta2;
       curr_eta4 <= curr_eta3;
       curr_eta5 <= curr_eta4;
       curr_eta6 <= curr_eta5;
       state01 <= state[1];  //true if in READ state (reading in tracks)
       if(state[1] | start4) begin
           etabin1_ne <= track_eta_ne;
           etabin1_pe <= track_eta_pe;
       end
       else if(state[3]) begin   //if clustering, zero the used etas. 
           etabin1_ne <= curr_eta-1;
           etabin1_pe <= curr_eta-1;
       end

       bitx_1_ne <= bitx_ne;
       bitx_2_ne <= bitx_1_ne;
       bitx_1_pe <= bitx_pe;
       bitx_2_pe <= bitx_1_pe;
       stop1 <= stop;
       stop2 <= stop1;
       pT_ne <= track_pt_ne;
       pT_pe <= track_pt_pe;
       pT1_ne <= pT_ne;                         //pT delayed by 1 cycle
       pT1_pe <= pT_pe;                         //pT delayed by 1 cycle
       right_z_reg_ne <= right_z_ne;
       right_z_reg_pe <= right_z_pe;
       right_phi_reg_ne <= right_phi_ne;
       right_phi_reg_pe <= right_phi_pe;
       eta_in_ne <= etabin1_ne;
       eta_in_pe <= etabin1_pe;
    end 
    
    wire [4:0] readeta = curr_eta; //eta address that we want to read from the histogram
    reg [4:0] readeta1;
    reg [4:0] readeta2;
    reg [4:0] readeta3;
    wire [8:0] curr_E_ne;  //pT from neg eta histogram
    wire [8:0] curr_E_pe;  //pT from pos eta histogram
    wire [8:0] curr_E = (readeta3 < 12) ? curr_E_ne : curr_E_pe;  //pT that is being passed from the histogram to the L1 clustering
    wire [4:0] curr_ntrx_ne; //number of tracks from neg eta histogram
    wire [4:0] curr_ntrx_pe; //number of tracks from pos eta histogram
    wire [4:0] curr_ntrx = (readeta3 < 12) ? curr_ntrx_ne : curr_ntrx_pe; //number of tracks
    wire [3:0] curr_xcnt_ne; //number of special tracks from neg eta histogram
    wire [3:0] curr_xcnt_pe; //number of special tracks from pos eta histogram
    wire [3:0] curr_xcnt = (readeta3 < 12) ? curr_xcnt_ne : curr_xcnt_pe; //number of special tracks

    wire add_valid_ne = right_z_reg_ne & right_phi_reg_ne & state[1] & pT_ne > 0; //add valid track?
    wire add_valid_pe = right_z_reg_pe & right_phi_reg_pe & state[1] & pT_pe > 0; //add valid track?
    
    fill_binL1v4 fb_ne //histogram for negative eta
    (
      .clk(clk),
      .reset(reset_j),
      .E_add(pT1_ne),  //pT delayed by (2) clock (to coincide with avr and writeeta)
      .bitx(bitx_2_ne), //to determine whether or not to increment xcount
      .clustering(clustering), //while clustering, only 0s should be written to memory
      .writeeta(writeeta_ne),  //eta getting written to memory
      .readeta(readeta),  //eta from which pT is being read
      .add_valid(avr_ne),  //add_valid delayed by (2) clock
      .E_tot(curr_E_ne),  //pT getting sent to L1cluster
      .ntrx(curr_ntrx_ne), //current ntracks
      .xcount(curr_xcnt_ne) //current x-count (ntracks of type x)
      /////////////DEBUGGING///////////////
      ,
      .tot_pt_out(tot_pt_out),
      .old_pt_out(old_pt_out),
      .add_val3_out(add_val3_out),
      .new_pt2_out(new_pt2_out),
      .ptout_out(ptout_out),
      .wea_out(wea_out),
      .re_out(re_out)
    );
fill_binL1v4 fb_pe //histogram for positive eta
    (
      .clk(clk),
      .reset(reset_j),
      .E_add(pT1_pe),  //pT delayed by (2) clock (to coincide with avr and writeeta)
      .bitx(bitx_2_pe), //to determine whether or not to increment xcount
      .clustering(clustering), //while clustering, only 0s should be written to memory
      .writeeta(writeeta_pe),  //eta getting written to memory
      .readeta(readeta),  //eta from which pT is being read
      .add_valid(avr_pe),  //add_valid delayed by (2) clock
      .E_tot(curr_E_pe),  //pT getting sent to L1cluster
      .ntrx(curr_ntrx_pe), //current ntracks
      .xcount(curr_xcnt_pe) //current x-count (ntracks of type x)
      /////////////DEBUGGING///////////////
      /*,
      .tot_pt_out(tot_pt_out),
      .old_pt_out(old_pt_out),
      .add_val3_out(add_val3_out),
      .new_pt2_out(new_pt2_out),
      .ptout_out(ptout_out),
      .wea_out(wea_out),
      .re_out(re_out)*/
    );
   
    wire [4:0] jet_eta;
    wire cluster_valid;
    wire [4:0] last_eta = jet_eta;  
        
    always @(posedge clk) begin
        readeta1 <= readeta;
        readeta2 <= readeta1;
        readeta3 <= readeta2;
        avr_ne <= add_valid_ne & state[1]; //only valid if still in the correct state
        avr_pe <= add_valid_pe & state[1]; //only valid if still in the correct state
    end
    
    assign filled = clustering;
//we're done if we're in the wait state and all eta bins have been seen
    assign all_done = (state == WAIT & curr_eta6 == 5'b11011);
      
    wire [8:0] jet_pt;
    wire [4:0] jet_ntrx;
    wire [3:0] jet_xcount;
    wire start_clust = initc;
       
    L1cluster_v6 L1c ( //first read through neg histogram, then pos, make sure the switch does not have an extra clk cycle in between
        .clk(clk),
        .reset(restart),
        .start(start_clust),
        .E_in(curr_E),   //pT coming in (from fill_bin)
        .ntrx_in(curr_ntrx),
        .nx_in(curr_xcnt),
        .curr_eta(curr_eta),  //eta from which to get pT
        .jet_valid(cluster_valid),
        .jet_pt(jet_pt),  //pT of cluster made by L1cluster
        .jet_eta(jet_eta), //eta of cluster made by L1cluster
        .jet_ntrx(jet_ntrx),
        .jet_xcount(jet_xcount)
        //////DEBUGGING/////////
        ,
        .my_E_out(my_E_out),
        .left_E_out(left_E_out),
        .right_E_out(right_E_out),
        .right2E_out(right2E_out),
        .jvalid_out(jvalid_out),
        .jpt_out(jpt_out),
        .my_eta_out(my_eta_out),
        .cstate_out(cstate_out)
        ////////////////////////////
    );
      
    //output cluster, to get passed to merge_jetsL1 and then L2 clustering.    
    wire [22:0] cluster_out = {jet_ntrx, jet_xcount, jet_eta, jet_pt};
 
  //  assign L1_pt_out = cluster_out[8:0];
 //   assign L1_eta_out = cluster_out[13:9];
    assign L1_cluster_out = cluster_out;
    assign L1_cluster_valid = cluster_valid;

  //////DEBUGGING//////////////
    assign state_out = state;
    assign pT1_out = pT1_ne;
    assign curr_eta_out = curr_eta;
    assign curr_E_out = curr_E;
    assign avr_out = avr_ne;
    assign jet_pt_out = jet_pt;
    assign jet_eta_out = jet_eta;
    assign clustering_out = clustering;
    assign readeta_out = readeta;
 ///////////////////////////////   
    
endmodule
