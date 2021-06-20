-- ==============================================================
-- Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2019.2 (64-bit)
-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- ==============================================================
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

entity p_T_lut_V_0_rom is 
    generic(
             DWIDTH     : integer := 10; 
             AWIDTH     : integer := 9; 
             MEM_SIZE    : integer := 512
    ); 
    port (
          addr0      : in std_logic_vector(AWIDTH-1 downto 0); 
          ce0       : in std_logic; 
          q0         : out std_logic_vector(DWIDTH-1 downto 0);
          clk       : in std_logic
    ); 
end entity; 


architecture rtl of p_T_lut_V_0_rom is 

signal addr0_tmp : std_logic_vector(AWIDTH-1 downto 0); 
type mem_array is array (0 to MEM_SIZE-1) of std_logic_vector (DWIDTH-1 downto 0); 
signal mem : mem_array := (
    0 to 11=> "1111111111", 12 => "1111100100", 13 => "1110101011", 14 => "1101111000", 
    15 => "1101001011", 16 => "1100100010", 17 => "1011111100", 18 => "1011011010", 
    19 => "1010111011", 20 => "1010011111", 21 => "1010000101", 22 => "1001101100", 
    23 => "1001010110", 24 => "1001000001", 25 => "1000101101", 26 => "1000011011", 
    27 => "1000001010", 28 => "0111111010", 29 => "0111101011", 30 => "0111011101", 
    31 => "0111001111", 32 => "0111000010", 33 => "0110110110", 34 => "0110101011", 
    35 => "0110100000", 36 => "0110010110", 37 => "0110001100", 38 => "0110000011", 
    39 => "0101111010", 40 => "0101110001", 41 => "0101101001", 42 => "0101100010", 
    43 => "0101011010", 44 => "0101010011", 45 => "0101001100", 46 => "0101000110", 
    47 => "0100111111", 48 => "0100111001", 49 => "0100110011", 50 => "0100101110", 
    51 => "0100101000", 52 => "0100100011", 53 => "0100011110", 54 => "0100011001", 
    55 => "0100010100", 56 => "0100010000", 57 => "0100001011", 58 => "0100000111", 
    59 => "0100000011", 60 => "0011111111", 61 => "0011111011", 62 => "0011110111", 
    63 => "0011110100", 64 => "0011110000", 65 => "0011101101", 66 => "0011101001", 
    67 => "0011100110", 68 => "0011100011", 69 => "0011100000", 70 => "0011011101", 
    71 => "0011011010", 72 => "0011010111", 73 => "0011010100", 74 => "0011010001", 
    75 => "0011001111", 76 => "0011001100", 77 => "0011001010", 78 => "0011000111", 
    79 => "0011000101", 80 => "0011000011", 81 => "0011000000", 82 => "0010111110", 
    83 => "0010111100", 84 => "0010111010", 85 => "0010111000", 86 => "0010110110", 
    87 => "0010110100", 88 => "0010110010", 89 => "0010110000", 90 => "0010101110", 
    91 => "0010101100", 92 => "0010101010", 93 => "0010101001", 94 => "0010100111", 
    95 => "0010100101", 96 => "0010100100", 97 => "0010100010", 98 => "0010100000", 
    99 => "0010011111", 100 => "0010011101", 101 => "0010011100", 102 => "0010011010", 
    103 => "0010011001", 104 => "0010011000", 105 => "0010010110", 106 => "0010010101", 
    107 => "0010010011", 108 => "0010010010", 109 => "0010010001", 110 => "0010010000", 
    111 => "0010001110", 112 => "0010001101", 113 => "0010001100", 114 => "0010001011", 
    115 => "0010001010", 116 => "0010001000", 117 => "0010000111", 118 => "0010000110", 
    119 => "0010000101", 120 => "0010000100", 121 => "0010000011", 122 => "0010000010", 
    123 => "0010000001", 124 => "0010000000", 125 => "0001111111", 126 => "0001111110", 
    127 => "0001111101", 128 => "0001111100", 129 => "0001111011", 130 => "0001111010", 
    131 => "0001111001", 132 to 133=> "0001111000", 134 => "0001110111", 135 => "0001110110", 
    136 => "0001110101", 137 => "0001110100", 138 to 139=> "0001110011", 140 => "0001110010", 
    141 => "0001110001", 142 => "0001110000", 143 to 144=> "0001101111", 145 => "0001101110", 
    146 to 147=> "0001101101", 148 => "0001101100", 149 => "0001101011", 150 to 151=> "0001101010", 
    152 => "0001101001", 153 to 154=> "0001101000", 155 => "0001100111", 156 to 157=> "0001100110", 
    158 to 159=> "0001100101", 160 => "0001100100", 161 to 162=> "0001100011", 163 to 164=> "0001100010", 
    165 => "0001100001", 166 to 167=> "0001100000", 168 to 169=> "0001011111", 170 to 171=> "0001011110", 
    172 to 173=> "0001011101", 174 to 175=> "0001011100", 176 to 177=> "0001011011", 178 to 179=> "0001011010", 
    180 to 181=> "0001011001", 182 to 183=> "0001011000", 184 to 185=> "0001010111", 186 to 187=> "0001010110", 
    188 to 190=> "0001010101", 191 to 192=> "0001010100", 193 to 194=> "0001010011", 195 to 197=> "0001010010", 
    198 to 199=> "0001010001", 200 to 202=> "0001010000", 203 to 205=> "0001001111", 206 to 207=> "0001001110", 
    208 to 210=> "0001001101", 211 to 213=> "0001001100", 214 to 216=> "0001001011", 217 to 219=> "0001001010", 
    220 to 222=> "0001001001", 223 to 225=> "0001001000", 226 to 228=> "0001000111", 229 to 232=> "0001000110", 
    233 to 235=> "0001000101", 236 to 239=> "0001000100", 240 to 242=> "0001000011", 243 to 246=> "0001000010", 
    247 to 250=> "0001000001", 251 to 254=> "0001000000", 255 to 258=> "0000111111", 259 to 262=> "0000111110", 
    263 to 267=> "0000111101", 268 to 271=> "0000111100", 272 to 276=> "0000111011", 277 to 281=> "0000111010", 
    282 to 286=> "0000111001", 287 to 291=> "0000111000", 292 to 297=> "0000110111", 298 to 302=> "0000110110", 
    303 to 308=> "0000110101", 309 to 314=> "0000110100", 315 to 321=> "0000110011", 322 to 327=> "0000110010", 
    328 to 334=> "0000110001", 335 to 341=> "0000110000", 342 to 349=> "0000101111", 350 to 356=> "0000101110", 
    357 to 365=> "0000101101", 366 to 373=> "0000101100", 374 to 382=> "0000101011", 383 to 391=> "0000101010", 
    392 to 401=> "0000101001", 402 to 411=> "0000101000", 412 to 422=> "0000100111", 423 to 434=> "0000100110", 
    435 to 446=> "0000100101", 447 to 458=> "0000100100", 459 to 472=> "0000100011", 473 to 486=> "0000100010", 
    487 to 501=> "0000100001", 502 to 511=> "0000100000" );


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

entity p_T_lut_V_0 is
    generic (
        DataWidth : INTEGER := 10;
        AddressRange : INTEGER := 512;
        AddressWidth : INTEGER := 9);
    port (
        reset : IN STD_LOGIC;
        clk : IN STD_LOGIC;
        address0 : IN STD_LOGIC_VECTOR(AddressWidth - 1 DOWNTO 0);
        ce0 : IN STD_LOGIC;
        q0 : OUT STD_LOGIC_VECTOR(DataWidth - 1 DOWNTO 0));
end entity;

architecture arch of p_T_lut_V_0 is
    component p_T_lut_V_0_rom is
        port (
            clk : IN STD_LOGIC;
            addr0 : IN STD_LOGIC_VECTOR;
            ce0 : IN STD_LOGIC;
            q0 : OUT STD_LOGIC_VECTOR);
    end component;



begin
    p_T_lut_V_0_rom_U :  component p_T_lut_V_0_rom
    port map (
        clk => clk,
        addr0 => address0,
        ce0 => ce0,
        q0 => q0);

end architecture;

