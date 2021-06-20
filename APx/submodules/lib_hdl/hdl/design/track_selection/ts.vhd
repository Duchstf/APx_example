-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
-- Version: 2019.2
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ts is
port (
    input_stream_V_data_0_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_0_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_0_V_read : OUT STD_LOGIC;
    input_stream_V_data_1_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_1_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_1_V_read : OUT STD_LOGIC;
    input_stream_V_data_2_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_2_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_2_V_read : OUT STD_LOGIC;
    input_stream_V_data_3_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_3_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_3_V_read : OUT STD_LOGIC;
    input_stream_V_data_4_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_4_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_4_V_read : OUT STD_LOGIC;
    input_stream_V_data_5_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_5_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_5_V_read : OUT STD_LOGIC;
    input_stream_V_data_6_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_6_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_6_V_read : OUT STD_LOGIC;
    input_stream_V_data_7_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_7_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_7_V_read : OUT STD_LOGIC;
    input_stream_V_data_8_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_8_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_8_V_read : OUT STD_LOGIC;
    input_stream_V_data_9_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_9_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_9_V_read : OUT STD_LOGIC;
    input_stream_V_data_10_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_10_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_10_V_read : OUT STD_LOGIC;
    input_stream_V_data_11_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_11_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_11_V_read : OUT STD_LOGIC;
    input_stream_V_data_12_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_12_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_12_V_read : OUT STD_LOGIC;
    input_stream_V_data_13_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_13_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_13_V_read : OUT STD_LOGIC;
    input_stream_V_data_14_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_14_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_14_V_read : OUT STD_LOGIC;
    input_stream_V_data_15_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_15_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_15_V_read : OUT STD_LOGIC;
    input_stream_V_data_16_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_16_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_16_V_read : OUT STD_LOGIC;
    input_stream_V_data_17_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
    input_stream_V_data_17_V_empty_n : IN STD_LOGIC;
    input_stream_V_data_17_V_read : OUT STD_LOGIC;
    VerZPos_V_data_0_V_dout : IN STD_LOGIC_VECTOR (11 downto 0);
    VerZPos_V_data_0_V_empty_n : IN STD_LOGIC;
    VerZPos_V_data_0_V_read : OUT STD_LOGIC;
    output_stream_V_data_0_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_1_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_2_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_3_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_4_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_5_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_6_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_7_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_8_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_9_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_10_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_11_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_12_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_13_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_14_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_15_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_16_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    output_stream_V_data_17_V : OUT STD_LOGIC_VECTOR (95 downto 0);
    selTracksCounter_V : OUT STD_LOGIC_VECTOR (10 downto 0);
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    output_stream_V_data_0_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_0_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_1_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_1_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_2_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_2_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_3_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_3_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_4_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_4_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_5_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_5_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_6_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_6_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_7_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_7_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_8_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_8_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_9_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_9_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_10_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_10_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_11_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_11_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_12_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_12_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_13_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_13_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_14_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_14_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_15_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_15_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_16_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_16_V_ap_ack : IN STD_LOGIC;
    output_stream_V_data_17_V_ap_vld : OUT STD_LOGIC;
    output_stream_V_data_17_V_ap_ack : IN STD_LOGIC;
    selTracksCounter_V_ap_vld : OUT STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC );
end;


