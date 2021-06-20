`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2019 03:19:14 PM
// Design Name: 
// Module Name: ZBIN_v5
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


module ZBIN_v5
   #(
  parameter ZBIN   = 6'b000000,
  parameter NETA = 24,
  parameter NPHI = 27
 )
 (
  input clk,
  input bramclk,                              
  input reset,
  input rstb,                                 
  input start,
  input stop,
  
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
  
  input   [7:0] final_jet_addr,
  
  output [31:0]  final_jet_out,
  output  [7:0]  final_num,
   
  output  [8:0] all_ht,
  output        L1done,
  output  reg   L2_done
/////////////////FOR DEBUGGING/////////////////
  ,
  output [3:0] state_phi,  //state for phibin
  output [2:0] state_out,  //state for zbin
  output [8:0] pT1_out,
  output [26:0] L1_done_out,
  output all_L1_done_out,
  output [26:0] phi_clust_val,
  output        avr_out,
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
  output [3:0] cstate_out ,  //L1cluster state
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
  output start_clust_out,
  output [23:0] row_done_out
  //////////////////////////////////////////////
 );
 
 parameter NETA1 = NETA-1; //number of eta bins-1
 parameter NPHI1 = NPHI-1; //number of phi bins -1
 parameter NETA2 = NETA-2; //number of eta bins -2
 reg [27:0] track_in[17:0]; //array of all the input tracks
 reg start1, start2;    //start delayed by 1,2 clk cycles
 always @(posedge clk) begin
 //assign tracks
     track_in[0] <= track_in0; //assign correct track to each point in array
     track_in[1] <= track_in1;
     track_in[2] <= track_in2;
     track_in[3] <= track_in3;
     track_in[4] <= track_in4;
     track_in[5] <= track_in5;
     track_in[6] <= track_in6;
     track_in[7] <= track_in7;
     track_in[8] <= track_in8;
     track_in[9] <= track_in9;
     track_in[10] <= track_in10;
     track_in[11] <= track_in11;
     track_in[12] <= track_in12;
     track_in[13] <= track_in13;
     track_in[14] <= track_in14;
     track_in[15] <= track_in15;
     track_in[16] <= track_in16;
     track_in[17] <= track_in17;
     /*track_in[18] <= track_in18;
     track_in[19] <= track_in19;
     track_in[20] <= track_in20;
     track_in[21] <= track_in21;
     track_in[22] <= track_in22;
     track_in[23] <= track_in23;
     track_in[24] <= track_in24;
     track_in[25] <= track_in25;
     track_in[26] <= track_in26;*/
 end
 
//Used for L2 clustering
 reg restart, restart2; //reset or start
 wire [NPHI1:0] L1_done; //whether each phi bin is done
 wire [NPHI1:0] clustering; //true while PHI is performing L1 clustering.
 
 wire [4:0] L1_phi_addr; //used to read out the clusters from L1 into L2
 reg [4:0] L1_por=0;  //L1_phi_out register. The phi value of the ouput cluster of L1 delayed by 1

 
  //generate input memories 
  wire [4:0]     addr[NETA1:0];          
  wire [8:0]   etbin[NETA1:0];
  wire [4:0] ntrxbin[NETA1:0];
  wire [3:0] xcntbin[NETA1:0];
  wire [4:0]    jet_n[NETA1:0];

  wire [22:0]     Jet[NETA1:0];
  wire [22:0] pe_jets[NETA1:0];
  wire [4:0] jet_addr[NETA1:0];          
  wire         pe_sel[NETA1:0];
  wire       pe_valid[NETA1:0];
  wire      pe_hasdat[NETA1:0];
  wire      jet_valid[NETA1:0];
  wire       bin_done[NETA1:0];
  wire [NETA1:0] row_done;
  
  wire [17:0]   Etom2[NETA1:0];
  wire [17:0]   Etom1[NETA1:0];
  wire [17:0]   Etop1[NETA1:0];
  wire [17:0]   Etop2[NETA1:0];
 
  wire [22:0]   L1clust[NPHI1:0]; //{ntrx[9b], xcount[9b], eta[5b], pT[9b]}
 
  wire [NPHI1:0] wen;
  reg all_L1_done;
  //Parameters are for state machine
  parameter IDLE     = 4'b0001;
  parameter RUNL1    = 4'b0010;
  parameter READL1   = 4'b0100;
  parameter RUNL2    = 4'b1000;
  
  reg [3:0] L1_state1, L1_state2, L1_state3;
  reg start_clust, stopped, start3, start4;

  always @(posedge clk) begin
    start1 <= start;
    start2 <= start1;
    start3 <= start2;
    start4 <= start3;
    if(restart) begin
      all_L1_done <= 0;
    end
    else begin
      all_L1_done <= (L1_done == {NPHI{1'b1}}); //only true if all the phi bins in layer 1 are done
    end
  end
  
  wire L2_fin; //true when the clusters from L2 are done getting read to the final memory
  wire [NPHI1:0] has_dat; //Used to see if each phi bin in L1 has data to send to L2
  reg bj_done, bj_done1, bj_done2, bj_done3, bj_done4, bj_done5, bj_done6;   //build_jet done?
  wire L1_fin; //L1 encoder has finished
 //Delays:
  reg [2:0] L1dly_count=0;
  reg [3:0] L1_state;
  reg restart_L1=0;
  reg restart_L2=0;
  reg restart_L1_1, restart_L1_2;
  reg restart_L2_1, restart_L2_2;
  reg runl2_1;
  reg [3:0] L2_state=0;
  wire runl2 = (L2_state == RUNL2);
  reg L2_done1; //L2_done delayed by 1
  always @(posedge clk) begin
    L2_done1 <= L2_done;
    runl2_1 <= runl2;
    restart <= reset | start;
    restart_L1_1 <= restart_L1;
    restart_L1_2 <= restart_L1_1 | reset;
    restart_L2_1 <= restart_L2;
    restart_L2_2 <= restart_L2_1 | reset;
    //reset L2 once it's finished.
    restart_L2 <= reset | (L2_done & !L2_done1);
    L1_state1 <= L1_state;
    L1_state2 <= L1_state1;
    L1_state3 <= L1_state2;
    bj_done1 <= bj_done;
    bj_done2 <= bj_done1;
    bj_done3 <= bj_done2;
    bj_done4 <= bj_done3;
    bj_done5 <= bj_done4;
    bj_done6 <= bj_done5;
  end //end always
  
  //FSM for L1
  always @(posedge clk) begin
    if(reset) begin
       //If we have to reset, restart_L1 should also be true.
       L1_state <= IDLE;
       restart_L1 <= 1;
    end
    else begin
      case (L1_state) 
       //waiting for start signal (and for L1 clustering to finish) 
       // Now in this time, the L1 clusters will also be read to L2 memories
         IDLE: begin
           restart_L1 <= 0;
           if(clustering[0]) begin
             L1_state <= READL1; //Are we done receiving tracks?
           end
           else begin
             L1_state <= IDLE;
           end
         end
         READL1: begin
         //L2 clustering can only start once all L1 sectors are finished
         //   AND the L1 pe (priority) encoder has finished sending clusters to L2.
         // But PHI can start receiving new tracks before pe_encoder is done,
         //   so all_L1_done might go false, so we need an additional state
            restart_L1 <= 0;
            if(all_L1_done) begin
                L1_state <= RUNL1; //we can go into RUNL1 once all L1 clusters are done getting sent
            end
         end
         RUNL1: begin
       //Once all clusters are sent from L1 to L2, we're ready to receive new L1 data   
            if(L1_fin) begin
                restart_L1 <= 1; //ready to restart
                L1_state <= IDLE; //go back to IDLE
            end
         end
       endcase
     end //not reset
    end //always
    
    //FSM for L2 clustering
    always @(posedge clk) begin
      if(reset) begin
        L2_state <= IDLE;
        start_clust <= 0;
        bj_done <= 0;
      end
      else begin
        case(L2_state)
         //waiting to start
         IDLE: begin
            if(clustering[0]) begin
                L2_state <= RUNL1; //when L1 is clustering
            end
            if(L2_fin) begin
                bj_done <= 0; //getting ready for next event
            end
         end //idle
         RUNL1: begin
         //once L1 clustering is finished we just have to wait for pe_encoder to finish  
            if(all_L1_done) begin
                L2_state <= READL1; //we can continue reading clusters from L1
            end
            if(L2_fin) begin
                bj_done <= 0; //getting ready for next event
            end
         end
         //while L1 clustering is happening, we're reading L1 clusters
         READL1: begin
            if(L1_fin) begin
                 start_clust <= 1; //All L1 clusters are done, we can move on to L2 clustering
                 L2_state <= RUNL2;
             end
             if(L2_fin) begin
                 bj_done <= 0;
             end
         end
         //once L1 clustering is done, we can start running L2
         RUNL2: begin
             start_clust <= 0; //we only want start_clust true for 1 clk cycle
           //once build jet is finished, we're ready for more data
           //  so can start reading L1 data (only if it's started already).
             if(row_done == {NETA{1'b1}})begin
                bj_done <= 1'b1; //only if each eta bin is finished
                L2_state <= IDLE;
             end
             else begin
                bj_done <= 0;
             end
         end //end RUNL2
      endcase
    end //not reset
  end //always
/////////////////DEBUGGING////////////////////////////
wire [3:0] state_o[26:0];
wire [8:0] pT1_o[26:0];
wire [4:0] curr_eta_o[26:0];
wire [8:0] curr_E_o[26:0];
wire       avr_o[26:0];
wire [8:0] jet_pt_o[26:0];
wire [4:0] jet_eta_o[26:0];
wire [8:0] my_E_o[26:0];
wire [8:0] left_E_o[26:0];
wire [8:0] right_E_o[26:0];
wire [8:0] right2E_o[26:0];
wire       jvalid_o[26:0];
wire [8:0] jpt_o[26:0];
wire [4:0] my_eta_o[26:0];
wire [3:0] cstate_o[26:0];
wire [8:0] tot_pt_o [26:0];
wire [8:0] old_pt_o [26:0];
wire       add_val3_o [26:0];
wire [8:0] new_pt2_o [26:0];
wire [8:0] ptout_o  [26:0];
wire  [26:0]  clustering_o;
wire       wea_o  [26:0];
wire [4:0] re_o   [26:0];
wire [4:0] readeta_o[26:0];
wire [4:0] L2_phi_in_o[23:0];
wire [26:0] wenj2_o;
wire [4:0] L1addr_o[26:0];
///////////////////////////////////////////////////////

//**************LAYER 1: Cascade of phi bins*********//
 genvar j;
   generate
     for(j=0; j<NPHI; j = j+1) begin : phis                
        wire [22:0] L1_cluster_out;
        
	reg [4:0] track_phi_ne;
        reg [3:0] zbin1_ne;
        reg [3:0] zbin2_ne;
        reg [4:0] track_eta_ne;
        reg [8:0] track_pt_ne;
        reg bitx_ne;
	
	reg [4:0] track_phi_pe;
        reg [3:0] zbin1_pe;
        reg [3:0] zbin2_pe;
        reg [4:0] track_eta_pe;
        reg [8:0] track_pt_pe;
        reg bitx_pe;
        

        always @(posedge clk) begin
            track_phi_ne <= track_in[j/3][27:23];//assigning the corresponding bits in track_in to the designated value
            zbin1_ne <= track_in[j/3][22:19];
            zbin2_ne <= track_in[j/3][18:15];
            track_eta_ne <= track_in[j/3][14:10];
            track_pt_ne <= track_in[j/3][9:1];
            bitx_ne <= track_in[j/3][0];
       
            track_phi_pe <= track_in[j/3+9][27:23];//assigning the corresponding bits in track_in to the designated value
            zbin1_pe <= track_in[j/3+9][22:19]; 
            zbin2_pe <= track_in[j/3+9][18:15];
            track_eta_pe <= track_in[j/3+9][14:10];
            track_pt_pe <= track_in[j/3+9][9:1];
            bitx_pe <= track_in[j/3+9][0];
        end
	
        wire hasdat; //true if data of cluster(s) is stored in mj (regardless of if L2 is ready to receive it). (mj is merged jets)
        wire mj_ready = !hasdat & !has_dat[j]; //true if mj is ready for L1 clustering to start again (for the new event)
        PHI_v1 #( .ZBIN(ZBIN), .PHIBIN(j)) UE                     //Layer 1
 
           (
          
              .clk(clk),
              .bramclk(bramclk),                              
              .reset(reset),
              .rstb(rstb),                                    
              .start(start),
              .stop(stop),
	      .track_phi_ne(track_phi_ne),
              .zbin1_ne(zbin1_ne),
              .zbin2_ne(zbin2_ne),
              .track_eta_ne(track_eta_ne),
              .track_pt_ne(track_pt_ne),
              .bitx_ne(bitx_ne),
	      .track_phi_pe(track_phi_pe),
              .zbin1_pe(zbin1_pe),
              .zbin2_pe(zbin2_pe),
              .track_eta_pe(track_eta_pe),
              .track_pt_pe(track_pt_pe),
              .bitx_pe(bitx_pe),
              .mj_ready(mj_ready),
              
              .L1_cluster_out(L1_cluster_out),
              .L1_cluster_valid(wen[j]),
     
              .done(L1_done[j]),  //o
              .filled(clustering[j])
           ////////////DEBUGGING//////////////////
              ,
              .state_out(state_o[j]),
              .pT1_out(pT1_o[j]),
              .curr_eta_out(curr_eta_o[j]),
              .curr_E_out(curr_E_o[j]),
              .avr_out(avr_o[j]),
              .jet_pt_out(jet_pt_o[j]),
              .jet_eta_out(jet_eta_o[j]),
              .my_E_out(my_E_o[j]),
              .left_E_out(left_E_o[j]),
              .right_E_out(right_E_o[j]),
              .right2E_out(right2E_o[j]),
              .jvalid_out(jvalid_o[j]),
              .jpt_out(jpt_o[j]),
              .my_eta_out(my_eta_o[j]),
              .cstate_out(cstate_o[j]),
              .tot_pt_out(tot_pt_o[j]),
              .old_pt_out     (old_pt_o[j]      )   ,
              .add_val3_out   (add_val3_o[j]   )    ,
              .new_pt2_out    (new_pt2_o[j]     )   ,
              .ptout_out      (ptout_o[j]       )   ,
              .clustering_out (clustering_o[j]  )   ,
              .wea_out        (wea_o[j]         )   ,
              .re_out         (re_o[j])             ,
              .readeta_out    (readeta_o[j])
          ////////////////////////////////////////
           );
           
           wire [4:0] nclust;
           reg [4:0] L1addr=0; //which address we're reading
           reg [4:0] L1addr1;
           wire [4:0] L1m1 = L1addr; 
           
  //pseudo-clusters come out of PHI_v1, but need to merge any neighboring clusters using merge_jets
           merge_jets_L1
            mj1 (
             .clk(clk),
             .reset(restart_L1),
           
             .Jet(L1_cluster_out),
             .jet_valid(wen[j]),
           
             .jet_addr(L1m1),
             .jet_out(L1clust[j]),
             .nclust(nclust)
           );
          
           reg wenj1, wenj2, wenj3, wenj4;
           reg L2_ready; //is Layer 2 ready to receive our mj data?
//           reg L2_ready1;
//           reg L2_ready2;
//           reg L2_ready3;
//           reg L2_ready4;

           always @(posedge clk) begin
             wenj1 <= wen[j];
             wenj2 <= wenj1;
             wenj3 <= wenj2;
             wenj4 <= wenj3;
             
             L1addr1 <= L1addr;
//             L2_ready1 <= L2_ready;
//             L2_ready2 <= L2_ready1;
//             L2_ready3 <= L2_ready2;
//             L2_ready4 <= L2_ready3;

             if(restart_L1_2) begin
                L1addr <= 0;
             end
             //only admit we have data after 3 clks to give mj a chance to write it
             else begin
                 if(L1_state == RUNL1 && L1_phi_addr == j && L2_ready) begin
                    L1addr <= L1addr + 1;   //once data is read, increment memory address.
                 end
              end //end not restart
           end
       
       //we still have data if all our clusters weren't already read
           assign hasdat = (L1addr < nclust || L1addr1 < nclust && !(L1addr == L1addr1)); //used to include  && !(L1addr == (nclust - 1) && L1_phi_addr == j)
           always @(posedge clk) begin
              if(reset) begin
                 L2_ready <= 1;
              end
              else if(runl2 & !runl2_1) begin
                 L2_ready <= 0;
               end
               //The jth phi sector is ready for new data as soon as the old data is read.
               else if(addr[0] == j) begin //maybe actually a few ticks before this (because it takes >5 clks for L1clust to send its first clust)
                 L2_ready <= 1;
               end
           end
           assign has_dat[j] = hasdat & L2_ready;
           //////////////DEBUGGING////////////////////
           assign wenj2_o[j] = wenj2;
           assign L1addr_o[j] = L1addr;
           ///////////////////////////////////////////
    end
  endgenerate
  
  wire readl1 = (L2_state == READL1 || L2_state == RUNL1); //added L1_fin part
//  reg readl1_2;
//  reg readl1_3;
//  reg readl1_4;
//  reg readl1_5;
//  reg readl1_6;
//  reg readl1_7;
//Prio_mux to get tracks out of layer1 memories
prio_encoder2 L1_encoder //chooses which sector to read from
    (
      .clk(clk),
      .start(readl1),
      .has_dat00(has_dat[0]),
      .has_dat01(has_dat[1]),
      .has_dat02(has_dat[2]),
      .has_dat03(has_dat[3]),
      .has_dat04(has_dat[4]),
      .has_dat05(has_dat[5]),
      .has_dat06(has_dat[6]),
      .has_dat07(has_dat[7]),
      .has_dat08(has_dat[8]),
      .has_dat09(has_dat[9]),
      .has_dat10(has_dat[10]),
      .has_dat11(has_dat[11]),
      .has_dat12(has_dat[12]),
      .has_dat13(has_dat[13]),
      .has_dat14(has_dat[14]),
      .has_dat15(has_dat[15]),
      .has_dat16(has_dat[16]),
      .has_dat17(has_dat[17]),
      .has_dat18(has_dat[18]),
      .has_dat19(has_dat[19]),
      .has_dat20(has_dat[20]),
      .has_dat21(has_dat[21]),
      .has_dat22(has_dat[22]),
      .has_dat23(has_dat[23]),
      .has_dat24(has_dat[24]),
      .has_dat25(has_dat[25]),
      .has_dat26(has_dat[26]),

      .sel(L1_phi_addr), //phi address that it is choosing
      .none(L1_fin) //if all of the hasdats are false
    );

  wire [22:0] L1out;
  
  prio_mux27 #(.WIDTH(23)) L1pm //multi-plexor, it chooses the output from one of the 27 input addresses
          (
           .clk(clk),
           .o(L1out),
           //select cluster from phi sector with highest priority that has data
           .sel(L1_phi_addr), 
           .i0(L1clust[0]),
           .i1(L1clust[1]),
           .i2(L1clust[2]),
           .i3(L1clust[3]),
           .i4(L1clust[4]),
           .i5(L1clust[5]),
           .i6(L1clust[6]),
           .i7(L1clust[7]),
           .i8(L1clust[8]),
           .i9(L1clust[9]),
           .i10(L1clust[10]),
           .i11(L1clust[11]),
           .i12(L1clust[12]),
           .i13(L1clust[13]),
           .i14(L1clust[14]),
           .i15(L1clust[15]),
           .i16(L1clust[16]),
           .i17(L1clust[17]),
           .i18(L1clust[18]),
           .i19(L1clust[19]),
           .i20(L1clust[20]),
           .i21(L1clust[21]),
           .i22(L1clust[22]),
           .i23(L1clust[23]),
           .i24(L1clust[24]),          
           .i25(L1clust[25]),       
           .i26(L1clust[26])          
          );
 
  reg zeroing, zeroing1;   //writing 0 to memory so that clusters aren't carried over to next event
  wire zing = zeroing1;
  reg [4:0] L1_por1;  //L1_phi_out register delayed by 1
  reg start_clust1, start_clust2; //start L2 clustering?
  //must set all memory to 0 to prepare for next event.                   
      always @(posedge clk) begin
          start_clust1 <= start_clust;
          L1_por <= L1_phi_addr;
          L1_por1 <= L1_por;
          zeroing1 <= zeroing;
          zeroing <= L2_state == RUNL2;
      end
  
  //Now compile L1 tracks from each eta bin into phibin memories for Layer 2.
  reg [27:0] L2clust_in;
  wire [NETA1:0] wen2;
  wire [4:0] L2_eta_in = L2clust_in[18:14];
  wire [8:0] L2_pt_in = (zing? 9'b0 : L2clust_in[13:5]); 
  wire [4:0] L2_ntrx_in = (zing? 9'b0 : L2clust_in[27:23]);
  wire [3:0] L2_xcnt_in = (zing? 9'b0 : L2clust_in[22:19]);
  
  wire start_pe = bj_done3 & ~bj_done4;
  
  wire [17:0] L2_cell_in = {L2_pt_in, L2_ntrx_in, L2_xcnt_in};
  always @(posedge clk) begin
    L2clust_in <= {L1out, L1_por}; //adding the phi-value to the layer1 cluster
  end
 
  wire [4:0] pe_sel_enc; //selection for the L2 readout pe_encoder; used for reading at the end of L2
//**********LAYER 2: eta bin cascade****************//  
  genvar i;
  generate
   for(i=0; i<NETA; i=i+1) begin: etas   
     reg [4:0] addri1;
     always @(posedge clk) begin
        addri1 <= addr[i];
     end
     assign wen2[i] = (L2_eta_in == i & L1_state2 == RUNL1 & L2_pt_in > 0);
     wire wea = wen2[i] | zing;
     wire [4:0] L2_phi_in = zing? addri1 : L2clust_in[4:0];
     /////////DEBUGGING///////////////////////
     assign L2_phi_in_o[i] = L2_phi_in;
     /////////////////////////////////////////
     wire [17:0] L2_cell_out;
     Memory #(                                                                          //Layer 2
                    .RAM_WIDTH(18),
                    .RAM_DEPTH(32),
                    .RAM_PERFORMANCE("LOW_LATENCY")
                  ) L2in_mem
                  (
                    .clka(clk),
                    .clkb(clk),
                    .addra(L2_phi_in), // address is phi
                    .dina(L2_cell_in),   //data is {pT, ntrx, nx}
                    .wea(wea),     
                    .rstb(reset),
                    .enb(1'b1),
                    .regceb(1'b1),
                    .addrb(addr[i]),                 
                    .doutb(L2_cell_out) //gets sent out into build_jetv5
                  );
        assign etbin[i] = L2_cell_out[17:9]; //part that corresponds to pT
        assign ntrxbin[i] = L2_cell_out[8:4]; //number of tracks coming out
        assign xcntbin[i] = L2_cell_out[3:0]; //number of special tracks

     build_jetv5 pre_jet //first pass for clustering
                   (
                    .clk(clk),
                    .reset(restart_L2),
                    .start(start_clust1), //true once all L1 clusters are done being read
                    
                    .Center(etbin[i]),  //Center is my pT
                    .Left ( i>0? etbin[i-1] : 9'b0), //Left is my left neighbor's pT
                    .Right( i<NETA1? etbin[i+1] : 9'b0), //Right is my right neighbor's pT
                    
                    .Etom2  (Etom2[i]), //m2 - minus 2
                    .Etom1  (Etom1[i]), // These are just redundant pT values; minus 1
                    .Etop1  (Etop1[i]), //p1 plus 1
                    .Etop2  (Etop2[i]), //p2 plus 2
                    .Em2(i>1? Etom2[i-2] : 18'b0), //pT of my neighbor 2 to the left
                    .Em1(i>0? Etom1[i-1] : 18'b0), //pT of my neighbor 1 to the left
                    .Ep1(i<NETA1? Etop1[i+1] : 18'b0), //pT of my neighbor 1 to the right
                    .Ep2(i<NETA2? Etop2[i+2] : 18'b0), //pT of my neighbor 2 to the right
                    
                    .my_ntrx(ntrxbin[i]),
                    .left_ntrx(i>1? ntrxbin[i-1]: 5'b0),
                    .right_ntrx(i<NETA1? ntrxbin[i+1]: 5'b0),
                    
                    .my_xcnt(xcntbin[i]),
                    .left_xcnt(i>1? xcntbin[i-1]: 4'b0),
                    .right_xcnt(i<NETA1? xcntbin[i+1]: 4'b0),
                    
                    .addr(addr[i]), //phibin whose pT build_jet needs
                    .Jet(Jet[i]),  //cluster made by build_jet
                    .jet_valid(jet_valid[i]), //output cluster is valid
                    .done(row_done[i]) //this etabin is all done for this event.
                   );
           
           reg [4:0] L2addr;
           wire [4:0] njet;
           merge_jets_L2v2 //second pass; also merges phi0 and phi26 if necessary
                jet (
                      .clk(clk),
                      .reset(restart_L2),
                    
                      .Jet(Jet[i]),
                      .jet_valid(jet_valid[i]),
                    
                      .jet_addr(L2addr),
                      .jet_out(pe_jets[i]),
                      .njet(njet)
                    );
           
           wire pe_val;
          // reg [4:0] njet; //total number of jets found by L2
           reg jet_vali1, jet_vali2, jet_vali3;
           reg pe_vali, pe_vali2, pe_vali3;
           always @(posedge clk) begin
             jet_vali1 <= jet_valid[i];
             jet_vali2 <= jet_vali1;
             jet_vali3 <= jet_vali2;
             if(restart_L2_2) begin
                L2addr <= 0;
             end
             else begin
                 if(L2_state != RUNL2 && pe_sel_enc == i) begin
                    L2addr <= L2addr + 1;   //once data is read, decrement memory address.
                    pe_vali <= 1'b1;
                 end
                 else begin
                    pe_vali <= 1'b0;
                 end
              end //end not restart
           end
                   
                   //we still have data if all our clusters weren't already read
           assign pe_hasdat[i] = (L2addr < njet && !(L2addr == (njet - 1) && pe_sel_enc == i));
           
           always @(posedge clk) begin
           //    pe_vali <= pe_val;  //add ntracks or nx-tracks requirements here?
               pe_vali2 <= pe_vali;
               pe_vali3 <= pe_vali2;  
           end
           assign pe_valid[i] = pe_vali2;
     end
  endgenerate  

//encoder to read out all the cluster memories
  reg [4:0] prio_sel;
  reg [4:0] prio_sel1;
  wire none;
   wire [31:0] all_jet_out; //Will be {ntracks[9b], nx-tracks[9b], zbin[6b], phibin[5b], etabin[5b], pT[9b]}
   reg [31:0] all_jet_out1, all_jet_out2;

  // with current memory latency, need to delay VALID two clocks
  reg valid_1, valid_2;
  reg all_jet_valid;
  reg all_jet_valid1;
  reg smallpT;
  reg notSmallFk;
  reg notLargeFk;
  always @(posedge clk) begin
    valid_1 <= pe_valid[ 0] | pe_valid[ 1] | pe_valid[ 2] | pe_valid[ 3] | pe_valid[ 4] | pe_valid[ 5] | pe_valid[ 6] | pe_valid[ 7] | pe_valid[ 8] | pe_valid[ 9] | 
              pe_valid[10] | pe_valid[11] | pe_valid[12] | pe_valid[13] | pe_valid[14] | pe_valid[15] | pe_valid[16] | pe_valid[17] | pe_valid[18] | pe_valid[19] |
              pe_valid[20] | pe_valid[21] | pe_valid[22] | pe_valid[23] ;
    valid_2 <= valid_1;
    
//    readl1_2 <= readl1;
//    readl1_3 <= readl1_2;
//    readl1_4 <= readl1_3;
//    readl1_5 <= readl1_4;
//    readl1_6 <= readl1_5;
//    readl1_7 <= readl1_6;
  end

//accumulator to calculate ht
  reg [17:0] ht;
  reg [8:0] allht;
  reg L2_state1;
  assign all_ht = allht;
   
  always @(posedge clk) begin
     all_jet_out1 <= all_jet_out;
     all_jet_out2 <= all_jet_out1;
     smallpT <= all_jet_out[8:0] < 9'b000110010;
     notSmallFk <= (all_jet_out[8:0] < 9'b001100100 && all_jet_out[31:27] > 5'b00001);
     notLargeFk <= (all_jet_out[8:0] > 9'b001100100 && all_jet_out[31:27] > 5'b00010);
     all_jet_valid <= valid_2 && all_jet_out[8:0] != 0;
     all_jet_valid1 <= all_jet_valid && (smallpT || notSmallFk || notLargeFk);
     L2_state1 <= L2_state;
     if(L2_state == 1 && L2_state1 != 1) begin //was restart L2_state == 1 && L2_state1 != 1
        ht <= 0;
     end
     else if(all_jet_valid1) begin
         ht <= ht + all_jet_out2[8:0];
     end
     
     //if any of the MSBs are used, HT is higher than max for 9 bits, so set to max value.
     if(ht[17:9] > 0) begin
        allht <= 9'b111111111;
     end
     else begin
        allht <= ht[8:0]; 
     end
  end

  //final memory
    FoundJets fj
    (
      .clk(clk),
      .reset(reset),        //restart each new event--only keep clusters for the current event.
      .valid(all_jet_valid1),
      .din(all_jet_out2), //filter out jets with only one track
      .addr(final_jet_addr),
      
      .dout(final_jet_out),
      .num(final_num)
    );   
         
  wire [3:0] ZBINb = ZBIN[3:0]; //When ZBIN is passed it does it as integer with 32 bits, we only need 4
  prio_mux #(.WIDTH(32)) pe_mux //chooses which eta bin to send out from
    (
      .clk(clk),
      .o(all_jet_out),
      .sel(prio_sel1),
      //pe_jets contain ntrx[22:18], nx[17:14], phi [13:9] and et [8:0]
      //add eta and zbin (4 b for z-bin just to make it exactly 32 b)
      .i0({  pe_jets[0][22:18],  pe_jets[0][17:14], ZBINb,5'b00000,pe_jets[0][13:9],  pe_jets[0][8:0]}),
      .i1({  pe_jets[1][22:18],  pe_jets[1][17:14], ZBINb,5'b00001,pe_jets[1][13:9],  pe_jets[1][8:0]}),
      .i2({  pe_jets[2][22:18],  pe_jets[2][17:14], ZBINb,5'b00010,pe_jets[2][13:9],  pe_jets[2][8:0]}),
      .i3({  pe_jets[3][22:18],  pe_jets[3][17:14], ZBINb,5'b00011,pe_jets[3][13:9],  pe_jets[3][8:0]}),
      .i4({  pe_jets[4][22:18],  pe_jets[4][17:14], ZBINb,5'b00100,pe_jets[4][13:9],  pe_jets[4][8:0]}),
      .i5({  pe_jets[5][22:18],  pe_jets[5][17:14], ZBINb,5'b00101,pe_jets[5][13:9],  pe_jets[5][8:0]}),
      .i6({  pe_jets[6][22:18],  pe_jets[6][17:14], ZBINb,5'b00110,pe_jets[6][13:9],  pe_jets[6][8:0]}),
      .i7({  pe_jets[7][22:18],  pe_jets[7][17:14], ZBINb,5'b00111,pe_jets[7][13:9],  pe_jets[7][8:0]}),
      .i8({  pe_jets[8][22:18],  pe_jets[8][17:14], ZBINb,5'b01000,pe_jets[8][13:9],  pe_jets[8][8:0]}),
      .i9({  pe_jets[9][22:18],  pe_jets[9][17:14], ZBINb,5'b01001,pe_jets[9][13:9],  pe_jets[9][8:0]}),
      .i10({pe_jets[10][22:18], pe_jets[10][17:14],ZBINb,5'b01010,pe_jets[10][13:9], pe_jets[10][8:0]}),
      .i11({pe_jets[11][22:18], pe_jets[11][17:14],ZBINb,5'b01011,pe_jets[11][13:9], pe_jets[11][8:0]}),
      .i12({pe_jets[12][22:18], pe_jets[12][17:14],ZBINb,5'b01100,pe_jets[12][13:9], pe_jets[12][8:0]}),
      .i13({pe_jets[13][22:18], pe_jets[13][17:14],ZBINb,5'b01101,pe_jets[13][13:9], pe_jets[13][8:0]}),
      .i14({pe_jets[14][22:18], pe_jets[14][17:14],ZBINb,5'b01110,pe_jets[14][13:9], pe_jets[14][8:0]}),
      .i15({pe_jets[15][22:18], pe_jets[15][17:14],ZBINb,5'b01111,pe_jets[15][13:9], pe_jets[15][8:0]}),
      .i16({pe_jets[16][22:18], pe_jets[16][17:14],ZBINb,5'b10000,pe_jets[16][13:9], pe_jets[16][8:0]}),
      .i17({pe_jets[17][22:18], pe_jets[17][17:14],ZBINb,5'b10001,pe_jets[17][13:9], pe_jets[17][8:0]}),
      .i18({pe_jets[18][22:18], pe_jets[18][17:14],ZBINb,5'b10010,pe_jets[18][13:9], pe_jets[18][8:0]}),
      .i19({pe_jets[19][22:18], pe_jets[19][17:14],ZBINb,5'b10011,pe_jets[19][13:9], pe_jets[19][8:0]}),
      .i20({pe_jets[20][22:18], pe_jets[20][17:14],ZBINb,5'b10100,pe_jets[20][13:9], pe_jets[20][8:0]}),
      .i21({pe_jets[21][22:18], pe_jets[21][17:14],ZBINb,5'b10101,pe_jets[21][13:9], pe_jets[21][8:0]}),
      .i22({pe_jets[22][22:18], pe_jets[22][17:14],ZBINb,5'b10110,pe_jets[22][13:9], pe_jets[22][8:0]}),
      .i23({pe_jets[23][22:18], pe_jets[23][17:14],ZBINb,5'b10111,pe_jets[23][13:9], pe_jets[23][8:0]}),
      .i24(32'b0),      //only 24 eta bins, so the rest just have 0s.
      .i25(32'b0),
      .i26(32'b0),
      .i27(32'b0),
      .i28(32'b0),
      .i29(32'b0),
      .i30(32'b0),
      .i31(32'b0)
    );

  prio_encoder2 pe_encoder2 //says whether there is a jet in a certain etabin
    (
      .clk(clk),
      .start(bj_done1),
      .has_dat00(pe_hasdat[0]),
      .has_dat01(pe_hasdat[1]),
      .has_dat02(pe_hasdat[2]),
      .has_dat03(pe_hasdat[3]),
      .has_dat04(pe_hasdat[4]),
      .has_dat05(pe_hasdat[5]),
      .has_dat06(pe_hasdat[6]),
      .has_dat07(pe_hasdat[7]),
      .has_dat08(pe_hasdat[8]),
      .has_dat09(pe_hasdat[9]),
      .has_dat10(pe_hasdat[10]),
      .has_dat11(pe_hasdat[11]),
      .has_dat12(pe_hasdat[12]),
      .has_dat13(pe_hasdat[13]),
      .has_dat14(pe_hasdat[14]),
      .has_dat15(pe_hasdat[15]),
      .has_dat16(pe_hasdat[16]),
      .has_dat17(pe_hasdat[17]),
      .has_dat18(pe_hasdat[18]),
      .has_dat19(pe_hasdat[19]),
      .has_dat20(pe_hasdat[20]),
      .has_dat21(pe_hasdat[21]),
      .has_dat22(pe_hasdat[22]),
      .has_dat23(pe_hasdat[23]),
      .has_dat24(1'b0),
      .has_dat25(1'b0), //only 24 eta bins
      .has_dat26(1'b0),

      .sel(pe_sel_enc),
      .none(L2_fin)
    
    );
    reg L2_fin1; //L2 finished, delayed by 1
    reg [4:0] pe_sel_enc1;
    always @(posedge clk) begin
        pe_sel_enc1 <= pe_sel_enc;
        prio_sel <= pe_sel_enc1;
        prio_sel1 <= prio_sel;
        L2_fin1 <= L2_fin;
        //once all L2s are done, get ready for next event.
     //output L2_done only the first clk it's true.
     //     z_cascade will handle the rest.
    if(bj_done5 && L2_fin) begin //used to be bj_done5
            L2_done <= 1;
        end
        else begin
            L2_done <= 0;
        end
    end
  assign L1done = all_L1_done;
 /////////////////////////////FOR DEBUGGING////////////////////////////////
  assign state_phi = state_o[3];
  assign state_out = L1_state;
  assign pT1_out = pT1_o[3];
  assign L1_done_out = L1_done; //done for each phi
  assign  all_L1_done_out = all_L1_done; //all phi done
  assign phi_clust_val = wen;
  assign avr_out = avr_o[3];
  assign jet_pt_out = jet_pt_o[3];
  assign jet_eta_out = jet_eta_o[3];
  assign curr_E_out = curr_E_o[3];
  assign my_E_out = my_E_o[3];
  assign left_E_out = left_E_o[3];
  assign right_E_out = right_E_o[3];
  assign right2E_out = right2E_o[3];
  assign jvalid_out = jvalid_o[3];
  assign jpt_out = jpt_o[3];
  assign my_eta_out = my_eta_o[3];
  assign cstate_out = cstate_o[3];
  assign  tot_pt_out = tot_pt_o[3];
  assign old_pt_out = old_pt_o[3];
  assign add_val3_out = add_val3_o[3];
  assign new_pt2_out = new_pt2_o[3];
  assign ptout_out = ptout_o[3];
  assign clustering_out = clustering_o;
  assign wea_out = wea_o[3];
  assign re_out = re_o[3];
  assign readeta_out = readeta_o[3];
  assign L2_phi_in_out = L2_phi_in_o[12];
  assign L2_pt_in_out = L2_pt_in;
  assign wenj2_out = wenj2_o[3];
  assign L1addr_out = L1addr_o[3];
  assign L2state_out = L2_state;
  assign start_clust_out = start_clust;
  assign row_done_out = row_done;
/////////////////////////////////////////////////////////////////////////////   
endmodule
