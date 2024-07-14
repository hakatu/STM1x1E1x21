create_clock -period 10 -name ecc_clk [get_ports ecc_clk]
set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports ecc_clk]