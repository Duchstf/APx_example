//==========================================================================
// CU Boulder
//-----------------------------------------------------------------------------
// @file
// @brief Test bench for make histograms for vertex finding 
// @author rglein
// @date 2019-06-21
// @version v.1.0
// @details
//=============================================================================

`timescale 1 ns / 1 ps

import global_pkg::*;

module tb_vertex_histogram; 

// Signal to connect the DUT
logic rst; // Reset
logic clk; // Clock
logic [c_TRACK_WORD_WIDTH-1:0] track_set_in [0:c_TRACKS_IN_SET-1]; // Input set of track words
logic rdy_out; // Ready out to source module
logic vld_in;  // Valid in from source module
logic [c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_flat_out; // Output flat histogram
logic [c_HIST_BIN_WIDTH-1:0] hist_out [0:c_HIST_BINS-1]; // Output histogram
logic rdy_in;  // Ready in from sink module
logic vld_out; // Valid out to sink module
logic [6:0] set_cnt_out; // Set counter
logic rdy_out_d0; // Delayed ready out to source module
// Clock periode
time c_CLK = 2;//3.125;

// Connect the DUT
vertex_histogram dut_vertex_histogram (
  .rst          (rst          ),
  .clk          (clk          ),
  .track_set_in (track_set_in ),
  .rdy_out      (rdy_out      ),
  .vld_in       (vld_in       ),
  .hist_out     (hist_flat_out),
  .rdy_in       (rdy_in       ),
  .vld_out      (vld_out      ),
  .set_cnt_out  (set_cnt_out  )
);

// Mapping array <- flattened port
always_comb begin
  for (int bin=0; bin < c_HIST_BINS; bin++) begin  
    hist_out[bin] = hist_flat_out[bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH];//{>>{hist_flat_out[bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH]}};
  end
end

// Clock generation 
always begin
  #(c_CLK/2)  clk =  ! clk; 
end

// Input initialization  
initial begin
rst          = 1'b1;
clk          = 1'b0;
track_set_in = '{default:0};
vld_in       = 1'b0;
rdy_in       = 1'b0;
end 

// Write output to file 
initial  begin
 $dumpfile ("vertex_histogram.vcd"); 
 $dumpvars; 
end 

// Print to stdout
`define DEBUG 0
`define DISP "\t\ttime,\trst,\tset_cnt_out,\ttrack_set_in[0],\ttrack_set_in[1],\ttrack_set_in[17],\trdy_out,\tvld_in,\thist_out[0],\thist_out[1],\thist_out[37],\thist_out[71],\trdy_in,\tvld_out"
`define MON  "%d,\t%b,\t%d,\t%h,\t%h,\t%h,\t%b,\t%b,\t%d,\t%d,\t%d,\t%d,\t%b,\t%b", \
              $time,rst,set_cnt_out,track_set_in[0],track_set_in[1],track_set_in[17],rdy_out,vld_in,hist_out[0],hist_out[1],hist_out[37],hist_out[71],rdy_in,vld_out
