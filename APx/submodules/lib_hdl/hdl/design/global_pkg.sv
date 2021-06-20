//==========================================================================
// CU Boulder
//-----------------------------------------------------------------------------
// @file
// @brief Global types for (System)Verilog
// @author rglein
// @date 2019-06-21
// @version v.1.0
// @details
//=============================================================================

`timescale 1 ns / 1 ps

package global_pkg;

  // Constant definition
  parameter int c_PT_WIDTH              = 15; // Track parameter bit width; extra charge bit
  parameter int c_PHI_WIDTH             = 12; // Track parameter bit width
  parameter int c_ETA_WIDTH             = 16; // Track parameter bit width
  parameter int c_Z0_WIDTH              = 12; // Track parameter bit width
  parameter int c_D0_WIDTH              = 13; // Track parameter bit width
  parameter int c_CHI2_WIDTH            = 4;  // Track quality parameter bit width
  parameter int c_BEND_CHI2_WIDTH       = 3;  // Track quality parameter bit width
  parameter int c_HIT_MASK_WIDTH        = 7;  // Track quality parameter bit width
  parameter int c_MVA_WIDTH             = 3;  // Track quality parameter bit width
  parameter int c_MVA_SPECIALIZED_WIDTH = 6;  // Track quality parameter bit width
  parameter int c_RESERVE_WIDTH         = 5;  // Reserve bit width
  parameter int c_TRACK_WORD_WIDTH      = c_RESERVE_WIDTH+c_MVA_SPECIALIZED_WIDTH+c_MVA_WIDTH+c_HIT_MASK_WIDTH+c_BEND_CHI2_WIDTH+c_CHI2_WIDTH+
                                           c_D0_WIDTH+c_Z0_WIDTH+c_ETA_WIDTH+c_PHI_WIDTH+c_PT_WIDTH; // Track word bit width
  //parameter int c_TRACK_WORD_WIDTH = 96;  // Word width of tracks
  parameter int c_TRACKS_IN_SET    = 18;  // Number of tracks in one set
  parameter int c_HIST_BIN_WIDTH   = 9;   // Word width of bins
  parameter int c_HIST_BINS        = 72;  // Number of bins in a histogram
  parameter int c_SETS_IN_EVENT    = 95;  // Number of track sets in one event
  parameter int c_PT_MAX_WIDTH     = 7;   // max pT width
  parameter int c_PT_MAX           = (2**c_PT_MAX_WIDTH)-1; // max pT

  // Type definition
  typedef struct packed
  { logic [c_RESERVE_WIDTH-1 : 0]         reserve;
    logic [c_MVA_SPECIALIZED_WIDTH-1 : 0] mva_specialized;
    logic [c_MVA_WIDTH-1 : 0]             mva;            
    logic [c_HIT_MASK_WIDTH-1 : 0]        hit_mask;       
    logic [c_BEND_CHI2_WIDTH-1 : 0]       bend_chi2;      
    logic [c_CHI2_WIDTH-1 : 0]            chi2;           
    logic [c_D0_WIDTH-1 : 0]              d0;             
    logic [c_Z0_WIDTH-1 : 0]              z0;             
    logic [c_ETA_WIDTH-1 : 0]             eta;            
    logic [c_PHI_WIDTH-1 : 0]             phi;            
    logic [c_PT_WIDTH-1 : 0]              pt;             
  } t_track_word_struct;
  typedef logic [c_TRACK_WORD_WIDTH-1 : 0] t_track_word;

  // Functions
  // Convert flatten word to struct
  function t_track_word_struct [0:c_TRACKS_IN_SET-1] tw2tw_struct(input [c_TRACK_WORD_WIDTH-1:0] track_set_in [0:c_TRACKS_IN_SET-1]);
    for (int i=0; i < c_TRACKS_IN_SET; i++) begin 
      tw2tw_struct[i].reserve         = track_set_in[i][c_TRACK_WORD_WIDTH-1 : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH];
      tw2tw_struct[i].mva_specialized = track_set_in[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH];
      tw2tw_struct[i].mva             = track_set_in[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH];
      tw2tw_struct[i].hit_mask        = track_set_in[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH];
      tw2tw_struct[i].bend_chi2       = track_set_in[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH];
      tw2tw_struct[i].chi2            = track_set_in[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH-c_CHI2_WIDTH];
      tw2tw_struct[i].d0              = track_set_in[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH+c_D0_WIDTH : c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH];
      tw2tw_struct[i].z0              = track_set_in[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH            : c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH];
      tw2tw_struct[i].eta             = track_set_in[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH                       : c_PT_WIDTH+c_PHI_WIDTH];
      tw2tw_struct[i].phi             = track_set_in[i][c_PT_WIDTH-1+c_PHI_WIDTH                                   : c_PT_WIDTH];
      tw2tw_struct[i].pt              = track_set_in[i][c_PT_WIDTH-1                                               : 0];
    end
  endfunction
  // Convert struct to flatten word
  function [0:c_TRACKS_IN_SET-1] [c_TRACK_WORD_WIDTH-1:0] tw_struct2tw(input t_track_word_struct tw2tw_struct [0:c_TRACKS_IN_SET-1]);
    for (int i=0; i < c_TRACKS_IN_SET; i++) begin 
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1 : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH] = tw2tw_struct[i].reserve;
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH] = tw2tw_struct[i].mva_specialized;
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH] = tw2tw_struct[i].mva;
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH] = tw2tw_struct[i].hit_mask;
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH] = tw2tw_struct[i].bend_chi2;
      tw_struct2tw[i][c_TRACK_WORD_WIDTH-1-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH : c_TRACK_WORD_WIDTH-c_RESERVE_WIDTH-c_MVA_SPECIALIZED_WIDTH-c_MVA_WIDTH-c_HIT_MASK_WIDTH-c_BEND_CHI2_WIDTH-c_CHI2_WIDTH] = tw2tw_struct[i].chi2;
      tw_struct2tw[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH+c_D0_WIDTH : c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH] = tw2tw_struct[i].d0;
      tw_struct2tw[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH+c_Z0_WIDTH            : c_PT_WIDTH+c_PHI_WIDTH+c_ETA_WIDTH] = tw2tw_struct[i].z0; 
      tw_struct2tw[i][c_PT_WIDTH-1+c_PHI_WIDTH+c_ETA_WIDTH                       : c_PT_WIDTH+c_PHI_WIDTH] = tw2tw_struct[i].eta;
      tw_struct2tw[i][c_PT_WIDTH-1+c_PHI_WIDTH                                   : c_PT_WIDTH] = tw2tw_struct[i].phi;
      tw_struct2tw[i][c_PT_WIDTH-1                                               : 0] = tw2tw_struct[i].pt;  
    end
  endfunction

endpackage
