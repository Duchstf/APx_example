//==========================================================================
// CU Boulder
//-----------------------------------------------------------------------------
// @file
// @brief Make histograms for vertex finding 
// @author rglein
// @date 2019-06-20
// @version v.1.0
// @details
// Replacment of HLS functions tkobjalgo_make_histograms and tkobjalgo_merge_histograms
// to fulfill resource, timing, II, and latency requirements.
//=============================================================================

`timescale 1 ns / 1 ps 

import global_pkg::*;

module vertex_histogram
(
    input  logic clk, // Clock
    input  logic rst, // Reset
    input  logic [c_TRACK_WORD_WIDTH-1:0] track_set_in [0:c_TRACKS_IN_SET-1], // Input set of track words
    output logic rdy_out, // Ready out to source module
    input  logic vld_in,  // Valid in from source module
    output logic [c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_out, // Output flat historgam
    input  logic rdy_in,  // Ready in from sink module
    output logic vld_out, // Valid out to sink module
    output logic [6:0] set_cnt_out // Set counter
);

// Defines
`define DEBUG 0

// Signals
t_track_word_struct [0:c_TRACKS_IN_SET-1] track_word_struct; // Track word struct
//logic [0:c_TRACKS_IN_SET-1][c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_arr       = '{default:0}; // Historgam array
logic [0:c_TRACKS_IN_SET-1][c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_arr0      = '{default:0}; // Historgam array ping
logic [0:c_TRACKS_IN_SET-1][c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_arr1      = '{default:0}; // Historgam array pong
logic [0:c_TRACKS_IN_SET-1][c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_arr_tmp0  = '{default:0}; // Historgam array ping
logic [0:c_TRACKS_IN_SET-1][c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_arr_tmp1  = '{default:0}; // Historgam array pong
logic [c_HIST_BINS*c_HIST_BIN_WIDTH-1:0] hist_out_tmp = '{default:0}; // Temporary flat historgam
byte unsigned set_cnt = 0;  // Set of tracks counter
logic vld_in_d0;  // Registered valid in 

always_ff @(posedge clk) begin 
  // Convert flatten word to struct
  track_word_struct <= tw2tw_struct(track_set_in);
end

// FSM -----------------------------------------------------
typedef enum logic[3:0] {IDLE, MAKE, MERGE, OUT} t_fsm_hist;
t_fsm_hist state, next;

always_ff @(posedge clk) begin
  if (rst)  state <= IDLE;
  else      state <= next;
end

always_comb begin 
  next = IDLE; // Default assigment
  hist_arr_tmp0 = hist_arr0; // Default assigment
  hist_arr_tmp1 = hist_arr1; // Default assigment
  hist_out_tmp  = hist_out; // Default assigment
  case (state)
    IDLE :  begin
      next = MAKE;
      hist_out_tmp = '{default:0};
    end
    MAKE :  begin
              next = MAKE; // Default assigment
              if(vld_in_d0) begin
                if(set_cnt >= c_SETS_IN_EVENT) begin 
                  next = MERGE;
                end
                if (set_cnt > 0) begin // Avoid valid situation (especially at start of event)
  
                    if((set_cnt%2) == 0) begin // Ping ---------------------------------------
                      for (byte tr=0; tr < c_TRACKS_IN_SET; tr++) begin  
                        byte bin[0:c_TRACKS_IN_SET-1]; // Current bin
                        logic valid[0:c_TRACKS_IN_SET-1]; // Bin valid
                        shortint pt_tmp; // Temporary pt
                        byte hist_bin[0:c_TRACKS_IN_SET-1]; // Temporary calc
                        bin[tr] = signed'(track_word_struct[tr].z0[c_Z0_WIDTH-1:3]) + signed'(c_HIST_BINS >> 1); //$display("%d",bin); 
                        valid[tr] = (bin[tr] >= 0) && (bin[tr] <= c_HIST_BINS-1);
                        if (valid[tr]) begin
                          if (track_word_struct[tr].pt[c_PT_WIDTH-2:1] > c_PT_MAX) begin // pt saturation: if pt/2 > PT_MAX
                            pt_tmp = c_PT_MAX;
                          end
                          else begin
                            pt_tmp = track_word_struct[tr].pt[c_PT_MAX_WIDTH:1]; // pT/2
                          end
                          hist_bin[tr] = hist_arr0[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] + pt_tmp; // add pt (w/o charge bit) to corresponding bin; todo: bit width add and ap_fixed
  //$display("%d  ,\t%d,\t%d,\t%d,\t%d,\t%d",$time,set_cnt,bin[tr],hist_bin[tr],hist_arr0[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH],track_word_struct[tr].pt[c_PT_WIDTH-2:0]);
                          if (hist_bin[tr] >= (2**c_HIST_BIN_WIDTH)) begin // Saturation protection
                            hist_arr_tmp0[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = (2**c_HIST_BIN_WIDTH)-1;
                          end
                          else begin 
                            hist_arr_tmp0[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = hist_bin[tr];
                          end
                        end
                      end
                    end
                    else begin // Pong ---------------------------------------
                      for (byte tr=0; tr < c_TRACKS_IN_SET; tr++) begin  
                        byte bin[0:c_TRACKS_IN_SET-1]; // Current bin
                        logic valid[0:c_TRACKS_IN_SET-1]; // Bin valid
                        shortint pt_tmp; // Temporary pt
                        byte hist_bin[0:c_TRACKS_IN_SET-1]; // Temporary calc
                        bin[tr] = signed'(track_word_struct[tr].z0[c_Z0_WIDTH-1:3]) + signed'(c_HIST_BINS >> 1); //$display("%d",bin); 
                        valid[tr] = (bin[tr] >= 0) && (bin[tr] <= c_HIST_BINS-1);
                          if (track_word_struct[tr].pt[c_PT_WIDTH-2:1] > c_PT_MAX) begin // pt saturation: if pt/2 > PT_MAX
                            pt_tmp = c_PT_MAX;
                          end
                          else begin
                            pt_tmp = track_word_struct[tr].pt[c_PT_MAX_WIDTH:1]; // pT/2
                          end
                        if (valid[tr]) begin
                          hist_bin[tr] = hist_arr1[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] + pt_tmp; // add pt (w/o charge bit) to corresponding bin; todo: bit width add and ap_fixed
  //$display("%d  ,\t%d,\t%d,\t%d,\t%d,\t%d",$time,set_cnt,bin[tr],hist_bin[tr],hist_arr1[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH],track_word_struct[tr].pt[c_PT_WIDTH-2:0]);
                          if (hist_bin[tr] >= (2**c_HIST_BIN_WIDTH)) begin // Saturation protection
                            hist_arr_tmp1[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = (2**c_HIST_BIN_WIDTH)-1;
                          end
                          else begin 
                            hist_arr_tmp1[tr][bin[tr]*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = hist_bin[tr];
                          end
                        end
                      end
                    end
  
                end
              end
              else    next = MAKE;

              if (`DEBUG==1) begin // Test section to update out every clk cycle
                for (byte i_bin=0; i_bin < c_HIST_BINS; i_bin++) begin
                  byte hist_bin_sum = 0; // Temporary calc
                  for (byte tr=0; tr < c_TRACKS_IN_SET; tr++) begin // Merge track histos of ping pong buffers
                    hist_bin_sum += hist_arr0[tr][i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] + hist_arr1[tr][i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH]; 
                  end
                  if (hist_bin_sum >= (2**c_HIST_BIN_WIDTH)) begin // Saturation protection
                    hist_out_tmp[i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = (2**c_HIST_BIN_WIDTH)-1;
                  end
                  else begin 
                    hist_out_tmp[i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = hist_bin_sum;
                  end
                end 
              end

            end // MAKE

    MERGE:  begin
              next = OUT;
              for (byte i_bin=0; i_bin < c_HIST_BINS; i_bin++) begin
                shortint hist_bin_sum = 0; // Temporary calc
                for (byte tr=0; tr < c_TRACKS_IN_SET; tr++) begin // Merge track histos of ping pong buffers
                  hist_bin_sum += hist_arr0[tr][i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] + hist_arr1[tr][i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH]; 
                end
                if (hist_bin_sum >= (2**c_HIST_BIN_WIDTH)) begin // Saturation protection
                  hist_out_tmp[i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = (2**c_HIST_BIN_WIDTH)-1;
                end
                else begin 
                  hist_out_tmp[i_bin*c_HIST_BIN_WIDTH +: c_HIST_BIN_WIDTH] = hist_bin_sum;
                end
              end
            end
    OUT:    if(rdy_in)  next = IDLE;
            else        next = OUT;
  endcase
end

always_ff @(posedge clk) begin
  if(rst)begin // Synch reset
      set_cnt      <= 0;
      //hist_arr     <= '{default:0};
      hist_arr0    <= '{default:0};
      hist_arr1    <= '{default:0};
      hist_out     <= '{default:0};
      rdy_out      <= 1'b0;
      vld_out      <= 1'b0;
      vld_in_d0    <= 1'b0;
  end
  else begin
    vld_out    <= 1'b0; // Default assigment
    rdy_out    <= 1'b0; // Default assigment
    hist_out   <= hist_out_tmp; // Default assigment
    vld_in_d0  <= vld_in;
    case (state)
      IDLE :  begin
                //hist_arr  <= '{default:0};
                hist_arr0 <= '{default:0};
                hist_arr1 <= '{default:0};
                hist_out  <= '{default:0};
                rdy_out   <= 1'b1; // signaling ready early
              end
      MAKE :  begin
                if(set_cnt < c_SETS_IN_EVENT-2) begin // stop reading in earlier
                  rdy_out  <= 1'b1;
                end
                if(vld_in) begin
                  set_cnt <= set_cnt+1; 
                end
                if((set_cnt%2) == 0) begin // Ping
                  hist_arr0  <= hist_arr_tmp0;
                end
                else begin // Pong
                  hist_arr1  <= hist_arr_tmp1;
                end
              end
      MERGE:  set_cnt <= 0;
      OUT:    begin
                vld_out <= 1'b1; // Only valid at end of event
                rdy_out <= 1'b1; // signaling ready early
              end
    endcase 
  end
end

assign set_cnt_out = set_cnt;

endmodule
