-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.1 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity tkobjalgo_find_vtx_inversion_table1_rom is 
    generic(
             DWIDTH     : integer := 14; 
             AWIDTH     : integer := 11; 
             MEM_SIZE    : integer := 1533
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of tkobjalgo_find_vtx_inversion_table1_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 => "00000000000000", 1 => "10000000000000", 2 => "01000000000000", 
    3 => "00101010101011", 4 => "00100000000000", 5 => "00011001100110", 
    6 => "00010101010101", 7 => "00010010010010", 8 => "00010000000000", 
    9 => "00001110001110", 10 => "00001100110011", 11 => "00001011101001", 
    12 => "00001010101011", 13 => "00001001110110", 14 => "00001001001001", 
    15 => "00001000100010", 16 => "00001000000000", 17 => "00000111100010", 
    18 => "00000111000111", 19 => "00000110101111", 20 => "00000110011010", 
    21 => "00000110000110", 22 => "00000101110100", 23 => "00000101100100", 
    24 => "00000101010101", 25 => "00000101001000", 26 => "00000100111011", 
    27 => "00000100101111", 28 => "00000100100101", 29 => "00000100011010", 
    30 => "00000100010001", 31 => "00000100001000", 32 => "00000100000000", 
    33 => "00000011111000", 34 => "00000011110001", 35 => "00000011101010", 
    36 => "00000011100100", 37 => "00000011011101", 38 => "00000011011000", 
    39 => "00000011010010", 40 => "00000011001101", 41 => "00000011001000", 
    42 => "00000011000011", 43 => "00000010111111", 44 => "00000010111010", 
    45 => "00000010110110", 46 => "00000010110010", 47 => "00000010101110", 
    48 => "00000010101011", 49 => "00000010100111", 50 => "00000010100100", 
    51 => "00000010100001", 52 => "00000010011110", 53 => "00000010011011", 
    54 => "00000010011000", 55 => "00000010010101", 56 => "00000010010010", 
    57 => "00000010010000", 58 => "00000010001101", 59 => "00000010001011", 
    60 => "00000010001001", 61 => "00000010000110", 62 => "00000010000100", 
    63 => "00000010000010", 64 => "00000010000000", 65 => "00000001111110", 
    66 => "00000001111100", 67 => "00000001111010", 68 => "00000001111000", 
    69 => "00000001110111", 70 => "00000001110101", 71 => "00000001110011", 
    72 => "00000001110010", 73 => "00000001110000", 74 => "00000001101111", 
    75 => "00000001101101", 76 => "00000001101100", 77 => "00000001101010", 
    78 => "00000001101001", 79 => "00000001101000", 80 => "00000001100110", 
    81 => "00000001100101", 82 => "00000001100100", 83 => "00000001100011", 
    84 => "00000001100010", 85 => "00000001100000", 86 => "00000001011111", 
    87 => "00000001011110", 88 => "00000001011101", 89 => "00000001011100", 
    90 => "00000001011011", 91 => "00000001011010", 92 => "00000001011001", 
    93 => "00000001011000", 94 => "00000001010111", 95 => "00000001010110", 
    96 => "00000001010101", 97 to 98=> "00000001010100", 99 => "00000001010011", 
    100 => "00000001010010", 101 => "00000001010001", 102 to 103=> "00000001010000", 
    104 => "00000001001111", 105 => "00000001001110", 106 to 107=> "00000001001101", 
    108 => "00000001001100", 109 => "00000001001011", 110 to 111=> "00000001001010", 
    112 => "00000001001001", 113 to 114=> "00000001001000", 115 to 116=> "00000001000111", 
    117 => "00000001000110", 118 to 119=> "00000001000101", 120 to 121=> "00000001000100", 
    122 to 123=> "00000001000011", 124 to 125=> "00000001000010", 126 to 127=> "00000001000001", 
    128 to 129=> "00000001000000", 130 to 131=> "00000000111111", 132 to 133=> "00000000111110", 
    134 to 135=> "00000000111101", 136 to 137=> "00000000111100", 138 to 140=> "00000000111011", 
    141 to 142=> "00000000111010", 143 to 144=> "00000000111001", 145 to 147=> "00000000111000", 
    148 to 150=> "00000000110111", 151 to 153=> "00000000110110", 154 to 156=> "00000000110101", 
    157 to 159=> "00000000110100", 160 to 162=> "00000000110011", 163 to 165=> "00000000110010", 
    166 to 168=> "00000000110001", 169 to 172=> "00000000110000", 173 to 176=> "00000000101111", 
    177 to 180=> "00000000101110", 181 to 184=> "00000000101101", 185 to 188=> "00000000101100", 
    189 to 192=> "00000000101011", 193 to 197=> "00000000101010", 198 to 202=> "00000000101001", 
    203 to 207=> "00000000101000", 208 to 212=> "00000000100111", 213 to 218=> "00000000100110", 
    219 to 224=> "00000000100101", 225 to 230=> "00000000100100", 231 to 237=> "00000000100011", 
    238 to 244=> "00000000100010", 245 to 252=> "00000000100001", 253 to 260=> "00000000100000", 
    261 to 268=> "00000000011111", 269 to 277=> "00000000011110", 278 to 287=> "00000000011101", 
    288 to 297=> "00000000011100", 298 to 309=> "00000000011011", 310 to 321=> "00000000011010", 
    322 to 334=> "00000000011001", 335 to 348=> "00000000011000", 349 to 364=> "00000000010111", 
    365 to 381=> "00000000010110", 382 to 399=> "00000000010101", 400 to 420=> "00000000010100", 
    421 to 442=> "00000000010011", 443 to 468=> "00000000010010", 469 to 496=> "00000000010001", 
    497 to 528=> "00000000010000", 529 to 564=> "00000000001111", 565 to 606=> "00000000001110", 
    607 to 655=> "00000000001101", 656 to 712=> "00000000001100", 713 to 780=> "00000000001011", 
    781 to 862=> "00000000001010", 863 to 963=> "00000000001001", 964 to 1092=> "00000000001000", 
    1093 to 1260=> "00000000000111", 1261 to 1489=> "00000000000110", 1490 to 1532=> "00000000000101" );


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

entity tkobjalgo_find_vtx_inversion_table1 is
    generic (
        DataWidth : INTEGER := 14;
        AddressRange : INTEGER := 1533;
        AddressWidth : INTEGER := 11);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of tkobjalgo_find_vtx_inversion_table1 is
    component tkobjalgo_find_vtx_inversion_table1_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    tkobjalgo_find_vtx_inversion_table1_rom_U :  component tkobjalgo_find_vtx_inversion_table1_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;


