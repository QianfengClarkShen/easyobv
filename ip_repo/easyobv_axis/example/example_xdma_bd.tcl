################################################################
# This is a generated script based on design: easyobv_ex
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

##################################################################
# DESIGN PROCs
##################################################################

# Hierarchical cell: xdma
proc create_hier_cell_xdma { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_memory() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_clk

  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt_0


  # Create pins
  create_bd_pin -dir O -type clk axi_aclk
  create_bd_pin -dir O -type rst axi_aresetn

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ addip smartconnect smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ addip util_ds_buf util_ds_buf_0 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {IBUFDSGTE} \
 ] $util_ds_buf_0

  # Create instance: xdma_0, and set properties
  set xdma_0 [ addip xdma xdma_0 ]
  set_property -dict [ list \
   CONFIG.PF0_DEVICE_ID_mqdma {903F} \
   CONFIG.PF2_DEVICE_ID_mqdma {903F} \
   CONFIG.PF3_DEVICE_ID_mqdma {903F} \
   CONFIG.axi_data_width {512_bit} \
   CONFIG.axil_master_64bit_en {false} \
   CONFIG.axilite_master_en {true} \
   CONFIG.axisten_freq {250} \
   CONFIG.cfg_mgmt_if {false} \
   CONFIG.coreclk_freq {500} \
   CONFIG.pcie_blk_locn {X1Y0} \
   CONFIG.pf0_device_id {903F} \
   CONFIG.pf0_msix_cap_pba_bir {BAR_3:2} \
   CONFIG.pf0_msix_cap_table_bir {BAR_3:2} \
   CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
   CONFIG.pl_link_cap_max_link_width {X16} \
   CONFIG.plltype {QPLL1} \
   CONFIG.select_quad {GTH_Quad_227} \
   CONFIG.xdma_pcie_64bit_en {true} \
   CONFIG.xdma_pcie_prefetchable {true} \
 ] $xdma_0

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ addip xlconstant xlconstant_0 ]

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ addip xlconstant xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins M_AXI] [get_bd_intf_pins xdma_0/M_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins pcie_mgt_0] [get_bd_intf_pins xdma_0/pcie_mgt]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins pcie_clk] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net Conn4 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_LITE [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins xdma_0/M_AXI_LITE]

  # Create port connections
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net xdma_0_axi_aclk [get_bd_pins axi_aclk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins xdma_0/axi_aclk]
  connect_bd_net -net xdma_0_axi_aresetn [get_bd_pins axi_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins xdma_0/axi_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xdma_0/sys_rst_n] [get_bd_pins xlconstant_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xdma_0/usr_irq_req] [get_bd_pins xlconstant_1/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: memory
proc create_hier_cell_memory { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dut() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4_0

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S01_AXI

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr_clk_DS


  # Create pins
  create_bd_pin -dir O -type clk mem_clk
  create_bd_pin -dir O -from 0 -to 0 -type rst mem_rstn
  create_bd_pin -dir I -type clk pcie_clk
  create_bd_pin -dir I -type rst pcie_rstn

  # Create instance: axi_interconnect_0, and set properties
  set axi_interconnect_0 [ addip axi_interconnect axi_interconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {1} \
   CONFIG.NUM_SI {2} \
 ] $axi_interconnect_0

  # Create instance: ddr4_0, and set properties
  set ddr4_0 [ addip ddr4 ddr4_0 ]
  set_property -dict [ list \
   CONFIG.C0.CKE_WIDTH {2} \
   CONFIG.C0.CK_WIDTH {2} \
   CONFIG.C0.CS_WIDTH {2} \
   CONFIG.C0.DDR4_AxiAddressWidth {34} \
   CONFIG.C0.DDR4_AxiDataWidth {512} \
   CONFIG.C0.DDR4_CLKOUT0_DIVIDE {5} \
   CONFIG.C0.DDR4_CasLatency {15} \
   CONFIG.C0.DDR4_DataMask {DM_NO_DBI} \
   CONFIG.C0.DDR4_DataWidth {64} \
   CONFIG.C0.DDR4_Ecc {false} \
   CONFIG.C0.DDR4_InputClockPeriod {3001} \
   CONFIG.C0.DDR4_MemoryPart {MTA16ATF2G64HZ-2G3} \
   CONFIG.C0.DDR4_MemoryType {SODIMMs} \
   CONFIG.C0.DDR4_TimePeriod {938} \
   CONFIG.C0.ODT_WIDTH {2} \
 ] $ddr4_0

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ addip proc_sys_reset proc_sys_reset_1 ]

  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ addip xlconstant xlconstant_0 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins ddr_clk_DS] [get_bd_intf_pins ddr4_0/C0_SYS_CLK]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins C0_DDR4_0] [get_bd_intf_pins ddr4_0/C0_DDR4]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins axi_interconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net S01_AXI_1 [get_bd_intf_pins S01_AXI] [get_bd_intf_pins axi_interconnect_0/S01_AXI]
  connect_bd_intf_net -intf_net axi_interconnect_0_M00_AXI [get_bd_intf_pins axi_interconnect_0/M00_AXI] [get_bd_intf_pins ddr4_0/C0_DDR4_S_AXI]

  # Create port connections
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins pcie_rstn] [get_bd_pins axi_interconnect_0/S00_ARESETN]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk [get_bd_pins mem_clk] [get_bd_pins axi_interconnect_0/ACLK] [get_bd_pins axi_interconnect_0/M00_ACLK] [get_bd_pins axi_interconnect_0/S01_ACLK] [get_bd_pins ddr4_0/c0_ddr4_ui_clk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk]
  connect_bd_net -net ddr4_0_c0_ddr4_ui_clk_sync_rst [get_bd_pins ddr4_0/c0_ddr4_ui_clk_sync_rst] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net pcie_clk_1 [get_bd_pins pcie_clk] [get_bd_pins axi_interconnect_0/S00_ACLK]
  connect_bd_net -net proc_sys_reset_1_interconnect_aresetn [get_bd_pins mem_rstn] [get_bd_pins axi_interconnect_0/ARESETN] [get_bd_pins axi_interconnect_0/M00_ARESETN] [get_bd_pins axi_interconnect_0/S01_ARESETN] [get_bd_pins proc_sys_reset_1/interconnect_aresetn]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins ddr4_0/c0_ddr4_aresetn] [get_bd_pins proc_sys_reset_1/peripheral_aresetn]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins ddr4_0/sys_rst] [get_bd_pins xlconstant_0/dout]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: dut
