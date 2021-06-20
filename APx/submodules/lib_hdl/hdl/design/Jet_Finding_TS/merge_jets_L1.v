`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/14/2018 05:37:01 PM
// Design Name: 
// Module Name: merge_jets_L1
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

module merge_jets_L1
 (
    input clk,
    input reset,

    input [22:0] Jet,
    input jet_valid,
    
    input  [4:0]  jet_addr,
    output [22:0] jet_out,
    output [4:0] nclust
    );
    
    reg [17:0] last_et;    //last jet et
    reg  [4:0] last_eta, last_eta1;   //last jet eta
    
    reg [4:0] addra, addra1, addra2, addra3; //address to write next jet
    
    //logic
    wire  [4:0] jet_eta = Jet[13:9];
    wire [9:0] jet_ntrx = {5'b0, Jet[22:18]};
    wire [7:0] jet_xcnt = {4'b0, Jet[17:14]};
    reg [9:0] prev_ntrx; 
    reg [4:0] prev_ntrx1; //previous ntrx
    reg [7:0] prev_xcnt; 
    reg [3:0] prev_xcnt1;
    wire [17:0] jet_et  = {9'b0, Jet[8:0]};
    reg [8:0] my_et;
    wire [4:0] next_eta = last_eta + 1;
    //merge clusters if they are in adjacent eta bins
    wire merge = (jet_eta == next_eta);
    reg merge1; //merge delayed by 1
    //shift eta to the second bin if the second cluster has higher pT
    wire shift = (jet_et  >  last_et);
   //jet is written into memory on the next clock
    reg jet_valid_dly, jet_valid_dly1;
    always @(posedge clk) begin
      merge1 <= merge;
      last_eta1 <= last_eta;
      if(prev_ntrx[9:5] == 0) begin
        prev_ntrx1 <= prev_ntrx[4:0];
      end
      else begin
        prev_ntrx1 <= 5'b11111;
      end
      if(prev_xcnt[7:4] == 0) begin
        prev_xcnt1 <= prev_xcnt[3:0];
      end
      else begin
        prev_xcnt1 <= 4'b1111;
      end
      if(last_et[17:9] == 0) begin
        my_et <= last_et[8:0];
      end
      else begin
        my_et <= 9'b111111111;
      end
      addra1 <= addra;
      addra2 <= addra1;
      addra3 <= addra2;
      if(reset) begin
        addra <= 5'b11111;
        last_eta <= 5'b11110;//start last_eta at 30 so next_eta starts at 31, 1st clust doesn't merge //5'b0;
        last_et  <= 9'b0;
      end
      else begin
        if(jet_valid_dly && ~merge1) begin //jet_valid_dly + merge1 in the past
            addra <= addra + 1;
        end
        if(jet_valid) begin 
           if(~merge) begin //new jet
              last_et <= jet_et;
              prev_ntrx <= jet_ntrx;
              prev_xcnt <= jet_xcnt;
              last_eta <= jet_eta;
           end
           else begin  //still in a cluster, add to existing
             last_et <= last_et + jet_et;
             prev_ntrx <= prev_ntrx + jet_ntrx;
             if(shift)  
               last_eta <= jet_eta; //cluster moves
             else 
               last_eta <= last_eta;//cluster stays
           end           
        end //endif jet_valid
      end
    end
    
   
   //re-assemble the jet
    wire [22:0] last_jet = {prev_ntrx1, prev_xcnt1, last_eta1, my_et}; 
   
    always @(posedge clk) begin
      jet_valid_dly <= jet_valid;
      jet_valid_dly1 <= jet_valid_dly;
    end
    
    Memory #(
      .RAM_WIDTH(23),
      .RAM_DEPTH(32),
      .RAM_PERFORMANCE("HIGH_PERFORMANCE")
    ) jet_mem
    (
      .clka(clk),
      .clkb(clk),
      .addra(addra),
      .dina(last_jet),
      .wea (jet_valid_dly1),
      
      .rstb(reset),
      .enb(1'b1),
      .regceb(1'b1),
      .addrb((jet_addr < nclust) ? jet_addr:5'b11111),
      .doutb(jet_out)
    );
    
    assign nclust = addra2 + 1; //addra also counts the total number of clusters we're storing.; used to be addra2
endmodule
                  