architecture behav of ts is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "ts,hls_ip_2019_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=1,HLS_INPUT_PART=xcvu9p-flga2104-2L-e,HLS_INPUT_CLOCK=3.125000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=1.577500,HLS_SYN_LAT=102,HLS_SYN_TPT=103,HLS_SYN_MEM=54,HLS_SYN_DSP=0,HLS_SYN_FF=2638,HLS_SYN_LUT=5999,HLS_VERSION=2019_2}";
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv96_0 : STD_LOGIC_VECTOR (95 downto 0) := "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    constant ap_const_lv11_0 : STD_LOGIC_VECTOR (10 downto 0) := "00000000000";
    constant ap_const_logic_1 : STD_LOGIC := '1';

    signal trackSelection_U0_track_stream_V_data_0_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_1_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_2_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_3_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_4_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_5_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_6_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_7_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_8_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_9_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_10_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_11_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_12_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_13_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_14_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_15_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_16_V_read : STD_LOGIC;
    signal trackSelection_U0_track_stream_V_data_17_V_read : STD_LOGIC;
    signal trackSelection_U0_VerZPos_V_data_V_read : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_0_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_1_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_2_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_3_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_4_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_5_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_6_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_7_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_8_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_9_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_10_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_11_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_12_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_13_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_14_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_15_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_16_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTrackStream_V_data_17_V : STD_LOGIC_VECTOR (95 downto 0);
    signal trackSelection_U0_selTracksCounter_V : STD_LOGIC_VECTOR (10 downto 0);
    signal trackSelection_U0_ap_start : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_0_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_1_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_2_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_3_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_4_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_5_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_6_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_7_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_8_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_9_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_10_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_11_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_12_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_13_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_14_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_15_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_16_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTrackStream_V_data_17_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_selTracksCounter_V_ap_vld : STD_LOGIC;
    signal trackSelection_U0_ap_done : STD_LOGIC;
    signal trackSelection_U0_ap_ready : STD_LOGIC;
    signal trackSelection_U0_ap_idle : STD_LOGIC;
    signal trackSelection_U0_ap_continue : STD_LOGIC;
    signal ap_sync_continue : STD_LOGIC;
    signal ap_sync_done : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal trackSelection_U0_start_full_n : STD_LOGIC;
    signal trackSelection_U0_start_write : STD_LOGIC;

    component trackSelection IS
    port (
        track_stream_V_data_0_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_0_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_0_V_read : OUT STD_LOGIC;
        track_stream_V_data_1_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_1_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_1_V_read : OUT STD_LOGIC;
        track_stream_V_data_2_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_2_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_2_V_read : OUT STD_LOGIC;
        track_stream_V_data_3_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_3_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_3_V_read : OUT STD_LOGIC;
        track_stream_V_data_4_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_4_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_4_V_read : OUT STD_LOGIC;
        track_stream_V_data_5_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_5_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_5_V_read : OUT STD_LOGIC;
        track_stream_V_data_6_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_6_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_6_V_read : OUT STD_LOGIC;
        track_stream_V_data_7_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_7_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_7_V_read : OUT STD_LOGIC;
        track_stream_V_data_8_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_8_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_8_V_read : OUT STD_LOGIC;
        track_stream_V_data_9_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_9_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_9_V_read : OUT STD_LOGIC;
        track_stream_V_data_10_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_10_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_10_V_read : OUT STD_LOGIC;
        track_stream_V_data_11_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_11_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_11_V_read : OUT STD_LOGIC;
        track_stream_V_data_12_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_12_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_12_V_read : OUT STD_LOGIC;
        track_stream_V_data_13_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_13_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_13_V_read : OUT STD_LOGIC;
        track_stream_V_data_14_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_14_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_14_V_read : OUT STD_LOGIC;
        track_stream_V_data_15_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_15_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_15_V_read : OUT STD_LOGIC;
        track_stream_V_data_16_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_16_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_16_V_read : OUT STD_LOGIC;
        track_stream_V_data_17_V_dout : IN STD_LOGIC_VECTOR (95 downto 0);
        track_stream_V_data_17_V_empty_n : IN STD_LOGIC;
        track_stream_V_data_17_V_read : OUT STD_LOGIC;
        VerZPos_V_data_V_dout : IN STD_LOGIC_VECTOR (11 downto 0);
        VerZPos_V_data_V_empty_n : IN STD_LOGIC;
        VerZPos_V_data_V_read : OUT STD_LOGIC;
        selTrackStream_V_data_0_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_1_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_2_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_3_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_4_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_5_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_6_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_7_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_8_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_9_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_10_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_11_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_12_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_13_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_14_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_15_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_16_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTrackStream_V_data_17_V : OUT STD_LOGIC_VECTOR (95 downto 0);
        selTracksCounter_V : OUT STD_LOGIC_VECTOR (10 downto 0);
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        selTrackStream_V_data_0_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_0_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_1_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_1_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_2_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_2_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_3_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_3_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_4_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_4_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_5_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_5_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_6_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_6_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_7_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_7_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_8_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_8_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_9_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_9_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_10_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_10_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_11_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_11_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_12_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_12_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_13_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_13_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_14_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_14_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_15_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_15_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_16_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_16_V_ap_ack : IN STD_LOGIC;
        selTrackStream_V_data_17_V_ap_vld : OUT STD_LOGIC;
        selTrackStream_V_data_17_V_ap_ack : IN STD_LOGIC;
        selTracksCounter_V_ap_vld : OUT STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC );
    end component;