proc create_hier_cell_dut { parentCell nameHier } {

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2092 -severity "ERROR" "create_hier_cell_dut() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:axis_rtl:1.0 S_AXIS

  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 traffic_clk


  # Create pins
  create_bd_pin -dir I -from 0 -to 0 rst
  create_bd_pin -dir O -from 0 -to 0 -type clk traffic_clk

  # Create instance: axis_register_slice_0, and set properties
  set axis_register_slice_0 [ addip axis_register_slice axis_register_slice_0 ]

  # Create instance: axis_register_slice_1, and set properties
  set axis_register_slice_1 [ addip axis_register_slice axis_register_slice_1 ]

  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ addip util_ds_buf util_ds_buf_0 ]

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ addip util_ds_buf util_ds_buf_1 ]
  set_property -dict [ list \
   CONFIG.C_BUF_TYPE {BUFG} \
 ] $util_ds_buf_1

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ addip util_vector_logic util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S_AXIS] [get_bd_intf_pins axis_register_slice_0/S_AXIS]
  connect_bd_intf_net -intf_net Conn3 [get_bd_intf_pins traffic_clk] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net axis_register_slice_0_M_AXIS [get_bd_intf_pins axis_register_slice_0/M_AXIS] [get_bd_intf_pins axis_register_slice_1/S_AXIS]

  # Create port connections
  connect_bd_net -net Op1_1 [get_bd_pins rst] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net aresetn_1 [get_bd_pins axis_register_slice_0/aresetn] [get_bd_pins axis_register_slice_1/aresetn] [get_bd_pins util_vector_logic_0/Res]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins util_ds_buf_1/BUFG_I]
  connect_bd_net -net util_ds_buf_1_BUFG_O [get_bd_pins traffic_clk] [get_bd_pins axis_register_slice_0/aclk] [get_bd_pins axis_register_slice_1/aclk] [get_bd_pins util_ds_buf_1/BUFG_O]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell INSTR_BYTES easyobv_config} {

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set C0_DDR4_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddr4_rtl:1.0 C0_DDR4_0 ]

  set ddr_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 ddr_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {333111111} \
   ] $ddr_clk

  set pcie_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_clk ]

  set pcie_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_mgt ]

  set traffic_clk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 traffic_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $traffic_clk


  set EN_AXIL [dict get $easyobv_config CONFIG.EN_AXIL]
  # Create ports

  # Create instance: const_zero, and set properties
  if {$EN_AXIL == 0} {
    set const_zero [ addip xlconstant const_zero ]
    set_property -dict [ list \
     CONFIG.CONST_VAL {0} \
    ] $const_zero
  }

  # Create instance: dut
  create_hier_cell_dut [current_bd_instance .] dut

  # Create instance: easyobv_axis_0, and set properties
  set easyobv_axis_0 [ addip easyobv_axis easyobv_axis_0 ]
  set_property -dict ${easyobv_config} $easyobv_axis_0

  # Create instance: memory
  create_hier_cell_memory [current_bd_instance .] memory

  # Create instance: system_ila, and set properties
  set system_ila [ addip system_ila system_ila ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {6} \
   CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila

  # Create instance: traffic_engine_0, and set properties
  set traffic_engine_0 [ addip traffic_engine traffic_engine_0 ]
  set_property -dict [ list \
   CONFIG.INSTR0_WIDTH $INSTR_BYTES \
   CONFIG.N_CHANNELS {1} \
 ] $traffic_engine_0

  # Create instance: util_vector_logic, and set properties
  set util_vector_logic [ addip util_vector_logic util_vector_logic ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
 ] $util_vector_logic

  # Create instance: vio_0, and set properties
  set vio_0 [ addip vio vio_0 ]
  set_property -dict [ list \
   CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
   CONFIG.C_NUM_PROBE_IN {0} \
   CONFIG.C_NUM_PROBE_OUT {1} \
 ] $vio_0

  # Create instance: xdma
  create_hier_cell_xdma [current_bd_instance .] xdma

  # Create interface connections
  connect_bd_intf_net -intf_net C0_SYS_CLK_0_1 [get_bd_intf_ports ddr_clk] [get_bd_intf_pins memory/ddr_clk_DS]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports pcie_clk] [get_bd_intf_pins xdma/pcie_clk]
  connect_bd_intf_net -intf_net DDR_C0_DDR4_0 [get_bd_intf_ports C0_DDR4_0] [get_bd_intf_pins memory/C0_DDR4_0]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins memory/S00_AXI] [get_bd_intf_pins xdma/M_AXI]
  connect_bd_intf_net -intf_net easyobv_axis_0_traffic [get_bd_intf_pins dut/S_AXIS] [get_bd_intf_pins easyobv_axis_0/traffic]
  connect_bd_intf_net -intf_net [get_bd_intf_nets easyobv_axis_0_traffic] [get_bd_intf_pins dut/S_AXIS] [get_bd_intf_pins system_ila/SLOT_0_AXIS]
  connect_bd_intf_net -intf_net traffic_clk_1 [get_bd_intf_ports traffic_clk] [get_bd_intf_pins dut/traffic_clk]
  connect_bd_intf_net -intf_net traffic_engine_0_instr0 [get_bd_intf_pins easyobv_axis_0/instr] [get_bd_intf_pins traffic_engine_0/instr0]
  connect_bd_intf_net -intf_net traffic_engine_0_m_axi [get_bd_intf_pins memory/S01_AXI] [get_bd_intf_pins traffic_engine_0/m_axi]
  connect_bd_intf_net -intf_net xdma_M00_AXI [get_bd_intf_pins traffic_engine_0/s_axil] [get_bd_intf_pins xdma/M00_AXI]
  connect_bd_intf_net -intf_net xdma_pcie_mgt_0 [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins xdma/pcie_mgt_0]

  # Create port connections
  connect_bd_net -net memory_mem_clk [get_bd_pins memory/mem_clk] [get_bd_pins traffic_engine_0/mem_clk]
  connect_bd_net -net processor_pl_clk0 [get_bd_pins memory/pcie_clk] [get_bd_pins traffic_engine_0/s_axil_aclk] [get_bd_pins xdma/axi_aclk]
  connect_bd_net -net traffic_engine_0_instr0_rst [get_bd_pins dut/rst] [get_bd_pins easyobv_axis_0/rst] [get_bd_pins traffic_engine_0/instr0_rst] [get_bd_pins util_vector_logic/Op1]
  connect_bd_net -net util_ds_buf_1_BUFG_O [get_bd_pins dut/traffic_clk] [get_bd_pins easyobv_axis_0/clk] [get_bd_pins system_ila/clk] [get_bd_pins traffic_engine_0/instr0_clk] [get_bd_pins vio_0/clk]
  connect_bd_net -net util_vector_logic_Res [get_bd_pins system_ila/resetn] [get_bd_pins util_vector_logic/Res]
  connect_bd_net -net vio_0_probe_out0 [get_bd_pins traffic_engine_0/rst] [get_bd_pins vio_0/probe_out0]
  connect_bd_net -net xdma_axi_aresetn [get_bd_pins memory/pcie_rstn] [get_bd_pins xdma/axi_aresetn]
  if {$EN_AXIL == 0} {
    connect_bd_net -net xlconstant_0_dout [get_bd_pins const_zero/dout] [get_bd_pins easyobv_axis_0/pause] [get_bd_pins easyobv_axis_0/timeout_clr]
  }

  # Create address segments
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces traffic_engine_0/m_axi] [get_bd_addr_segs memory/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI] [get_bd_addr_segs memory/ddr4_0/C0_DDR4_MEMORY_MAP/C0_DDR4_ADDRESS_BLOCK] -force
  assign_bd_address -offset 0x00000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma/xdma_0/M_AXI_LITE] [get_bd_addr_segs traffic_engine_0/s_axil/reg0] -force

  # Restore current instance
  current_bd_instance $oldCurInst
}