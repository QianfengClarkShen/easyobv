
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/easyobv_axis_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "TYPE_EX" -widget comboBox
  #Adding Page
  set General_Configuration [ipgui::add_page $IPINST -name "General Configuration"]
  set_property tooltip {General Configuration} ${General_Configuration}
  ipgui::add_param $IPINST -name "EN_AXIL" -parent ${General_Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "MODE" -parent ${General_Configuration} -widget comboBox
  ipgui::add_param $IPINST -name "DEFAULT_TIMEOUT_VAL" -parent ${General_Configuration}
  ipgui::add_param $IPINST -name "REPEAT_BITS" -parent ${General_Configuration}
  ipgui::add_param $IPINST -name "TIMEOUT_BITS" -parent ${General_Configuration}

  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {AXI4-Stream Configuration}]
  set_property tooltip {AXI4-Stream Configuration} ${Page_0}
  ipgui::add_param $IPINST -name "PAUSE_ON_NRDY" -parent ${Page_0} -widget comboBox
  set DWIDTH [ipgui::add_param $IPINST -name "DWIDTH" -parent ${Page_0}]
  set_property tooltip {AXI4-Stream Data Width} ${DWIDTH}
  ipgui::add_param $IPINST -name "HAS_READY" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "HAS_KEEP" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "HAS_LAST" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "HAS_STRB" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "DEST_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "USER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ID_WIDTH" -parent ${Page_0}

  #Adding Page
  set Traffic_Monitor [ipgui::add_page $IPINST -name "Traffic Monitor" -display_name {Traffic Monitor Configuration}]
  set_property tooltip {Traffic Monitor} ${Traffic_Monitor}
  ipgui::add_param $IPINST -name "CMP_FIFO_DEPTH" -parent ${Traffic_Monitor}


}

proc update_PARAM_VALUE.CMP_FIFO_DEPTH { PARAM_VALUE.CMP_FIFO_DEPTH PARAM_VALUE.MODE } {
	# Procedure called to update CMP_FIFO_DEPTH when any of the dependent parameters in the arguments change
	
	set CMP_FIFO_DEPTH ${PARAM_VALUE.CMP_FIFO_DEPTH}
	set MODE ${PARAM_VALUE.MODE}
	set values(MODE) [get_property value $MODE]
	if { [gen_USERPARAMETER_CMP_FIFO_DEPTH_ENABLEMENT $values(MODE)] } {
		set_property enabled true $CMP_FIFO_DEPTH
	} else {
		set_property enabled false $CMP_FIFO_DEPTH
	}
}

proc validate_PARAM_VALUE.CMP_FIFO_DEPTH { PARAM_VALUE.CMP_FIFO_DEPTH } {
	# Procedure called to validate CMP_FIFO_DEPTH
	return true
}

proc update_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH PARAM_VALUE.DWIDTH PARAM_VALUE.HAS_READY PARAM_VALUE.HAS_KEEP PARAM_VALUE.HAS_LAST PARAM_VALUE.HAS_STRB PARAM_VALUE.DEST_WIDTH PARAM_VALUE.USER_WIDTH PARAM_VALUE.ID_WIDTH PARAM_VALUE.TIMEOUT_BITS PARAM_VALUE.REPEAT_BITS } {
	# Procedure called to update INSTR_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR_WIDTH ${PARAM_VALUE.INSTR_WIDTH}
	set DWIDTH ${PARAM_VALUE.DWIDTH}
	set HAS_READY ${PARAM_VALUE.HAS_READY}
	set HAS_KEEP ${PARAM_VALUE.HAS_KEEP}
	set HAS_LAST ${PARAM_VALUE.HAS_LAST}
	set HAS_STRB ${PARAM_VALUE.HAS_STRB}
	set DEST_WIDTH ${PARAM_VALUE.DEST_WIDTH}
	set USER_WIDTH ${PARAM_VALUE.USER_WIDTH}
	set ID_WIDTH ${PARAM_VALUE.ID_WIDTH}
	set TIMEOUT_BITS ${PARAM_VALUE.TIMEOUT_BITS}
	set REPEAT_BITS ${PARAM_VALUE.REPEAT_BITS}
	set values(DWIDTH) [get_property value $DWIDTH]
	set values(HAS_READY) [get_property value $HAS_READY]
	set values(HAS_KEEP) [get_property value $HAS_KEEP]
	set values(HAS_LAST) [get_property value $HAS_LAST]
	set values(HAS_STRB) [get_property value $HAS_STRB]
	set values(DEST_WIDTH) [get_property value $DEST_WIDTH]
	set values(USER_WIDTH) [get_property value $USER_WIDTH]
	set values(ID_WIDTH) [get_property value $ID_WIDTH]
	set values(TIMEOUT_BITS) [get_property value $TIMEOUT_BITS]
	set values(REPEAT_BITS) [get_property value $REPEAT_BITS]
	set_property value [gen_USERPARAMETER_INSTR_WIDTH_VALUE $values(DWIDTH) $values(HAS_READY) $values(HAS_KEEP) $values(HAS_LAST) $values(HAS_STRB) $values(DEST_WIDTH) $values(USER_WIDTH) $values(ID_WIDTH) $values(TIMEOUT_BITS) $values(REPEAT_BITS)] $INSTR_WIDTH
}

