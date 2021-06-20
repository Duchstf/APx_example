# Option 1 distributed FIFO
#set_false_path -from [filter [all_fanout -from [get_ports wr_clk] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~ *gdm.dm_gen.dm*/gpr1.dout_i_reg*}];   # Original IP core constraint
set_false_path -from [filter [all_fanout -from [get_nets -hierarchical -filter {NAME =~ *i_fifo_dist_96bx117*wr_clk}] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~ *i_fifo_dist_96bx117*gdm.dm_gen.dm*/gpr1.dout_i_reg*}]
# Option 2 built-in FIFO
#set_false_path -from [filter [all_fanout -from [get_ports wr_clk] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~ *gdm.dm_gen.dm*/gpr1.dout_i_reg*}];   # Original IP core constraint
set_false_path -from [filter [all_fanout -from [get_nets -hierarchical -filter {NAME =~ *i_fifo_builtin_96bx512*wr_clk}] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~ *i_fifo_builtin_96bx512*gdm.dm_gen.dm*/gpr1.dout_i_reg*}]

