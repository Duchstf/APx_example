-- libraries
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use ieee.std_logic_textio.all;
-- Standard textIO functions
library std; use std.textio.all;

entity tb_track_conv is
end tb_track_conv;

architecture behavior of tb_track_conv is
	signal clk : std_logic;
	signal rst : std_logic;
	signal track_word_in : std_logic_vector (95 downto 0);
	signal ap_start : std_logic;
	signal ap_done : std_logic;
	signal ap_idle : std_logic;
	signal ap_ready : std_logic;
	signal track_word_converted : std_logic_vector (95 downto 0);
	signal ap_vld : std_logic;

begin

-- Instantiate the Unit Under Test (UUT)
	uut : entity work.track_conv port map (
		clk => clk,
		rst => rst,
		track_word_in => track_word_in,
		ap_start => ap_start,
		ap_done => ap_done,
		ap_idle => ap_idle,
		ap_ready => ap_ready,
		track_word_converted => track_word_converted,
		ap_vld => ap_vld
	);

	-- Stimulus process
	stim_proc : process
		file InF: TEXT open READ_MODE is "../../../../../../lib_hdl/hdl/tb/track_conv/input_text.txt";
		file OutF: TEXT open WRITE_MODE is "../../../../../../lib_hdl/hdl/tb/track_conv/output_text.txt";
		variable ILine: LINE; variable OLine: LINE; variable TimeWhen: TIME;
		variable textio_clk,textio_rst,textio_ap_start: bit_vector(0 downto 0);
		variable textio_track_word_in: bit_vector(95 downto 0);

	begin
		while not ENDFILE(InF) loop
			READLINE (InF, ILine); -- Read individual lines from input file.
			-- Read from line.
			READ (ILine, TimeWhen);
			READ (ILine, textio_clk);
			READ (ILine, textio_rst);
			READ (ILine, textio_track_word_in);
			READ (ILine, textio_ap_start);

		-- insert stimulus here
			wait for TimeWhen - NOW; -- Wait until one time step

			clk <= to_stdlogicvector(textio_clk)(0);
			rst <= to_stdlogicvector(textio_rst)(0);
			track_word_in <= to_stdlogicvector(textio_track_word_in)(95 downto 0);
			ap_start <= to_stdlogicvector(textio_ap_start)(0);

			-- Export output state to file.
			write (OLine, TimeWhen);
			write (OLine, string'("  "));
			write (OLine, ap_done);
			write (OLine, string'("  "));
			write (OLine, ap_idle);
			write (OLine, string'("  "));
			write (OLine, ap_ready);
			write (OLine, string'("  "));
			write (OLine, track_word_converted(95 downto 0));
			write (OLine, string'("  "));
			write (OLine, ap_vld);

			writeline (OutF, OLine); -- write all output variables in file

		end loop;

		wait for 10 NS;
		file_close(InF);
		file_close(OutF);
		wait;
	end process;
end behavior;
