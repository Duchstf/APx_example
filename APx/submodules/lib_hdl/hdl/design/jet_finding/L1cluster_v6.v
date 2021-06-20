`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2019 06:02:35 PM
// Design Name: 
// Module Name: L1cluster_v6
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

//Perform clustering for Layer 1
// No more delay between data reads. Should take 32 clks total
module L1cluster_v6(
    input clk,
    input reset,
    input start,
    input [8:0] E_in, //pT of eta bin that we requested, although it has been delayed
    input [4:0] ntrx_in, //number of tracks
    input [3:0] nx_in, //number of special tracks
    output reg jet_valid, 
    output [4:0] curr_eta, //asking for what value is at the eta address being sent back to the histogram
	//data of jet we are creating:
    output reg [8:0] jet_pt,
    output reg [4:0] jet_eta,
    output reg [4:0] jet_ntrx,
    output reg [3:0] jet_xcount
    
    ////////////DEBUGGING/////////////
    ,
    output [8:0] my_E_out,
    output [8:0] left_E_out,
    output [8:0] right_E_out,
    output [8:0] right2E_out,
    output       jvalid_out,
    output [8:0] jpt_out,
    output [4:0] my_eta_out,
    output [3:0] cstate_out
    ///////////////////////////////////
    );
    parameter NETAp6 = 30; //number of eta bins + 6 <-- because of delays
    //pT for myself, my left neighbor, right neighbor, and neighbor 2 to the right
    reg [8:0] my_E, left_E, right_E,right2E;
    reg [4:0] my_ntrx, left_ntrx, right_ntrx, right2ntrx;
    reg [3:0] my_nx, left_nx, right_nx, right2nx;
    reg [17:0] jpt; //jet (sum) pT
    reg [9:0] jntrx;
    reg [7:0] jnx;
    reg [4:0] jet_eta_reg;
    //jet valid?
    reg jvalid;
    reg[4:0] eta=0; //eta address we're currently sending to be read data of
    assign curr_eta = eta;
  //my_eta is 6 behind curr_eta because 3 clk delay for reading, and we're reading 3 bins ahead
    wire [4:0] my_eta = eta - 5'b00110;
    
    reg [3:0] state;
    parameter IDLE = 4'b0001;
    parameter W0 =   4'b0010;
    parameter W1 =   4'b0100;
    parameter C1 =   4'b1000;
    
    wire use_right = my_E >= right2E; //use pT of right neighbor?
    wire [8:0] leftD = left_E; //always use left!
    wire [8:0] rightD = (my_E >= right2E? right_E : 0); //only use right if it belongs to me.
    wire [4:0] leftN = left_ntrx;
    wire [4:0] rightN = (my_E >= right2E? right_ntrx : 0);
    wire [3:0] leftX = left_nx;
    wire [3:0] rightX = (my_E >= right2E? right_nx : 0);
   
    reg jet_valid1; //jet_valid delayed by 1
    always @(posedge clk) begin
        jet_valid1 <= jet_valid;
        jet_eta <= jet_eta_reg;
        if(reset) begin  //reset before each new event!
            state <= IDLE;
            jpt <= 0;
            jntrx <= 0;
            jnx <= 0;
            jvalid <= 0;
            my_E <= 0;
            left_E <= 0;
            right_E <= 0;
            right2E <= 0;
            my_ntrx <= 0;
            left_ntrx <= 0;
            right_ntrx <= 0;
            right2ntrx <= 0;
            my_nx <= 0;
            left_nx <= 0;
            right_nx <= 0;
            right2nx <= 0;
            jet_eta_reg <= 0;
          //eta starts 2 before 0 so that etabin 0 has a fair chance of being a cluster
            eta <= 5'b0-5'b00010; 
        end
        else begin
          case(state)
           //waiting for start signal 
            IDLE: begin
                jvalid <= 0;
                if(start) begin
                    eta <= eta + 1;
                    state <= W0;
                end
                else begin
                    eta <= 5'b0-5'b00010;
                    state <= IDLE;
                end
            end
            W0: begin
            //need to wait for two clock cycles before the first pT data comes in.
                eta <= eta + 1;
                state <= W1;
            end
            W1: begin
            //second wait before clustering can begin
                eta <= eta + 1;
                state <= C1;
            end
          //check if this eta is center of a cluster.
           //only send center pT to the left if it isn't already part of a cluster.
            C1: begin
               eta <= eta + 1; //go to next eta bin
               if(eta == NETAp6) begin    
                   state <= IDLE;
               end
               else begin
                   state <= C1;
               end
               //if jet, output sum pT
                if(my_E >= left_E & my_E > right_E) begin
                    jvalid <= 1;
                    jpt <= my_E + leftD + rightD;
                    jntrx <= my_ntrx + leftN + rightN;
                    jnx <= my_nx + leftX + rightX;
                    jet_eta_reg <= my_eta;
                    //shift to prepare for next etabin.
                    left_E <= 0;
                    left_ntrx <= 0;
                    left_nx <= 0;
                    if(~use_right) begin
                        my_E <= right_E;
                        my_ntrx <= right_ntrx;
                        my_nx <= right_nx;
                    end
                    else begin
                        my_E <= 0;
                        my_ntrx <= 0;
                        my_nx <= 0;
                    end
                end
                //if there's still pT leftover in left neighbor, spit this out as a cluster so it's not lost
                     //  (if multiple in a row they'll be merged together by merge_jets) 
                else if(left_E > 0) begin
                    jvalid <= 1;
                    jpt <= left_E;
                    jntrx <= left_ntrx;
                    jnx <= left_nx;
                    jet_eta_reg <= my_eta - 5'b00001;
                    
                    left_E <= my_E;
                    left_ntrx <= my_ntrx;
                    left_nx <= my_nx;
                    my_E <= right_E;
                    my_ntrx <= right_ntrx;
                    my_nx <= right_nx;
                end
                //otherwise there is no cluster.
                else begin
                    jvalid <= 0;
                    
                    left_E <= my_E;
                    left_ntrx <= my_ntrx;
                    left_nx <= my_nx;
                    my_E <= right_E;
                    my_ntrx <= right_ntrx;
                    my_nx <= right_nx;
                end
                //Shift right2E and get pT of the new eta bin.
                right_E <= right2E;
                right_ntrx <= right2ntrx;
                right_nx <= right2nx;
             
                right2E <= E_in;
                right2ntrx <= ntrx_in;
                right2nx <= nx_in;
            end
          endcase  
        end 
    end
    
    always @(posedge clk) begin 
        if(jntrx[9:5] == 0) begin
            jet_ntrx <= jntrx[4:0];
        end
        else begin
            jet_ntrx <= 5'b11111;
        end
        if(jnx[7:4] == 0) begin
            jet_xcount <= jnx[3:0];
        end
        else begin
            jet_xcount <= 4'b1111;
        end
        if(jpt[17:9] == 0)begin
            jet_pt <= jpt[8:0];
        end
        else begin
            jet_pt <= 9'b111111111;
        end
        jet_valid <= jvalid;
    end
    
    ////////DEBUGGING/////////////////
    assign my_E_out = my_E;
    assign left_E_out = left_E;
    assign right_E_out = right_E;
    assign right2E_out = right2E;
    assign jvalid_out = jvalid;
    assign jpt_out = jpt[8:0];   //only look at the last 9 bits to save resources
    assign my_eta_out = my_eta;
    assign cstate_out = state;
             
endmodule

