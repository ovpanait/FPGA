create_clock -period "50.0 MHz" [get_ports clk]
derive_pll_clocks
derive_clock_uncertainty

set_output_delay 10 -max -clock clk [get_ports q] 