proc validate_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to validate INSTR_WIDTH
	return true
}

proc update_PARAM_VALUE.PAUSE_ON_NRDY { PARAM_VALUE.PAUSE_ON_NRDY PARAM_VALUE.HAS_READY } {
	# Procedure called to update PAUSE_ON_NRDY when any of the dependent parameters in the arguments change
	
	set PAUSE_ON_NRDY ${PARAM_VALUE.PAUSE_ON_NRDY}
	set HAS_READY ${PARAM_VALUE.HAS_READY}
	set values(HAS_READY) [get_property value $HAS_READY]
	if { [gen_USERPARAMETER_PAUSE_ON_NRDY_ENABLEMENT $values(HAS_READY)] } {
		set_property enabled true $PAUSE_ON_NRDY
	} else {
		set_property enabled false $PAUSE_ON_NRDY
	}
}

proc validate_PARAM_VALUE.PAUSE_ON_NRDY { PARAM_VALUE.PAUSE_ON_NRDY } {
	# Procedure called to validate PAUSE_ON_NRDY
	return true
}

proc update_PARAM_VALUE.CLK_FREQ { PARAM_VALUE.CLK_FREQ } {
	# Procedure called to update CLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLK_FREQ { PARAM_VALUE.CLK_FREQ } {
	# Procedure called to validate CLK_FREQ
	return true
}

proc update_PARAM_VALUE.DEFAULT_TIMEOUT_VAL { PARAM_VALUE.DEFAULT_TIMEOUT_VAL } {
	# Procedure called to update DEFAULT_TIMEOUT_VAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEFAULT_TIMEOUT_VAL { PARAM_VALUE.DEFAULT_TIMEOUT_VAL } {
	# Procedure called to validate DEFAULT_TIMEOUT_VAL
	return true
}

proc update_PARAM_VALUE.DEST_WIDTH { PARAM_VALUE.DEST_WIDTH } {
	# Procedure called to update DEST_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEST_WIDTH { PARAM_VALUE.DEST_WIDTH } {
	# Procedure called to validate DEST_WIDTH
	return true
}

proc update_PARAM_VALUE.DWIDTH { PARAM_VALUE.DWIDTH } {
	# Procedure called to update DWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DWIDTH { PARAM_VALUE.DWIDTH } {
	# Procedure called to validate DWIDTH
	return true
}

proc update_PARAM_VALUE.EN_AXIL { PARAM_VALUE.EN_AXIL } {
	# Procedure called to update EN_AXIL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EN_AXIL { PARAM_VALUE.EN_AXIL } {
	# Procedure called to validate EN_AXIL
	return true
}

proc update_PARAM_VALUE.HAS_KEEP { PARAM_VALUE.HAS_KEEP } {
	# Procedure called to update HAS_KEEP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_KEEP { PARAM_VALUE.HAS_KEEP } {
	# Procedure called to validate HAS_KEEP
	return true
}

proc update_PARAM_VALUE.HAS_LAST { PARAM_VALUE.HAS_LAST } {
	# Procedure called to update HAS_LAST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_LAST { PARAM_VALUE.HAS_LAST } {
	# Procedure called to validate HAS_LAST
	return true
}

proc update_PARAM_VALUE.HAS_READY { PARAM_VALUE.HAS_READY } {
	# Procedure called to update HAS_READY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_READY { PARAM_VALUE.HAS_READY } {
	# Procedure called to validate HAS_READY
	return true
}

proc update_PARAM_VALUE.HAS_STRB { PARAM_VALUE.HAS_STRB } {
	# Procedure called to update HAS_STRB when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HAS_STRB { PARAM_VALUE.HAS_STRB } {
	# Procedure called to validate HAS_STRB
	return true
}

proc update_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH } {
	# Procedure called to update ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ID_WIDTH { PARAM_VALUE.ID_WIDTH } {
	# Procedure called to validate ID_WIDTH
	return true
}

proc update_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to update MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MODE { PARAM_VALUE.MODE } {
	# Procedure called to validate MODE
	return true
}

proc update_PARAM_VALUE.REPEAT_BITS { PARAM_VALUE.REPEAT_BITS } {
	# Procedure called to update REPEAT_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REPEAT_BITS { PARAM_VALUE.REPEAT_BITS } {
	# Procedure called to validate REPEAT_BITS
	return true
}

proc update_PARAM_VALUE.TIMEOUT_BITS { PARAM_VALUE.TIMEOUT_BITS } {
	# Procedure called to update TIMEOUT_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TIMEOUT_BITS { PARAM_VALUE.TIMEOUT_BITS } {
	# Procedure called to validate TIMEOUT_BITS
	return true
}

