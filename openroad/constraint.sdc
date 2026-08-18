# Conservative 50 MHz starting constraint.
set clk_period 20.0
create_clock -name clk -period $clk_period [get_ports clk]

set_input_delay 4.0 -clock clk \
    [get_ports {instr_rdata[*] data_rdata[*]}]
set_output_delay 4.0 -clock clk \
    [get_ports {instr_addr[*] data_read data_write data_addr[*] data_wdata[*]}]

# Reset is asynchronous in the current RTL.
set_false_path -from [get_ports rst]
