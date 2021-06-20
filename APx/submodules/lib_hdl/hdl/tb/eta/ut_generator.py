import sys
from collections import OrderedDict

# variables to change
top = 'eta' # name of module under test; test bench is named 'tb_{}'.format(top)

time_elapsed = 0.0
t_step = float(sys.argv[1])			#time step for each iteration
duration = int(sys.argv[2]) + 2		#the number of iterations generated									#total time = t_step * duration (in ns)

input_vars = OrderedDict() # stores all the variables from the design

# keep the variables in the same order as the design file
#system Clk and reset
input_vars['ap_clk'] 			= 1  #--! Clock
input_vars['ap_rst'] 			= 1  #--! Reset
input_vars['ap_start'] 			= 1  #--! signal
input_vars['indexTanLambda_V'] 	= '000000000000000'  #--! input tan(lambda)

# stores output variables for the top.vhd
# make sure that they are stored in order as the top file
# enter std_logic variables as strings
# and std_logic_vectors as tuples where the first argument is the variable name and the second is the number of bits 
output_vars = [
	"ap_done", "ap_idle", "ap_ready", ("out_eta_V", 15), "out_eta_V_ap_vld"
]

# function used to flip a bit value in a vector
def flip_vector_bit(vector, msb, value):
	# vector name (str)
	# the bit number (first bit is leftmost) (int)
	# the new value to flip to
	vector_str = input_vars[vector]
	new_vector = vector_str[:msb-1] + str(value) + vector_str[msb:]
	return new_vector

# create the new line using the current states of the variables
def create_new_line():
	# add a case for python 3
	new_line = "{} ns".format(time_elapsed)
	for variable, val in input_vars.iteritems():
		new_line = new_line + "  {}".format(val)

	new_line = new_line + '\n'

	return new_line

# creates the input text file
with open('input_text.txt', 'w') as f:

	c_320MHZ_CLK = 0.0 #clock counter

	for i in range(1, duration):
		time_elapsed = round((t_step * i) - t_step, 4)

		new_line = create_new_line()
		f.write(new_line)

		#CPU_RESET is on for 10 ns
		if time_elapsed >= 10.0:
			input_vars['ap_rst'] = 0
		else:
			input_vars['ap_rst'] = 1

		#320MHz clock
		if c_320MHZ_CLK + t_step > 3.125/2:
			c_320MHZ_CLK = 0
			input_vars['ap_clk'] = 0 if input_vars['ap_clk'] == 1 else 1
		else:
			c_320MHZ_CLK += t_step

		# #250MHz clock
		# if c_250MHZ_CLK > 2.000000:
		# 	c_250MHZ_CLK = t_step
		# 	tmp = input_vars['PIN_250MHZ_CLK1_P'] #flip clk's
		# 	input_vars['PIN_250MHZ_CLK1_P'] = input_vars['PIN_250MHZ_CLK1_N']
		# 	input_vars['PIN_250MHZ_CLK1_N'] = tmp
		# else:
		# 	c_250MHZ_CLK += t_step

		# #625MHz clock
		# if c_625MHZ_CLK > 0.800000:
		# 	c_625MHZ_CLK = t_step
		# 	tmp = input_vars['PHY1_SGMII_CLK_P'] #flip clk's
		# 	input_vars['PHY1_SGMII_CLK_P'] = input_vars['PHY1_SGMII_CLK_N']
		# 	input_vars['PHY1_SGMII_CLK_N'] = tmp
		# else:
		# 	c_625MHZ_CLK += t_step

		# #156.25MHz clock
		# if c_156MHZ_CLK > 3.200000:
		# 	c_156MHZ_CLK = t_step
		# 	tmp = input_vars['MGT_SI570_CLOCK3_C_P'] #flip clk's
		# 	input_vars['MGT_SI570_CLOCK3_C_P'] = input_vars['MGT_SI570_CLOCK3_C_N']
		# 	input_vars['MGT_SI570_CLOCK3_C_N'] = tmp
		# else:
		# 	c_156MHZ_CLK += t_step

		# change will be effective in the next iteration

		if time_elapsed == 10.0:
			input_vars['indexTanLambda_V'] = "000000000000000"

		elif time_elapsed == 10.0+3.125:
			input_vars['indexTanLambda_V'] = "011111111111111"

		elif time_elapsed == 10.0+3.125*2:
			input_vars['indexTanLambda_V'] = "011011101000100"
				
		elif time_elapsed == 10.0+3.125*3:
			input_vars['indexTanLambda_V'] = "000001101001011"

		elif time_elapsed == 10.0+3.125*4:
			input_vars['indexTanLambda_V'] = "011011010101110"

		elif time_elapsed == 10.0+3.125*5:
			input_vars['indexTanLambda_V'] = "000000000000000"

		elif time_elapsed == 10.0+3.125*6:
			input_vars['indexTanLambda_V'] = "000100111111101"

		elif time_elapsed == 10.0+3.125*7:
			input_vars['indexTanLambda_V'] = "000000101000010"

		elif time_elapsed == 10.0+3.125*8:
			input_vars['indexTanLambda_V'] = "000100100001110"

		elif time_elapsed == 10.0+3.125*9:
			input_vars['indexTanLambda_V'] = "010010101101100"

		elif time_elapsed == 10.0+3.125*10:
			input_vars['indexTanLambda_V'] = "011101101001011"

		elif time_elapsed == 10.0+3.125*11:
			input_vars['indexTanLambda_V'] = "011100111011111"

		elif time_elapsed == 10.0+3.125*12:
			input_vars['indexTanLambda_V'] = "011111111111111"

		elif time_elapsed == 10.0+3.125*13:
			input_vars['indexTanLambda_V'] = "001110011011101"

		elif time_elapsed == 10.0+3.125*14:
			input_vars['indexTanLambda_V'] = "010011001110000"

		elif time_elapsed == 10.0+3.125*15:
			input_vars['indexTanLambda_V'] = "000000000000000"

	f.close()

