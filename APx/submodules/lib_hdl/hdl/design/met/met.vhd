-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and OpenCL
-- Version: 2019.2
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity met is
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
end;


architecture behav of met is 
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_const_lv35_0 : STD_LOGIC_VECTOR (34 downto 0) := "00000000000000000000000000000000000";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_lv2_0 : STD_LOGIC_VECTOR (1 downto 0) := "00";
    constant ap_const_lv2_1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal met_Block_ZN8ap_fix_U0_ap_start : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_ap_done : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_ap_continue : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_ap_idle : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_ap_ready : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_Px_V_out_din : STD_LOGIC_VECTOR (0 downto 0);
    signal met_Block_ZN8ap_fix_U0_Px_V_out_write : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_Py_V_out_din : STD_LOGIC_VECTOR (0 downto 0);
    signal met_Block_ZN8ap_fix_U0_Py_V_out_write : STD_LOGIC;
    signal addTracks_U0_ap_start : STD_LOGIC;
    signal addTracks_U0_ap_done : STD_LOGIC;
    signal addTracks_U0_ap_continue : STD_LOGIC;
    signal addTracks_U0_ap_idle : STD_LOGIC;
    signal addTracks_U0_ap_ready : STD_LOGIC;
    signal addTracks_U0_start_out : STD_LOGIC;
    signal addTracks_U0_start_write : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_0_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_1_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_2_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_3_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_4_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_5_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_6_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_7_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_8_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_9_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_10_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_11_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_12_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_13_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_14_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_15_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_16_V_read : STD_LOGIC;
    signal addTracks_U0_track_stream_V_data_17_V_read : STD_LOGIC;
    signal addTracks_U0_Px_V_read : STD_LOGIC;
    signal addTracks_U0_Py_V_read : STD_LOGIC;
    signal addTracks_U0_Px_V_out_din : STD_LOGIC_VECTOR (18 downto 0);
    signal addTracks_U0_Px_V_out_write : STD_LOGIC;
    signal addTracks_U0_Py_V_out_din : STD_LOGIC_VECTOR (18 downto 0);
    signal addTracks_U0_Py_V_out_write : STD_LOGIC;
    signal getMET_U0_ap_start : STD_LOGIC;
    signal getMET_U0_ap_done : STD_LOGIC;
    signal getMET_U0_ap_continue : STD_LOGIC;
    signal getMET_U0_ap_idle : STD_LOGIC;
    signal getMET_U0_ap_ready : STD_LOGIC;
    signal getMET_U0_Px_V_read : STD_LOGIC;
    signal getMET_U0_Py_V_read : STD_LOGIC;
    signal getMET_U0_ap_return_0 : STD_LOGIC_VECTOR (16 downto 0);
    signal getMET_U0_ap_return_1 : STD_LOGIC_VECTOR (17 downto 0);
    signal ap_channel_done_metPhi_V : STD_LOGIC;
    signal metPhi_V_full_n : STD_LOGIC;
    signal ap_sync_reg_channel_write_metPhi_V : STD_LOGIC := '0';
    signal ap_sync_channel_write_metPhi_V : STD_LOGIC;
    signal ap_channel_done_metPt_V : STD_LOGIC;
    signal metPt_V_full_n : STD_LOGIC;
    signal ap_sync_reg_channel_write_metPt_V : STD_LOGIC := '0';
    signal ap_sync_channel_write_metPt_V : STD_LOGIC;
    signal packMET_U0_ap_start : STD_LOGIC;
    signal packMET_U0_ap_done : STD_LOGIC;
    signal packMET_U0_ap_continue : STD_LOGIC;
    signal packMET_U0_ap_idle : STD_LOGIC;
    signal packMET_U0_ap_ready : STD_LOGIC;
    signal packMET_U0_output_stream_V_data_V_din : STD_LOGIC_VECTOR (34 downto 0);
    signal packMET_U0_output_stream_V_data_V_write : STD_LOGIC;
    signal ap_sync_continue : STD_LOGIC;
    signal Px_V_c_full_n : STD_LOGIC;
    signal Px_V_c_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal Px_V_c_empty_n : STD_LOGIC;
    signal Py_V_c_full_n : STD_LOGIC;
    signal Py_V_c_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal Py_V_c_empty_n : STD_LOGIC;
    signal Px_V_c32_full_n : STD_LOGIC;
    signal Px_V_c32_dout : STD_LOGIC_VECTOR (18 downto 0);
    signal Px_V_c32_empty_n : STD_LOGIC;
    signal Py_V_c33_full_n : STD_LOGIC;
    signal Py_V_c33_dout : STD_LOGIC_VECTOR (18 downto 0);
    signal Py_V_c33_empty_n : STD_LOGIC;
    signal metPt_V_dout : STD_LOGIC_VECTOR (16 downto 0);
    signal metPt_V_empty_n : STD_LOGIC;
    signal metPhi_V_dout : STD_LOGIC_VECTOR (17 downto 0);
    signal metPhi_V_empty_n : STD_LOGIC;
    signal ap_sync_done : STD_LOGIC;
    signal ap_sync_ready : STD_LOGIC;
    signal ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready : STD_LOGIC := '0';
    signal ap_sync_met_Block_ZN8ap_fix_U0_ap_ready : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_ap_ready_count : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal ap_sync_reg_addTracks_U0_ap_ready : STD_LOGIC := '0';
    signal ap_sync_addTracks_U0_ap_ready : STD_LOGIC;
    signal addTracks_U0_ap_ready_count : STD_LOGIC_VECTOR (1 downto 0) := "00";
    signal met_Block_ZN8ap_fix_U0_start_full_n : STD_LOGIC;
    signal met_Block_ZN8ap_fix_U0_start_write : STD_LOGIC;
    signal start_for_getMET_U0_din : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_getMET_U0_full_n : STD_LOGIC;
    signal start_for_getMET_U0_dout : STD_LOGIC_VECTOR (0 downto 0);
    signal start_for_getMET_U0_empty_n : STD_LOGIC;
    signal getMET_U0_start_full_n : STD_LOGIC;
    signal getMET_U0_start_write : STD_LOGIC;
    signal packMET_U0_start_full_n : STD_LOGIC;
    signal packMET_U0_start_write : STD_LOGIC;

    component met_Block_ZN8ap_fix IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        Px_V_out_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        Px_V_out_full_n : IN STD_LOGIC;
        Px_V_out_write : OUT STD_LOGIC;
        Py_V_out_din : OUT STD_LOGIC_VECTOR (0 downto 0);
        Py_V_out_full_n : IN STD_LOGIC;
        Py_V_out_write : OUT STD_LOGIC );
    end component;


    component addTracks IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        start_full_n : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        start_out : OUT STD_LOGIC;
        start_write : OUT STD_LOGIC;
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
        Px_V_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        Px_V_empty_n : IN STD_LOGIC;
        Px_V_read : OUT STD_LOGIC;
        Py_V_dout : IN STD_LOGIC_VECTOR (0 downto 0);
        Py_V_empty_n : IN STD_LOGIC;
        Py_V_read : OUT STD_LOGIC;
        Px_V_out_din : OUT STD_LOGIC_VECTOR (18 downto 0);
        Px_V_out_full_n : IN STD_LOGIC;
        Px_V_out_write : OUT STD_LOGIC;
        Py_V_out_din : OUT STD_LOGIC_VECTOR (18 downto 0);
        Py_V_out_full_n : IN STD_LOGIC;
        Py_V_out_write : OUT STD_LOGIC );
    end component;


    component getMET IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        Px_V_dout : IN STD_LOGIC_VECTOR (18 downto 0);
        Px_V_empty_n : IN STD_LOGIC;
        Px_V_read : OUT STD_LOGIC;
        Py_V_dout : IN STD_LOGIC_VECTOR (18 downto 0);
        Py_V_empty_n : IN STD_LOGIC;
        Py_V_read : OUT STD_LOGIC;
        ap_return_0 : OUT STD_LOGIC_VECTOR (16 downto 0);
        ap_return_1 : OUT STD_LOGIC_VECTOR (17 downto 0) );
    end component;


    component packMET IS
    port (
        ap_clk : IN STD_LOGIC;
        ap_rst : IN STD_LOGIC;
        ap_start : IN STD_LOGIC;
        ap_done : OUT STD_LOGIC;
        ap_continue : IN STD_LOGIC;
        ap_idle : OUT STD_LOGIC;
        ap_ready : OUT STD_LOGIC;
        p_read : IN STD_LOGIC_VECTOR (16 downto 0);
        p_read1 : IN STD_LOGIC_VECTOR (17 downto 0);
        output_stream_V_data_V_din : OUT STD_LOGIC_VECTOR (34 downto 0);
        output_stream_V_data_V_full_n : IN STD_LOGIC;
        output_stream_V_data_V_write : OUT STD_LOGIC );
    end component;


    component fifo_w1_d2_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w19_d2_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (18 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (18 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w17_d2_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (16 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (16 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component fifo_w18_d2_A IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (17 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (17 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;


    component start_for_getMET_U0 IS
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        if_read_ce : IN STD_LOGIC;
        if_write_ce : IN STD_LOGIC;
        if_din : IN STD_LOGIC_VECTOR (0 downto 0);
        if_full_n : OUT STD_LOGIC;
        if_write : IN STD_LOGIC;
        if_dout : OUT STD_LOGIC_VECTOR (0 downto 0);
        if_empty_n : OUT STD_LOGIC;
        if_read : IN STD_LOGIC );
    end component;



begin
    met_Block_ZN8ap_fix_U0 : component met_Block_ZN8ap_fix
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => met_Block_ZN8ap_fix_U0_ap_start,
        ap_done => met_Block_ZN8ap_fix_U0_ap_done,
        ap_continue => met_Block_ZN8ap_fix_U0_ap_continue,
        ap_idle => met_Block_ZN8ap_fix_U0_ap_idle,
        ap_ready => met_Block_ZN8ap_fix_U0_ap_ready,
        Px_V_out_din => met_Block_ZN8ap_fix_U0_Px_V_out_din,
        Px_V_out_full_n => Px_V_c_full_n,
        Px_V_out_write => met_Block_ZN8ap_fix_U0_Px_V_out_write,
        Py_V_out_din => met_Block_ZN8ap_fix_U0_Py_V_out_din,
        Py_V_out_full_n => Py_V_c_full_n,
        Py_V_out_write => met_Block_ZN8ap_fix_U0_Py_V_out_write);

    addTracks_U0 : component addTracks
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => addTracks_U0_ap_start,
        start_full_n => start_for_getMET_U0_full_n,
        ap_done => addTracks_U0_ap_done,
        ap_continue => addTracks_U0_ap_continue,
        ap_idle => addTracks_U0_ap_idle,
        ap_ready => addTracks_U0_ap_ready,
        start_out => addTracks_U0_start_out,
        start_write => addTracks_U0_start_write,
        track_stream_V_data_0_V_dout => track_stream_V_data_0_V_dout,
        track_stream_V_data_0_V_empty_n => track_stream_V_data_0_V_empty_n,
        track_stream_V_data_0_V_read => addTracks_U0_track_stream_V_data_0_V_read,
        track_stream_V_data_1_V_dout => track_stream_V_data_1_V_dout,
        track_stream_V_data_1_V_empty_n => track_stream_V_data_1_V_empty_n,
        track_stream_V_data_1_V_read => addTracks_U0_track_stream_V_data_1_V_read,
        track_stream_V_data_2_V_dout => track_stream_V_data_2_V_dout,
        track_stream_V_data_2_V_empty_n => track_stream_V_data_2_V_empty_n,
        track_stream_V_data_2_V_read => addTracks_U0_track_stream_V_data_2_V_read,
        track_stream_V_data_3_V_dout => track_stream_V_data_3_V_dout,
        track_stream_V_data_3_V_empty_n => track_stream_V_data_3_V_empty_n,
        track_stream_V_data_3_V_read => addTracks_U0_track_stream_V_data_3_V_read,
        track_stream_V_data_4_V_dout => track_stream_V_data_4_V_dout,
        track_stream_V_data_4_V_empty_n => track_stream_V_data_4_V_empty_n,
        track_stream_V_data_4_V_read => addTracks_U0_track_stream_V_data_4_V_read,
        track_stream_V_data_5_V_dout => track_stream_V_data_5_V_dout,
        track_stream_V_data_5_V_empty_n => track_stream_V_data_5_V_empty_n,
        track_stream_V_data_5_V_read => addTracks_U0_track_stream_V_data_5_V_read,
        track_stream_V_data_6_V_dout => track_stream_V_data_6_V_dout,
        track_stream_V_data_6_V_empty_n => track_stream_V_data_6_V_empty_n,
        track_stream_V_data_6_V_read => addTracks_U0_track_stream_V_data_6_V_read,
        track_stream_V_data_7_V_dout => track_stream_V_data_7_V_dout,
        track_stream_V_data_7_V_empty_n => track_stream_V_data_7_V_empty_n,
        track_stream_V_data_7_V_read => addTracks_U0_track_stream_V_data_7_V_read,
        track_stream_V_data_8_V_dout => track_stream_V_data_8_V_dout,
        track_stream_V_data_8_V_empty_n => track_stream_V_data_8_V_empty_n,
        track_stream_V_data_8_V_read => addTracks_U0_track_stream_V_data_8_V_read,
        track_stream_V_data_9_V_dout => track_stream_V_data_9_V_dout,
        track_stream_V_data_9_V_empty_n => track_stream_V_data_9_V_empty_n,
        track_stream_V_data_9_V_read => addTracks_U0_track_stream_V_data_9_V_read,
        track_stream_V_data_10_V_dout => track_stream_V_data_10_V_dout,
        track_stream_V_data_10_V_empty_n => track_stream_V_data_10_V_empty_n,
        track_stream_V_data_10_V_read => addTracks_U0_track_stream_V_data_10_V_read,
        track_stream_V_data_11_V_dout => track_stream_V_data_11_V_dout,
        track_stream_V_data_11_V_empty_n => track_stream_V_data_11_V_empty_n,
        track_stream_V_data_11_V_read => addTracks_U0_track_stream_V_data_11_V_read,
        track_stream_V_data_12_V_dout => track_stream_V_data_12_V_dout,
        track_stream_V_data_12_V_empty_n => track_stream_V_data_12_V_empty_n,
        track_stream_V_data_12_V_read => addTracks_U0_track_stream_V_data_12_V_read,
        track_stream_V_data_13_V_dout => track_stream_V_data_13_V_dout,
        track_stream_V_data_13_V_empty_n => track_stream_V_data_13_V_empty_n,
        track_stream_V_data_13_V_read => addTracks_U0_track_stream_V_data_13_V_read,
        track_stream_V_data_14_V_dout => track_stream_V_data_14_V_dout,
        track_stream_V_data_14_V_empty_n => track_stream_V_data_14_V_empty_n,
        track_stream_V_data_14_V_read => addTracks_U0_track_stream_V_data_14_V_read,
        track_stream_V_data_15_V_dout => track_stream_V_data_15_V_dout,
        track_stream_V_data_15_V_empty_n => track_stream_V_data_15_V_empty_n,
        track_stream_V_data_15_V_read => addTracks_U0_track_stream_V_data_15_V_read,
        track_stream_V_data_16_V_dout => track_stream_V_data_16_V_dout,
        track_stream_V_data_16_V_empty_n => track_stream_V_data_16_V_empty_n,
        track_stream_V_data_16_V_read => addTracks_U0_track_stream_V_data_16_V_read,
        track_stream_V_data_17_V_dout => track_stream_V_data_17_V_dout,
        track_stream_V_data_17_V_empty_n => track_stream_V_data_17_V_empty_n,
        track_stream_V_data_17_V_read => addTracks_U0_track_stream_V_data_17_V_read,
        Px_V_dout => Px_V_c_dout,
        Px_V_empty_n => Px_V_c_empty_n,
        Px_V_read => addTracks_U0_Px_V_read,
        Py_V_dout => Py_V_c_dout,
        Py_V_empty_n => Py_V_c_empty_n,
        Py_V_read => addTracks_U0_Py_V_read,
        Px_V_out_din => addTracks_U0_Px_V_out_din,
        Px_V_out_full_n => Px_V_c32_full_n,
        Px_V_out_write => addTracks_U0_Px_V_out_write,
        Py_V_out_din => addTracks_U0_Py_V_out_din,
        Py_V_out_full_n => Py_V_c33_full_n,
        Py_V_out_write => addTracks_U0_Py_V_out_write);

    getMET_U0 : component getMET
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => getMET_U0_ap_start,
        ap_done => getMET_U0_ap_done,
        ap_continue => getMET_U0_ap_continue,
        ap_idle => getMET_U0_ap_idle,
        ap_ready => getMET_U0_ap_ready,
        Px_V_dout => Px_V_c32_dout,
        Px_V_empty_n => Px_V_c32_empty_n,
        Px_V_read => getMET_U0_Px_V_read,
        Py_V_dout => Py_V_c33_dout,
        Py_V_empty_n => Py_V_c33_empty_n,
        Py_V_read => getMET_U0_Py_V_read,
        ap_return_0 => getMET_U0_ap_return_0,
        ap_return_1 => getMET_U0_ap_return_1);

    packMET_U0 : component packMET
    port map (
        ap_clk => ap_clk,
        ap_rst => ap_rst,
        ap_start => packMET_U0_ap_start,
        ap_done => packMET_U0_ap_done,
        ap_continue => packMET_U0_ap_continue,
        ap_idle => packMET_U0_ap_idle,
        ap_ready => packMET_U0_ap_ready,
        p_read => metPt_V_dout,
        p_read1 => metPhi_V_dout,
        output_stream_V_data_V_din => packMET_U0_output_stream_V_data_V_din,
        output_stream_V_data_V_full_n => output_stream_V_data_V_full_n,
        output_stream_V_data_V_write => packMET_U0_output_stream_V_data_V_write);

    Px_V_c_U : component fifo_w1_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => met_Block_ZN8ap_fix_U0_Px_V_out_din,
        if_full_n => Px_V_c_full_n,
        if_write => met_Block_ZN8ap_fix_U0_Px_V_out_write,
        if_dout => Px_V_c_dout,
        if_empty_n => Px_V_c_empty_n,
        if_read => addTracks_U0_Px_V_read);

    Py_V_c_U : component fifo_w1_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => met_Block_ZN8ap_fix_U0_Py_V_out_din,
        if_full_n => Py_V_c_full_n,
        if_write => met_Block_ZN8ap_fix_U0_Py_V_out_write,
        if_dout => Py_V_c_dout,
        if_empty_n => Py_V_c_empty_n,
        if_read => addTracks_U0_Py_V_read);

    Px_V_c32_U : component fifo_w19_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => addTracks_U0_Px_V_out_din,
        if_full_n => Px_V_c32_full_n,
        if_write => addTracks_U0_Px_V_out_write,
        if_dout => Px_V_c32_dout,
        if_empty_n => Px_V_c32_empty_n,
        if_read => getMET_U0_Px_V_read);

    Py_V_c33_U : component fifo_w19_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => addTracks_U0_Py_V_out_din,
        if_full_n => Py_V_c33_full_n,
        if_write => addTracks_U0_Py_V_out_write,
        if_dout => Py_V_c33_dout,
        if_empty_n => Py_V_c33_empty_n,
        if_read => getMET_U0_Py_V_read);

    metPt_V_U : component fifo_w17_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => getMET_U0_ap_return_0,
        if_full_n => metPt_V_full_n,
        if_write => ap_channel_done_metPt_V,
        if_dout => metPt_V_dout,
        if_empty_n => metPt_V_empty_n,
        if_read => packMET_U0_ap_ready);

    metPhi_V_U : component fifo_w18_d2_A
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => getMET_U0_ap_return_1,
        if_full_n => metPhi_V_full_n,
        if_write => ap_channel_done_metPhi_V,
        if_dout => metPhi_V_dout,
        if_empty_n => metPhi_V_empty_n,
        if_read => packMET_U0_ap_ready);

    start_for_getMET_U0_U : component start_for_getMET_U0
    port map (
        clk => ap_clk,
        reset => ap_rst,
        if_read_ce => ap_const_logic_1,
        if_write_ce => ap_const_logic_1,
        if_din => start_for_getMET_U0_din,
        if_full_n => start_for_getMET_U0_full_n,
        if_write => addTracks_U0_start_write,
        if_dout => start_for_getMET_U0_dout,
        if_empty_n => start_for_getMET_U0_empty_n,
        if_read => getMET_U0_ap_ready);





    ap_sync_reg_addTracks_U0_ap_ready_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_addTracks_U0_ap_ready <= ap_const_logic_0;
            else
                if (((ap_sync_ready and ap_start) = ap_const_logic_1)) then 
                    ap_sync_reg_addTracks_U0_ap_ready <= ap_const_logic_0;
                else 
                    ap_sync_reg_addTracks_U0_ap_ready <= ap_sync_addTracks_U0_ap_ready;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_channel_write_metPhi_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_channel_write_metPhi_V <= ap_const_logic_0;
            else
                if (((getMET_U0_ap_done and getMET_U0_ap_continue) = ap_const_logic_1)) then 
                    ap_sync_reg_channel_write_metPhi_V <= ap_const_logic_0;
                else 
                    ap_sync_reg_channel_write_metPhi_V <= ap_sync_channel_write_metPhi_V;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_channel_write_metPt_V_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_channel_write_metPt_V <= ap_const_logic_0;
            else
                if (((getMET_U0_ap_done and getMET_U0_ap_continue) = ap_const_logic_1)) then 
                    ap_sync_reg_channel_write_metPt_V <= ap_const_logic_0;
                else 
                    ap_sync_reg_channel_write_metPt_V <= ap_sync_channel_write_metPt_V;
                end if; 
            end if;
        end if;
    end process;


    ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready <= ap_const_logic_0;
            else
                if (((ap_sync_ready and ap_start) = ap_const_logic_1)) then 
                    ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready <= ap_const_logic_0;
                else 
                    ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready <= ap_sync_met_Block_ZN8ap_fix_U0_ap_ready;
                end if; 
            end if;
        end if;
    end process;


    addTracks_U0_ap_ready_count_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_sync_ready = ap_const_logic_1) and (ap_const_logic_0 = addTracks_U0_ap_ready))) then 
                addTracks_U0_ap_ready_count <= std_logic_vector(unsigned(addTracks_U0_ap_ready_count) - unsigned(ap_const_lv2_1));
            elsif (((ap_const_logic_1 = addTracks_U0_ap_ready) and (ap_sync_ready = ap_const_logic_0))) then 
                addTracks_U0_ap_ready_count <= std_logic_vector(unsigned(addTracks_U0_ap_ready_count) + unsigned(ap_const_lv2_1));
            end if; 
        end if;
    end process;

    met_Block_ZN8ap_fix_U0_ap_ready_count_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_sync_ready = ap_const_logic_1) and (met_Block_ZN8ap_fix_U0_ap_ready = ap_const_logic_0))) then 
                met_Block_ZN8ap_fix_U0_ap_ready_count <= std_logic_vector(unsigned(met_Block_ZN8ap_fix_U0_ap_ready_count) - unsigned(ap_const_lv2_1));
            elsif (((met_Block_ZN8ap_fix_U0_ap_ready = ap_const_logic_1) and (ap_sync_ready = ap_const_logic_0))) then 
                met_Block_ZN8ap_fix_U0_ap_ready_count <= std_logic_vector(unsigned(met_Block_ZN8ap_fix_U0_ap_ready_count) + unsigned(ap_const_lv2_1));
            end if; 
        end if;
    end process;
    addTracks_U0_ap_continue <= ap_const_logic_1;
    addTracks_U0_ap_start <= ((ap_sync_reg_addTracks_U0_ap_ready xor ap_const_logic_1) and ap_start);
    ap_channel_done_metPhi_V <= (getMET_U0_ap_done and (ap_sync_reg_channel_write_metPhi_V xor ap_const_logic_1));
    ap_channel_done_metPt_V <= (getMET_U0_ap_done and (ap_sync_reg_channel_write_metPt_V xor ap_const_logic_1));
    ap_done <= packMET_U0_ap_done;
    ap_idle <= (packMET_U0_ap_idle and met_Block_ZN8ap_fix_U0_ap_idle and getMET_U0_ap_idle and (metPhi_V_empty_n xor ap_const_logic_1) and (metPt_V_empty_n xor ap_const_logic_1) and addTracks_U0_ap_idle);
    ap_ready <= ap_sync_ready;
    ap_sync_addTracks_U0_ap_ready <= (ap_sync_reg_addTracks_U0_ap_ready or addTracks_U0_ap_ready);
    ap_sync_channel_write_metPhi_V <= ((metPhi_V_full_n and ap_channel_done_metPhi_V) or ap_sync_reg_channel_write_metPhi_V);
    ap_sync_channel_write_metPt_V <= ((metPt_V_full_n and ap_channel_done_metPt_V) or ap_sync_reg_channel_write_metPt_V);
    ap_sync_continue <= ap_continue;
    ap_sync_done <= packMET_U0_ap_done;
    ap_sync_met_Block_ZN8ap_fix_U0_ap_ready <= (met_Block_ZN8ap_fix_U0_ap_ready or ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready);
    ap_sync_ready <= (ap_sync_met_Block_ZN8ap_fix_U0_ap_ready and ap_sync_addTracks_U0_ap_ready);
    getMET_U0_ap_continue <= (ap_sync_channel_write_metPt_V and ap_sync_channel_write_metPhi_V);
    getMET_U0_ap_start <= start_for_getMET_U0_empty_n;
    getMET_U0_start_full_n <= ap_const_logic_1;
    getMET_U0_start_write <= ap_const_logic_0;
    met_Block_ZN8ap_fix_U0_ap_continue <= ap_const_logic_1;
    met_Block_ZN8ap_fix_U0_ap_start <= ((ap_sync_reg_met_Block_ZN8ap_fix_U0_ap_ready xor ap_const_logic_1) and ap_start);
    met_Block_ZN8ap_fix_U0_start_full_n <= ap_const_logic_1;
    met_Block_ZN8ap_fix_U0_start_write <= ap_const_logic_0;
    output_stream_V_data_V_din <= packMET_U0_output_stream_V_data_V_din;
    output_stream_V_data_V_write <= packMET_U0_output_stream_V_data_V_write;
    packMET_U0_ap_continue <= ap_continue;
    packMET_U0_ap_start <= (metPt_V_empty_n and metPhi_V_empty_n);
    packMET_U0_start_full_n <= ap_const_logic_1;
    packMET_U0_start_write <= ap_const_logic_0;
    start_for_getMET_U0_din <= (0=>ap_const_logic_1, others=>'-');
    track_stream_V_data_0_V_read <= addTracks_U0_track_stream_V_data_0_V_read;
    track_stream_V_data_10_V_read <= addTracks_U0_track_stream_V_data_10_V_read;
    track_stream_V_data_11_V_read <= addTracks_U0_track_stream_V_data_11_V_read;
    track_stream_V_data_12_V_read <= addTracks_U0_track_stream_V_data_12_V_read;
    track_stream_V_data_13_V_read <= addTracks_U0_track_stream_V_data_13_V_read;
    track_stream_V_data_14_V_read <= addTracks_U0_track_stream_V_data_14_V_read;
    track_stream_V_data_15_V_read <= addTracks_U0_track_stream_V_data_15_V_read;
    track_stream_V_data_16_V_read <= addTracks_U0_track_stream_V_data_16_V_read;
    track_stream_V_data_17_V_read <= addTracks_U0_track_stream_V_data_17_V_read;
    track_stream_V_data_1_V_read <= addTracks_U0_track_stream_V_data_1_V_read;
    track_stream_V_data_2_V_read <= addTracks_U0_track_stream_V_data_2_V_read;
    track_stream_V_data_3_V_read <= addTracks_U0_track_stream_V_data_3_V_read;
    track_stream_V_data_4_V_read <= addTracks_U0_track_stream_V_data_4_V_read;
    track_stream_V_data_5_V_read <= addTracks_U0_track_stream_V_data_5_V_read;
    track_stream_V_data_6_V_read <= addTracks_U0_track_stream_V_data_6_V_read;
    track_stream_V_data_7_V_read <= addTracks_U0_track_stream_V_data_7_V_read;
    track_stream_V_data_8_V_read <= addTracks_U0_track_stream_V_data_8_V_read;
    track_stream_V_data_9_V_read <= addTracks_U0_track_stream_V_data_9_V_read;
end behav;
