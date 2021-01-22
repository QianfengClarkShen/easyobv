proc init { cell_name undefined_params } {}

proc post_config_ip { cell_name args } {
    set ip [get_bd_cells $cell_name]
    set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $cell_name/rst]
    set_property CONFIG.ASSOCIATED_BUSIF {m_axi} [get_bd_pins $cell_name/mem_clk]
    set_property CONFIG.ASSOCIATED_BUSIF {s_axil} [get_bd_pins $cell_name/s_axil_aclk]
    for {set i 0} "\$i < [get_property CONFIG.N_CHANNELS $ip]" {incr i} {
        set_property CONFIG.ASSOCIATED_BUSIF "instr$i" [get_bd_pins $cell_name/instr${i}_clk]
        set_property CONFIG.POLARITY {ACTIVE_HIGH} [get_bd_pins $cell_name/instr${i}_rst]
    }
}

proc propagate { cell_name prop_info } {}
