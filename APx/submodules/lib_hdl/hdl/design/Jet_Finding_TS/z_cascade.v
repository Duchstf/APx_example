`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2018 02:34:38 PM
// Design Name: 
// Module Name: Decipher_v2018_0
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

module z_cascade       
#(
     parameter NZ = 2, //number of z-bins
     parameter NPHI = 27 //number of phibins
   )
   (
    input clk,
    input bramclk,                                                 
    input reset,
    input rstb,
    input start,
    input stop,

      //tracks of each phibin
      input [27:0] track_in0,
      input [27:0] track_in1,
      input [27:0] track_in2,
      input [27:0] track_in3,
      input [27:0] track_in4,
      input [27:0] track_in5,
      input [27:0] track_in6,
      input [27:0] track_in7,
      input [27:0] track_in8,
      input [27:0] track_in9,
      input [27:0] track_in10,
      input [27:0] track_in11,
      input [27:0] track_in12,
      input [27:0] track_in13,
      input [27:0] track_in14,
      input [27:0] track_in15,
      input [27:0] track_in16,
      input [27:0] track_in17,
      /*input [22:0] track_in18,
      input [22:0] track_in19,
      input [22:0] track_in20,
      input [22:0] track_in21,
      input [22:0] track_in22,
      input [22:0] track_in23,
      input [22:0] track_in24,
      input [22:0] track_in25,
      input [22:0] track_in26,*/
      input   [7:0] final_cluster_addr,
      input event_done, //true once all clusters from the event are read
    
    output [31:0] final_cluster_out,
    output [8:0] HTmax,
    output [7:0] Nmax,
    output reg L1done,
    output reg all_done,
    output [3:0] zmax
 /////////////////DEBUGGING//////////////////////
    ,
    output [3:0] state_phi,  //state for phibin
    output [2:0] state_out,  //state for zbin
    output [8:0] pT1_out,
    output [26:0] L1_done_out,
    output [5:0] all_L1_done_out,
    output [26:0] phi_clust_val,
    output     avr_out,
    output [5:0] L2_done_out,
    output [8:0] jet_pt_out,
    output [4:0] jet_eta_out,
    output [8:0] curr_E_out,
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
      output [26:0] clustering_out,
      output       wea_out,
      output [4:0] re_out,
      output [4:0] readeta_out,
      output [4:0] L2_phi_in_out,
      output [8:0] L2_pt_in_out,
      output wenj2_out,
      output [4:0] L1addr_out,
      output [3:0] L2state_out,
      output [5:0] start_clust_out,
      output [23:0] row_done_out
 ////////////////////////////////////////////////
    );
 //////////////DEBUGGING/////////////////////////////////    
     wire        [2:0] state_o[5:0];      
     wire        [3:0] state_p[5:0]; //state for phibin
     wire  [8:0] pT1_o [5:0];
     wire  [26:0]  L1_done_o [5:0];
     wire  [5:0] all_L1_done_o;
     wire  [26:0] phi_val_o[5:0];
     wire         avr_o[5:0];
     wire  [8:0]  jet_pt_o[5:0];
     wire  [4:0] jet_eta_o[5:0];
     wire  [8:0]  curr_E_o[5:0];
     wire [8:0] my_E_o[5:0];
     wire [8:0] left_E_o[5:0];
     wire [8:0] right_E_o[5:0];
     wire [8:0] right2E_o[5:0];
     wire       jvalid_o[5:0];
     wire [8:0] jpt_o[5:0];
     wire [4:0] my_eta_o[5:0];
     wire [3:0] cstate_o[5:0];
     wire [8:0] tot_pt_o [5:0];       
     wire [8:0] old_pt_o [5:0];       
     wire       add_val3_o [5:0];     
     wire [8:0] new_pt2_o [5:0];      
     wire [8:0] ptout_o  [5:0];       
     wire [26:0] clustering_o[5:0];    
     wire       wea_o  [5:0];         
     wire [4:0] re_o   [5:0];
     wire [4:0] readeta_o[5:0];
     wire [4:0] L2_phi_in_o[5:0];
     wire [8:0] L2_pt_in_o[5:0];
     wire [4:0] L1addr_o[5:0];
     wire [5:0] wenj2_o;
     wire [3:0] L2state_o[5:0];
     wire [5:0] start_clust_o;
     wire [23:0] row_done_o[5:0];
 //////////////////////////////////////////////////////////
    
    
    parameter NZ1 = NZ - 1;
  
  wire [31:0] jet_out[NZ1-1:0];  //output data; is an array because there is one jet coming from each z-bin
  wire [7:0] num[NZ1-1:0]; //number of jets from each z-bin       

  wire [NZ1-1:0] L2_done; //level 2 clustering is done for each z-bin
  reg [NZ1-1:0] L2_done1, L2_done2, L2_done3; //L2 done delayed by 1,2,3
  reg [NZ1-1:0] L2_done_reg; //possibly another delay
  wire [NZ1-1:0] L1_done; //Layer 1 clustering is done
  reg restart=0, start1=0; //restart is reset or start, start1 is start delayed by 1
  reg event_done1=0; //event_done delayed by 1
  always @(posedge clk) begin
    L2_done1 <= L2_done;
    L2_done2 <= L2_done1;
    L2_done3 <= L2_done2;
    event_done1 <= event_done;
    restart <= reset | start;
    start1 <= start;
    if(reset) begin
      L1done <= 1; //start at 1 so first event can start
    end
    else if(start1) begin
      L1done <= 0; //we are now in the middle of our process, so we are not done
    end
    else if(L1_done == {NZ1{1'b1}}) begin
      L1done <= 1;
    end
    //reset all_done as soon as all clusters from the event are read
    if(reset) begin
       all_done <= 0; //input does not care about whether layer 2 is done. All_done says whether or not layer 2 is done.
    end
    else if(event_done || event_done1) begin
       all_done <= 0; //We started a new event, not done
    end
    else if(L2_done_reg == {NZ1{1'b1}} && L2_done1 != {NZ1{1'b1}}) begin //if every z-bin is done, and that was not true during the last clk cycle
       all_done <= 1;
    end
  end
 
  wire [8:0] ht_wire[NZ1-1:0]; //ht for each z-bin
  reg [8:0] ht[NZ1-1:0];  //reg version of above
  genvar i;
  //generate //generating 5 z-bins
    //for(i=0; i<NZ1; i = i+1) begin : zzz                     //Only 5 zbins
ZBIN_v5 #( .ZBIN(4'b0000), .NPHI(NPHI)) UZ                     

  (
     .clk(clk),
     .bramclk(bramclk),                              
     .reset(reset),
     .rstb(rstb),                                    
     .start(start),
     .stop(stop),
  //tracks of each phibin
  .track_in0(track_in0),
  .track_in1(track_in1),
  .track_in2(track_in2),
  .track_in3(track_in3),
  .track_in4(track_in4),
  .track_in5(track_in5),
  .track_in6(track_in6),
  .track_in7(track_in7),
  .track_in8(track_in8),
  .track_in9(track_in9),
  .track_in10(track_in10),
  .track_in11(track_in11),
  .track_in12(track_in12),
  .track_in13(track_in13),
  .track_in14(track_in14),
  .track_in15(track_in15),
  .track_in16(track_in16),
  .track_in17(track_in17),
  /*.track_in18(track_in18),
  .track_in19(track_in19),
  .track_in20(track_in20),
  .track_in21(track_in21),
  .track_in22(track_in22),
  .track_in23(track_in23),
  .track_in24(track_in24),
  .track_in25(track_in25),
  .track_in26(track_in26),*/
   
     .final_num(num[0]), //number of jets in this z-bin
     .final_jet_out(final_cluster_out),//jet_out[0]), //actual jet data
     .final_jet_addr(final_cluster_addr), //input, memory address of the cluster we want
        
     .all_ht(ht_wire[0]),  //ht of this z-bin
     .L1done(L1_done[0]),  //whether or not L1 clustering of the z-bin is done
     .L2_done(L2_done[0])  //whether or not L2 clustering of the z-bin is done
//////////////////////DEBUGGING//////////////////////////////////////////
  ,
  .state_out(state_o[0]),        
  .state_phi(state_p[0]),
  .pT1_out(pT1_o[0]),
  .L1_done_out(L1_done_o[0]),
  .all_L1_done_out(all_L1_done_o[0]),
  .phi_clust_val(phi_val_o[0]),
  .avr_out(avr_o[0]),
  .jet_pt_out(jet_pt_o[0]),
  .jet_eta_out(jet_eta_o[0]),
  .curr_E_out(curr_E_o[0]),
  .my_E_out(my_E_o[0]),
  .left_E_out(left_E_o[0]),
  .right_E_out(right_E_o[0]),
  .right2E_out(right2E_o[0]),
  .jvalid_out(jvalid_o[0]),
  .jpt_out(jpt_o[0]),
  .my_eta_out(my_eta_o[0]),
  .cstate_out(cstate_o[0]),
  .tot_pt_out(tot_pt_o[0]),                        
  .old_pt_out     (old_pt_o[0]      )   ,         
  .add_val3_out   (add_val3_o[0]   )    ,         
  .new_pt2_out    (new_pt2_o[0]     )      ,      
  .ptout_out      (ptout_o[0]       )       ,     
  .clustering_out (clustering_o[0]  )          ,  
  .wea_out        (wea_o[0]         ),
  .re_out         (re_o[0]  ),
  .readeta_out    (readeta_o[0]),
  .L2_pt_in_out   (L2_pt_in_o[0]),
  .L2_phi_in_out  (L2_phi_in_o[0]),
  .L1addr_out(L1addr_o[0]),
  .wenj2_out(wenj2_o[0]),
  .L2state_out(L2state_o[0]),
  .start_clust_out(start_clust_o[0]),
  .row_done_out(row_done_o[0])
/////////////////////////////////////////////////////////////////////////////
  );
  
  always @(posedge clk) begin
     ht[0] <= ht_wire[0];
     if(reset) begin
        L2_done_reg/*[i]*/ <= 0;
     end
     else if(event_done || event_done1) begin
        L2_done_reg/*[i]*/ <= 0;
     end
     else if(L2_done/*[i]*/) begin
        L2_done_reg/*[i]*/ <= 1;
     end
  end   
  //endgenerate  
 
//-----------------------------------------------------------------------   
 reg done_dly;
 reg [7:0] final_cluster_addr1, final_cluster_addr2; 
 reg [3:0] curr_SELmax = 4'b0000;
 //wire [3:0] SELmax;
 always @(posedge clk) begin
    done_dly <= all_done;
    final_cluster_addr1 <= final_cluster_addr;
    final_cluster_addr2 <= final_cluster_addr1;
    
    //curr_SELmax <= final_cluster_addr2 == 0 ? SELmax: curr_SELmax;
 end
 
 //wire [8:0] HTmax1, HTmax2;



 assign zmax = curr_SELmax;
   //To get max HT and its zbin
//    select_max #(.WIDTH(9)) Smax
//       (
//       .clk(clk),
//       .reset(restart),
       
//       .in0(ht[0]),
//       .in1(ht[1]),
//       .in2(ht[2]),
//       .in3(ht[3]),
//       .in4(ht[4]),
//       .in5(9'b0),
//       .in6(9'b0),
//       .in7(9'b0),
//       .max(HTmax),   // o
//       .sel(SELmax)  // o ; which z-bin had the highest HT
//       );

//    prio_mux8 #(.WIDTH(32)) muxD
//    (
//       .clk(clk),
//       .sel(curr_SELmax),
//       .i0(jet_out[0]),
//       .i1(jet_out[1]),
//       .i2(jet_out[2]),
//       .i3(jet_out[3]),
//       .i4(jet_out[4]),
//       .i5(32'b0),
//       .i6(32'b0),
//       .i7(32'b0),
//       .o(final_cluster_out)  //o chooses jets from zbin with highest HT
//    );
    
    //get total number of clusters in the max zbin
    prio_mux8 #(.WIDTH(8)) muxN 
       (
       .clk(clk),
       .sel(curr_SELmax),//.sel(SELmax),
       .i0(num[0]),
       .i1(num[1]),
       .i2(num[2]),
       .i3(num[3]),
       .i4(num[4]),
       .i5(8'b0),
       .i6(8'b0),
       .i7(8'b0),
       .o(Nmax)  //o
       );
       
//--------------------------------------------------------------------------------
  
////////////////////DEBUGGING/////////////////////////////
assign state_out = state_o[2];         
assign state_phi = state_p[2];  //state for phibin
assign pT1_out = pT1_o[2];
assign L1_done_out = L1_done_o[2];
assign all_L1_done_out = all_L1_done_o;
assign phi_clust_val = phi_val_o[2];
assign L2_done_out = L2_done;   
assign avr_out = avr_o[2];  
assign jet_pt_out = jet_pt_o[2];
assign jet_eta_out = jet_eta_o[2];
assign curr_E_out = curr_E_o[2];     
assign my_E_out = my_E_o[2];
assign left_E_out = left_E_o[2];
assign right_E_out = right_E_o[2];
assign right2E_out = right2E_o[2];
assign jvalid_out = jvalid_o[2];
assign jpt_out = jpt_o[2];
assign my_eta_out = my_eta_o[2];
assign cstate_out = cstate_o[2];
assign  tot_pt_out = tot_pt_o[2];       
assign old_pt_out = old_pt_o[2];        
assign add_val3_out = add_val3_o[2];    
assign new_pt2_out = new_pt2_o[2];      
assign ptout_out = ptout_o[2];          
assign clustering_out = clustering_o[2];
assign wea_out = wea_o[2];          
assign re_out  =  re_o[2];   
assign readeta_out = readeta_o[2]; 
assign L2_pt_in_out = L2_pt_in_o[2];
assign L2_phi_in_out = L2_phi_in_o[2];
assign wenj2_out = wenj2_o[2];
assign L1addr_out = L1addr_o[2];
assign L2state_out = L2state_o[2];
assign start_clust_out = start_clust_o;
assign row_done_out = row_done_o[2];
/////////////////////////////////////////////////////////////

endmodule
