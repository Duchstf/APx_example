--==========================================================================
-- CU Boulder
-------------------------------------------------------------------------------
--! @file
--! @brief Test bench for the algoTopWrapper using playback/capture BRAM pattern files. 
--! @author Glein
--! @date 2019-12-10
--! @version v.1.0
--=============================================================================

--! Standard library
library ieee;
--! Standard package
use ieee.std_logic_1164.all;
--! Signed/unsigned calculations
use ieee.numeric_std.all;
--! Math real
use ieee.math_real.all;
--! TextIO
use ieee.std_logic_textio.all;
--! Standard functions
library std;
--! Standard TextIO functions
use std.textio.all;

--! Xilinx library
library unisim;
--! Xilinx package
use unisim.vcomponents.all;

--! User packages
use work.StdRtlPkg.all;    --! From surf/base/general/rtl submodule
use work.AxiStreamPkg.all; --! From surf/axi/axi-stream submodule
use work.PrjSpecPkg.all;   --! From top/rtl/PrjSpecPkg.vhd

--! @brief TB
entity tb_algoTopWrapper is
end tb_algoTopWrapper;

--! @brief TB
architecture behavior of tb_algoTopWrapper is
	-- ########################### Constant Definitions ###########################
	-- ############ Please change the constants in this section ###################
	--constant INPUT_FILE     : string := "../../../../../../submodules/apx-fs-alpha/algoSim/cnt_SBoff.txt"; --! Input file
	--constant INPUT_FILE     : string := "../../../../../../submodules/apx-fs-alpha/algoSim/cnt_SBon.txt"; --! Input file
	constant INPUT_FILE  : string := "../../../../../../top/sim/trackerRegion_alltracks_sectors_2x9_TTbar_PU200_7Events_0_plus2x18cnt.txt"; --! Input file
	constant OUTPUT_FILE : string := "../../../../../../top/sim/result_0_plus2x18cnt.txt"; --! Output file
	--constant INPUT_FILE  : string := "../../../../../../top/sim/trackerRegion_alltracks_sectors_2x9_TTbar_PU200_7Events_1.txt"; --! Input file
	--constant OUTPUT_FILE : string := "../../../../../../top/sim/result_1.txt"; --! Output file
	--constant OUTPUT_FILE    : string  := "../../../../../../submodules/apx-fs-alpha/algoSim/result.txt"; --! Output file
	constant N_ADD_WR_LINES : integer := 250;                     --! Number of additional lines for the output file 
	                                                              --! incl. number of header and comment lines of the input file
	constant CLK_PERIOD        : time    := 3.125 ns;             --! 320.0 MHz
	constant SIG_RST_HOLD      : integer := 120;             	  --! Reset hold: Long time because of the sync. rst generation in CDC and start-up of 2nd clk
	constant SIG_START_D       : integer := 10;             	  --! Start delay after rst
	constant DEBUG             : boolean := true;                 --! Debug off/on
	constant N_INPUT_STREAMS   : integer := L1T_IN_STREAM_CNT_C;  --! Number of input streams
	constant N_OUTPUT_STREAMS  : integer := L1T_OUT_STREAM_CNT_C; --! Number of output streams
	constant MAX_LIMKSEQ_DELAY : integer := 100;                  --! Maximum possible input LinkSeq delay
	constant LIMKSEQ_OFFSET    : integer := 8;                    --! Offset for string: #LinkSeq

	-- ########################### Types ###########################
	type t_int_array       is array (natural range <>) of integer; --! Interger array type
	type t_arr_axiStream   is array (natural range <>) of AxiStreamMasterArray(0 to N_INPUT_STREAMS-1); --! Array of AXI streams type

	-- ########################### Signals ###########################
	-- Algo Control/Status Signals
	signal algoClk   : sl := '0';
	signal algoRst   : sl := '1';
	signal algoStart : sl := '0';
	signal algoDone  : sl := '0';
	signal algoIdle  : sl := '0';
	signal algoReady : sl := '0';
	-- AXI-Stream In/Out Ports
	signal axiStreamIn  : AxiStreamMasterArray(0 to N_INPUT_STREAMS-1);
	signal axiStreamOut : AxiStreamMasterArray(0 to N_OUTPUT_STREAMS-1);

