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
	if {[string compare $quartus(project) "rot_ban"]} {
		puts "Project rot_ban is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists rot_ban]} {
		project_open -revision rot_ban rot_ban
	} else {
		project_new -revision rot_ban rot_ban
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M50DAF484C6GES
	set_global_assignment -name TOP_LEVEL_ENTITY rot_ban
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
	set_global_assignment -name VHDL_FILE rot_ban.vhd
	set_global_assignment -name VHDL_FILE seg_7.vhd
	set_global_assignment -name VHDL_FILE reg.vhd
	set_global_assignment -name VHDL_FILE freq_div.vhd
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top

## Pin assignments
	set_location_assignment PIN_P11 -to clk

	set_location_assignment PIN_C14 -to disp1_o[0]
	set_location_assignment PIN_E15 -to disp1_o[1]
	set_location_assignment PIN_C15 -to disp1_o[2]
	set_location_assignment PIN_C16 -to disp1_o[3]
	set_location_assignment PIN_E16 -to disp1_o[4]
	set_location_assignment PIN_D17 -to disp1_o[5]
	set_location_assignment PIN_C17 -to disp1_o[6]
	set_location_assignment PIN_D15 -to disp1_o[7]
	set_location_assignment PIN_C18 -to disp2_o[0]
	set_location_assignment PIN_D18 -to disp2_o[1]
	set_location_assignment PIN_E18 -to disp2_o[2]
	set_location_assignment PIN_B16 -to disp2_o[3]
	set_location_assignment PIN_A17 -to disp2_o[4]
	set_location_assignment PIN_A18 -to disp2_o[5]
	set_location_assignment PIN_B17 -to disp2_o[6]
	set_location_assignment PIN_A16 -to disp2_o[7]
	set_location_assignment PIN_B20 -to disp3_o[0]
	set_location_assignment PIN_A20 -to disp3_o[1]
	set_location_assignment PIN_B19 -to disp3_o[2]
	set_location_assignment PIN_A21 -to disp3_o[3]
	set_location_assignment PIN_B21 -to disp3_o[4]
	set_location_assignment PIN_C22 -to disp3_o[5]
	set_location_assignment PIN_B22 -to disp3_o[6]
	set_location_assignment PIN_A19 -to disp3_o[7]
	set_location_assignment PIN_F21 -to disp4_o[0]
	set_location_assignment PIN_E22 -to disp4_o[1]
	set_location_assignment PIN_E21 -to disp4_o[2]
	set_location_assignment PIN_C19 -to disp4_o[3]
	set_location_assignment PIN_C20 -to disp4_o[4]
	set_location_assignment PIN_D19 -to disp4_o[5]
	set_location_assignment PIN_E17 -to disp4_o[6]
	set_location_assignment PIN_D22 -to disp4_o[7]

	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
