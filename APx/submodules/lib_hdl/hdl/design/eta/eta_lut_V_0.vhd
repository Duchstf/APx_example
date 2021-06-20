-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.2 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity eta_lut_V_0_rom is 
    generic(
             DWIDTH     : integer := 6; 
             AWIDTH     : integer := 6; 
             MEM_SIZE    : integer := 64
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of eta_lut_V_0_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "000001", 1 => "000010", 2 => "000011", 3 => "000101", 4 => "000110", 
    5 => "000111", 6 => "001001", 7 => "001010", 8 => "001011", 9 => "001101", 
    10 => "001110", 11 => "001111", 12 => "010000", 13 => "010010", 14 => "010011", 
    15 => "010100", 16 => "010101", 17 => "010110", 18 => "010111", 19 => "011000", 
    20 => "011001", 21 => "011010", 22 => "011011", 23 => "011100", 24 => "011101", 
    25 => "011110", 26 => "011111", 27 => "100000", 28 => "100001", 29 => "100010", 
    30 to 31=> "100011", 32 => "100100", 33 => "100101", 34 => "100110", 35 to 36=> "100111", 
    37 => "101000", 38 to 39=> "101001", 40 => "101010", 41 to 42=> "101011", 43 => "101100", 
    44 to 45=> "101101", 46 => "101110", 47 to 48=> "101111", 49 to 50=> "110000", 51 => "110001", 
    52 to 53=> "110010", 54 to 55=> "110011", 56 to 57=> "110100", 58 to 59=> "110101", 60 to 61=> "110110", 
    62 to 63=> "110111" );

attribute syn_rom_style : string;
attribute syn_rom_style of mem : signal is "select_rom";
attribute ROM_STYLE : string;
attribute ROM_STYLE of mem : signal is "distributed";

begin 


memory_access_guard_0: process (addr0) 
begin
      addr0_tmp <= addr0;
--synthesis translate_off
      if (CONV_INTEGER(addr0) > mem_size-1) then
           addr0_tmp <= (others => '0');
      else 
           addr0_tmp <= addr0;
      end if;
--synthesis translate_on
end process;

p_rom_access: process (clk)  
begin 
    if (clk'event and clk = '1') then
        if (ce0 = '1') then 
            q0 <= mem(CONV_INTEGER(addr0_tmp)); 
        end if;
    end if;
end process;

end rtl;

Library IEEE;
use IEEE.std_logic_1164.all;

entity eta_lut_V_0 is
    generic (
        DataWidth : INTEGER := 6;
        AddressRange : INTEGER := 64;
        AddressWidth : INTEGER := 6);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of eta_lut_V_0 is
    component eta_lut_V_0_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    eta_lut_V_0_rom_U :  component eta_lut_V_0_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


