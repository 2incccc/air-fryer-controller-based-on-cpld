transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/intel_fpga/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/intel_fpga/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/intel_fpga/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/intel_fpga/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/intel_fpga/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/maxii_ver
vmap maxii_ver ./verilog_libs/maxii_ver
vlog -vlog01compat -work maxii_ver {d:/intel_fpga/quartus/eda/sim_lib/maxii_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/freq_div.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/buzzer_beep.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/debounce.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/state_control.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/fryer.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/seg_counter.v}
vlog -vlog01compat -work work +incdir+D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital\ System\ Design\ LAB {D:/DESKTOP/WANGHAO/WORKSPACE/Verilog_FPGA/Digital System Design LAB/two_color_matrix.v}