proc update_PARAM_VALUE.TYPE_EX { PARAM_VALUE.TYPE_EX } {
	# Procedure called to update TYPE_EX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TYPE_EX { PARAM_VALUE.TYPE_EX } {
	# Procedure called to validate TYPE_EX
	return true
}

proc update_PARAM_VALUE.USER_WIDTH { PARAM_VALUE.USER_WIDTH } {
	# Procedure called to update USER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USER_WIDTH { PARAM_VALUE.USER_WIDTH } {
	# Procedure called to validate USER_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.EN_AXIL { MODELPARAM_VALUE.EN_AXIL PARAM_VALUE.EN_AXIL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EN_AXIL}] ${MODELPARAM_VALUE.EN_AXIL}
}

proc update_MODELPARAM_VALUE.MODE { MODELPARAM_VALUE.MODE PARAM_VALUE.MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MODE}] ${MODELPARAM_VALUE.MODE}
}

proc update_MODELPARAM_VALUE.DWIDTH { MODELPARAM_VALUE.DWIDTH PARAM_VALUE.DWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DWIDTH}] ${MODELPARAM_VALUE.DWIDTH}
}

proc update_MODELPARAM_VALUE.HAS_READY { MODELPARAM_VALUE.HAS_READY PARAM_VALUE.HAS_READY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_READY}] ${MODELPARAM_VALUE.HAS_READY}
}

proc update_MODELPARAM_VALUE.HAS_KEEP { MODELPARAM_VALUE.HAS_KEEP PARAM_VALUE.HAS_KEEP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_KEEP}] ${MODELPARAM_VALUE.HAS_KEEP}
}

proc update_MODELPARAM_VALUE.HAS_LAST { MODELPARAM_VALUE.HAS_LAST PARAM_VALUE.HAS_LAST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_LAST}] ${MODELPARAM_VALUE.HAS_LAST}
}

proc update_MODELPARAM_VALUE.HAS_STRB { MODELPARAM_VALUE.HAS_STRB PARAM_VALUE.HAS_STRB } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HAS_STRB}] ${MODELPARAM_VALUE.HAS_STRB}
}

proc update_MODELPARAM_VALUE.DEST_WIDTH { MODELPARAM_VALUE.DEST_WIDTH PARAM_VALUE.DEST_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEST_WIDTH}] ${MODELPARAM_VALUE.DEST_WIDTH}
}

proc update_MODELPARAM_VALUE.USER_WIDTH { MODELPARAM_VALUE.USER_WIDTH PARAM_VALUE.USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USER_WIDTH}] ${MODELPARAM_VALUE.USER_WIDTH}
}

proc update_MODELPARAM_VALUE.ID_WIDTH { MODELPARAM_VALUE.ID_WIDTH PARAM_VALUE.ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ID_WIDTH}] ${MODELPARAM_VALUE.ID_WIDTH}
}

proc update_MODELPARAM_VALUE.DEFAULT_TIMEOUT_VAL { MODELPARAM_VALUE.DEFAULT_TIMEOUT_VAL PARAM_VALUE.DEFAULT_TIMEOUT_VAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEFAULT_TIMEOUT_VAL}] ${MODELPARAM_VALUE.DEFAULT_TIMEOUT_VAL}
}

proc update_MODELPARAM_VALUE.TIMEOUT_BITS { MODELPARAM_VALUE.TIMEOUT_BITS PARAM_VALUE.TIMEOUT_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TIMEOUT_BITS}] ${MODELPARAM_VALUE.TIMEOUT_BITS}
}

proc update_MODELPARAM_VALUE.REPEAT_BITS { MODELPARAM_VALUE.REPEAT_BITS PARAM_VALUE.REPEAT_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REPEAT_BITS}] ${MODELPARAM_VALUE.REPEAT_BITS}
}

proc update_MODELPARAM_VALUE.PAUSE_ON_NRDY { MODELPARAM_VALUE.PAUSE_ON_NRDY PARAM_VALUE.PAUSE_ON_NRDY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PAUSE_ON_NRDY}] ${MODELPARAM_VALUE.PAUSE_ON_NRDY}
}

proc update_MODELPARAM_VALUE.INSTR_WIDTH { MODELPARAM_VALUE.INSTR_WIDTH PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR_WIDTH}] ${MODELPARAM_VALUE.INSTR_WIDTH}
}

proc update_MODELPARAM_VALUE.CMP_FIFO_DEPTH { MODELPARAM_VALUE.CMP_FIFO_DEPTH PARAM_VALUE.CMP_FIFO_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CMP_FIFO_DEPTH}] ${MODELPARAM_VALUE.CMP_FIFO_DEPTH}
}

proc update_MODELPARAM_VALUE.CLK_FREQ { MODELPARAM_VALUE.CLK_FREQ PARAM_VALUE.CLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLK_FREQ}] ${MODELPARAM_VALUE.CLK_FREQ}
}

