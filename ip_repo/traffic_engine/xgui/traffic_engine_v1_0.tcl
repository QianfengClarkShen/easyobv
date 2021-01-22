
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/traffic_engine_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "N_CHANNELS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "INSTR0_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR1_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR2_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR3_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR4_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR5_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR6_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR7_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR8_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR9_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR10_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR11_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR12_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR13_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR14_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR15_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.INSTR0_WIDTH { PARAM_VALUE.INSTR0_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR0_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR0_WIDTH ${PARAM_VALUE.INSTR0_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR0_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR0_WIDTH
	} else {
		set_property enabled false $INSTR0_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR0_WIDTH { PARAM_VALUE.INSTR0_WIDTH } {
	# Procedure called to validate INSTR0_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR10_WIDTH { PARAM_VALUE.INSTR10_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR10_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR10_WIDTH ${PARAM_VALUE.INSTR10_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR10_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR10_WIDTH
	} else {
		set_property enabled false $INSTR10_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR10_WIDTH { PARAM_VALUE.INSTR10_WIDTH } {
	# Procedure called to validate INSTR10_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR11_WIDTH { PARAM_VALUE.INSTR11_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR11_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR11_WIDTH ${PARAM_VALUE.INSTR11_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR11_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR11_WIDTH
	} else {
		set_property enabled false $INSTR11_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR11_WIDTH { PARAM_VALUE.INSTR11_WIDTH } {
	# Procedure called to validate INSTR11_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR12_WIDTH { PARAM_VALUE.INSTR12_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR12_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR12_WIDTH ${PARAM_VALUE.INSTR12_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR12_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR12_WIDTH
	} else {
		set_property enabled false $INSTR12_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR12_WIDTH { PARAM_VALUE.INSTR12_WIDTH } {
	# Procedure called to validate INSTR12_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR13_WIDTH { PARAM_VALUE.INSTR13_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR13_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR13_WIDTH ${PARAM_VALUE.INSTR13_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR13_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR13_WIDTH
	} else {
		set_property enabled false $INSTR13_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR13_WIDTH { PARAM_VALUE.INSTR13_WIDTH } {
	# Procedure called to validate INSTR13_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR14_WIDTH { PARAM_VALUE.INSTR14_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR14_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR14_WIDTH ${PARAM_VALUE.INSTR14_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR14_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR14_WIDTH
	} else {
		set_property enabled false $INSTR14_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR14_WIDTH { PARAM_VALUE.INSTR14_WIDTH } {
	# Procedure called to validate INSTR14_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR15_WIDTH { PARAM_VALUE.INSTR15_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR15_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR15_WIDTH ${PARAM_VALUE.INSTR15_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR15_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR15_WIDTH
	} else {
		set_property enabled false $INSTR15_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR15_WIDTH { PARAM_VALUE.INSTR15_WIDTH } {
	# Procedure called to validate INSTR15_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR1_WIDTH { PARAM_VALUE.INSTR1_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR1_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR1_WIDTH ${PARAM_VALUE.INSTR1_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR1_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR1_WIDTH
	} else {
		set_property enabled false $INSTR1_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR1_WIDTH { PARAM_VALUE.INSTR1_WIDTH } {
	# Procedure called to validate INSTR1_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR2_WIDTH { PARAM_VALUE.INSTR2_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR2_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR2_WIDTH ${PARAM_VALUE.INSTR2_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR2_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR2_WIDTH
	} else {
		set_property enabled false $INSTR2_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR2_WIDTH { PARAM_VALUE.INSTR2_WIDTH } {
	# Procedure called to validate INSTR2_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR3_WIDTH { PARAM_VALUE.INSTR3_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR3_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR3_WIDTH ${PARAM_VALUE.INSTR3_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR3_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR3_WIDTH
	} else {
		set_property enabled false $INSTR3_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR3_WIDTH { PARAM_VALUE.INSTR3_WIDTH } {
	# Procedure called to validate INSTR3_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR4_WIDTH { PARAM_VALUE.INSTR4_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR4_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR4_WIDTH ${PARAM_VALUE.INSTR4_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR4_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR4_WIDTH
	} else {
		set_property enabled false $INSTR4_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR4_WIDTH { PARAM_VALUE.INSTR4_WIDTH } {
	# Procedure called to validate INSTR4_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR5_WIDTH { PARAM_VALUE.INSTR5_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR5_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR5_WIDTH ${PARAM_VALUE.INSTR5_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR5_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR5_WIDTH
	} else {
		set_property enabled false $INSTR5_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR5_WIDTH { PARAM_VALUE.INSTR5_WIDTH } {
	# Procedure called to validate INSTR5_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR6_WIDTH { PARAM_VALUE.INSTR6_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR6_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR6_WIDTH ${PARAM_VALUE.INSTR6_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR6_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR6_WIDTH
	} else {
		set_property enabled false $INSTR6_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR6_WIDTH { PARAM_VALUE.INSTR6_WIDTH } {
	# Procedure called to validate INSTR6_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR7_WIDTH { PARAM_VALUE.INSTR7_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR7_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR7_WIDTH ${PARAM_VALUE.INSTR7_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR7_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR7_WIDTH
	} else {
		set_property enabled false $INSTR7_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR7_WIDTH { PARAM_VALUE.INSTR7_WIDTH } {
	# Procedure called to validate INSTR7_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR8_WIDTH { PARAM_VALUE.INSTR8_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR8_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR8_WIDTH ${PARAM_VALUE.INSTR8_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR8_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR8_WIDTH
	} else {
		set_property enabled false $INSTR8_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR8_WIDTH { PARAM_VALUE.INSTR8_WIDTH } {
	# Procedure called to validate INSTR8_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR9_WIDTH { PARAM_VALUE.INSTR9_WIDTH PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update INSTR9_WIDTH when any of the dependent parameters in the arguments change
	
	set INSTR9_WIDTH ${PARAM_VALUE.INSTR9_WIDTH}
	set N_CHANNELS ${PARAM_VALUE.N_CHANNELS}
	set values(N_CHANNELS) [get_property value $N_CHANNELS]
	if { [gen_USERPARAMETER_INSTR9_WIDTH_ENABLEMENT $values(N_CHANNELS)] } {
		set_property enabled true $INSTR9_WIDTH
	} else {
		set_property enabled false $INSTR9_WIDTH
	}
}

proc validate_PARAM_VALUE.INSTR9_WIDTH { PARAM_VALUE.INSTR9_WIDTH } {
	# Procedure called to validate INSTR9_WIDTH
	return true
}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.MEM_WIDTH { PARAM_VALUE.MEM_WIDTH } {
	# Procedure called to update MEM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_WIDTH { PARAM_VALUE.MEM_WIDTH } {
	# Procedure called to validate MEM_WIDTH
	return true
}

proc update_PARAM_VALUE.N_CHANNELS { PARAM_VALUE.N_CHANNELS } {
	# Procedure called to update N_CHANNELS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_CHANNELS { PARAM_VALUE.N_CHANNELS } {
	# Procedure called to validate N_CHANNELS
	return true
}


proc update_MODELPARAM_VALUE.MEM_WIDTH { MODELPARAM_VALUE.MEM_WIDTH PARAM_VALUE.MEM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_WIDTH}] ${MODELPARAM_VALUE.MEM_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.N_CHANNELS { MODELPARAM_VALUE.N_CHANNELS PARAM_VALUE.N_CHANNELS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_CHANNELS}] ${MODELPARAM_VALUE.N_CHANNELS}
}

proc update_MODELPARAM_VALUE.INSTR0_WIDTH { MODELPARAM_VALUE.INSTR0_WIDTH PARAM_VALUE.INSTR0_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR0_WIDTH}] ${MODELPARAM_VALUE.INSTR0_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR1_WIDTH { MODELPARAM_VALUE.INSTR1_WIDTH PARAM_VALUE.INSTR1_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR1_WIDTH}] ${MODELPARAM_VALUE.INSTR1_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR2_WIDTH { MODELPARAM_VALUE.INSTR2_WIDTH PARAM_VALUE.INSTR2_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR2_WIDTH}] ${MODELPARAM_VALUE.INSTR2_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR3_WIDTH { MODELPARAM_VALUE.INSTR3_WIDTH PARAM_VALUE.INSTR3_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR3_WIDTH}] ${MODELPARAM_VALUE.INSTR3_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR4_WIDTH { MODELPARAM_VALUE.INSTR4_WIDTH PARAM_VALUE.INSTR4_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR4_WIDTH}] ${MODELPARAM_VALUE.INSTR4_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR5_WIDTH { MODELPARAM_VALUE.INSTR5_WIDTH PARAM_VALUE.INSTR5_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR5_WIDTH}] ${MODELPARAM_VALUE.INSTR5_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR6_WIDTH { MODELPARAM_VALUE.INSTR6_WIDTH PARAM_VALUE.INSTR6_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR6_WIDTH}] ${MODELPARAM_VALUE.INSTR6_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR7_WIDTH { MODELPARAM_VALUE.INSTR7_WIDTH PARAM_VALUE.INSTR7_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR7_WIDTH}] ${MODELPARAM_VALUE.INSTR7_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR8_WIDTH { MODELPARAM_VALUE.INSTR8_WIDTH PARAM_VALUE.INSTR8_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR8_WIDTH}] ${MODELPARAM_VALUE.INSTR8_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR9_WIDTH { MODELPARAM_VALUE.INSTR9_WIDTH PARAM_VALUE.INSTR9_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR9_WIDTH}] ${MODELPARAM_VALUE.INSTR9_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR10_WIDTH { MODELPARAM_VALUE.INSTR10_WIDTH PARAM_VALUE.INSTR10_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR10_WIDTH}] ${MODELPARAM_VALUE.INSTR10_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR11_WIDTH { MODELPARAM_VALUE.INSTR11_WIDTH PARAM_VALUE.INSTR11_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR11_WIDTH}] ${MODELPARAM_VALUE.INSTR11_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR12_WIDTH { MODELPARAM_VALUE.INSTR12_WIDTH PARAM_VALUE.INSTR12_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR12_WIDTH}] ${MODELPARAM_VALUE.INSTR12_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR13_WIDTH { MODELPARAM_VALUE.INSTR13_WIDTH PARAM_VALUE.INSTR13_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR13_WIDTH}] ${MODELPARAM_VALUE.INSTR13_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR14_WIDTH { MODELPARAM_VALUE.INSTR14_WIDTH PARAM_VALUE.INSTR14_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR14_WIDTH}] ${MODELPARAM_VALUE.INSTR14_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR15_WIDTH { MODELPARAM_VALUE.INSTR15_WIDTH PARAM_VALUE.INSTR15_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR15_WIDTH}] ${MODELPARAM_VALUE.INSTR15_WIDTH}
}

