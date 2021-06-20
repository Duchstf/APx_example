`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2019 04:03:18 PM
// Design Name: 
// Module Name: jet_finding_top2
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


module jet_finding_top2
#(parameter mkIla=1)
(
    input s_clk, //from board

    input        start,               
    input        reset,                         
     
  //tracks of each phibin 

	input [95:0] track_in0_n,
	input [95:0] track_in1_n,
	input [95:0] track_in2_n,
	input [95:0] track_in3_n,
	input [95:0] track_in4_n,
	input [95:0] track_in5_n,
	input [95:0] track_in6_n,
	input [95:0] track_in7_n,
	input [95:0] track_in8_n,
	input [95:0] track_in0_p,
	input [95:0] track_in1_p,
	input [95:0] track_in2_p,
	input [95:0] track_in3_p,
	input [95:0] track_in4_p,
	input [95:0] track_in5_p,
	input [95:0] track_in6_p,
	input [95:0] track_in7_p,
	input [95:0] track_in8_p,

        input vld_in,  //may need to change to NPHI bits later.
	//vld_in turns on at a certain point, then just stays on. Right now we don't really use it, we just count 24 tracks and then turn off
        
        output rdy_out,  //able to receive new signals
	//signal we send out if we are ready to receive new signals
        
        output [31:0] dout, //cluster data: {9'b0, ntracks[5b], nx-tracks[4b], zbin[4b], phibin[5b], etabin[5b], pT[9b]}
        input rdy_in,   //currently always 1
	//input from rest of board that tells us the next step is ready; we are ready to send data
        output vld_out  //dout is valid, true after event is all processed
	//turn on only when output is real data
    );
    parameter NPHI = 27; //number of phibins.
	//we will have to see if NPHI needs to be changed
    parameter NPHI1 = NPHI-1;
    wire clk = s_clk;
    wire bramclk = clk; //probably not needed
    
    //stop when all tracks of the event are read in.
    reg        r_stop = 0; //supposed to turn on once all 24 tracks are read. 
  
    parameter IDLE = 2'b01;
    parameter READ = 2'b10;
    
    reg [1:0]i_state = IDLE; //state of input--waiting for signal or reading new input?
	//means we are waiting for new data to come it
    reg [1:0] o_state = IDLE; //state of output--waiting for new output or reading output?
	//means we are waiting for new output
    
    reg idle1; //true if i_state was idle on the previous clk cycle
    
    wire done; //true when event is done being processed
    reg r1; //reset

    wire START = start & vld_in; //actually ready to start
    reg [4:0] waitcount; //how long has been waited? Stop at tot_wait
    parameter tot_wait = 5; //wait for select_max to finish
    //waiting until correct bins have been selected

//start and stop delays
    reg start1, start2, start3, start4, start5, start6, start7;
    reg r_stop1, r_stop2, r_stop3;
    reg done1, done2; 
    
    //count how many events we've done
    reg [7:0] nevents=0; //might not be used now, calculates number of events
    always @(posedge clk) begin
       if(r1)begin
         nevents <= 0;
       end
       else if(start7) begin
         nevents <= nevents + 1;
       end
    end
    reg clust_valid=0, ready_out=0; //clust_valid is; ready_out is a delay
    reg ready_out1; //ready_out delayed by 1; used for d_valid
    reg [7:0] final_clust_addr; //address that will be sent into the rest of the algorithm to read out cluser. Memory address
    wire [7:0] Nmax; //number of clusters in the zbin of maximum HT. Once final_clust_addr reaches Nmax, then we can stop
    wire [31:0] jet_out; //output data
    reg [6:0] ntrx = 0; //counter for how many tracks have been sent in. Reaches 24, stop
    reg start_reg; //start delayed by 1
    reg vld_in_reg; //valid delayed by 1
    
    wire valid_in = vld_in; //MUST EQUAL vld_in FOR HARDWARE TO WORK
    //Must delay vld_in an extra clk cycle for simulation ONLY!
    
////*****************************simulation only code*********************************************************
////The next 'comment' line tells Vivado not to synthesize the next few lines, leave it here!
    //synthesis translate_off
    reg vld_in1; //delays vld_in just for the simulation so that it matches the hardware
    always @(posedge clk) begin
        vld_in1 <= vld_in;
    end
    //Change valid_in to be delayed by 1 extra clk cycle, for simulation only!
    assign valid_in = vld_in1;
    //The next 'comment' line tells Vivado to go back to synthesizing the rest of the lines, leave it here!
    //synthesis translate_on
////*******************************end simulation only code****************************************************   
   wire L1done; //L1 clustering is finished
	//Once L1 is done, we can start processing a new event
  //Input FSM: when are we ready to read in new data?
    always @(posedge clk) begin
        ready_out1 <= ready_out;
        r1<= reset;
        idle1 <= i_state[0];
        start_reg <= start;
        vld_in_reg <= valid_in;
        //if reset, go to IDLE
        if(r1) begin
            i_state <= IDLE;
            r_stop <= 0;
            ntrx <= 0;
            ready_out <= 0;
            start1 <= 0;
        end   //RESET
        else begin
          case(i_state)
           //waiting for start signal
            IDLE: begin
                if(rdy_in & start & L1done) begin //added & start so events don't get wasted
                   ready_out <= 1; //as soon as this goes to true, we start recieving new tracks
                end
                else begin
                   ready_out <= 0;
                end
                r_stop <= 0;
                if(start_reg & valid_in & ready_out & idle1 & L1done) begin
                  i_state <= READ;
			//state changes
                  start1 <= 1'b1;
                  //if valid_in is true for first time, we're already 1 behind on the count so start at 2 instead of 1
                  if(vld_in_reg) begin
                    ntrx <= 7'b0000001; 
                  end 
                  else begin
                    ntrx <= 7'b0000010; 
                  end
                end
                else begin
                  ntrx <= 0;
                  i_state <= IDLE;
                  start1 <= 1'b0;
                end
              end //IDLE case
           //sending tracks in to be deciphered and then clustered
            READ: begin
                start1 <= 1'b0; //we only want start1 on for one clk cycle, so we set it back to 0
                if(!valid_in || ntrx == 7'b1011110) begin //24 is number of tracks per event for each phibin; changed to 95
//we stop at 23 bc it takes 1 clk cycle to turn off; now stops at 94
                  r_stop <= 1; 
//stop receiving tracks
                  ready_out <= 0;
                  i_state <= IDLE; //once all the events for this event are read, wait for processing to finish
//we can go back to idle
                end
                else begin //if we aren't done, increment ntrx
                  ntrx <= ntrx + 1;
                  r_stop <= 0;                
                  ready_out <= 1;
                  i_state <= READ;
                end
            end //end READ
           endcase
        end   //Not RESET 
    end  //always loop
   
   reg event_done=0;
   reg [7:0] curr_Nmax = 0;
   //FSM for output: when are we outputing new data?
   always @(posedge clk) begin
      if(r1) begin
        clust_valid <= 0;
        waitcount <= 0;
        o_state <= IDLE;
        event_done <= 0;
      end
      else begin
        case(o_state)
   //waiting for clustering to finish for this event
             IDLE: begin               
                  //once L2_clustering is done, wait a little longer for select_max to finish. 
                  //   otherwise wrong zbin might be selected.
                  event_done <= 0; //only true once event is done being processed
                  final_clust_addr <= 0;
                  if(done) begin
                       if(waitcount != tot_wait) begin
                          waitcount <= waitcount + 1;
                          o_state <= IDLE;
				//we need to get through waitcount before moving on; make sure selectmax is finished
                       end
                       else begin
                          o_state <= READ; //if we've waited long enough, start reading output data!
                          waitcount <= 0; //waitcount is set back to 0 for next time
                          curr_Nmax <= Nmax;
                       end
                   end  //if done 
                   else begin  //if not done
                       waitcount <= 0; 
                       o_state <= IDLE;
                   end  //not done        
               end  //IDLE case
               //reading out final cluster data for this event
               READ: begin
                   //if all clusters have been read, we start waiting for the next set of data.
                   if(final_clust_addr == curr_Nmax) begin //Nmax is number of clusters in the z-bin with max ht
                       clust_valid <= 0; //no longer reading
                       final_clust_addr <= 0;
                       o_state <= IDLE;
                       event_done <= 1; //finished reading all clusters of this event!
                   end
                   else begin
                       clust_valid <= 1; //still reading
                       final_clust_addr <= final_clust_addr + 1;
                       o_state <= READ;
                       event_done <= 0;
                   end
                end //end READ
              endcase
          end
   end
   
    reg r_stop4, r_stop5, r_stop6;  
    reg clust_val1, clust_val2; 
    reg event_done1, event_done2;
    //delays for start, done, stop, clust_val
    always @(posedge clk) begin //just a bunch of delays
      if(r1) begin
       start7<=0;
       start6<=0;
       start5<=0;
       start4 <= 0;
       start3 <= 0;
       start2 <= 0;
       r_stop6 <= 0;
       r_stop5 <= 0;
       r_stop4 <= 0;
       r_stop3 <= 0;
       r_stop2 <= 0;
       r_stop1 <= 0;
       done1 <= 0;
       done2 <= 0;
       clust_val1 <= 0;
       clust_val2 <= 0;
       event_done1 <= 0;
       event_done2 <= 0;
      end
      else begin
       done1 <= done;
       done2 <= done1;
       start7<=start6;
       start6<=start5;
       start5<=start4;
       start4 <= start3;
       start3 <= start2 ;
       start2 <= start1 ;
       r_stop6 <= r_stop5;
       r_stop5 <= r_stop4;
       r_stop4 <= r_stop3;
       r_stop3 <= r_stop2;
       r_stop2 <= r_stop1;
       r_stop1 <= r_stop;
       clust_val1 <= clust_valid;
       clust_val2 <= clust_val1;
       event_done1 <= event_done;
       event_done2 <= event_done1;
      end
    end
    
    //track objects obtained from decipher, to be sent to the z-cascade
    // 23 bits: zbin1(4), zbin2(4), eta(5), pT(9), special bit(1)
    // one track object for each phibin.
    wire [27:0] track_in[17:0];
    
    //true if input 100-bit tracks should be used
    wire d_valid = vld_in & ready_out1;
      
      //Now convert each track to the usable form of its data. 
      //Need one instance of decipher for each phibin. 

    decipher_v2018_2 D0(  .clk(clk), //we sent our 100 bit track word through decipher, and this sends us the info we need. There are 27 copies of this
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in0_n),
		      .phi_sector(5'b00000),
                     .track(track_in[0])
                );
    decipher_v2018_2 D1(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in1_n),
		      .phi_sector(5'b00011),
                     .track(track_in[1])
                );
    decipher_v2018_2 D2(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in2_n),
		      .phi_sector(5'b00110),
                     .track(track_in[2])
                );
    decipher_v2018_2 D3(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in3_n),
		      .phi_sector(5'b01001),
                     .track(track_in[3])
                );
    decipher_v2018_2 D4(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in4_n),
		      .phi_sector(5'b01100),
                     .track(track_in[4])
                );
    decipher_v2018_2 D5(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in5_n),
		      .phi_sector(5'b01111),
                     .track(track_in[5])
                );
    decipher_v2018_2 D6(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in6_n),
		      .phi_sector(5'b10010),
                     .track(track_in[6])
                );
    decipher_v2018_2 D7(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in7_n),
		      .phi_sector(5'b10101),
                     .track(track_in[7])
                );
    decipher_v2018_2 D8(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in8_n),
		      .phi_sector(5'b11000),
                     .track(track_in[8])
                );
    decipher_v2018_2 D9(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in0_p),
		      .phi_sector(5'b00000),
                     .track(track_in[9])
                );
    decipher_v2018_2 D10(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in1_p),
		      .phi_sector(5'b00011),
                     .track(track_in[10])
                );
    decipher_v2018_2 D11(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in2_p),
		      .phi_sector(5'b00110),
                     .track(track_in[11])
                );
    decipher_v2018_2 D12(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in3_p),
		      .phi_sector(5'b01001),
                     .track(track_in[12])
                );
    decipher_v2018_2 D13(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in4_p),
		      .phi_sector(5'b01100),
                     .track(track_in[13])
                );
    decipher_v2018_2 D14(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in5_p),
		      .phi_sector(5'b01111),
                     .track(track_in[14])
                );
    decipher_v2018_2 D15(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in6_p),
		      .phi_sector(5'b10010),
                     .track(track_in[15])
                );
    decipher_v2018_2 D16(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in7_p),
		      .phi_sector(5'b10101),
                     .track(track_in[16])
                );
    decipher_v2018_2 D17(  .clk(clk),
                     .valid(d_valid),
                      .reset(r1),
                      .clust_in(track_in8_p),
		      .phi_sector(5'b11000),
                     .track(track_in[17])
                );
   
    //reg [27:0] track_in_arr1;
    //always @(posedge clk) begin
      //  track_in_arr1 <= track_in[0];
    //end
    wire [8:0] HTmax; //Max HT of any zbin. Might not be necessary anymore
    wire [3:0] zmax; //zbin with the max HT
    
    //DEBUGGING////////////////////////
         wire        [2:0] state_z;      
         wire        [3:0] state_phi; 
         wire        [8:0] pT1_out;
         wire        [26:0] L1_done_out;
         wire        [5:0]  all_L1_done_out;
         wire        [26:0] phi_clust_val;
         wire              avr_out;
         wire        [5:0] L2_done;
         wire        [8:0] jet_pt_out;
         wire        [4:0] jet_eta_out;
         wire        [8:0] curr_E_out;
         wire        [8:0] my_E_out;
         wire        [8:0] left_E_out;
         wire        [8:0] right_E_out;
         wire        [8:0] right2E_out;
         wire              jvalid_out;
         wire        [8:0] jpt_out;
         wire        [4:0] my_eta_out;
         wire        [3:0] cstate_out;
         wire        [8:0] tot_pt_out;
         wire        [8:0] old_pt_out;
         wire              add_val3_out;
         wire        [8:0] new_pt2_out;
         wire        [8:0] ptout_out;
         wire        [26:0] clustering_out;
         wire              wea_out;
         wire        [4:0] re_out;
         wire        [4:0] readeta_out;
         wire        [4:0] L2_phi_in_out;
         wire        [8:0] L2_pt_in_out;
         wire        [4:0] L1addr_out;
         wire              wenj2_out;
         wire       [3:0] L2state_out;
         wire       [5:0] start_clust_out;
         wire       [23:0] row_done_out;
   ////////////////////////////////// 
    
    //send all our track data to the z-cascade
    z_cascade #(.NPHI(NPHI)) UL1
      (
      
        .clk(clk),
        .bramclk(clk),                   
        .reset(r1),//i
        .rstb(r1), //i                        
        .start(start1),//i
        .stop(r_stop6),//i
          //tracks of each phibin
        .track_in0(track_in[0]),//i
        .track_in1(track_in[1]),
        .track_in2(track_in[2]),
        .track_in3(track_in[3]),
        .track_in4(track_in[4]),//i
        .track_in5(track_in[5]),
        .track_in6(track_in[6]),
        .track_in7(track_in[7]),//i
        .track_in8(track_in[8]),
        .track_in9(track_in[9]),
        .track_in10(track_in[10]),
        .track_in11(track_in[11]),//i
        .track_in12(track_in[12]),
        .track_in13(track_in[13]),
        .track_in14(track_in[14]),
        .track_in15(track_in[15]),//i
        .track_in16(track_in[16]),
        .track_in17(track_in[17]),
        /*.track_in18(track_in[18]),
        .track_in19(track_in[19]),//i
        .track_in20(track_in[20]),
        .track_in21(track_in[21]),
        .track_in22(track_in[22]),
        .track_in23(track_in[23]),//i
        .track_in24(track_in[24]),
        .track_in25(track_in[25]),
        .track_in26(track_in[26]),*/
        
        .all_done(done),//o
	//is the event done being processed
        .final_cluster_addr(final_clust_addr),//i     
        .final_cluster_out(jet_out),  //o    
        .HTmax(HTmax),
        .L1done(L1done), //is L1 part of algorithm finished?
        .Nmax(Nmax), //number of clusters of the z-bins with max HT
        .zmax(zmax), //z-bin with max hT
        .event_done(event_done) //input, we are finished sending out all the clusters from this event
  /////////////////////DEBUGGING//////////////////////////////
  //all these wires go directly to the ILA
            ,
            .state_phi      (state_phi) ,  //state for phibin
            .state_out      (state_z ) ,  //state for zbin
            .pT1_out       (pT1_out ) ,
            .L1_done_out (L1_done_out) ,
            .all_L1_done_out   (all_L1_done_out  ) ,
            .phi_clust_val(phi_clust_val) ,
            .avr_out     (avr_out),
            .L2_done_out    (L2_done),
            .jet_pt_out (jet_pt_out),
            .jet_eta_out(jet_eta_out),
            .curr_E_out (curr_E_out),
            .my_E_out(my_E_out),
            .left_E_out(left_E_out),
            .right_E_out(right_E_out),
            .right2E_out(right2E_out),
            .jvalid_out(jvalid_out),
            .jpt_out(jpt_out),
            .my_eta_out(my_eta_out),
            .cstate_out(cstate_out),
            .tot_pt_out(tot_pt_out),
            .old_pt_out(old_pt_out),
            .add_val3_out(add_val3_out),
            .new_pt2_out(new_pt2_out),
            .ptout_out(ptout_out),
            .wea_out(wea_out),
            .clustering_out(clustering_out),
            .re_out(re_out),
            .readeta_out(readeta_out),
            .L2_phi_in_out(L2_phi_in_out),
            .L2_pt_in_out(L2_pt_in_out),
            .L1addr_out(L1addr_out),
            .wenj2_out(wenj2_out),
            .L2state_out(L2state_out),
            .start_clust_out(start_clust_out),
            .row_done_out(row_done_out)
  ///////////////////////////////////////////////////////////
      );
    
    assign dout = jet_out; //dout is the data of each cluster
    //a new cluster is sent on each clk cycle.
    assign vld_out = clust_val2; //cluster data is valid?
    assign rdy_out = ready_out;  //able to receive new signals
 
 ////////////////SIMULATION ONLY/////////////////////////////////////////
    //Write output data to file (for simulation only)
    //(this will all be ignored by synthesis).
    integer outfile;
    initial begin
        outfile = $fopen("sim_outL2.txt","w"); //name of file to write to
        $fwrite(outfile,"hi");
        #20000 $fclose(outfile); //close file after 20000 ns in simulation time
    end  
    
    //anytime valid data gets sent out, write it to the file.
//    always @(posedge clk) begin
//         if(vld_out) begin 
//            $fwrite(outfile, "%h", dout);
//         end
//         else if(event_done2) begin
//            $fwrite(outfile, "00000000");
//         end
//    end
//////////////////////////////////////////////////////////////////////////    
   
//   Integrated Logic Analyzer for debugging
//    each probe is a reg or wire we want to track the value of.
//    The ILA is Vivado IP. 
//    To change number of probes or width of a probe the IP must be re-generated.
    generate
    if(mkIla)
    ila_jet_finding ilajf (
            .clk(clk), 
    
            .probe0(track_in0_n), 
            .probe1(track_in1_n), 
            .probe2(track_in2_n), 
            .probe3(track_in3_n), 
            .probe4(track_in4_n), 
            .probe5(track_in5_n), 
            .probe6(track_in6_n), 
            .probe7(track_in7_n), 
            .probe8(track_in8_n), 
            .probe9(track_in0_p), 
            .probe10(track_in1_p), 
            .probe11(track_in2_p), 
            .probe12(     L2_done      ), 
            .probe13(vld_in), 
            .probe14(rdy_out),
            .probe15(dout), 
            .probe16(rdy_in), 
            .probe17(vld_out),
            .probe18(    state_z      ), 
            .probe19(start), 
            .probe20(reset), 
            .probe21(i_state),
            .probe22(done), 
            .probe23(track_in[0]), 
            .probe24(r_stop), 
            .probe25(    state_phi      ), 
            .probe26(    pT1_out           ), 
            .probe27(    L1_done_out     ), 
            .probe28(    avr_out         ), 
            .probe29(  curr_E_out     ),  
            .probe30(   phi_clust_val     ),
            .probe31(   jet_pt_out       ), 
            .probe32(   my_E_out         ),
            .probe33(   left_E_out       ),
            .probe34(   right_E_out      ),
            .probe35(   right2E_out      ),
            .probe36(   jvalid_out       ),
            .probe37(   jpt_out          ),
            .probe38(   my_eta_out       ),
            .probe39(   cstate_out       ),
            .probe40(   ntrx             ),
            .probe41(   tot_pt_out       ),
            .probe42(   old_pt_out       ),
            .probe43(   add_val3_out     ),
            .probe44(   new_pt2_out      ),
            .probe45(   ptout_out        ),
            .probe46(   clustering_out   ),
            .probe47(   wea_out          ),
            .probe48(   START            ),
            .probe49(   re_out),
            .probe50(   readeta_out    ),
            .probe51(   jet_eta_out    ),
            .probe52(   L2_phi_in_out  ),
            .probe53(   L2_pt_in_out   ),
            .probe54(   L1addr_out     ),
            .probe55(   wenj2_out      ),
            .probe56(   o_state        ),
            .probe57(   L1done         ),
            .probe58(   event_done     ),
            .probe59(   L2state_out    ),
            .probe60(   start_clust_out),
            .probe61(   row_done_out   )
    );
    endgenerate
//      ila_0 ilajf (
//                  .clk(clk), 
          
//                  .probe0(track_in0_n), 
//                  .probe1(track_in1_n), 
//                  .probe2(track_in2_n), 
//                  .probe3(track_in3_n), 
//                  .probe4(track_in4_n), 
//                  .probe5(track_in5_n), 
//                  .probe6(track_in6_n), 
//                  .probe7(track_in7_n), 
//                  .probe8(track_in8_n), 
//                  .probe9(track_in0_p), 
//                  .probe10(track_in1_p), 
//                  .probe11(track_in2_p), 
//                  .probe12(track_in3_p), 
//                  .probe13(track_in4_p), 
//                  .probe14(track_in5_p), 
//                  .probe15(track_in6_p), 
//                  .probe16(track_in7_p), 
//                  .probe17(track_in8_p),
//                  .probe18(     L2_done      ), 
//                  .probe19(vld_in), 
//                  .probe20(rdy_out),
//                  .probe21(dout), 
//                  .probe22(rdy_in), 
//                  .probe23(vld_out),
//                  .probe24(    state_z      ), 
//                  .probe25(start), 
//                  .probe26(reset), 
//                  .probe27(i_state),
//                  .probe28(done), 
//                  .probe29(track_in[0]), 
//                  .probe30(r_stop), 
//                  .probe31(    state_phi      ), 
//                  .probe32(    pT1_out           ), 
//                  .probe33(    L1_done_out     ), 
//                  .probe34(    avr_out         ), 
//                  .probe35(  curr_E_out     ),  
//                  .probe36(   phi_clust_val     ),
//                  .probe37(   jet_pt_out       ), 
//                  .probe38(   my_E_out         ),
//                  .probe39(   left_E_out       ),
//                  .probe40(   right_E_out      ),
//                  .probe41(   right2E_out      ),
//                  .probe42(   jvalid_out       ),
//                  .probe43(   jpt_out          ),
//                  .probe44(   my_eta_out       ),
//                  .probe45(   cstate_out       ),
//                  .probe46(   ntrx             ),
//                  .probe47(   tot_pt_out       ),
//                  .probe48(   old_pt_out       ),
//                  .probe49(   add_val3_out     ),
//                  .probe50(   new_pt2_out      ),
//                  .probe51(   ptout_out        ),
//                  .probe52(   clustering_out   ),
//                  .probe53(   wea_out          ),
//                  .probe54(   START            ),
//                  .probe55(   re_out),
//                  .probe56(   readeta_out    ),
//                  .probe57(   jet_eta_out    ),
//                  .probe58(   L2_phi_in_out  ),
//                  .probe59(   L2_pt_in_out   ),
//                  .probe60(   L1addr_out     ),
//                  .probe61(   wenj2_out      ),
//                  .probe62(   o_state        ),
//                  .probe63(   L1done         )
//      );
endmodule
