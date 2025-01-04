redirect -tee dc.out {

	set vhdlfiles {dff.vhdl reg.vhdl ha.vhdl fa.vhdl ha_noc.vhdl fa_noc.vhdl fir_pp.vhdl fir_cs.vhdl fir_vma.vhdl fir.vhdl}
	foreach f $vhdlfiles {
		if {[analyze -format vhdl $f] != 1} {
			quit
		}
	}

	if {[elaborate fir] != 1} {
		quit
	}

	create_clock -period 1.6667 clk

	set_load 0.01 [all_outputs]
	set_driving_cell -lib_cell "IVSVTX1" [all_inputs]
	set_drive 0 clk

	set_input_delay 0.0 [all_inputs] -clock clk
	set_output_delay 0.0 [all_outputs] -clock clk

	set_switching_activity [all_inputs] -static_probability 0.5 -toggle_rate 0.5 -period 1.6667

	check_design

	if {[compile] != 1} {
		quit
	}

	report_area
	report_timing
	report_power
}

exit