# create a testbench
with open('tb_{}.vhd'.format(top), 'w') as f:

	# header
	f.write("-- libraries\n")
	f.write("library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use ieee.std_logic_textio.all;\n")
	f.write("-- Standard textIO functions\n")
	f.write("library std; use std.textio.all;\n")
	f.write("\nentity tb_{} is\nend tb_{};\n".format(top,top))

	# testbench architecture
	f.write("\narchitecture behavior of tb_{} is\n".format(top))
	for key, val in input_vars.iteritems():
		if isinstance(val, basestring):
			f.write("	signal {} : std_logic_vector ({} downto 0);\n".format(key, len(val) - 1))
		else:
			f.write("	signal {} : std_logic;\n".format(key))

	for output_var in output_vars:
		if isinstance(output_var, basestring):
			if output_var not in input_vars:
				f.write("	signal {} : std_logic;\n".format(output_var))
		else:
			if output_var[0] not in input_vars:
				f.write("	signal {} : std_logic_vector ({} downto 0);\n".format(output_var[0], output_var[1] - 1))

	# architecture body begins
	f.write("\nbegin\n")
	f.write("\n-- Instantiate the Unit Under Test (UUT)\n")
	f.write("	uut : entity work.{} port map (\n".format(top))

	lines = []
	for input_var in input_vars:
		line = "		{} => {}".format(input_var,input_var)
		lines.append(line)

	for output_var in output_vars:
		if isinstance(output_var, basestring):
			if output_var not in input_vars:
				line = "		{} => {}".format(output_var,output_var)
				lines.append(line)
		else:
			if output_var[0] not in input_vars:
				line = "		{} => {}".format(output_var[0],output_var[0])
				lines.append(line)

	f.write(",\n".join(lines))

	# Stimulus process write up
	f.write("\n	);\n\n	-- Stimulus process\n")
	f.write("	stim_proc : process\n")
	f.write('		file InF: TEXT open READ_MODE is "../../../../../../lib/hdl/tb/eta/input_text.txt";\n')
	f.write('		file OutF: TEXT open WRITE_MODE is "../../../../../../lib/hdl/tb/eta/output_text.txt";\n')
	f.write('		variable ILine: LINE; variable OLine: LINE; variable TimeWhen: TIME;\n')
	bit_variables = []
	vector_variables = []
	for input_var, val in input_vars.iteritems():
		if isinstance(val, int):
			bit_variables.append(input_var)
		else:
			vector_variables.append(input_var)

	f.write("		variable textio_{}: bit_vector(0 downto 0);\n".format(",textio_".join(bit_variables)))
	for variable in vector_variables:
		f.write("		variable textio_{}: bit_vector({} downto 0);\n".format(variable, len(input_vars[variable]) - 1))

	#Stimulus body begins
	f.write("\n	begin\n")
	f.write("		while not ENDFILE(InF) loop\n")
	f.write("			READLINE (InF, ILine); -- Read individual lines from input file.\n")
	f.write("			-- Read from line.\n")
	f.write("			READ (ILine, TimeWhen);\n")
	for input_var in input_vars:
		f.write("			READ (ILine, textio_{});\n".format(input_var))

	# Stimulus starts here.
	f.write("\n		-- insert stimulus here\n")
	f.write("			wait for TimeWhen - NOW; -- Wait until one time step\n\n")
	for input_var, val in input_vars.iteritems():
		if isinstance(val, int):
			f.write("			{} <= to_stdlogicvector(textio_{})(0);\n".format(input_var, input_var))
		else:
			f.write("			{} <= to_stdlogicvector(textio_{})({} downto 0);\n".format(input_var, input_var, len(val) - 1))

	#Export output state to file starts here
	f.write("\n			-- Export output state to file.\n")
	f.write("			write (OLine, TimeWhen);\n")
	for output_var in output_vars:
		f.write('			write (OLine, string\'("  "));\n')
		if isinstance(output_var, basestring):
			f.write("			write (OLine, {});\n".format(output_var))
		else:
			f.write("			write (OLine, {}({} downto 0));\n".format(output_var[0], output_var[1] - 1))

	f.write("\n			writeline (OutF, OLine); -- write all output variables in file\n")
	f.write("\n		end loop;\n")
	f.write("\n		wait for 10 NS;\n		file_close(InF);\n		file_close(OutF);\n		wait;\n	end process;")
	f.write("\nend behavior;\n")

	f.close()

