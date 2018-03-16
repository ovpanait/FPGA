# Copyright (C) 2017  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Intel and sold by Intel or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus Prime: Generate Tcl File for Project
# File: rot_ban.tcl
# Generated on: Sat Oct 28 22:02:10 2017

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "fib"]} {
		puts "Project fib is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists rot_ban]} {
		project_open -revision fib fib
	} else {
		project_new -revision fib fib
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M50DAF484C6GES
	set_global_assignment -name TOP_LEVEL_ENTITY fib
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 15.1.0
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "17:45:13 JUNE 17,2016"
	set_global_assignment -name LAST_QUARTUS_VERSION "16.1.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 484
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 6
	set_global_assignment -name VERILOG_FILE DE10_LITE_Golden_Top.v
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name BOARD "MAX 10 DE10 - Lite"
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (VHDL)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name VHDL_FILE fib.vhd
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top

## Pin assignments
	set_location_assignment PIN_P11 -to clk
	set_location_assignment PIN_B8  -to reset
	set_location_assignment PIN_A7  -to start
	
	set_location_assignment PIN_C10  -to input[0]
	set_location_assignment PIN_C11  -to input[1]
	set_location_assignment PIN_D12  -to input[2]
	set_location_assignment PIN_C12  -to input[3]
	
	set_location_assignment PIN_A8   -to result[0]
	set_location_assignment PIN_A9   -to result[1]
	set_location_assignment PIN_A10  -to result[2]
	set_location_assignment PIN_B10  -to result[3]
	set_location_assignment PIN_D13  -to result[4]
	set_location_assignment PIN_C13  -to result[5]
	set_location_assignment PIN_E14  -to result[6]
	set_location_assignment PIN_D14  -to result[7]
	set_location_assignment PIN_A11  -to result[8]
	
	set_location_assignment PIN_B11   -to ready
	
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
