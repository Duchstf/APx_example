-- libraries
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use ieee.std_logic_textio.all;
-- Standard textIO functions
library std; use std.textio.all;

entity tb_p_T is
end tb_p_T;

architecture behavior of tb_p_T is
	signal ap_clk : std_logic;
	signal ap_rst : std_logic;
	signal ap_start : std_logic;
	signal in_val_V : std_logic_vector (13 downto 0);
	signal ap_done : std_logic;
	signal ap_idle : std_logic;
	signal ap_ready : std_logic;
	signal recipro_V : std_logic_vector (12 downto 0);
	signal recipro_V_ap_vld : std_logic;

begin

-- Instantiate the Unit Under Test (UUT)
	uut : entity work.p_T port map (
		ap_clk => ap_clk,
		ap_rst => ap_rst,
		ap_start => ap_start,
		in_val_V => in_val_V,
		ap_done => ap_done,
		ap_idle => ap_idle,
		ap_ready => ap_ready,
		recipro_V => recipro_V,
		recipro_V_ap_vld => recipro_V_ap_vld
	);

	-- Stimulus process
	stim_proc : process
		file InF: TEXT open READ_MODE is "../../../../../input_text.txt";
		file OutF: TEXT open WRITE_MODE is "../../../../../output_text.txt";
		variable ILine: LINE; variable OLine: LINE; variable TimeWhen: TIME;
		variable textio_ap_clk,textio_ap_rst,textio_ap_start: bit_vector(0 downto 0);
		variable textio_in_val_V: bit_vector(13 downto 0);

	begin
		while not ENDFILE(InF) loop
			READLINE (InF, ILine); -- Read individual lines from input file.
			-- Read from line.
			READ (ILine, TimeWhen);
			READ (ILine, textio_ap_clk);
			READ (ILine, textio_ap_rst);
			READ (ILine, textio_ap_start);
			READ (ILine, textio_in_val_V);

		-- insert stimulus here
			wait for TimeWhen - NOW; -- Wait until one time step

			ap_clk <= to_stdlogicvector(textio_ap_clk)(0);
			ap_rst <= to_stdlogicvector(textio_ap_rst)(0);
			ap_start <= to_stdlogicvector(textio_ap_start)(0);
			in_val_V <= to_stdlogicvector(textio_in_val_V)(13 downto 0);

			-- Export output state to file.
			write (OLine, TimeWhen);
			write (OLine, string'("  "));
			write (OLine, ap_done);
			write (OLine, string'("  "));
			write (OLine, ap_idle);
			write (OLine, string'("  "));
			write (OLine, ap_ready);
			write (OLine, string'("  "));
			write (OLine, recipro_V(12 downto 0));
			write (OLine, string'("  "));
			write (OLine, recipro_V_ap_vld);

			writeline (OutF, OLine); -- write all output variables in file

		end loop;

		wait for 10 NS;
		file_close(InF);
		file_close(OutF);
		wait;
	end process;
end behavior;
