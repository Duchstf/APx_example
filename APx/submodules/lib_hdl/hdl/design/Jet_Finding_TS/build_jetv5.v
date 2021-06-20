`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2019 06:36:24 PM
// Design Name: 
// Module Name: build_jetv5
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

//perform L2 clustering-- this version should take only 1 clk cycle per phi bin.
module build_jetv5
 #(
   parameter NPHI = 27
  )
  (
    input clk,
    input reset,
    input start,
    
    input [8:0] Center,
    input [8:0] Left,
    input [8:0] Right,
    
    input [17:0] Em2,
    input [17:0] Em1,
    input [17:0] Ep1,
    input [17:0] Ep2,
    output  [17:0] Etom2,
    output  [17:0] Etom1,
    output  [17:0] Etop1,
    output  [17:0] Etop2,
    
    input  [4:0]  my_ntrx,
    input  [4:0]  left_ntrx,
    input  [4:0]  right_ntrx,
    
    input  [3:0]  my_xcnt,
    input  [3:0]  left_xcnt,
    input  [3:0]  right_xcnt,
    
    output reg [4:0] addr, //request phi bin
    
    output [22:0] Jet, //output
    output jet_valid,   //valid output
    output reg done
  );
  parameter NPHI1 = NPHI-1;
  parameter NPHI2 = NPHI-2;
  //lagging addr: 4 clocks delay from algorithm and 2 more from memory latency
  reg [4:0] addr1=0;
  reg [4:0] addr2=0;
  reg [4:0] addr3=0;
  reg [4:0] addr4=0;
  reg [4:0] addr5=0;
  reg [4:0] addr6=0;
  always @(posedge clk) begin
    addr1 <= addr;
    addr2 <= addr1;
    addr3 <= addr2;
    addr4 <= addr3;
    addr5 <= addr4;
    addr6 <= addr5;
  end
  
  reg Jvalid = 0; //is the jet valid?
  reg [4:0] Jphi; //phi value of jet
  reg [17:0] Ecl; //energy of the cluster
  reg [9:0] tcl;  //tracks in cluster
  reg [7:0] xcl;  //x-tracks in cluster
  reg [17:0] Ecl_out; //energy that gets sent to neighbors
  reg [9:0] tcl_out; //tracks sent to neighbors
  reg [7:0] xcl_out; //special tracks sent to neighbors
  reg [17:0] E0;
  reg [9:0] t0;
  reg [7:0] x0;
  reg [17:0] E1;
  reg [9:0] t1;
  reg [7:0] x1;
  reg [17:0] E2;
  reg [9:0] t2;
  reg [7:0] x2;
  reg [8:0] Jetpt; //final pT
  reg [4:0] Jetnt; //final number of tracks
  reg [3:0] Jetnx; //final number of special tracks
  reg Jetvalid; //is final jet valid?
  reg [4:0] Jetphi; //final phi
  assign jet_valid = Jetvalid;
  assign Jet = {Jetnt, Jetnx, Jetphi, Jetpt};
  
  always @(posedge clk) begin //assigning the final outputs
    Jetvalid <= Jvalid;
    Jetphi <= Jphi;
    if(Ecl[17:9] == 0) begin
        Jetpt <= Ecl[8:0];
    end
    else begin
        Jetpt <= 9'b111111111;
    end
    if(tcl[9:5] == 0) begin
        Jetnt <= tcl[4:0];
    end
    else begin
        Jetnt <= 5'b11111;
    end
    if(xcl[7:4] == 0) begin
        Jetnx <= xcl[3:0];
    end
    else begin
        Jetnx <= 4'b1111;
    end
  end
 
  reg [8:0] Ec;
  reg [4:0] tc;
  reg [3:0] xc;
  reg [17:0] En; 
  reg [9:0] tn;
  reg [7:0] xn; 
  wire [8:0] El;  
  wire [4:0] tl;
  wire [3:0] xl;
  wire [8:0] Er; 
  wire [4:0] tr;
  wire [3:0] xr;
  //used to be Ecl for all of these
  assign El = (Ec > Em2)? Left  : 0; //if energy of my cluster is greater than the energy of the cluster 2 to the left, then we will see whatever is in the left cluster so we can add it to my cluster
  assign tl = (Ec > Em2)? left_ntrx : 0; //clustering is always based on energy, but we also want to keep track of tracks and special tracks
  assign xl = (Ec > Em2)? left_xcnt : 0;
  
  assign Er = (Ec > Ep2)? Right : 0; //same thing for the right
  assign tr = (Ec > Ep2)? right_ntrx : 0;
  assign xr = (Ec > Ep2)? right_xcnt : 0;
  always @(posedge clk) begin
    if(reset) begin
      Ec <= 0;
      tc <= 0;
      xc <= 0;
      En <= 0;
      tn <= 0;
      xn <= 0;
    end
    else begin
      Ec <= Center;
      tc <= my_ntrx;
      xc <= my_xcnt;
      //En is energy of neighbors
      En <= El + Er;
      tn <= tl + tr;
      xn <= xl + xr;
    end
  end
  //all the same, we really don't need 4 outputs
  assign Etom2 = Ecl_out;
  assign Etom1 = Ecl_out;
  assign Etop1 = Ecl_out;
  assign Etop2 = Ecl_out;
  
  //state machine 
  parameter IDLE= 6'b000001;
  parameter W0  = 6'b000010;
  parameter S0  = 6'b000100;
  parameter S1  = 6'b001000;
  parameter S2  = 6'b010000;
  parameter S2G = 6'b100000;
    
  reg [7:0] state = S0;  
  always @(posedge clk) begin
     if(reset) begin
        state <= IDLE;
        Jvalid <=0;
        Jphi   <=0;
        addr   <=5'b0; //start at 0 to save time
        done   <=0;
        E0  <= 0;
        t0 <= 0;
        x0 <= 0;
        E1  <= 0;
        t1 <= 0;
        x1 <= 0;
        E2  <= 0;
        t2 <= 0;
        x2 <= 0;
        Ecl     <= 0;
        tcl <= 0;
        xcl <= 0;
        Ecl_out <= 0;
        tcl_out <= 0;
        xcl_out <= 0;
     end
     else
       case (state)
         IDLE: begin //start in IDLE
           Jvalid <=0;
           if(start) begin
             addr  <= addr + 1;
             state <= W0;
             done <= 0;
           end
           else begin
             addr  <= 5'b0;
             state <= IDLE;
           end
         end
         //must wait 1 clk before regular clustering can start.
         W0: begin
            addr <= addr + 1;
            state <= S0;
         end
        //0 pT has been found so far--check the next phi bin 
         S0  : begin
           Jvalid <= 0;
           E1 <= 0;
           t1 <= 0;
           x1 <= 0;
           E2 <= 0;
           t2 <= 0;
           x2 <= 0;
          //addr2 is phi address of the pT coming in now 
           if(addr2 == NPHI1) begin //if our address is the last address, then we know our cluster is whatever was in the last bin
                state <= IDLE;
                done <= 1;
                if(Em1==0 && Ep1==0 && Ec > 0) begin //if no cluster to the left or right but I do have pT, then this is the Jet. We are also at the last phibin at this point
                    Jvalid <= 1;
                    Jphi <= NPHI1;
                    Ecl <= Ec;
                    tcl <= tc;
                    xcl <= xc;
                end
                else begin
                    Jvalid <= 0;
                    Ecl_out <= 0;
                    tcl_out <= 0;
                    xcl_out <= 0;
                end
           end  //end addr2 is NPHI1
           else begin
            addr <= addr + 1;
           //only use the Center pT if it's not being used by one of the neighbors. 
           if(Ec > 0 && Em1==0 && Ep1 == 0) begin 
             E0  <= Ec;
             t0 <= tc;
             x0 <= xc;
             Ecl <= Ec;
             tcl <= tc;
             xcl <= xc;
             Ecl_out <= Ec;
             tcl_out <= tc;
             xcl_out <= xc;
             state <= S1; //we've found one phi-bin with pT so far
           end
           else begin      //otherwise we stay in this phibin and everything stays 0  
             E0  <= 0;
             t0 <= 0;
             x0 <= 0;
             Ecl <= 0;
             tcl <= 0;
             xcl <= 0;
             Ecl_out <= 0;
             tcl_out <= 0;
             xcl_out <= 0;
             state <= S0;
           end
          end    //end addr not NPHI1
         end    //end S0
       //pT was found in 1 phibin. So is this now the center? 
         S1  : begin                     
           E2 <= 0;
           t2 <= 0;
           x2 <= 0;
           Ecl <= E0 + Ec + En; //either Ec or En will be 0 because we already went through L1 clustering
           tcl <= t0 + tc + tn;
           xcl <= x0 + xc + xn;
           if(addr2 == NPHI1) begin //if we are in the last phibin
             done <=1; //we're done
             state<= IDLE;
             Jvalid <= 1; //send out Jet      
           //phi of the cluster is whichever bin had more pT 
             Jphi <= E0 > Ec+En? NPHI2 : NPHI1;      
             Ecl_out <= E0 + Ec + En;
             tcl_out <= t0 + tc + tn;
             xcl_out <= x0 + xc + xn;
           end  //end addr2 is NPHI1
           //if new bin has less pT than first one, cluster is done.
           else if(Ec + En < E0) begin //haven't reached last phibin
             addr <= addr + 1;
             Ecl_out <= 0; 
             tcl_out <= 0;  //cluster is done so can set Ecl_out to 0; we want neighbors to be able to take pT
             xcl_out <= 0;
             state <= S0;   //state goes back to S0 so we can potentially build another jet    
             Jvalid <= 1;  //send out jet
             Jphi <= addr3; //addr delayed by 3 (2 clks for reading, 1 bin prior)   
           end
           //otherwise, we need to add the next bin to the cluster.
           else begin
             addr <= addr + 1;
             E1 <= Ec + En;
             t1 <= tc + tn;
             x1 <= xc + xn;
             Ecl_out <= E0 + Ec + En; //still building a jet, so we want our neighbors to know the pT of our jet
             tcl_out <= t0 + tc + tn;
             xcl_out <= x0 + xc + xn;
             Jvalid <= 0;
             state <= S2;
           end
         end
        //get pT of third bin of cluster 
         S2 : begin //there could potentially be a bug here that we need Jet_valid for the if and else statements
           if(addr2 == NPHI1) begin //again check if we have reached the last phibin
               //if last phibin has lowest pT, all 1 proper cluster
               if(E1 > Ec + En)begin
                   state <= IDLE;
                   Jphi <= NPHI2; //center will be second to last phibin
                   done <= 1; //we're done
                   Ecl <= E0 + E1 + Ec + En; //set energy of cluster
                   tcl <= t0 + t1 + tc + tn;
                   xcl <= x0 + x1 + xc + xn;            
                   Ecl_out <= 0;
                   tcl_out <= 0; //cluster done so set Ecl_out to 0.
                   xcl_out <= 0;
		   Jvalid <= 1; //make sure this is correct
		   //JVALID SHOULD EQUAL 1?
               end
               //otherwise, 2 separate clusters, one in 3rd-last, one in last
               else begin //output the first bin
                   Ecl <= E0;
                   tcl <= t0;
                   xcl <= x0;
                   Ecl_out <= E1 + Ec + En; //maybe set to E1 + Ec + En, shouldn't matter at the end; originally E0
                   tcl_out <= t1 + tc + tn; //originally t0
                   xcl_out <= x1 + xc + xn; //originally x0
                   E2 <= Ec + En;
                   t2 <= tc + tn;
                   x2 <= xc + xn;
                   state <= S2G; //final state
                   done <= 0;
                   Jphi <= NPHI2-1; 
		   Jvalid <= 1; //make sure this is correct as well
		   //JVALID SHOULD EQUAL 1?
               end 
           end
          //if third bin is lower than second, proper cluster is now complete.
           else if(Ec + En < E1) begin
              addr <= addr + 1;
              Ecl <= E0 + E1 + Ec + En;
              tcl <= t0 + t1 + tc + tn;
              xcl <= x0 + x1 + xc + xn;
              Ecl_out <= 0; //cluster done, so set Ecl_out to 0.
              tcl_out <= 0;
              xcl_out <= 0;
              Jvalid <= 1;
              Jphi <= addr3; //2 clk delay, center was 1 bin prior
              state <= S0;
           end
           //otherwise we need to spit out E0 as its own cluster, E1 is the new E0, etc.
           else begin
              addr <= addr + 1;
              Ecl <= E0;
              tcl <= t0;
              xcl <= x0;
              Ecl_out <= E1 + Ec + En; //originally E0; make sure this is correct
              tcl_out <= t1 + tc + tn; //originally t0; make sure this is correct
              xcl_out <= x1 + xc + xn; //originally x0; make sure this is correct
              Jvalid <= 1;
              Jphi <= addr4; //2 clk delay, center was 2 bins prior
              E0 <= E1;
              t0 <= t1;
              x0 <= x1;
              E1 <= Ec + En;
              t1 <= tc + tn;
              x1 <= xc + xn;
              state <= S2;
           end
         end
         S2G : begin   //after S2 reaches end, definitely the end.
             done <= 1;
             state <= IDLE;
             Ecl <= E1 + E2; 
             tcl <= t1 + t2;
             xcl <= x1 + x2;            
             //Ecl_out <= E1 + E2;
             Jvalid <= 1;
             Jphi <= NPHI1;
          end
       endcase
  end
    
endmodule
