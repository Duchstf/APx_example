-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2019.1
-- Copyright (C) 1986-2019 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pack_out is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_continue : IN STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    outvtx_hwSumPt_V_dout : IN STD_LOGIC_VECTOR (10 downto 0);
    outvtx_hwSumPt_V_empty_n : IN STD_LOGIC;
    outvtx_hwSumPt_V_read : OUT STD_LOGIC;
    outvtx_hwZ0_V_dout : IN STD_LOGIC_VECTOR (9 downto 0);
    outvtx_hwZ0_V_empty_n : IN STD_LOGIC;
    outvtx_hwZ0_V_read : OUT STD_LOGIC;
    outvtx_mult_V_dout : IN STD_LOGIC_VECTOR (0 downto 0);
    outvtx_mult_V_empty_n : IN STD_LOGIC;
    outvtx_mult_V_read : OUT STD_LOGIC;
    outvtx_hwBin_V_dout : IN STD_LOGIC_VECTOR (6 downto 0);
    outvtx_hwBin_V_empty_n : IN STD_LOGIC;
    outvtx_hwBin_V_read : OUT STD_LOGIC;
    data_V_data_V_din : OUT STD_LOGIC_VECTOR (99 downto 0);
    data_V_data_V_full_n : IN STD_LOGIC;
    data_V_data_V_write : OUT STD_LOGIC );
end;


architecture behav of pack_out is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal ap_done_reg : STD_LOGIC := '0';
    signal ap_CS_fsm : STD_LOGIC_VECTOR (0 downto 0) := "1";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal outvtx_hwSumPt_V_blk_n : STD_LOGIC;
    signal outvtx_hwZ0_V_blk_n : STD_LOGIC;
    signal outvtx_mult_V_blk_n : STD_LOGIC;
    signal outvtx_hwBin_V_blk_n : STD_LOGIC;
    signal data_V_data_V_blk_n : STD_LOGIC;
    signal ap_block_state1 : BOOLEAN;
    signal v2_V_4_fu_83_p1 : STD_LOGIC_VECTOR (9 downto 0);
    signal v2_V_3_fu_79_p1 : STD_LOGIC_VECTOR (11 downto 0);
    signal v2_V_fu_75_p1 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_fu_87_p5 : STD_LOGIC_VECTOR (38 downto 0);
    signal ap_NS_fsm : STD_LOGIC_VECTOR (0 downto 0);


begin




    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_done_reg_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_done_reg <= ap_const_logic_0;
            else
                if ((ap_continue = ap_const_logic_1)) then 
                    ap_done_reg <= ap_const_logic_0;
                elsif ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
                    ap_done_reg <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_NS_fsm_assign_proc : process (ap_start, ap_done_reg, ap_CS_fsm, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                ap_NS_fsm <= ap_ST_fsm_state1;
            when others =>  
                ap_NS_fsm <= "X";
        end case;
    end process;
    ap_CS_fsm_state1 <= ap_CS_fsm(0);

    ap_block_state1_assign_proc : process(ap_start, ap_done_reg, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
                ap_block_state1 <= ((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1));
    end process;


    ap_done_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_done_reg;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    data_V_data_V_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            data_V_data_V_blk_n <= data_V_data_V_full_n;
        else 
            data_V_data_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;

    data_V_data_V_din <= std_logic_vector(IEEE.numeric_std.resize(unsigned(tmp_fu_87_p5),100));

    data_V_data_V_write_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            data_V_data_V_write <= ap_const_logic_1;
        else 
            data_V_data_V_write <= ap_const_logic_0;
        end if; 
    end process;


    outvtx_hwBin_V_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwBin_V_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwBin_V_blk_n <= outvtx_hwBin_V_empty_n;
        else 
            outvtx_hwBin_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    outvtx_hwBin_V_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwBin_V_read <= ap_const_logic_1;
        else 
            outvtx_hwBin_V_read <= ap_const_logic_0;
        end if; 
    end process;


    outvtx_hwSumPt_V_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwSumPt_V_blk_n <= outvtx_hwSumPt_V_empty_n;
        else 
            outvtx_hwSumPt_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    outvtx_hwSumPt_V_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwSumPt_V_read <= ap_const_logic_1;
        else 
            outvtx_hwSumPt_V_read <= ap_const_logic_0;
        end if; 
    end process;


    outvtx_hwZ0_V_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwZ0_V_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwZ0_V_blk_n <= outvtx_hwZ0_V_empty_n;
        else 
            outvtx_hwZ0_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    outvtx_hwZ0_V_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_hwZ0_V_read <= ap_const_logic_1;
        else 
            outvtx_hwZ0_V_read <= ap_const_logic_0;
        end if; 
    end process;


    outvtx_mult_V_blk_n_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_mult_V_empty_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_mult_V_blk_n <= outvtx_mult_V_empty_n;
        else 
            outvtx_mult_V_blk_n <= ap_const_logic_1;
        end if; 
    end process;


    outvtx_mult_V_read_assign_proc : process(ap_start, ap_done_reg, ap_CS_fsm_state1, outvtx_hwSumPt_V_empty_n, outvtx_hwZ0_V_empty_n, outvtx_mult_V_empty_n, outvtx_hwBin_V_empty_n, data_V_data_V_full_n)
    begin
        if ((not(((ap_start = ap_const_logic_0) or (data_V_data_V_full_n = ap_const_logic_0) or (outvtx_hwBin_V_empty_n = ap_const_logic_0) or (outvtx_mult_V_empty_n = ap_const_logic_0) or (outvtx_hwZ0_V_empty_n = ap_const_logic_0) or (outvtx_hwSumPt_V_empty_n = ap_const_logic_0) or (ap_done_reg = ap_const_logic_1))) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            outvtx_mult_V_read <= ap_const_logic_1;
        else 
            outvtx_mult_V_read <= ap_const_logic_0;
        end if; 
    end process;

    tmp_fu_87_p5 <= (((outvtx_mult_V_dout & v2_V_4_fu_83_p1) & v2_V_3_fu_79_p1) & v2_V_fu_75_p1);
        v2_V_3_fu_79_p1 <= std_logic_vector(IEEE.numeric_std.resize(signed(outvtx_hwZ0_V_dout),12));

    v2_V_4_fu_83_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(outvtx_hwBin_V_dout),10));
    v2_V_fu_75_p1 <= std_logic_vector(IEEE.numeric_std.resize(unsigned(outvtx_hwSumPt_V_dout),16));
end behav;