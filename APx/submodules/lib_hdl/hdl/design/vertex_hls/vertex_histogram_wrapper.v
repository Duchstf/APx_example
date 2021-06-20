//==========================================================================
// CU Boulder
//-----------------------------------------------------------------------------
// @file
// @brief Wrapper to instantiate it in VHDL using Xilinx (no multidim. arrays)
// @author rglein
// @date 2019-07-03
// @version v.1.0
//=============================================================================

`timescale 1 ns / 1 ps 

module vertex_histogram_wrapper
#(  // Redefinition of constants for sim and synth: Needed because of Verilog and SystemVerilog mix
    parameter c_WRAP_TRACK_WORD_WIDTH  = 96,
    parameter c_WRAP_HIST_BIN_WIDTH    = 9,
    parameter c_WRAP_TRACKS_IN_SET     = 18,
    parameter c_WRAP_HIST_BINS         = 72
) (
    input  wire clk, // Clock
    input  wire rst, // Reset
    input  wire rdy_in,      // Ready in from sink module
    input  wire ap_ce,       // Dummy port for HLS
    output wire ap_idle,     // Dummy port for HLS
    input  wire ap_start,    // vld_in - Valid in from source module
    output wire ap_ready,    // rdy_out - Ready out to source module
    output wire ap_done,     // vld_out - Valid out to sink module
    input  wire ap_continue, // Dummy port for HLS
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_0 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_1 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_2 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_3 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_4 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_5 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_6 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_7 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_8 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_9 , // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_10, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_11, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_12, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_13, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_14, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_15, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_16, // Input track word
    input  wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_in_17, // Input track word
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_0 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_1 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_2 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_3 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_4 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_5 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_6 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_7 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_8 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_9 , // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_10, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_11, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_12, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_13, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_14, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_15, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_16, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_17, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_18, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_19, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_20, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_21, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_22, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_23, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_24, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_25, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_26, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_27, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_28, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_29, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_30, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_31, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_32, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_33, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_34, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_35, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_36, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_37, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_38, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_39, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_40, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_41, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_42, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_43, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_44, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_45, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_46, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_47, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_48, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_49, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_50, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_51, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_52, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_53, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_54, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_55, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_56, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_57, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_58, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_59, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_60, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_61, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_62, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_63, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_64, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_65, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_66, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_67, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_68, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_69, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_70, // Output histogram bin
    output wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out_71, // Output histogram bin
    output wire [6:0] set_cnt_out // Set counter
);

// Variables
wire [c_WRAP_TRACK_WORD_WIDTH-1:0] track_set_in [0:c_WRAP_TRACKS_IN_SET-1]; // Packed variable
//wire [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out [0:c_WRAP_HIST_BINS-1]; // Packed variable

// Mapping of HLS signaing
// rdy_in is mapped directly
// ap_ce is an unused dummy input
assign ap_idle = 1'b0; // Assign dummy port for HLS
wire vld_in;  assign vld_in   = ap_start; // vld_in - Valid in from source module
wire rdy_out; assign ap_ready = rdy_out;  // rdy_out - Ready out to source module
wire vld_out; assign ap_done  = vld_out;  // vld_out - Valid out to sink module
// ap_continue is an unused dummy input

// Mapping packed <-> unpacked
//assign tmp =  {>>{32'h0000_0000}};
assign track_set_in[0]  = {>>{track_in_0 }};
assign track_set_in[1]  = {>>{track_in_1 }};
assign track_set_in[2]  = {>>{track_in_2 }};
assign track_set_in[3]  = {>>{track_in_3 }};
assign track_set_in[4]  = {>>{track_in_4 }};
assign track_set_in[5]  = {>>{track_in_5 }};
assign track_set_in[6]  = {>>{track_in_6 }};
assign track_set_in[7]  = {>>{track_in_7 }};
assign track_set_in[8]  = {>>{track_in_8 }};
assign track_set_in[9]  = {>>{track_in_9 }};
assign track_set_in[10] = {>>{track_in_10}};
assign track_set_in[11] = {>>{track_in_11}};
assign track_set_in[12] = {>>{track_in_12}};
assign track_set_in[13] = {>>{track_in_13}};
assign track_set_in[14] = {>>{track_in_14}};
assign track_set_in[15] = {>>{track_in_15}};
assign track_set_in[16] = {>>{track_in_16}};
assign track_set_in[17] = {>>{track_in_17}};
//assign {>>{hist_out_0}}  = hist_out[0];


// Instantiation with synthesis off/on to make xsim work
vertex_histogram i_vertex_histogram(
  .rst         (rst),
  .clk         (clk),
  .track_set_in({   // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[0] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[1] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[2] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[3] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[4] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[5] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[6] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[7] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[8] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[9] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[10] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[11] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[12] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[13] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[14] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[15] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[16] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                    ,  
                    // synthesis translate_off
                    {>>{
                    // synthesis translate_on
                    track_set_in[17] 
                    // synthesis translate_off
                    }}
                    // synthesis translate_on
                 }), // [c_WRAP_TRACK_WORD_WIDTH-1:0] track_set_in [0:c_WRAP_TRACKS_IN_SET-1], // Input set of track words
  .rdy_out     (rdy_out),
  .vld_in      (vld_in),
  .hist_out    ({ hist_out_71,  
                  hist_out_70,  
                  hist_out_69,  
                  hist_out_68,  
                  hist_out_67,  
                  hist_out_66,  
                  hist_out_65,  
                  hist_out_64,  
                  hist_out_63,  
                  hist_out_62,
                  hist_out_61, 
                  hist_out_60, 
                  hist_out_59, 
                  hist_out_58, 
                  hist_out_57, 
                  hist_out_56, 
                  hist_out_55, 
                  hist_out_54, 
                  hist_out_53, 
                  hist_out_52,
                  hist_out_51, 
                  hist_out_50, 
                  hist_out_49, 
                  hist_out_48, 
                  hist_out_47, 
                  hist_out_46, 
                  hist_out_45, 
                  hist_out_44, 
                  hist_out_43, 
                  hist_out_42,
                  hist_out_41, 
                  hist_out_40, 
                  hist_out_39, 
                  hist_out_38, 
                  hist_out_37, 
                  hist_out_36, 
                  hist_out_35, 
                  hist_out_34, 
                  hist_out_33, 
                  hist_out_32,
                  hist_out_31, 
                  hist_out_30, 
                  hist_out_29, 
                  hist_out_28, 
                  hist_out_27, 
                  hist_out_26, 
                  hist_out_25, 
                  hist_out_24, 
                  hist_out_23, 
                  hist_out_22,
                  hist_out_21, 
                  hist_out_20, 
                  hist_out_19, 
                  hist_out_18, 
                  hist_out_17, 
                  hist_out_16, 
                  hist_out_15, 
                  hist_out_14, 
                  hist_out_13, 
                  hist_out_12,
                  hist_out_11, 
                  hist_out_10, 
                  hist_out_9 , 
                  hist_out_8 , 
                  hist_out_7 , 
                  hist_out_6 , 
                  hist_out_5 , 
                  hist_out_4 , 
                  hist_out_3 , 
                  hist_out_2 ,
                  hist_out_1 , 
                  hist_out_0   }), // [c_WRAP_HIST_BIN_WIDTH-1:0] hist_out [0:c_WRAP_HIST_BINS-1], // Output histogram
  .rdy_in      (rdy_in),
  .vld_out     (vld_out),
  .set_cnt_out (set_cnt_out) );


endmodule
