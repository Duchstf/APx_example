-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
-- Version: 2019.2
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity metalgo is
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
    output_stream_V_data_0_V_din : OUT STD_LOGIC_VECTOR (34 downto 0);
    output_stream_V_data_0_V_full_n : IN STD_LOGIC;
    output_stream_V_data_0_V_write : OUT STD_LOGIC;
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC );
end;


architecture behav of metalgo is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "metalgo,hls_ip_2019_2,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xcvu9p-flga2104-2L-e,HLS_INPUT_CLOCK=3.125000,HLS_INPUT_ARCH=dataflow,HLS_SYN_CLOCK=2.533000,HLS_SYN_LAT=130,HLS_SYN_TPT=130,HLS_SYN_MEM=4,HLS_SYN_DSP=74,HLS_SYN_FF=48023,HLS_SYN_LUT=83074,HLS_VERSION=2019_2}";
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv35_0 : STD_LOGIC_VECTOR (34 downto 0) := "00000000000000000000000000000000000";
    constant ap_const_logic_1 : STD_LOGIC := '1';

    signal met_U0_track_stream_V_data_0_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_1_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_2_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_3_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_4_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_5_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_6_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_7_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_8_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_9_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_10_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_11_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_12_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_13_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_14_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_15_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_16_V_read : STD_LOGIC;
    signal met_U0_track_stream_V_data_17_V_read : STD_LOGIC;
    signal met_U0_output_stream_V_data_V_din : STD_LOGIC_VECTOR (34 downto 0);
    signal met_U0_output_stream_V_data_V_write : STD_LOGIC;
    signal met_U0_ap_start : STD_LOGIC;
    signal met_U0_ap_done : STD_LOGIC;
    signal met_U0_ap_ready : STD_LOGIC;
    signal met_U0_ap_idle : STD_LOGIC;
    signal met_U0_ap_continue : STD_LOGIC;
    signal ap_sync_continue : STD_LOGIC;
    signal ap_sync_done : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal met_U0_start_full_n : STD_LOGIC;
    signal met_U0_start_write : STD_LOGIC;

    component met IS
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
        output_stream_V_data_V_din : OUT STD_LOGIC_VECTOR (34 downto 0);
        output_stream_V_data_V_full_n : IN STD_LOGIC;
        output_stream_V_data_V_write : OUT STD_LOGIC;
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC );
    end component;