begin
	-- ########################### Assertion ###########################

	-- ########################### Instantiation ###########################
	-- Instantiate the Unit Under Test (UUT)
	uut : entity work.algoTopWrapper
		generic map(
			N_INPUT_STREAMS  => N_INPUT_STREAMS,
			N_OUTPUT_STREAMS => N_OUTPUT_STREAMS
		)
		port map(
			-- Algo Control/Status Signals
			algoClk   => algoClk,
			algoRst   => algoRst,
			algoStart => algoStart,
			algoDone  => algoDone,
			algoIdle  => algoIdle,
			algoReady => algoReady,
			-- AXI-Stream In/Out Ports
			axiStreamIn  => axiStreamIn,
			axiStreamOut => axiStreamOut );

	-- ########################### Port Map ##########################

	-- ########################### Processes ###########################
	--! @brief Clock process ---------------------------------------
	CLK_process : process
	begin
		algoClk <= '0';
		wait for CLK_PERIOD/2;
		algoClk <= '1';
		wait for CLK_PERIOD/2;
	end process CLK_process;

	--! @brief Signaling process ---------------------------------------
	sig_proc : process
	begin
		-- Start-up ------------------------------------------------------------------------
		algoRst <= '1';          -- Hold reset state
		wait for SIG_RST_HOLD*CLK_PERIOD; -- Long time because of the sync. rst generation in CDC and start-up of 2nd clk
		algoRst <= '0';
		wait for SIG_START_D*CLK_PERIOD;
		algoStart <= '1';
		-- Add more assigments but sync. with text_proc ------------------------------------
		-- ...
		wait;
	end process sig_proc;

	--! @brief TextIO process ---------------------------------------
	text_proc : process
		-- Files
		file InF  : text open READ_MODE is INPUT_FILE;             -- text - a file of character strings
		file OutF : text open WRITE_MODE is OUTPUT_FILE;           -- text - a file of character strings
		-- TextIO
		variable ILine        : line;                              -- line - one string from a text file
		variable ILine_length : integer;                           -- Length of ILine
		variable OLine        : line;                              -- line - one string from a text 
		variable s            : string(1 to 2000);                 -- String for parsing, >= max characters per line
		variable mode         : integer;                           -- Mode: 0-Sideband OFF, 1-Sideband ON
		variable LinkSeq_arr  : t_int_array(0 to N_INPUT_STREAMS-1); -- Array of link sequence delay
		variable line_cnt     : std_logic_vector(15 downto 0);     -- Line counter
		variable c            : character;                         -- Character
		variable i_rd_row     : integer;                           -- Read row index
		variable i_rd_col     : integer;                           -- Read column index
		variable i_wr_row     : integer;                           -- Write row index
		variable i_wr_col     : integer;                           -- Write column index
		-- AXI-Stream In/Out Ports
		variable v_axiStreamIn        : AxiStreamMasterArray(0 to N_INPUT_STREAMS-1) := (others => AXI_STREAM_MASTER_INIT_C);        -- Streams read from file
		variable v_axiStreamIn_arr    : t_arr_axiStream(0 to MAX_LIMKSEQ_DELAY) := (others => (others => AXI_STREAM_MASTER_INIT_C)); -- Delayed array of streams
		variable v_axiStreamIn_SB     : std_logic_vector(7 downto 0); -- Sideband vector
		variable v_axiStreamOut_SB    : std_logic_vector(7 downto 0); -- Sideband vector
	begin
		wait for (SIG_RST_HOLD+SIG_START_D)*CLK_PERIOD; -- Wait for start-up
		-- Read file header --------------------------------------------------------------
		readline (InF, ILine);                                                       -- Read 1. line from input file
		i_rd_row := 1;                                                               -- Init row index
		i_wr_row := 0;                                                               -- Init row index
		l_header : while ILine.all(1)='#' loop                                       -- Read the header to determine the mode and link sequence
			ILine_length := ILine'length;                                              -- Needed for access after read()
			assert ILine_length < s'length report "s'length too small" severity error; -- Make sure s is big enough
			read(ILine, s(1 to ILine'length));                                         -- Read line as string
			if s(1 to ILine_length)="#Sideband ON" then                                -- Mode1: Sideband ON
				mode := 1;
				if DEBUG=true then assert false report "Mode: " & integer'image(mode) severity note; end if;
			elsif s(1 to ILine_length)="#Sideband OFF" then -- Mode0: Sideband OFF
				mode := 0;
				if DEBUG=true then assert false report "Mode: " & integer'image(mode) severity note; end if;
			end if;
			if s(1 to LIMKSEQ_OFFSET)="#LinkSeq" then -- Read in LinkSeq
				if DEBUG=true then assert false report "" & s(1 to ILine_length) severity note; end if;
				write(ILine, s(1 to ILine_length)); -- Write to tmp line buffer, which is easier to read than the string
				read(ILine, s(1 to LIMKSEQ_OFFSET)); -- Dummy read header
				l_LinkSeq : for i_LinkNum in 0 to N_INPUT_STREAMS-1 loop -- Get delays for links
					read(ILine, LinkSeq_arr(i_LinkNum)); -- Read delay
					if DEBUG=true then assert false report "LinkNum = " & integer'image(i_LinkNum) & " with LinkSeq = " & integer'image(LinkSeq_arr(i_LinkNum)) severity note; end if;
					-- Make sure the delay is big enough
					assert LinkSeq_arr(i_LinkNum) < MAX_LIMKSEQ_DELAY report "MAX_LIMKSEQ_DELAY is smaller than read link delay, which is " & integer'image(LinkSeq_arr(i_LinkNum)) severity error;
				end loop l_LinkSeq;
			else
				LinkSeq_arr := (others => 0); -- No link delay
			end if;
			readline (InF, ILine); -- Read individual lines from input file
			i_rd_row := i_rd_row+1;
		end loop l_header;
		-- Write file header --------------------------------------------------------------
		write(OLine, string'("#Counter")); write(OLine, string'(" "));
		write(OLine, string'("algoRst")); write(OLine, string'(" "));
		write(OLine, string'("algoStart")); write(OLine, string'(" "));
		write(OLine, string'("algoDone")); write(OLine, string'(" "));
		write(OLine, string'("algoIdle")); write(OLine, string'(" "));
		write(OLine, string'("algoReady")); write(OLine, string'("                  "));
		l_wr_header : for i_wr_col in 0 to N_OUTPUT_STREAMS-1 loop -- Write link labels
			if i_wr_col < 10 then
				write(OLine, string'("Link_0")); write(OLine, i_wr_col); write(OLine, string'("                  "));
			else
				write(OLine, string'("Link_")); write(OLine, i_wr_col); write(OLine, string'("                  "));
			end if;
		end loop l_wr_header;
		writeline (OutF, OLine); -- Write line
		-- All other reads, assigments, and writes ---------------------------------------
		--l_rd_row : for i in 0 to 1 loop -- Debug
		l_rd_row : loop
			ILine_length := ILine'length;                                              -- Needed for access after read()
			assert ILine_length < s'length report "s'length too small" severity error; -- Make sure s is big enough
			s := (others => ' ');                                                      -- Make sure that the previous line is overwritten
			if ILine_length > 0 then                                                   -- Check that the Iline is not empty
				if ILine.all(1)='#' then                                                 -- Check if the line starts with a #
					read(ILine, s(1 to ILine'length));                                     -- Read line as string
				else
					read(ILine, c); -- Read dummy char
					if DEBUG=true then assert false report "c0: " & c severity note; end if;
					read(ILine, c); -- Read dummy char
					if DEBUG=true then assert false report "c1: " & c severity note; end if;
					hread(ILine, line_cnt); -- Read value as hex slv
					if DEBUG=true then assert false report "line_cnt in decimal = " & integer'image(to_integer(unsigned(line_cnt))) severity note; end if;
					i_rd_col := 0;                        -- Init column index
					l_rd_col : while ILine'length>0 loop  -- Loop over the columns 
						read(ILine, c);                     -- Read dummy chars ...
						if c='x' then                       -- ... until the next x
							if (mode=1) then                  --Sideband ON
								hread(ILine, v_axiStreamIn_SB); -- Read value as hex slv
								read(ILine, c);                 -- Read dummy char
								while (not (c='x')) loop        -- Read dummy chars until the next x
									read(ILine, c);
								end loop;
							end if;
							hread(ILine, v_axiStreamIn(i_rd_col).tData(63 downto 0)); -- Read value as hex slv
							v_axiStreamIn_arr(LinkSeq_arr(i_rd_col))(i_rd_col) := v_axiStreamIn(i_rd_col); -- Assign according to delay
							if (mode=0) then                  -- Sideband OFF
								v_axiStreamIn_arr(LinkSeq_arr(i_rd_col))(i_rd_col).tValid := '1';
							-- Add more sideband information if needed
							elsif (mode=1) then               --Sideband ON
								v_axiStreamIn_arr(LinkSeq_arr(i_rd_col))(i_rd_col).tValid            := v_axiStreamIn_SB(0);
								v_axiStreamIn_arr(LinkSeq_arr(i_rd_col))(i_rd_col).tLast             := v_axiStreamIn_SB(1);
								v_axiStreamIn_arr(LinkSeq_arr(i_rd_col))(i_rd_col).tUser(4 downto 0) := v_axiStreamIn_SB(6 downto 2);
								--Rsv <= v_axiStreamIn_SB(7);
								if DEBUG=true then if (i_rd_col=0) then assert false report "v_axiStreamIn_SB (of i_rd_col=" & integer'image(i_rd_col) & ") in decimal at accoring delay vaule = " & integer'image(to_integer(unsigned(v_axiStreamIn_SB))) severity note; end if; end if;
							end if;
							if DEBUG=true then if (i_rd_col=0) then assert false report "v_axiStreamIn_arr(0))(" & integer'image(i_rd_col) & ").tData(63 downto 0) in decimal = " & integer'image(to_integer(unsigned(v_axiStreamIn_arr(0)(i_rd_col).tData(63 downto 0)))) severity note; end if; end if;
							i_rd_col := i_rd_col+1;
						end if;
					end loop l_rd_col;
				end if;
			end if;
			-- Assign variable to signal each line -----------------------------------------
			axiStreamIn   <= v_axiStreamIn_arr(0);
			v_axiStreamIn := (others => AXI_STREAM_MASTER_INIT_C);
			if s(1) /= '#' then -- Check if this is a comment line
				v_axiStreamIn_arr(0 to MAX_LIMKSEQ_DELAY-1) := v_axiStreamIn_arr(1 to MAX_LIMKSEQ_DELAY); -- Update array
				wait for CLK_PERIOD;
			end if;
			-- Write file ------------------------------------------------------------------
			write(OLine, string'("0x")); hwrite(OLine, std_logic_vector(to_unsigned(i_wr_row,line_cnt'length))); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoRst); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoStart); write(OLine, string'("      "));
			write(OLine, string'("0b")); write(OLine, algoDone); write(OLine, string'("      "));
			write(OLine, string'("0b")); write(OLine, algoIdle); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoReady); write(OLine, string'("  "));
			l_wr_col : for i_wr_col_loop in 0 to N_OUTPUT_STREAMS-1 loop
				-- Compose sideband: Rsv & [FFO_Lock Link_Lock CHKSM_Err FFO SOF] & tLast & tVaild
				v_axiStreamOut_SB := '0' & axiStreamOut(i_wr_col_loop).tUser(4 downto 0) & axiStreamOut(i_wr_col_loop).tLast & axiStreamOut(i_wr_col_loop).tValid;
				write(OLine, string'("0x")); hwrite(OLine, v_axiStreamOut_SB); write(OLine, string'(" "));
				write(OLine, string'("0x")); hwrite(OLine, axiStreamOut(i_wr_col_loop).tData(63 downto 0)); write(OLine, string'("  "));
			end loop l_wr_col;
			writeline (OutF, OLine); -- write all output variables to line
			i_wr_row := i_wr_row+1;
			-- Check EOF (input) ----------------------------------------------------------
			if endfile(InF) then
				assert false report "End of file encountered; exiting." severity NOTE;
				exit;
			end if;
			readline (InF, ILine); -- Read individual lines from input file
			i_rd_row := i_rd_row+1;
		end loop l_rd_row;
		-- Additional lines for the output file -----------------------------------------
		l_wr_add_row : for i_wr_add_row in 1 to N_ADD_WR_LINES loop
			wait for CLK_PERIOD;
			write(OLine, string'("0x")); hwrite(OLine, std_logic_vector(to_unsigned(i_wr_row,line_cnt'length))); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoRst); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoStart); write(OLine, string'("      "));
			write(OLine, string'("0b")); write(OLine, algoDone); write(OLine, string'("      "));
			write(OLine, string'("0b")); write(OLine, algoIdle); write(OLine, string'("       "));
			write(OLine, string'("0b")); write(OLine, algoReady); write(OLine, string'("  "));
			l_wr_col_add : for i_wr_col_loop in 0 to N_OUTPUT_STREAMS-1 loop
				-- Compose sideband: Rsv & [FFO_Lock Link_Lock CHKSM_Err FFO SOF] & tLast & tVaild
				v_axiStreamOut_SB := '0' & axiStreamOut(i_wr_col_loop).tUser(4 downto 0) & axiStreamOut(i_wr_col_loop).tLast & axiStreamOut(i_wr_col_loop).tValid;
				write(OLine, string'("0x")); hwrite(OLine, v_axiStreamOut_SB); write(OLine, string'(" "));
				write(OLine, string'("0x")); hwrite(OLine, axiStreamOut(i_wr_col_loop).tData(63 downto 0)); write(OLine, string'("  "));
			end loop l_wr_col_add;
			writeline (OutF, OLine); -- write all output variables to line
			i_wr_row := i_wr_row+1;
		end loop l_wr_add_row;
		-- Report stats -----------------------------------------------------------------
		assert false report "Read " & integer'image(i_rd_row) & " rows (incl. header and comments) for " & integer'image(i_rd_col) & " links " severity note;
		assert false report "Wrote " & integer'image(i_wr_row) & " rows (incl. header) for " & integer'image(N_OUTPUT_STREAMS-1) & " links " severity note;

		wait for CLK_PERIOD;
		file_close(InF);
		file_close(OutF);
		assert false report "Simulation finished!" severity FAILURE;
	end process text_proc;
end behavior;