generate
if (`DEBUG==1) begin
  initial  begin
   $display(`DISP); 
   $monitor(`MON); 
   #500   $finish; // Finish simulation after x time units
  end 
end
else begin
  initial begin
    $display(`DISP);
    #5000  $finish; // Finish simulation after x time units
  end
  always begin
    #c_CLK  if (vld_out) begin
              $display(`MON); 
            end
  end
end
endgenerate
   
//Rest of testbench code after this line 
initial begin
  #(c_CLK/2)
  #(c_CLK*9)    rst = 1'b0; vld_in = 1'b1; rdy_in = 1'b1;
  //#(c_CLK*1)   track_word_struct[0].z0  = 12'b0000_0000_0000; track_word_struct[0].pt  = 15'b000_0000_0010_0000; tw_struct2tw(track_word_struct); // Convert struct to flatten word, no logic used
  //#(c_CLK*1)  
                // track_set_in[0]  = 96'h0000_0000_03F7_0000_0000_0001; // bin=0; pT=1 // z0=-288
                // track_set_in[1]  = 96'h0000_0000_03F7_4000_0000_0002; // bin=1; pT=2
                // track_set_in[2]  = 96'h0000_0000_03F7_4000_0000_0004;
                // track_set_in[3]  = 96'h0000_0000_03F7_4000_0000_0008;
                // track_set_in[4]  = 96'h0000_0000_0000_4000_0000_000A; // bin=37; pT=10   // track/I,hwPt/I,hwEta/I,hwPhi/I,hwZ0/I -> 0,    10,   +117,     -4,    +8   8>>3+36==37
                // track_set_in[5]  = 96'h0000_0000_0000_0000_0000_0400;
                // track_set_in[6]  = 96'h0000_0000_0000_0000_0000_0800;
                // track_set_in[7]  = 96'h0000_0000_0000_0000_0000_1000;
                // track_set_in[8]  = 96'h0000_0000_0000_0000_0000_2000;
                // track_set_in[9]  = 96'h0000_0000_0000_0000_0000_0000;
                // track_set_in[10] = 96'h0000_0000_0000_0000_0000_0020;
                // track_set_in[11] = 96'h0000_0000_0000_0000_0000_0040;
                // track_set_in[12] = 96'h0000_0000_0000_0000_0000_0020;
                // track_set_in[13] = 96'h0000_0000_0000_0000_0000_0040;
                // track_set_in[14] = 96'h0000_0000_0000_0000_0000_0020;
                // track_set_in[15] = 96'h0000_0000_0000_0000_0000_0040;
                // track_set_in[16] = 96'h0000_0000_0000_0000_0000_0020;
                //track_set_in[17]  = 96'h0000_0000_0008_C000_0000_0003; // bin=71; pT=3
                //track_set_in[17]  = 96'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
  #(c_CLK*100)  vld_in = 1'b0; // Test data flow signals
  #(c_CLK*2)    vld_in = 1'b1; // Test data flow signals
  #(c_CLK*10)   rdy_in = 1'b0; // Test data flow signals
  #(c_CLK*5)    rdy_in = 1'b1; // Test data flow signals
end

always @(posedge clk) begin
  //rdy_out_d0 <= rdy_out;
  // Track 0, 1, 2, 3, 4 ------------------------------------------------
  track_set_in[0]  = 96'h0000_0000_03F7_0000_0000_0000;
  track_set_in[1]  = 96'h0000_0000_03F7_4000_0000_0000;
  track_set_in[2]  = 96'h0000_0000_03F7_4000_0000_0000;
  track_set_in[3]  = 96'h0000_0000_03F7_4000_0000_0000;
  track_set_in[4]  = 96'h0000_0000_0000_4000_0000_0000;
  if(vld_in==1'b1 && rdy_out==1'b1) begin
    track_set_in[0]  = 96'h0000_0000_03F7_0000_0000_0001; // bin=0; pT=1 // z0=-288
    track_set_in[1]  = 96'h0000_0000_03F7_4000_0000_0002; // bin=1; pT=2
//    track_set_in[2]  = 96'h0000_0000_03F7_4000_0000_0004;
//    track_set_in[3]  = 96'h0000_0000_03F7_4000_0000_0008;
    track_set_in[4]  = 96'h0000_0000_0000_4000_0000_0014; // bin=37; pT=20   // track/I,hwPt/I,hwEta/I,hwPhi/I,hwZ0/I -> 0,    10,   +117,     -4,    +8   8>>3+36==37
  end
  // Track 17 -----------------------------------------------------------
  track_set_in[17]  <= 96'h0000_0000_0008_C000_0000_0000; // bin=71; pT=0
  if(vld_in==1'b1 && rdy_out==1'b1) begin
    if (set_cnt_out%3==0) 
      track_set_in[17] <= 96'h0000_0000_0008_C000_0000_0003; // bin=71; pT=3
    if (set_cnt_out%3==1) 
      track_set_in[17] <= 96'h0000_0000_0008_C000_0000_0001; // bin=71; pT=1
    if (set_cnt_out%3==2) 
      track_set_in[17] <= 96'h0000_0000_0008_C000_0000_0002; // bin=71; pT=2
  end
end

endmodule
