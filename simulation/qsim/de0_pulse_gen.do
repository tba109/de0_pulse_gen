onerror {exit -code 1}
vlib work
vlog -work work de0_pulse_gen.vo
vlog -work work config_ind.vwf.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate_ver -L altera_lnsim_ver work.de0_pulse_gen_top_vlg_vec_tst -voptargs="+acc"
vcd file -direction de0_pulse_gen.msim.vcd
vcd add -internal de0_pulse_gen_top_vlg_vec_tst/*
vcd add -internal de0_pulse_gen_top_vlg_vec_tst/i1/*
run -all
quit -f
