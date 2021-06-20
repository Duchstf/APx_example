-- libraries
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use ieee.std_logic_textio.all;
-- Standard textIO functions
library std; use std.textio.all;

entity tb_eta is
end tb_eta;

architecture behavior of tb_eta is
	signal ap_clk : std_logic;
	signal ap_rst : std_logic;
	signal ap_start : std_logic;
	signal indexTanLambda_V : std_logic_vector (14 downto 0);
	signal ap_done : std_logic;
	signal ap_idle : std_logic;
	signal ap_ready : std_logic;
	signal out_eta_V : std_logic_vector (14 downto 0);
	signal out_eta_V_ap_vld : std_logic;

begin

-- Instantiate the Unit Under Test (UUT)
	uut : entity work.eta port map (
		ap_clk => ap_clk,
		ap_rst => ap_rst,
		ap_start => ap_start,
		indexTanLambda_V => indexTanLambda_V,
		ap_done => ap_done,
		ap_idle => ap_idle,
		ap_ready => ap_ready,
		out_eta_V => out_eta_V,
		out_eta_V_ap_vld => out_eta_V_ap_vld
	);

	-- Stimulus process
	stim_proc : process
		file InF: TEXT open READ_MODE is "../../../../../input_text.txt";
		file OutF: TEXT open WRITE_MODE is "../../../../../output_text.txt";
		variable ILine: LINE; variable OLine: LINE; variable TimeWhen: TIME;
		variable textio_ap_clk,textio_ap_rst,textio_ap_start: bit_vector(0 downto 0);
		variable textio_indexTanLambda_V: bit_vector(14 downto 0);

	begin
		while not ENDFILE(InF) loop
			READLINE (InF, ILine); -- Read individual lines from input file.
			-- Read from line.
			READ (ILine, TimeWhen);
			READ (ILine, textio_ap_clk);
			READ (ILine, textio_ap_rst);
			READ (ILine, textio_ap_start);
			READ (ILine, textio_indexTanLambda_V);

		-- insert stimulus here
			wait for TimeWhen - NOW; -- Wait until one time step

			ap_clk <= to_stdlogicvector(textio_ap_clk)(0);
			ap_rst <= to_stdlogicvector(textio_ap_rst)(0);
			ap_start <= to_stdlogicvector(textio_ap_start)(0);
			indexTanLambda_V <= to_stdlogicvector(textio_indexTanLambda_V)(14 downto 0);

			-- Export output state to file.
			write (OLine, TimeWhen);
			write (OLine, string'("  "));
			write (OLine, ap_done);
			write (OLine, string'("  "));
			write (OLine, ap_idle);
			write (OLine, string'("  "));
			write (OLine, ap_ready);
			write (OLine, string'("  "));
			write (OLine, out_eta_V(14 downto 0));
			write (OLine, string'("  "));
			write (OLine, out_eta_V_ap_vld);

			writeline (OutF, OLine); -- write all output variables in file

		end loop;

		wait for 10 NS;
		file_close(InF);
		file_close(OutF);
		wait;
	end process;
end behavior;