begin
    trackSelection_U0 : component trackSelection
    port map (
        track_stream_V_data_0_V_dout => input_stream_V_data_0_V_dout,
        track_stream_V_data_0_V_empty_n => input_stream_V_data_0_V_empty_n,
        track_stream_V_data_0_V_read => trackSelection_U0_track_stream_V_data_0_V_read,
        track_stream_V_data_1_V_dout => input_stream_V_data_1_V_dout,
        track_stream_V_data_1_V_empty_n => input_stream_V_data_1_V_empty_n,
        track_stream_V_data_1_V_read => trackSelection_U0_track_stream_V_data_1_V_read,
        track_stream_V_data_2_V_dout => input_stream_V_data_2_V_dout,
        track_stream_V_data_2_V_empty_n => input_stream_V_data_2_V_empty_n,
        track_stream_V_data_2_V_read => trackSelection_U0_track_stream_V_data_2_V_read,
        track_stream_V_data_3_V_dout => input_stream_V_data_3_V_dout,
        track_stream_V_data_3_V_empty_n => input_stream_V_data_3_V_empty_n,
        track_stream_V_data_3_V_read => trackSelection_U0_track_stream_V_data_3_V_read,
        track_stream_V_data_4_V_dout => input_stream_V_data_4_V_dout,
        track_stream_V_data_4_V_empty_n => input_stream_V_data_4_V_empty_n,
        track_stream_V_data_4_V_read => trackSelection_U0_track_stream_V_data_4_V_read,
        track_stream_V_data_5_V_dout => input_stream_V_data_5_V_dout,
        track_stream_V_data_5_V_empty_n => input_stream_V_data_5_V_empty_n,
        track_stream_V_data_5_V_read => trackSelection_U0_track_stream_V_data_5_V_read,
        track_stream_V_data_6_V_dout => input_stream_V_data_6_V_dout,
        track_stream_V_data_6_V_empty_n => input_stream_V_data_6_V_empty_n,
        track_stream_V_data_6_V_read => trackSelection_U0_track_stream_V_data_6_V_read,
        track_stream_V_data_7_V_dout => input_stream_V_data_7_V_dout,
        track_stream_V_data_7_V_empty_n => input_stream_V_data_7_V_empty_n,
        track_stream_V_data_7_V_read => trackSelection_U0_track_stream_V_data_7_V_read,
        track_stream_V_data_8_V_dout => input_stream_V_data_8_V_dout,
        track_stream_V_data_8_V_empty_n => input_stream_V_data_8_V_empty_n,
        track_stream_V_data_8_V_read => trackSelection_U0_track_stream_V_data_8_V_read,
        track_stream_V_data_9_V_dout => input_stream_V_data_9_V_dout,
        track_stream_V_data_9_V_empty_n => input_stream_V_data_9_V_empty_n,
        track_stream_V_data_9_V_read => trackSelection_U0_track_stream_V_data_9_V_read,
        track_stream_V_data_10_V_dout => input_stream_V_data_10_V_dout,
        track_stream_V_data_10_V_empty_n => input_stream_V_data_10_V_empty_n,
        track_stream_V_data_10_V_read => trackSelection_U0_track_stream_V_data_10_V_read,
        track_stream_V_data_11_V_dout => input_stream_V_data_11_V_dout,
        track_stream_V_data_11_V_empty_n => input_stream_V_data_11_V_empty_n,
        track_stream_V_data_11_V_read => trackSelection_U0_track_stream_V_data_11_V_read,
        track_stream_V_data_12_V_dout => input_stream_V_data_12_V_dout,
        track_stream_V_data_12_V_empty_n => input_stream_V_data_12_V_empty_n,
        track_stream_V_data_12_V_read => trackSelection_U0_track_stream_V_data_12_V_read,
        track_stream_V_data_13_V_dout => input_stream_V_data_13_V_dout,
        track_stream_V_data_13_V_empty_n => input_stream_V_data_13_V_empty_n,
        track_stream_V_data_13_V_read => trackSelection_U0_track_stream_V_data_13_V_read,
        track_stream_V_data_14_V_dout => input_stream_V_data_14_V_dout,
        track_stream_V_data_14_V_empty_n => input_stream_V_data_14_V_empty_n,
        track_stream_V_data_14_V_read => trackSelection_U0_track_stream_V_data_14_V_read,
        track_stream_V_data_15_V_dout => input_stream_V_data_15_V_dout,
        track_stream_V_data_15_V_empty_n => input_stream_V_data_15_V_empty_n,
        track_stream_V_data_15_V_read => trackSelection_U0_track_stream_V_data_15_V_read,
        track_stream_V_data_16_V_dout => input_stream_V_data_16_V_dout,
        track_stream_V_data_16_V_empty_n => input_stream_V_data_16_V_empty_n,
        track_stream_V_data_16_V_read => trackSelection_U0_track_stream_V_data_16_V_read,
        track_stream_V_data_17_V_dout => input_stream_V_data_17_V_dout,
        track_stream_V_data_17_V_empty_n => input_stream_V_data_17_V_empty_n,
        track_stream_V_data_17_V_read => trackSelection_U0_track_stream_V_data_17_V_read,
        VerZPos_V_data_V_dout => VerZPos_V_data_0_V_dout,
        VerZPos_V_data_V_empty_n => VerZPos_V_data_0_V_empty_n,
        VerZPos_V_data_V_read => trackSelection_U0_VerZPos_V_data_V_read,
        selTrackStream_V_data_0_V => trackSelection_U0_selTrackStream_V_data_0_V,
        selTrackStream_V_data_1_V => trackSelection_U0_selTrackStream_V_data_1_V,
        selTrackStream_V_data_2_V => trackSelection_U0_selTrackStream_V_data_2_V,
        selTrackStream_V_data_3_V => trackSelection_U0_selTrackStream_V_data_3_V,
        selTrackStream_V_data_4_V => trackSelection_U0_selTrackStream_V_data_4_V,
        selTrackStream_V_data_5_V => trackSelection_U0_selTrackStream_V_data_5_V,
        selTrackStream_V_data_6_V => trackSelection_U0_selTrackStream_V_data_6_V,
        selTrackStream_V_data_7_V => trackSelection_U0_selTrackStream_V_data_7_V,
        selTrackStream_V_data_8_V => trackSelection_U0_selTrackStream_V_data_8_V,
        selTrackStream_V_data_9_V => trackSelection_U0_selTrackStream_V_data_9_V,
        selTrackStream_V_data_10_V => trackSelection_U0_selTrackStream_V_data_10_V,
        selTrackStream_V_data_11_V => trackSelection_U0_selTrackStream_V_data_11_V,
        selTrackStream_V_data_12_V => trackSelection_U0_selTrackStream_V_data_12_V,
        selTrackStream_V_data_13_V => trackSelection_U0_selTrackStream_V_data_13_V,
        selTrackStream_V_data_14_V => trackSelection_U0_selTrackStream_V_data_14_V,
        selTrackStream_V_data_15_V => trackSelection_U0_selTrackStream_V_data_15_V,
        selTrackStream_V_data_16_V => trackSelection_U0_selTrackStream_V_data_16_V,
        selTrackStream_V_data_17_V => trackSelection_U0_selTrackStream_V_data_17_V,
        selTracksCounter_V => trackSelection_U0_selTracksCounter_V,
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => trackSelection_U0_ap_start,
        selTrackStream_V_data_0_V_ap_vld => trackSelection_U0_selTrackStream_V_data_0_V_ap_vld,
        selTrackStream_V_data_0_V_ap_ack => output_stream_V_data_0_V_ap_ack,
        selTrackStream_V_data_1_V_ap_vld => trackSelection_U0_selTrackStream_V_data_1_V_ap_vld,
        selTrackStream_V_data_1_V_ap_ack => output_stream_V_data_1_V_ap_ack,
        selTrackStream_V_data_2_V_ap_vld => trackSelection_U0_selTrackStream_V_data_2_V_ap_vld,
        selTrackStream_V_data_2_V_ap_ack => output_stream_V_data_2_V_ap_ack,
        selTrackStream_V_data_3_V_ap_vld => trackSelection_U0_selTrackStream_V_data_3_V_ap_vld,
        selTrackStream_V_data_3_V_ap_ack => output_stream_V_data_3_V_ap_ack,
        selTrackStream_V_data_4_V_ap_vld => trackSelection_U0_selTrackStream_V_data_4_V_ap_vld,
        selTrackStream_V_data_4_V_ap_ack => output_stream_V_data_4_V_ap_ack,
        selTrackStream_V_data_5_V_ap_vld => trackSelection_U0_selTrackStream_V_data_5_V_ap_vld,
        selTrackStream_V_data_5_V_ap_ack => output_stream_V_data_5_V_ap_ack,
        selTrackStream_V_data_6_V_ap_vld => trackSelection_U0_selTrackStream_V_data_6_V_ap_vld,
        selTrackStream_V_data_6_V_ap_ack => output_stream_V_data_6_V_ap_ack,
        selTrackStream_V_data_7_V_ap_vld => trackSelection_U0_selTrackStream_V_data_7_V_ap_vld,
        selTrackStream_V_data_7_V_ap_ack => output_stream_V_data_7_V_ap_ack,
        selTrackStream_V_data_8_V_ap_vld => trackSelection_U0_selTrackStream_V_data_8_V_ap_vld,
        selTrackStream_V_data_8_V_ap_ack => output_stream_V_data_8_V_ap_ack,
        selTrackStream_V_data_9_V_ap_vld => trackSelection_U0_selTrackStream_V_data_9_V_ap_vld,
        selTrackStream_V_data_9_V_ap_ack => output_stream_V_data_9_V_ap_ack,
        selTrackStream_V_data_10_V_ap_vld => trackSelection_U0_selTrackStream_V_data_10_V_ap_vld,
        selTrackStream_V_data_10_V_ap_ack => output_stream_V_data_10_V_ap_ack,
        selTrackStream_V_data_11_V_ap_vld => trackSelection_U0_selTrackStream_V_data_11_V_ap_vld,
        selTrackStream_V_data_11_V_ap_ack => output_stream_V_data_11_V_ap_ack,
        selTrackStream_V_data_12_V_ap_vld => trackSelection_U0_selTrackStream_V_data_12_V_ap_vld,
        selTrackStream_V_data_12_V_ap_ack => output_stream_V_data_12_V_ap_ack,
        selTrackStream_V_data_13_V_ap_vld => trackSelection_U0_selTrackStream_V_data_13_V_ap_vld,
        selTrackStream_V_data_13_V_ap_ack => output_stream_V_data_13_V_ap_ack,
        selTrackStream_V_data_14_V_ap_vld => trackSelection_U0_selTrackStream_V_data_14_V_ap_vld,
        selTrackStream_V_data_14_V_ap_ack => output_stream_V_data_14_V_ap_ack,
        selTrackStream_V_data_15_V_ap_vld => trackSelection_U0_selTrackStream_V_data_15_V_ap_vld,
        selTrackStream_V_data_15_V_ap_ack => output_stream_V_data_15_V_ap_ack,
        selTrackStream_V_data_16_V_ap_vld => trackSelection_U0_selTrackStream_V_data_16_V_ap_vld,
        selTrackStream_V_data_16_V_ap_ack => output_stream_V_data_16_V_ap_ack,
        selTrackStream_V_data_17_V_ap_vld => trackSelection_U0_selTrackStream_V_data_17_V_ap_vld,
        selTrackStream_V_data_17_V_ap_ack => output_stream_V_data_17_V_ap_ack,
        selTracksCounter_V_ap_vld => trackSelection_U0_selTracksCounter_V_ap_vld,
        ap_done => trackSelection_U0_ap_done,
        ap_ready => trackSelection_U0_ap_ready,
        ap_idle => trackSelection_U0_ap_idle,
        ap_continue => trackSelection_U0_ap_continue);




    VerZPos_V_data_0_V_read <= trackSelection_U0_VerZPos_V_data_V_read;
    ap_done <= trackSelection_U0_ap_done;
    ap_idle <= trackSelection_U0_ap_idle;
    ap_ready <= trackSelection_U0_ap_ready;
    ap_sync_continue <= ap_const_logic_1;
    ap_sync_done <= trackSelection_U0_ap_done;
    ap_sync_ready <= trackSelection_U0_ap_ready;
    input_stream_V_data_0_V_read <= trackSelection_U0_track_stream_V_data_0_V_read;
    input_stream_V_data_10_V_read <= trackSelection_U0_track_stream_V_data_10_V_read;
    input_stream_V_data_11_V_read <= trackSelection_U0_track_stream_V_data_11_V_read;
    input_stream_V_data_12_V_read <= trackSelection_U0_track_stream_V_data_12_V_read;
    input_stream_V_data_13_V_read <= trackSelection_U0_track_stream_V_data_13_V_read;
    input_stream_V_data_14_V_read <= trackSelection_U0_track_stream_V_data_14_V_read;
    input_stream_V_data_15_V_read <= trackSelection_U0_track_stream_V_data_15_V_read;
    input_stream_V_data_16_V_read <= trackSelection_U0_track_stream_V_data_16_V_read;
    input_stream_V_data_17_V_read <= trackSelection_U0_track_stream_V_data_17_V_read;
    input_stream_V_data_1_V_read <= trackSelection_U0_track_stream_V_data_1_V_read;
    input_stream_V_data_2_V_read <= trackSelection_U0_track_stream_V_data_2_V_read;
    input_stream_V_data_3_V_read <= trackSelection_U0_track_stream_V_data_3_V_read;
    input_stream_V_data_4_V_read <= trackSelection_U0_track_stream_V_data_4_V_read;
    input_stream_V_data_5_V_read <= trackSelection_U0_track_stream_V_data_5_V_read;
    input_stream_V_data_6_V_read <= trackSelection_U0_track_stream_V_data_6_V_read;
    input_stream_V_data_7_V_read <= trackSelection_U0_track_stream_V_data_7_V_read;
    input_stream_V_data_8_V_read <= trackSelection_U0_track_stream_V_data_8_V_read;
    input_stream_V_data_9_V_read <= trackSelection_U0_track_stream_V_data_9_V_read;
    output_stream_V_data_0_V <= trackSelection_U0_selTrackStream_V_data_0_V;
    output_stream_V_data_0_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_0_V_ap_vld;
    output_stream_V_data_10_V <= trackSelection_U0_selTrackStream_V_data_10_V;
    output_stream_V_data_10_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_10_V_ap_vld;
    output_stream_V_data_11_V <= trackSelection_U0_selTrackStream_V_data_11_V;
    output_stream_V_data_11_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_11_V_ap_vld;
    output_stream_V_data_12_V <= trackSelection_U0_selTrackStream_V_data_12_V;
    output_stream_V_data_12_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_12_V_ap_vld;
    output_stream_V_data_13_V <= trackSelection_U0_selTrackStream_V_data_13_V;
    output_stream_V_data_13_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_13_V_ap_vld;
    output_stream_V_data_14_V <= trackSelection_U0_selTrackStream_V_data_14_V;
    output_stream_V_data_14_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_14_V_ap_vld;
    output_stream_V_data_15_V <= trackSelection_U0_selTrackStream_V_data_15_V;
    output_stream_V_data_15_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_15_V_ap_vld;
    output_stream_V_data_16_V <= trackSelection_U0_selTrackStream_V_data_16_V;
    output_stream_V_data_16_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_16_V_ap_vld;
    output_stream_V_data_17_V <= trackSelection_U0_selTrackStream_V_data_17_V;
    output_stream_V_data_17_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_17_V_ap_vld;
    output_stream_V_data_1_V <= trackSelection_U0_selTrackStream_V_data_1_V;
    output_stream_V_data_1_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_1_V_ap_vld;
    output_stream_V_data_2_V <= trackSelection_U0_selTrackStream_V_data_2_V;
    output_stream_V_data_2_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_2_V_ap_vld;
    output_stream_V_data_3_V <= trackSelection_U0_selTrackStream_V_data_3_V;
    output_stream_V_data_3_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_3_V_ap_vld;
    output_stream_V_data_4_V <= trackSelection_U0_selTrackStream_V_data_4_V;
    output_stream_V_data_4_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_4_V_ap_vld;
    output_stream_V_data_5_V <= trackSelection_U0_selTrackStream_V_data_5_V;
    output_stream_V_data_5_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_5_V_ap_vld;
    output_stream_V_data_6_V <= trackSelection_U0_selTrackStream_V_data_6_V;
    output_stream_V_data_6_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_6_V_ap_vld;
    output_stream_V_data_7_V <= trackSelection_U0_selTrackStream_V_data_7_V;
    output_stream_V_data_7_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_7_V_ap_vld;
    output_stream_V_data_8_V <= trackSelection_U0_selTrackStream_V_data_8_V;
    output_stream_V_data_8_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_8_V_ap_vld;
    output_stream_V_data_9_V <= trackSelection_U0_selTrackStream_V_data_9_V;
    output_stream_V_data_9_V_ap_vld <= trackSelection_U0_selTrackStream_V_data_9_V_ap_vld;
    selTracksCounter_V <= trackSelection_U0_selTracksCounter_V;
    selTracksCounter_V_ap_vld <= trackSelection_U0_selTracksCounter_V_ap_vld;
    trackSelection_U0_ap_continue <= ap_const_logic_1;
    trackSelection_U0_ap_start <= ap_start;
    trackSelection_U0_start_full_n <= ap_const_logic_1;
    trackSelection_U0_start_write <= ap_const_logic_0;
end behav;
