`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/23/2018 01:35:03 PM
// Design Name: 
// Module Name: merge_jets_L2v2
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


module merge_jets_L2v2
  #(parameter NPHI=27) 
  (
    input clk,
    input reset,

    input [22:0] Jet,
    input jet_valid,
    
    input  [4:0]  jet_addr,
    output [22:0] jet_out,
    output [4:0] njet
    );
    
    parameter NPHI1 = NPHI-1;
    reg [17:0] last_et;    //last (prior) jet et
    reg [ 9:0] prev_nt;    //previous jet ntracks
    reg [ 7:0] prev_nx;
    reg  [4:0] last_phi, last_phi1;   //last jet phi
    
    reg [4:0] addra, addradly, addra2; //address to write next jet
    
    //logic
    wire  [4:0] jet_phi = Jet[13:9];
    wire [17:0] jet_et  = {9'b0, Jet[8:0]};
    wire [ 9:0] jet_nt = {5'b0, Jet[22:18]};
    wire [ 7:0] jet_nx = {4'b0, Jet[17:14]};
    
    wire [4:0] next_phi = last_phi + 1; //phibin we're looking for to merge
    wire merge = (jet_phi == next_phi);
    reg merge1;
    wire shift = (jet_et  >  last_et);
    
    //pt of first phibin (0)
    reg [17:0] first_pt;
    reg [ 9:0] first_nt;
    reg [ 7:0] first_nx;
    //pt of last phibin (26)
    reg [17:0] last_pt;
    reg [ 9:0] last_nt;
    reg [ 7:0] last_nx;
    reg fl_merge;  //first-last merge: should first and last be merged?
    //to merge first and last, get pT of first phibin and last phibin.
    reg [8:0] my_et;
    reg [4:0] prev_nt1; 
    reg [3:0] prev_nx1;
    
    reg jet_valid_dly, jet_valid_dly1;
    always @(posedge clk) begin
        last_phi1 <= last_phi;
        merge1 <= merge;
        if(last_et[17:9] == 0) begin
          my_et <= last_et[8:0];
        end
        else begin
          my_et <= 9'b111111111;
        end
        if(prev_nt[9:5] == 0) begin
            prev_nt1 <= prev_nt[4:0];
        end
        else begin
            prev_nt1 <= 5'b11111;
        end
        if(prev_nx[7:4] == 0) begin
            prev_nx1 <= prev_nx[3:0];
        end
        else begin
            prev_nx1 <= 4'b1111;
        end
        if(reset)begin
            first_pt <= 0;
            first_nt <= 0;
            first_nx <= 0;
            last_pt <= 0;
            last_nt <= 0;
            last_nx <= 0;
        end
        //if jet in first or last phibin is written to mem, store pt/nt/nx in first/last_pt/nt/nx
        else if(last_phi1 == 0 && jet_valid_dly1) begin
            first_pt <= my_et; 
            first_nt <= prev_nt1; 
            first_nx <= prev_nx1; 
        end
        else if(last_phi1 == NPHI-1 && jet_valid_dly1) begin
            last_pt <= my_et; 
            last_nt <= prev_nt1; 
            last_nx <= prev_nx1; 
        end
      //first and last should be merged if both have pT. 
        fl_merge <= first_pt > 0 & last_pt > 0;
    end
    wire fbig = first_pt >= last_pt; //is first's pT bigger than last's pT?
    //jet is written into memory on the next clock
    always @(posedge clk) begin
      if(reset) begin
        addra <= 5'b11111; //start 1 before 0 so when 1st cluster comes in it's written on address 0
        last_phi <= 5'b11110; //start at 30 so next_phi starts at 31 //5'b0;
        last_et  <= 9'b0;
        prev_nt <= 9'b0;
        prev_nx <= 9'b0;
      end
      else begin
        //if we don't need to merge the last clust that came in, incr addra.
        if(jet_valid_dly && ~merge1) begin
           addra <= addra + 1;
        end
        if(jet_valid) begin 
           if(~merge) begin //new jet
              last_et <= jet_et;
              prev_nt <= jet_nt;
              prev_nx <= jet_nx;
              last_phi<= jet_phi;
           end
           else begin  //still in a cluster, add to existing
             last_et <= last_et + jet_et;
             prev_nt <= prev_nt + jet_nt;
             prev_nx <= prev_nx + jet_nx;
             if(shift)  
               last_phi <= jet_phi; //cluster moves
             else 
               last_phi <= last_phi;//cluster stays
           end           
        end //endif jet_valid
       
      end
    end
    assign njet = addra + 1;  
    
   //re-assemble the jet
    wire [22:0] last_jet = {prev_nt1, prev_nx1, last_phi1, my_et}; 
    wire [22:0] out_jet;
   
    always @(posedge clk) begin
      jet_valid_dly <= jet_valid;
      jet_valid_dly1 <= jet_valid_dly;
      addradly <= addra;
      addra2 <= addradly;
    end
    
    Memory #( //stores jets here, first and last jets are not merged until they are read out
      .RAM_WIDTH(23),
      .RAM_DEPTH(32),
      .RAM_PERFORMANCE("LOW_LATENCY")
    ) jet_mem
    (
      .clka(clk),
      .clkb(clk),
      .addra(addra), //changed from addra2
      .dina(last_jet),
      .wea (jet_valid_dly1),
      
      .rstb(reset),
      .enb(1'b1),
      .regceb(1'b1),
      .addrb((jet_addr < njet) ? jet_addr:5'b11111), //If j_addr is too large, now a valid jet will not be outputted
      .doutb(out_jet)
    );
    wire [4:0] out_phi = out_jet[13:9]; //phi of the output cluster
    wire [17:0] fl_sum = first_pt + last_pt;
    wire [ 9:0] fltsum = first_nt + last_nt;
    wire [ 7:0] flxsum = first_nx + last_nx;
    reg [40:0] j_out;
    reg [4:0] joutphi;
    reg [8:0] joutpt;
    reg [4:0] joutnt;
    reg [3:0] joutnx;

    always @(posedge clk) begin
      //output first-last sum when the address with larger pT is requested, 0 at the other address
        if(out_phi == 0 && out_jet[8:0] != 0) begin
            j_out <= fbig? {fltsum, flxsum, 5'b0, fl_sum} : 40'b0; //fbig says whether first is bigger than the last one
        end
        else if(out_phi == NPHI1 && out_jet[8:0] != 0) begin
            j_out <= fbig? 40'b0 : {fltsum, flxsum, 5'b11010, fl_sum};
        end
      //if out_phi isn't first or last, just read out what was stored in memory  
        else begin
            j_out <= {5'b0, out_jet[22:18], 4'b0, out_jet[17:9], 9'b0, out_jet[8:0]}; //re-form jet from nt, nx, phi, pt
        end
        joutphi <= j_out[22:18];
        if(j_out[17:9] == 0) begin
            joutpt <= j_out[8:0];
        end
        else begin
            joutpt <= 9'b111111111;
        end
        if(j_out[40:36] == 0) begin
            joutnt <= j_out[35:31];
        end
        else begin
            joutnt <= 5'b11111;
        end
        if(j_out[30:27] == 0) begin
            joutnx <= j_out[26:23];
        end
        else begin
            joutnx <= 4'b1111;
        end
        
    end
    
    assign jet_out = {joutnt, joutnx, joutphi, joutpt};
  
endmodule

