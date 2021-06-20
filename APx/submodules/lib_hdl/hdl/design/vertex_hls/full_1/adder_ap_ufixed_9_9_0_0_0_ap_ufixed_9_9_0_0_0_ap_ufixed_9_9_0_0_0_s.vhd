-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adder_ap_ufixed_9_9_0_0_0_ap_ufixed_9_9_0_0_0_ap_ufixed_9_9_0_0_0_s is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    first_V : IN STD_LOGIC_VECTOR (8 downto 0);
    args_V : IN STD_LOGIC_VECTOR (8 downto 0);
    args_V_2 : IN STD_LOGIC_VECTOR (8 downto 0);
    ap_return : OUT STD_LOGIC_VECTOR (8 downto 0);
    ap_ce : IN STD_LOGIC );
end;


architecture behav of adder_ap_ufixed_9_9_0_0_0_ap_ufixed_9_9_0_0_0_ap_ufixed_9_9_0_0_0_s is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_boolean_1 : BOOLEAN := true;
    constant ap_const_boolean_0 : BOOLEAN := false;
    constant ap_const_lv32_9 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000001001";
    constant ap_const_lv9_1FF : STD_LOGIC_VECTOR (8 downto 0) := "111111111";
    constant ap_const_logic_0 : STD_LOGIC := '0';

    signal p_Val2_28_fu_82_p2 : STD_LOGIC_VECTOR (8 downto 0);
    signal p_Val2_28_reg_102 : STD_LOGIC_VECTOR (8 downto 0);
    signal ap_block_state1_pp0_stage0_iter0 : BOOLEAN;
    signal ap_block_state2_pp0_stage0_iter1 : BOOLEAN;
    signal ap_block_pp0_stage0_11001 : BOOLEAN;
    signal overflow_3_reg_107 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_block_pp0_stage0 : BOOLEAN;
    signal rhs_V_1_fu_36_p1 : STD_LOGIC_VECTOR (9 downto 0);
    signal lhs_V_1_fu_32_p1 : STD_LOGIC_VECTOR (9 downto 0);
    signal ret_V_fu_40_p2 : STD_LOGIC_VECTOR (9 downto 0);
    signal overflow_fu_52_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal p_Val2_25_fu_46_p2 : STD_LOGIC_VECTOR (8 downto 0);
    signal p_Val2_26_fu_60_p3 : STD_LOGIC_VECTOR (8 downto 0);
    signal rhs_V_fu_72_p1 : STD_LOGIC_VECTOR (9 downto 0);
    signal lhs_V_fu_68_p1 : STD_LOGIC_VECTOR (9 downto 0);
    signal ret_V_12_fu_76_p2 : STD_LOGIC_VECTOR (9 downto 0);


begin



    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_boolean_0 = ap_block_pp0_stage0_11001) and (ap_const_logic_1 = ap_ce))) then
                overflow_3_reg_107 <= ret_V_12_fu_76_p2(9 downto 9);
                p_Val2_28_reg_102 <= p_Val2_28_fu_82_p2;
            end if;
        end if;
    end process;
        ap_block_pp0_stage0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_pp0_stage0_11001 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state1_pp0_stage0_iter0 <= not((ap_const_boolean_1 = ap_const_boolean_1));
        ap_block_state2_pp0_stage0_iter1 <= not((ap_const_boolean_1 = ap_const_boolean_1));
    ap_return <= 
        ap_const_lv9_1FF when (overflow_3_reg_107(0) = '1') else 
        p_Val2_28_reg_102;
    lhs_V_1_fu_32_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(args_V),10));
    lhs_V_fu_68_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(first_V),10));
    overflow_fu_52_p3 <= ret_V_fu_40_p2(9 downto 9);
    p_Val2_25_fu_46_p2 <= std_logic_vector(unsigned(args_V_2) + unsigned(args_V));
    p_Val2_26_fu_60_p3 <= 
        ap_const_lv9_1FF when (overflow_fu_52_p3(0) = '1') else 
        p_Val2_25_fu_46_p2;
    p_Val2_28_fu_82_p2 <= std_logic_vector(unsigned(p_Val2_26_fu_60_p3) + unsigned(first_V));
    ret_V_12_fu_76_p2 <= std_logic_vector(unsigned(rhs_V_fu_72_p1) + unsigned(lhs_V_fu_68_p1));
    ret_V_fu_40_p2 <= std_logic_vector(unsigned(rhs_V_1_fu_36_p1) + unsigned(lhs_V_1_fu_32_p1));
    rhs_V_1_fu_36_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(args_V_2),10));
    rhs_V_fu_72_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(p_Val2_26_fu_60_p3),10));
end behav;
