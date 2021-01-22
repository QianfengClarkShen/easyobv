proc init { cell_name undefined_params } {}

proc post_config_ip { cell_name args } {
    set ip [get_bd_cells $cell_name]
    set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $cell_name/rst]
    set en_axil [get_property CONFIG.EN_AXIL $ip]
    if {$en_axil != 0} {
	    set_property CONFIG.ASSOCIATED_BUSIF {s_axil} [get_bd_pins $cell_name/s_axil_aclk]
    }
    set mode [get_property CONFIG.MODE $ip]
    if {$mode == 0} {
        set_property CONFIG.ASSOCIATED_BUSIF {instr:traffic} [get_bd_pins $cell_name/clk]
    } elseif {$mode == 1} {
        set_property CONFIG.ASSOCIATED_BUSIF {instr:traffic} [get_bd_pins $cell_name/clk]
    } else {
        set_property CONFIG.ASSOCIATED_BUSIF {instr:traffic:rx_mon} [get_bd_pins $cell_name/clk]
    }
}

proc propagate { cell_name prop_info } {}