begin
    met_U0 : component met
    port map (
        track_stream_V_data_0_V_dout => track_stream_V_data_0_V_dout,
        track_stream_V_data_0_V_empty_n => track_stream_V_data_0_V_empty_n,
        track_stream_V_data_0_V_read => met_U0_track_stream_V_data_0_V_read,
        track_stream_V_data_1_V_dout => track_stream_V_data_1_V_dout,
        track_stream_V_data_1_V_empty_n => track_stream_V_data_1_V_empty_n,
        track_stream_V_data_1_V_read => met_U0_track_stream_V_data_1_V_read,
        track_stream_V_data_2_V_dout => track_stream_V_data_2_V_dout,
        track_stream_V_data_2_V_empty_n => track_stream_V_data_2_V_empty_n,
        track_stream_V_data_2_V_read => met_U0_track_stream_V_data_2_V_read,
        track_stream_V_data_3_V_dout => track_stream_V_data_3_V_dout,
        track_stream_V_data_3_V_empty_n => track_stream_V_data_3_V_empty_n,
        track_stream_V_data_3_V_read => met_U0_track_stream_V_data_3_V_read,
        track_stream_V_data_4_V_dout => track_stream_V_data_4_V_dout,
        track_stream_V_data_4_V_empty_n => track_stream_V_data_4_V_empty_n,
        track_stream_V_data_4_V_read => met_U0_track_stream_V_data_4_V_read,
        track_stream_V_data_5_V_dout => track_stream_V_data_5_V_dout,
        track_stream_V_data_5_V_empty_n => track_stream_V_data_5_V_empty_n,
        track_stream_V_data_5_V_read => met_U0_track_stream_V_data_5_V_read,
        track_stream_V_data_6_V_dout => track_stream_V_data_6_V_dout,
        track_stream_V_data_6_V_empty_n => track_stream_V_data_6_V_empty_n,
        track_stream_V_data_6_V_read => met_U0_track_stream_V_data_6_V_read,
        track_stream_V_data_7_V_dout => track_stream_V_data_7_V_dout,
        track_stream_V_data_7_V_empty_n => track_stream_V_data_7_V_empty_n,
        track_stream_V_data_7_V_read => met_U0_track_stream_V_data_7_V_read,
        track_stream_V_data_8_V_dout => track_stream_V_data_8_V_dout,
        track_stream_V_data_8_V_empty_n => track_stream_V_data_8_V_empty_n,
        track_stream_V_data_8_V_read => met_U0_track_stream_V_data_8_V_read,
        track_stream_V_data_9_V_dout => track_stream_V_data_9_V_dout,
        track_stream_V_data_9_V_empty_n => track_stream_V_data_9_V_empty_n,
        track_stream_V_data_9_V_read => met_U0_track_stream_V_data_9_V_read,
        track_stream_V_data_10_V_dout => track_stream_V_data_10_V_dout,
        track_stream_V_data_10_V_empty_n => track_stream_V_data_10_V_empty_n,
        track_stream_V_data_10_V_read => met_U0_track_stream_V_data_10_V_read,
        track_stream_V_data_11_V_dout => track_stream_V_data_11_V_dout,
        track_stream_V_data_11_V_empty_n => track_stream_V_data_11_V_empty_n,
        track_stream_V_data_11_V_read => met_U0_track_stream_V_data_11_V_read,
        track_stream_V_data_12_V_dout => track_stream_V_data_12_V_dout,
        track_stream_V_data_12_V_empty_n => track_stream_V_data_12_V_empty_n,
        track_stream_V_data_12_V_read => met_U0_track_stream_V_data_12_V_read,
        track_stream_V_data_13_V_dout => track_stream_V_data_13_V_dout,
        track_stream_V_data_13_V_empty_n => track_stream_V_data_13_V_empty_n,
        track_stream_V_data_13_V_read => met_U0_track_stream_V_data_13_V_read,
        track_stream_V_data_14_V_dout => track_stream_V_data_14_V_dout,
        track_stream_V_data_14_V_empty_n => track_stream_V_data_14_V_empty_n,
        track_stream_V_data_14_V_read => met_U0_track_stream_V_data_14_V_read,
        track_stream_V_data_15_V_dout => track_stream_V_data_15_V_dout,
        track_stream_V_data_15_V_empty_n => track_stream_V_data_15_V_empty_n,
        track_stream_V_data_15_V_read => met_U0_track_stream_V_data_15_V_read,
        track_stream_V_data_16_V_dout => track_stream_V_data_16_V_dout,
        track_stream_V_data_16_V_empty_n => track_stream_V_data_16_V_empty_n,
        track_stream_V_data_16_V_read => met_U0_track_stream_V_data_16_V_read,
        track_stream_V_data_17_V_dout => track_stream_V_data_17_V_dout,
        track_stream_V_data_17_V_empty_n => track_stream_V_data_17_V_empty_n,
        track_stream_V_data_17_V_read => met_U0_track_stream_V_data_17_V_read,
        output_stream_V_data_V_din => met_U0_output_stream_V_data_V_din,
        output_stream_V_data_V_full_n => output_stream_V_data_0_V_full_n,
        output_stream_V_data_V_write => met_U0_output_stream_V_data_V_write,
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => met_U0_ap_start,
        ap_done => met_U0_ap_done,
        ap_ready => met_U0_ap_ready,
        ap_idle => met_U0_ap_idle,
        ap_continue => met_U0_ap_continue);




    ap_done <= met_U0_ap_done;
    ap_idle <= met_U0_ap_idle;
    ap_ready <= met_U0_ap_ready;
    ap_sync_continue <= ap_const_logic_1;
    ap_sync_done <= met_U0_ap_done;
    ap_sync_ready <= met_U0_ap_ready;
    met_U0_ap_continue <= ap_const_logic_1;
    met_U0_ap_start <= ap_start;
    met_U0_start_full_n <= ap_const_logic_1;
    met_U0_start_write <= ap_const_logic_0;
    output_stream_V_data_0_V_din <= met_U0_output_stream_V_data_V_din;
    output_stream_V_data_0_V_write <= met_U0_output_stream_V_data_V_write;
    track_stream_V_data_0_V_read <= met_U0_track_stream_V_data_0_V_read;
    track_stream_V_data_10_V_read <= met_U0_track_stream_V_data_10_V_read;
    track_stream_V_data_11_V_read <= met_U0_track_stream_V_data_11_V_read;
    track_stream_V_data_12_V_read <= met_U0_track_stream_V_data_12_V_read;
    track_stream_V_data_13_V_read <= met_U0_track_stream_V_data_13_V_read;
    track_stream_V_data_14_V_read <= met_U0_track_stream_V_data_14_V_read;
    track_stream_V_data_15_V_read <= met_U0_track_stream_V_data_15_V_read;
    track_stream_V_data_16_V_read <= met_U0_track_stream_V_data_16_V_read;
    track_stream_V_data_17_V_read <= met_U0_track_stream_V_data_17_V_read;
    track_stream_V_data_1_V_read <= met_U0_track_stream_V_data_1_V_read;
    track_stream_V_data_2_V_read <= met_U0_track_stream_V_data_2_V_read;
    track_stream_V_data_3_V_read <= met_U0_track_stream_V_data_3_V_read;
    track_stream_V_data_4_V_read <= met_U0_track_stream_V_data_4_V_read;
    track_stream_V_data_5_V_read <= met_U0_track_stream_V_data_5_V_read;
    track_stream_V_data_6_V_read <= met_U0_track_stream_V_data_6_V_read;
    track_stream_V_data_7_V_read <= met_U0_track_stream_V_data_7_V_read;
    track_stream_V_data_8_V_read <= met_U0_track_stream_V_data_8_V_read;
    track_stream_V_data_9_V_read <= met_U0_track_stream_V_data_9_V_read;
end behav;