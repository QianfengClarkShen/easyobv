proc addip {ipName displayName} {
    set vlnv_version_independent [lindex [get_ipdefs -all -filter "NAME == $ipName"] end]
    return [create_bd_cell -type ip -vlnv $vlnv_version_independent $displayName]
}
set script_dir [file dirname [file normalize [info script]]]
#get easyobv configuration
set INSTR_BYTES [expr [get_property CONFIG.INSTR_WIDTH [get_ips]]/8]
set easyobv_config {}
foreach pp {EN_AXIL MODE DWIDTH DEFAULT_TIMEOUT_VAL DEST_WIDTH HAS_KEEP HAS_LAST HAS_READY HAS_STRB ID_WIDTH REPEAT_BITS TIMEOUT_BITS USER_WIDTH} {
    dict append easyobv_config CONFIG.${pp} [get_property CONFIG.${pp} [get_ips]]
}
if {[dict get $easyobv_config CONFIG.MODE] == 2} {
    dict append easyobv_config CONFIG.CMP_FIFO_DEPTH [get_property CONFIG.CMP_FIFO_DEPTH [get_ips]]
}
if {[dict get $easyobv_config CONFIG.HAS_READY] == 0} {
    dict append easyobv_config CONFIG.PAUSE_ON_NRDY [get_property CONFIG.PAUSE_ON_NRDY [get_ips]]
}

set cur_design [current_bd_design -quiet]
create_bd_design easyobv_ex

set TYPE_EX [get_property CONFIG.TYPE_EX [get_ips]]
if {$TYPE_EX == 0} {
    source $script_dir/example_xdma_bd.tcl
} else {
    source $script_dir/example_mpsoc_bd.tcl
}

create_root_design "" "$INSTR_BYTES" "$easyobv_config"

set project_dir [get_property DIRECTORY [current_project]]
set project_name [get_property NAME [current_project]]
remove_files  ${project_dir}/${project_name}.srcs/sources_1/ip/easyobv_axis_*/easyobv_axis_*.xci
file delete -force ${project_dir}/${project_name}.srcs/sources_1/ip/easyobv_axis_*
set AXIL [dict get $easyobv_config CONFIG.EN_AXIL]
set MODE [dict get $easyobv_config CONFIG.MODE]

if {$AXIL != 0} {
    if {$TYPE_EX != 0} {
        set_property -dict [list CONFIG.NUM_MI {4}] [get_bd_cells processor/smartconnect_0]
        connect_bd_net [get_bd_pins easyobv_axis_0/s_axil_aclk] [get_bd_pins processor/pl_clk0]
        connect_bd_intf_net [get_bd_intf_pins processor/smartconnect_0/M03_AXI] [get_bd_intf_pins easyobv_axis_0/s_axil]
        assign_bd_address [get_bd_addr_segs {easyobv_axis_0/s_axil/reg0 }]
        set_property range 4K [get_bd_addr_segs {processor/zynq_ultra_ps_e_0/Data/SEG_easyobv_axis_0_reg0}]
        set_property offset 0x00A0012000 [get_bd_addr_segs {processor/zynq_ultra_ps_e_0/Data/SEG_easyobv_axis_0_reg0}]
    } else {
        set_property -dict [list CONFIG.NUM_MI {2}] [get_bd_cells xdma/smartconnect_0]
        connect_bd_net [get_bd_pins easyobv_axis_0/s_axil_aclk] [get_bd_pins xdma/axi_aclk]
        connect_bd_intf_net [get_bd_intf_pins xdma/smartconnect_0/M01_AXI] [get_bd_intf_pins easyobv_axis_0/s_axil]
        assign_bd_address [get_bd_addr_segs {easyobv_axis_0/s_axil/reg0 }]
        set_property range 4K [get_bd_addr_segs {xdma/xdma_0/M_AXI_LITE/SEG_easyobv_axis_0_reg0}]
        set_property offset 0x00001000 [get_bd_addr_segs {xdma/xdma_0/M_AXI_LITE/SEG_easyobv_axis_0_reg0}]
    }
}

if {$MODE == 1} {
    set_property -dict [list CONFIG.C_SLOT {1} CONFIG.C_BRAM_CNT {6.5} CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} CONFIG.C_SLOT_1_INTF_TYPE {clarkshen.com:user:dbg_easyobv_rtl:1.0}] [get_bd_cells system_ila]
    connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_1_DBG_EASYOBV] [get_bd_intf_pins easyobv_axis_0/dbg]
} elseif {$MODE ==2} {
    set_property -dict [list CONFIG.C_SLOT {2} CONFIG.C_BRAM_CNT {6.5} CONFIG.C_NUM_MONITOR_SLOTS {3} CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} CONFIG.C_SLOT_2_INTF_TYPE {clarkshen.com:user:dbg_easyobv_rtl:1.0}] [get_bd_cells system_ila]
    connect_bd_intf_net [get_bd_intf_pins dut/axis_register_slice_1/M_AXIS] [get_bd_intf_pins easyobv_axis_0/rx_mon]
    connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_1_AXIS] -boundary_type upper [get_bd_intf_pins dut/M_AXIS]
    connect_bd_intf_net [get_bd_intf_pins system_ila/SLOT_2_DBG_EASYOBV] [get_bd_intf_pins easyobv_axis_0/dbg]
}

if {$TYPE_EX == 0} {
    remove_files  -fileset constrs_1 ${project_dir}/imports/mpsoc.xdc
} else {
    remove_files  -fileset constrs_1 ${project_dir}/imports/xdma.xdc
}

save_bd_design
validate_bd_design
make_wrapper -files [get_files ${project_dir}/${project_name}.srcs/sources_1/bd/easyobv_ex/easyobv_ex.bd] -top
add_files -norecurse ${project_dir}/${project_name}.srcs/sources_1/bd/easyobv_ex/hdl/easyobv_ex_wrapper.v
set_property top easyobv_ex_wrapper [current_fileset]