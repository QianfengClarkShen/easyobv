`timescale 1ns/1ps
module axil
(
//user
    input logic core_ready_axil,
    input logic [3:0] n_channels,
    input logic mm2s_start_done,
    output logic reset_axil,
    output logic mm2s_start_axil,
    output logic [15:0] channel_en_axil,
    output logic [31:0] repeat_cnt_axil,
    output logic [63:0] rd_addr_axil[15:0],
    output logic [63:0] rd_size_axil[15:0],
    output logic [63:0] flitcnt_axil[15:0],
//axi lite
    input logic         clk,
    input logic         rst,
    input logic [8:0]   s_axil_awaddr,
    input logic         s_axil_awvalid,
    output logic        s_axil_awready,
    input logic [31:0]  s_axil_wdata,
    input logic [3:0]   s_axil_wstrb,
    input logic         s_axil_wvalid,
    output logic        s_axil_wready,
    output logic [1:0]  s_axil_bresp,
    output logic        s_axil_bvalid,
    input logic         s_axil_bready,
    input logic [8:0]   s_axil_araddr,
    input logic         s_axil_arvalid,
    output logic        s_axil_arready,
    output logic [31:0] s_axil_rdata,
    output logic [1:0]  s_axil_rresp,
    output logic        s_axil_rvalid,
    input logic         s_axil_rready
);
//------------------------Address Info-------------------
// 0x0 : Data signal of core_ready_axil
//    bit 0->0 - core_ready_axil (READ ONLY)
// 0x4 : Data signal of n_channels
//    bit 3->0 - n_channels[3:0] (READ ONLY)
// 0x8 : Data signal of reset_axil
//    bit 0->0 - reset_axil (READ/WRITE)
// 0xc : Data signal of mm2s_start_axil
//    bit 0->0 - mm2s_start_axil (READ/WRITE)
// 0x10 : Data signal of channel_en_axil
//    bit 15->0 - channel_en_axil[15:0] (READ/WRITE)
// 0x14 : Data signal of repeat_cnt_axil
//    bit 31->0 - repeat_cnt_axil[31:0] (READ/WRITE)
// 0x18 : Data signal of rd_addr_axil[0]
//    bit 31->0 - rd_addr_axil[0][31:0] (WRITE ONLY)
// 0x1c : Data signal of rd_addr_axil[0]
//    bit 31->0 - rd_addr_axil[0][63:32] (WRITE ONLY)
// 0x20 : Data signal of rd_size_axil[0]
//    bit 31->0 - rd_size_axil[0][31:0] (WRITE ONLY)
// 0x24 : Data signal of rd_size_axil[0]
//    bit 31->0 - rd_size_axil[0][63:32] (WRITE ONLY)
// 0x28 : Data signal of flitcnt_axil[0]
//    bit 31->0 - flitcnt_axil[0][31:0] (WRITE ONLY)
// 0x2c : Data signal of flitcnt_axil[0]
//    bit 31->0 - flitcnt_axil[0][63:32] (WRITE ONLY)
// 0x30 : Data signal of rd_addr_axil[1]
//    bit 31->0 - rd_addr_axil[1][31:0] (WRITE ONLY)
// 0x34 : Data signal of rd_addr_axil[1]
//    bit 31->0 - rd_addr_axil[1][63:32] (WRITE ONLY)
// 0x38 : Data signal of rd_size_axil[1]
//    bit 31->0 - rd_size_axil[1][31:0] (WRITE ONLY)
// 0x3c : Data signal of rd_size_axil[1]
//    bit 31->0 - rd_size_axil[1][63:32] (WRITE ONLY)
// 0x40 : Data signal of flitcnt_axil[1]
//    bit 31->0 - flitcnt_axil[1][31:0] (WRITE ONLY)
// 0x44 : Data signal of flitcnt_axil[1]
//    bit 31->0 - flitcnt_axil[1][63:32] (WRITE ONLY)
// 0x48 : Data signal of rd_addr_axil[2]
//    bit 31->0 - rd_addr_axil[2][31:0] (WRITE ONLY)
// 0x4c : Data signal of rd_addr_axil[2]
//    bit 31->0 - rd_addr_axil[2][63:32] (WRITE ONLY)
// 0x50 : Data signal of rd_size_axil[2]
//    bit 31->0 - rd_size_axil[2][31:0] (WRITE ONLY)
// 0x54 : Data signal of rd_size_axil[2]
//    bit 31->0 - rd_size_axil[2][63:32] (WRITE ONLY)
// 0x58 : Data signal of flitcnt_axil[2]
//    bit 31->0 - flitcnt_axil[2][31:0] (WRITE ONLY)
// 0x5c : Data signal of flitcnt_axil[2]
//    bit 31->0 - flitcnt_axil[2][63:32] (WRITE ONLY)
// 0x60 : Data signal of rd_addr_axil[3]
//    bit 31->0 - rd_addr_axil[3][31:0] (WRITE ONLY)
// 0x64 : Data signal of rd_addr_axil[3]
//    bit 31->0 - rd_addr_axil[3][63:32] (WRITE ONLY)
// 0x68 : Data signal of rd_size_axil[3]
//    bit 31->0 - rd_size_axil[3][31:0] (WRITE ONLY)
// 0x6c : Data signal of rd_size_axil[3]
//    bit 31->0 - rd_size_axil[3][63:32] (WRITE ONLY)
// 0x70 : Data signal of flitcnt_axil[3]
//    bit 31->0 - flitcnt_axil[3][31:0] (WRITE ONLY)
// 0x74 : Data signal of flitcnt_axil[3]
//    bit 31->0 - flitcnt_axil[3][63:32] (WRITE ONLY)
// 0x78 : Data signal of rd_addr_axil[4]
//    bit 31->0 - rd_addr_axil[4][31:0] (WRITE ONLY)
// 0x7c : Data signal of rd_addr_axil[4]
//    bit 31->0 - rd_addr_axil[4][63:32] (WRITE ONLY)
// 0x80 : Data signal of rd_size_axil[4]
//    bit 31->0 - rd_size_axil[4][31:0] (WRITE ONLY)
// 0x84 : Data signal of rd_size_axil[4]
//    bit 31->0 - rd_size_axil[4][63:32] (WRITE ONLY)
// 0x88 : Data signal of flitcnt_axil[4]
//    bit 31->0 - flitcnt_axil[4][31:0] (WRITE ONLY)
// 0x8c : Data signal of flitcnt_axil[4]
//    bit 31->0 - flitcnt_axil[4][63:32] (WRITE ONLY)
// 0x90 : Data signal of rd_addr_axil[5]
//    bit 31->0 - rd_addr_axil[5][31:0] (WRITE ONLY)
// 0x94 : Data signal of rd_addr_axil[5]
//    bit 31->0 - rd_addr_axil[5][63:32] (WRITE ONLY)
// 0x98 : Data signal of rd_size_axil[5]
//    bit 31->0 - rd_size_axil[5][31:0] (WRITE ONLY)
// 0x9c : Data signal of rd_size_axil[5]
//    bit 31->0 - rd_size_axil[5][63:32] (WRITE ONLY)
// 0xa0 : Data signal of flitcnt_axil[5]
//    bit 31->0 - flitcnt_axil[5][31:0] (WRITE ONLY)
// 0xa4 : Data signal of flitcnt_axil[5]
//    bit 31->0 - flitcnt_axil[5][63:32] (WRITE ONLY)
// 0xa8 : Data signal of rd_addr_axil[6]
//    bit 31->0 - rd_addr_axil[6][31:0] (WRITE ONLY)
// 0xac : Data signal of rd_addr_axil[6]
//    bit 31->0 - rd_addr_axil[6][63:32] (WRITE ONLY)
// 0xb0 : Data signal of rd_size_axil[6]
//    bit 31->0 - rd_size_axil[6][31:0] (WRITE ONLY)
// 0xb4 : Data signal of rd_size_axil[6]
//    bit 31->0 - rd_size_axil[6][63:32] (WRITE ONLY)
// 0xb8 : Data signal of flitcnt_axil[6]
//    bit 31->0 - flitcnt_axil[6][31:0] (WRITE ONLY)
// 0xbc : Data signal of flitcnt_axil[6]
//    bit 31->0 - flitcnt_axil[6][63:32] (WRITE ONLY)
// 0xc0 : Data signal of rd_addr_axil[7]
//    bit 31->0 - rd_addr_axil[7][31:0] (WRITE ONLY)
// 0xc4 : Data signal of rd_addr_axil[7]
//    bit 31->0 - rd_addr_axil[7][63:32] (WRITE ONLY)
// 0xc8 : Data signal of rd_size_axil[7]
//    bit 31->0 - rd_size_axil[7][31:0] (WRITE ONLY)
// 0xcc : Data signal of rd_size_axil[7]
//    bit 31->0 - rd_size_axil[7][63:32] (WRITE ONLY)
// 0xd0 : Data signal of flitcnt_axil[7]
//    bit 31->0 - flitcnt_axil[7][31:0] (WRITE ONLY)
// 0xd4 : Data signal of flitcnt_axil[7]
//    bit 31->0 - flitcnt_axil[7][63:32] (WRITE ONLY)
// 0xd8 : Data signal of rd_addr_axil[8]
//    bit 31->0 - rd_addr_axil[8][31:0] (WRITE ONLY)
// 0xdc : Data signal of rd_addr_axil[8]
//    bit 31->0 - rd_addr_axil[8][63:32] (WRITE ONLY)
// 0xe0 : Data signal of rd_size_axil[8]
//    bit 31->0 - rd_size_axil[8][31:0] (WRITE ONLY)
// 0xe4 : Data signal of rd_size_axil[8]
//    bit 31->0 - rd_size_axil[8][63:32] (WRITE ONLY)
// 0xe8 : Data signal of flitcnt_axil[8]
//    bit 31->0 - flitcnt_axil[8][31:0] (WRITE ONLY)
// 0xec : Data signal of flitcnt_axil[8]
//    bit 31->0 - flitcnt_axil[8][63:32] (WRITE ONLY)
// 0xf0 : Data signal of rd_addr_axil[9]
//    bit 31->0 - rd_addr_axil[9][31:0] (WRITE ONLY)
// 0xf4 : Data signal of rd_addr_axil[9]
//    bit 31->0 - rd_addr_axil[9][63:32] (WRITE ONLY)
// 0xf8 : Data signal of rd_size_axil[9]
//    bit 31->0 - rd_size_axil[9][31:0] (WRITE ONLY)
// 0xfc : Data signal of rd_size_axil[9]
//    bit 31->0 - rd_size_axil[9][63:32] (WRITE ONLY)
// 0x100 : Data signal of flitcnt_axil[9]
//    bit 31->0 - flitcnt_axil[9][31:0] (WRITE ONLY)
// 0x104 : Data signal of flitcnt_axil[9]
//    bit 31->0 - flitcnt_axil[9][63:32] (WRITE ONLY)
// 0x108 : Data signal of rd_addr_axil[10]
//    bit 31->0 - rd_addr_axil[10][31:0] (WRITE ONLY)
// 0x10c : Data signal of rd_addr_axil[10]
//    bit 31->0 - rd_addr_axil[10][63:32] (WRITE ONLY)
// 0x110 : Data signal of rd_size_axil[10]
//    bit 31->0 - rd_size_axil[10][31:0] (WRITE ONLY)
// 0x114 : Data signal of rd_size_axil[10]
//    bit 31->0 - rd_size_axil[10][63:32] (WRITE ONLY)
// 0x118 : Data signal of flitcnt_axil[10]
//    bit 31->0 - flitcnt_axil[10][31:0] (WRITE ONLY)
// 0x11c : Data signal of flitcnt_axil[10]
//    bit 31->0 - flitcnt_axil[10][63:32] (WRITE ONLY)
// 0x120 : Data signal of rd_addr_axil[11]
//    bit 31->0 - rd_addr_axil[11][31:0] (WRITE ONLY)
// 0x124 : Data signal of rd_addr_axil[11]
//    bit 31->0 - rd_addr_axil[11][63:32] (WRITE ONLY)
// 0x128 : Data signal of rd_size_axil[11]
//    bit 31->0 - rd_size_axil[11][31:0] (WRITE ONLY)
// 0x12c : Data signal of rd_size_axil[11]
//    bit 31->0 - rd_size_axil[11][63:32] (WRITE ONLY)
// 0x130 : Data signal of flitcnt_axil[11]
//    bit 31->0 - flitcnt_axil[11][31:0] (WRITE ONLY)
// 0x134 : Data signal of flitcnt_axil[11]
//    bit 31->0 - flitcnt_axil[11][63:32] (WRITE ONLY)
// 0x138 : Data signal of rd_addr_axil[12]
//    bit 31->0 - rd_addr_axil[12][31:0] (WRITE ONLY)
// 0x13c : Data signal of rd_addr_axil[12]
//    bit 31->0 - rd_addr_axil[12][63:32] (WRITE ONLY)
// 0x140 : Data signal of rd_size_axil[12]
//    bit 31->0 - rd_size_axil[12][31:0] (WRITE ONLY)
// 0x144 : Data signal of rd_size_axil[12]
//    bit 31->0 - rd_size_axil[12][63:32] (WRITE ONLY)
// 0x148 : Data signal of flitcnt_axil[12]
//    bit 31->0 - flitcnt_axil[12][31:0] (WRITE ONLY)
// 0x14c : Data signal of flitcnt_axil[12]
//    bit 31->0 - flitcnt_axil[12][63:32] (WRITE ONLY)
// 0x150 : Data signal of rd_addr_axil[13]
//    bit 31->0 - rd_addr_axil[13][31:0] (WRITE ONLY)
// 0x154 : Data signal of rd_addr_axil[13]
//    bit 31->0 - rd_addr_axil[13][63:32] (WRITE ONLY)
// 0x158 : Data signal of rd_size_axil[13]
//    bit 31->0 - rd_size_axil[13][31:0] (WRITE ONLY)
// 0x15c : Data signal of rd_size_axil[13]
//    bit 31->0 - rd_size_axil[13][63:32] (WRITE ONLY)
// 0x160 : Data signal of flitcnt_axil[13]
//    bit 31->0 - flitcnt_axil[13][31:0] (WRITE ONLY)
// 0x164 : Data signal of flitcnt_axil[13]
//    bit 31->0 - flitcnt_axil[13][63:32] (WRITE ONLY)
// 0x168 : Data signal of rd_addr_axil[14]
//    bit 31->0 - rd_addr_axil[14][31:0] (WRITE ONLY)
// 0x16c : Data signal of rd_addr_axil[14]
//    bit 31->0 - rd_addr_axil[14][63:32] (WRITE ONLY)
// 0x170 : Data signal of rd_size_axil[14]
//    bit 31->0 - rd_size_axil[14][31:0] (WRITE ONLY)
// 0x174 : Data signal of rd_size_axil[14]
//    bit 31->0 - rd_size_axil[14][63:32] (WRITE ONLY)
// 0x178 : Data signal of flitcnt_axil[14]
//    bit 31->0 - flitcnt_axil[14][31:0] (WRITE ONLY)
// 0x17c : Data signal of flitcnt_axil[14]
//    bit 31->0 - flitcnt_axil[14][63:32] (WRITE ONLY)
// 0x180 : Data signal of rd_addr_axil[15]
//    bit 31->0 - rd_addr_axil[15][31:0] (WRITE ONLY)
// 0x184 : Data signal of rd_addr_axil[15]
//    bit 31->0 - rd_addr_axil[15][63:32] (WRITE ONLY)
// 0x188 : Data signal of rd_size_axil[15]
//    bit 31->0 - rd_size_axil[15][31:0] (WRITE ONLY)
// 0x18c : Data signal of rd_size_axil[15]
//    bit 31->0 - rd_size_axil[15][63:32] (WRITE ONLY)
// 0x190 : Data signal of flitcnt_axil[15]
//    bit 31->0 - flitcnt_axil[15][31:0] (WRITE ONLY)
// 0x194 : Data signal of flitcnt_axil[15]
//    bit 31->0 - flitcnt_axil[15][63:32] (WRITE ONLY)
//------------------------Parameter----------------------
    localparam bit [8:0] CORE_READY_AXIL_ADDR_0 = 9'd0;
    localparam bit [8:0] N_CHANNELS_ADDR_0 = 9'd4;
    localparam bit [8:0] RESET_AXIL_ADDR_0 = 9'd8;
    localparam bit [8:0] MM2S_START_AXIL_ADDR_0 = 9'd12;
    localparam bit [8:0] CHANNEL_EN_AXIL_ADDR_0 = 9'd16;
    localparam bit [8:0] REPEAT_CNT_AXIL_ADDR_0 = 9'd20;
    localparam bit [8:0] RD_ADDR_AXIL0_ADDR_0 = 9'd24;
    localparam bit [8:0] RD_ADDR_AXIL0_ADDR_1 = 9'd28;
    localparam bit [8:0] RD_SIZE_AXIL0_ADDR_0 = 9'd32;
    localparam bit [8:0] RD_SIZE_AXIL0_ADDR_1 = 9'd36;
    localparam bit [8:0] FLITCNT_AXIL0_ADDR_0 = 9'd40;
    localparam bit [8:0] FLITCNT_AXIL0_ADDR_1 = 9'd44;
    localparam bit [8:0] RD_ADDR_AXIL1_ADDR_0 = 9'd48;
    localparam bit [8:0] RD_ADDR_AXIL1_ADDR_1 = 9'd52;
    localparam bit [8:0] RD_SIZE_AXIL1_ADDR_0 = 9'd56;
    localparam bit [8:0] RD_SIZE_AXIL1_ADDR_1 = 9'd60;
    localparam bit [8:0] FLITCNT_AXIL1_ADDR_0 = 9'd64;
    localparam bit [8:0] FLITCNT_AXIL1_ADDR_1 = 9'd68;
    localparam bit [8:0] RD_ADDR_AXIL2_ADDR_0 = 9'd72;
    localparam bit [8:0] RD_ADDR_AXIL2_ADDR_1 = 9'd76;
    localparam bit [8:0] RD_SIZE_AXIL2_ADDR_0 = 9'd80;
    localparam bit [8:0] RD_SIZE_AXIL2_ADDR_1 = 9'd84;
    localparam bit [8:0] FLITCNT_AXIL2_ADDR_0 = 9'd88;
    localparam bit [8:0] FLITCNT_AXIL2_ADDR_1 = 9'd92;
    localparam bit [8:0] RD_ADDR_AXIL3_ADDR_0 = 9'd96;
    localparam bit [8:0] RD_ADDR_AXIL3_ADDR_1 = 9'd100;
    localparam bit [8:0] RD_SIZE_AXIL3_ADDR_0 = 9'd104;
    localparam bit [8:0] RD_SIZE_AXIL3_ADDR_1 = 9'd108;
    localparam bit [8:0] FLITCNT_AXIL3_ADDR_0 = 9'd112;
    localparam bit [8:0] FLITCNT_AXIL3_ADDR_1 = 9'd116;
    localparam bit [8:0] RD_ADDR_AXIL4_ADDR_0 = 9'd120;
    localparam bit [8:0] RD_ADDR_AXIL4_ADDR_1 = 9'd124;
    localparam bit [8:0] RD_SIZE_AXIL4_ADDR_0 = 9'd128;
    localparam bit [8:0] RD_SIZE_AXIL4_ADDR_1 = 9'd132;
    localparam bit [8:0] FLITCNT_AXIL4_ADDR_0 = 9'd136;
    localparam bit [8:0] FLITCNT_AXIL4_ADDR_1 = 9'd140;
    localparam bit [8:0] RD_ADDR_AXIL5_ADDR_0 = 9'd144;
    localparam bit [8:0] RD_ADDR_AXIL5_ADDR_1 = 9'd148;
    localparam bit [8:0] RD_SIZE_AXIL5_ADDR_0 = 9'd152;
    localparam bit [8:0] RD_SIZE_AXIL5_ADDR_1 = 9'd156;
    localparam bit [8:0] FLITCNT_AXIL5_ADDR_0 = 9'd160;
    localparam bit [8:0] FLITCNT_AXIL5_ADDR_1 = 9'd164;
    localparam bit [8:0] RD_ADDR_AXIL6_ADDR_0 = 9'd168;
    localparam bit [8:0] RD_ADDR_AXIL6_ADDR_1 = 9'd172;
    localparam bit [8:0] RD_SIZE_AXIL6_ADDR_0 = 9'd176;
    localparam bit [8:0] RD_SIZE_AXIL6_ADDR_1 = 9'd180;
    localparam bit [8:0] FLITCNT_AXIL6_ADDR_0 = 9'd184;
    localparam bit [8:0] FLITCNT_AXIL6_ADDR_1 = 9'd188;
    localparam bit [8:0] RD_ADDR_AXIL7_ADDR_0 = 9'd192;
    localparam bit [8:0] RD_ADDR_AXIL7_ADDR_1 = 9'd196;
    localparam bit [8:0] RD_SIZE_AXIL7_ADDR_0 = 9'd200;
    localparam bit [8:0] RD_SIZE_AXIL7_ADDR_1 = 9'd204;
    localparam bit [8:0] FLITCNT_AXIL7_ADDR_0 = 9'd208;
    localparam bit [8:0] FLITCNT_AXIL7_ADDR_1 = 9'd212;
    localparam bit [8:0] RD_ADDR_AXIL8_ADDR_0 = 9'd216;
    localparam bit [8:0] RD_ADDR_AXIL8_ADDR_1 = 9'd220;
    localparam bit [8:0] RD_SIZE_AXIL8_ADDR_0 = 9'd224;
    localparam bit [8:0] RD_SIZE_AXIL8_ADDR_1 = 9'd228;
    localparam bit [8:0] FLITCNT_AXIL8_ADDR_0 = 9'd232;
    localparam bit [8:0] FLITCNT_AXIL8_ADDR_1 = 9'd236;
    localparam bit [8:0] RD_ADDR_AXIL9_ADDR_0 = 9'd240;
    localparam bit [8:0] RD_ADDR_AXIL9_ADDR_1 = 9'd244;
    localparam bit [8:0] RD_SIZE_AXIL9_ADDR_0 = 9'd248;
    localparam bit [8:0] RD_SIZE_AXIL9_ADDR_1 = 9'd252;
    localparam bit [8:0] FLITCNT_AXIL9_ADDR_0 = 9'd256;
    localparam bit [8:0] FLITCNT_AXIL9_ADDR_1 = 9'd260;
    localparam bit [8:0] RD_ADDR_AXIL10_ADDR_0 = 9'd264;
    localparam bit [8:0] RD_ADDR_AXIL10_ADDR_1 = 9'd268;
    localparam bit [8:0] RD_SIZE_AXIL10_ADDR_0 = 9'd272;
    localparam bit [8:0] RD_SIZE_AXIL10_ADDR_1 = 9'd276;
    localparam bit [8:0] FLITCNT_AXIL10_ADDR_0 = 9'd280;
    localparam bit [8:0] FLITCNT_AXIL10_ADDR_1 = 9'd284;
    localparam bit [8:0] RD_ADDR_AXIL11_ADDR_0 = 9'd288;
    localparam bit [8:0] RD_ADDR_AXIL11_ADDR_1 = 9'd292;
    localparam bit [8:0] RD_SIZE_AXIL11_ADDR_0 = 9'd296;
    localparam bit [8:0] RD_SIZE_AXIL11_ADDR_1 = 9'd300;
    localparam bit [8:0] FLITCNT_AXIL11_ADDR_0 = 9'd304;
    localparam bit [8:0] FLITCNT_AXIL11_ADDR_1 = 9'd308;
    localparam bit [8:0] RD_ADDR_AXIL12_ADDR_0 = 9'd312;
    localparam bit [8:0] RD_ADDR_AXIL12_ADDR_1 = 9'd316;
    localparam bit [8:0] RD_SIZE_AXIL12_ADDR_0 = 9'd320;
    localparam bit [8:0] RD_SIZE_AXIL12_ADDR_1 = 9'd324;
    localparam bit [8:0] FLITCNT_AXIL12_ADDR_0 = 9'd328;
    localparam bit [8:0] FLITCNT_AXIL12_ADDR_1 = 9'd332;
    localparam bit [8:0] RD_ADDR_AXIL13_ADDR_0 = 9'd336;
    localparam bit [8:0] RD_ADDR_AXIL13_ADDR_1 = 9'd340;
    localparam bit [8:0] RD_SIZE_AXIL13_ADDR_0 = 9'd344;
    localparam bit [8:0] RD_SIZE_AXIL13_ADDR_1 = 9'd348;
    localparam bit [8:0] FLITCNT_AXIL13_ADDR_0 = 9'd352;
    localparam bit [8:0] FLITCNT_AXIL13_ADDR_1 = 9'd356;
    localparam bit [8:0] RD_ADDR_AXIL14_ADDR_0 = 9'd360;
    localparam bit [8:0] RD_ADDR_AXIL14_ADDR_1 = 9'd364;
    localparam bit [8:0] RD_SIZE_AXIL14_ADDR_0 = 9'd368;
    localparam bit [8:0] RD_SIZE_AXIL14_ADDR_1 = 9'd372;
    localparam bit [8:0] FLITCNT_AXIL14_ADDR_0 = 9'd376;
    localparam bit [8:0] FLITCNT_AXIL14_ADDR_1 = 9'd380;
    localparam bit [8:0] RD_ADDR_AXIL15_ADDR_0 = 9'd384;
    localparam bit [8:0] RD_ADDR_AXIL15_ADDR_1 = 9'd388;
    localparam bit [8:0] RD_SIZE_AXIL15_ADDR_0 = 9'd392;
    localparam bit [8:0] RD_SIZE_AXIL15_ADDR_1 = 9'd396;
    localparam bit [8:0] FLITCNT_AXIL15_ADDR_0 = 9'd400;
    localparam bit [8:0] FLITCNT_AXIL15_ADDR_1 = 9'd404;
    localparam int ADDR_BITS = 9;
    localparam bit [1:0] WRIDLE = 2'd0;
    localparam bit [1:0] WRDATA = 2'd1;
    localparam bit [1:0] WRRESP = 2'd2;
    localparam bit [1:0] WRRESET = 2'd3;
    localparam bit [1:0] RDIDLE = 2'd0;
    localparam bit [1:0] RDDATA = 2'd1;
    localparam bit [1:0] RDRESET = 2'd2;

    logic [1:0] wstate = WRRESET;
    logic [1:0] wnext;
    logic [ADDR_BITS-1:0] waddr;
    logic [31:0] wmask;
    logic aw_hs;
    logic w_hs;
    logic [1:0] rstate = RDRESET;
    logic [1:0] rnext;
    logic [31:0] rdata;
    logic ar_hs;
    logic [ADDR_BITS-1:0] raddr;

//user logic
    logic [31:0] int_core_ready_axil_0;
    logic [31:0] int_n_channels_0;
    logic [31:0] int_reset_axil_0;
    logic [31:0] int_mm2s_start_axil_0;
    logic [31:0] int_channel_en_axil_0;
    logic [31:0] int_repeat_cnt_axil_0;
    logic [31:0] int_rd_addr_axil0_0;
    logic [31:0] int_rd_addr_axil0_1;
    logic [31:0] int_rd_size_axil0_0;
    logic [31:0] int_rd_size_axil0_1;
    logic [31:0] int_flitcnt_axil0_0;
    logic [31:0] int_flitcnt_axil0_1;
    logic [31:0] int_rd_addr_axil1_0;
    logic [31:0] int_rd_addr_axil1_1;
    logic [31:0] int_rd_size_axil1_0;
    logic [31:0] int_rd_size_axil1_1;
    logic [31:0] int_flitcnt_axil1_0;
    logic [31:0] int_flitcnt_axil1_1;
    logic [31:0] int_rd_addr_axil2_0;
    logic [31:0] int_rd_addr_axil2_1;
    logic [31:0] int_rd_size_axil2_0;
    logic [31:0] int_rd_size_axil2_1;
    logic [31:0] int_flitcnt_axil2_0;
    logic [31:0] int_flitcnt_axil2_1;
    logic [31:0] int_rd_addr_axil3_0;
    logic [31:0] int_rd_addr_axil3_1;
    logic [31:0] int_rd_size_axil3_0;
    logic [31:0] int_rd_size_axil3_1;
    logic [31:0] int_flitcnt_axil3_0;
    logic [31:0] int_flitcnt_axil3_1;
    logic [31:0] int_rd_addr_axil4_0;
    logic [31:0] int_rd_addr_axil4_1;
    logic [31:0] int_rd_size_axil4_0;
    logic [31:0] int_rd_size_axil4_1;
    logic [31:0] int_flitcnt_axil4_0;
    logic [31:0] int_flitcnt_axil4_1;
    logic [31:0] int_rd_addr_axil5_0;
    logic [31:0] int_rd_addr_axil5_1;
    logic [31:0] int_rd_size_axil5_0;
    logic [31:0] int_rd_size_axil5_1;
    logic [31:0] int_flitcnt_axil5_0;
    logic [31:0] int_flitcnt_axil5_1;
    logic [31:0] int_rd_addr_axil6_0;
    logic [31:0] int_rd_addr_axil6_1;
    logic [31:0] int_rd_size_axil6_0;
    logic [31:0] int_rd_size_axil6_1;
    logic [31:0] int_flitcnt_axil6_0;
    logic [31:0] int_flitcnt_axil6_1;
    logic [31:0] int_rd_addr_axil7_0;
    logic [31:0] int_rd_addr_axil7_1;
    logic [31:0] int_rd_size_axil7_0;
    logic [31:0] int_rd_size_axil7_1;
    logic [31:0] int_flitcnt_axil7_0;
    logic [31:0] int_flitcnt_axil7_1;
    logic [31:0] int_rd_addr_axil8_0;
    logic [31:0] int_rd_addr_axil8_1;
    logic [31:0] int_rd_size_axil8_0;
    logic [31:0] int_rd_size_axil8_1;
    logic [31:0] int_flitcnt_axil8_0;
    logic [31:0] int_flitcnt_axil8_1;
    logic [31:0] int_rd_addr_axil9_0;
    logic [31:0] int_rd_addr_axil9_1;
    logic [31:0] int_rd_size_axil9_0;
    logic [31:0] int_rd_size_axil9_1;
    logic [31:0] int_flitcnt_axil9_0;
    logic [31:0] int_flitcnt_axil9_1;
    logic [31:0] int_rd_addr_axil10_0;
    logic [31:0] int_rd_addr_axil10_1;
    logic [31:0] int_rd_size_axil10_0;
    logic [31:0] int_rd_size_axil10_1;
    logic [31:0] int_flitcnt_axil10_0;
    logic [31:0] int_flitcnt_axil10_1;
    logic [31:0] int_rd_addr_axil11_0;
    logic [31:0] int_rd_addr_axil11_1;
    logic [31:0] int_rd_size_axil11_0;
    logic [31:0] int_rd_size_axil11_1;
    logic [31:0] int_flitcnt_axil11_0;
    logic [31:0] int_flitcnt_axil11_1;
    logic [31:0] int_rd_addr_axil12_0;
    logic [31:0] int_rd_addr_axil12_1;
    logic [31:0] int_rd_size_axil12_0;
    logic [31:0] int_rd_size_axil12_1;
    logic [31:0] int_flitcnt_axil12_0;
    logic [31:0] int_flitcnt_axil12_1;
    logic [31:0] int_rd_addr_axil13_0;
    logic [31:0] int_rd_addr_axil13_1;
    logic [31:0] int_rd_size_axil13_0;
    logic [31:0] int_rd_size_axil13_1;
    logic [31:0] int_flitcnt_axil13_0;
    logic [31:0] int_flitcnt_axil13_1;
    logic [31:0] int_rd_addr_axil14_0;
    logic [31:0] int_rd_addr_axil14_1;
    logic [31:0] int_rd_size_axil14_0;
    logic [31:0] int_rd_size_axil14_1;
    logic [31:0] int_flitcnt_axil14_0;
    logic [31:0] int_flitcnt_axil14_1;
    logic [31:0] int_rd_addr_axil15_0;
    logic [31:0] int_rd_addr_axil15_1;
    logic [31:0] int_rd_size_axil15_0;
    logic [31:0] int_rd_size_axil15_1;
    logic [31:0] int_flitcnt_axil15_0;
    logic [31:0] int_flitcnt_axil15_1;
    assign s_axil_awready = (wstate == WRIDLE);
    assign s_axil_wready = (wstate == WRDATA);
    assign s_axil_bresp = 2'b00;
    assign s_axil_bvalid = (wstate == WRRESP);
    assign wmask = { {8{s_axil_wstrb[3]}}, {8{s_axil_wstrb[2]}}, {8{s_axil_wstrb[1]}}, {8{s_axil_wstrb[0]}} };
    assign aw_hs = s_axil_awvalid & s_axil_awready;
    assign w_hs = s_axil_wvalid & s_axil_wready;

// wstate
    always_ff @(posedge clk) begin
        if (rst)
            wstate <= WRRESET;
        else
            wstate <= wnext;
    end
    
    // wnext
    always_comb begin
        case (wstate)
            WRIDLE:
                if (s_axil_awvalid)
                    wnext = WRDATA;
                else
                    wnext = WRIDLE;
            WRDATA:
                if (s_axil_wvalid)
                    wnext = WRRESP;
                else
                    wnext = WRDATA;
            WRRESP:
                if (s_axil_bready)
                    wnext = WRIDLE;
                else
                    wnext = WRRESP;
            default:
                wnext = WRIDLE;
        endcase
    end
    
    // waddr
    always_ff @(posedge clk) begin
        if (aw_hs)
            waddr <= s_axil_awaddr[ADDR_BITS-1:0];
    end
    
    //------------------------AXI read fsm-------------------
    assign s_axil_arready = (rstate == RDIDLE);
    assign s_axil_rdata = rdata;
    assign s_axil_rresp = 2'b00;
    assign s_axil_rvalid = (rstate == RDDATA);
    assign ar_hs = s_axil_arvalid & s_axil_arready;
    assign raddr = s_axil_araddr[ADDR_BITS-1:0];
    
    // rstate
    always_ff @(posedge clk) begin
        if (rst)
            rstate <= RDRESET;
        else
            rstate <= rnext;
    end
    
    // rnext
    always_comb begin
        case (rstate)
            RDIDLE:
                if (s_axil_arvalid)
                    rnext = RDDATA;
                else
                    rnext = RDIDLE;
            RDDATA:
                if (s_axil_rready & s_axil_rvalid)
                    rnext = RDIDLE;
                else
                    rnext = RDDATA;
            default:
                rnext = RDIDLE;
        endcase
    end
    
    // rdata
    always_ff @(posedge clk) begin
        if (ar_hs) begin
            rdata <= 1'b0;
            case (raddr)
                CORE_READY_AXIL_ADDR_0: begin
                    rdata <= int_core_ready_axil_0;
                end
                N_CHANNELS_ADDR_0: begin
                    rdata <= int_n_channels_0;
                end
                RESET_AXIL_ADDR_0: begin
                    rdata <= int_reset_axil_0;
                end
                MM2S_START_AXIL_ADDR_0: begin
                    rdata <= int_mm2s_start_axil_0;
                end
                CHANNEL_EN_AXIL_ADDR_0: begin
                    rdata <= int_channel_en_axil_0;
                end
                REPEAT_CNT_AXIL_ADDR_0: begin
                    rdata <= int_repeat_cnt_axil_0;
                end
                default: begin
                    rdata <= 32'b0;
                end
            endcase
        end
    end

    //------------------------user read logic-----------------
    // int_core_ready_axil_0
    always_ff @(posedge clk) begin
        if (rst)
            int_core_ready_axil_0 <= 32'b0;
        else
            int_core_ready_axil_0[0:0] <= core_ready_axil;
    end
    // int_n_channels_0
    always_ff @(posedge clk) begin
        if (rst)
            int_n_channels_0 <= 32'b0;
        else
            int_n_channels_0[3:0] <= n_channels[3:0];
    end
    //------------------------user write logic-----------------
    // int_reset_axil_0
    always_ff @(posedge clk) begin
        if (rst)
            int_reset_axil_0 <= 32'b0;
        else if (int_reset_axil_0 != 32'b0)
            int_reset_axil_0 <= 32'b0;
        else if (w_hs && waddr == RESET_AXIL_ADDR_0)
            int_reset_axil_0 <= (s_axil_wdata[31:0] & wmask) | (int_reset_axil_0 & ~wmask);
    end
    // int_mm2s_start_axil_0
    always_ff @(posedge clk) begin
        if (rst)
            int_mm2s_start_axil_0 <= 32'b0;
        else if (mm2s_start_done)
            int_mm2s_start_axil_0 <= 32'b0;
        else if (w_hs && waddr == MM2S_START_AXIL_ADDR_0)
            int_mm2s_start_axil_0 <= (s_axil_wdata[31:0] & wmask) | (int_mm2s_start_axil_0 & ~wmask);
    end
    // int_channel_en_axil_0
    always_ff @(posedge clk) begin
        if (rst)
            int_channel_en_axil_0 <= 32'b0;
        else if (w_hs && waddr == CHANNEL_EN_AXIL_ADDR_0)
            int_channel_en_axil_0 <= (s_axil_wdata[31:0] & wmask) | (int_channel_en_axil_0 & ~wmask);
    end
    // int_repeat_cnt_axil_0
    always_ff @(posedge clk) begin
        if (rst)
            int_repeat_cnt_axil_0 <= 32'b0;
        else if (w_hs && waddr == REPEAT_CNT_AXIL_ADDR_0)
            int_repeat_cnt_axil_0 <= (s_axil_wdata[31:0] & wmask) | (int_repeat_cnt_axil_0 & ~wmask);
    end
    // int_rd_addr_axil0_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil0_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL0_ADDR_0)
            int_rd_addr_axil0_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil0_0 & ~wmask);
    end
    // int_rd_addr_axil0_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil0_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL0_ADDR_1)
            int_rd_addr_axil0_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil0_1 & ~wmask);
    end
    // int_rd_size_axil0_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil0_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL0_ADDR_0)
            int_rd_size_axil0_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil0_0 & ~wmask);
    end
    // int_rd_size_axil0_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil0_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL0_ADDR_1)
            int_rd_size_axil0_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil0_1 & ~wmask);
    end
    // int_flitcnt_axil0_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil0_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL0_ADDR_0)
            int_flitcnt_axil0_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil0_0 & ~wmask);
    end
    // int_flitcnt_axil0_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil0_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL0_ADDR_1)
            int_flitcnt_axil0_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil0_1 & ~wmask);
    end
    // int_rd_addr_axil1_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil1_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL1_ADDR_0)
            int_rd_addr_axil1_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil1_0 & ~wmask);
    end
    // int_rd_addr_axil1_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil1_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL1_ADDR_1)
            int_rd_addr_axil1_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil1_1 & ~wmask);
    end
    // int_rd_size_axil1_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil1_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL1_ADDR_0)
            int_rd_size_axil1_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil1_0 & ~wmask);
    end
    // int_rd_size_axil1_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil1_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL1_ADDR_1)
            int_rd_size_axil1_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil1_1 & ~wmask);
    end
    // int_flitcnt_axil1_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil1_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL1_ADDR_0)
            int_flitcnt_axil1_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil1_0 & ~wmask);
    end
    // int_flitcnt_axil1_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil1_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL1_ADDR_1)
            int_flitcnt_axil1_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil1_1 & ~wmask);
    end
    // int_rd_addr_axil2_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil2_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL2_ADDR_0)
            int_rd_addr_axil2_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil2_0 & ~wmask);
    end
    // int_rd_addr_axil2_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil2_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL2_ADDR_1)
            int_rd_addr_axil2_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil2_1 & ~wmask);
    end
    // int_rd_size_axil2_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil2_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL2_ADDR_0)
            int_rd_size_axil2_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil2_0 & ~wmask);
    end
    // int_rd_size_axil2_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil2_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL2_ADDR_1)
            int_rd_size_axil2_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil2_1 & ~wmask);
    end
    // int_flitcnt_axil2_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil2_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL2_ADDR_0)
            int_flitcnt_axil2_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil2_0 & ~wmask);
    end
    // int_flitcnt_axil2_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil2_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL2_ADDR_1)
            int_flitcnt_axil2_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil2_1 & ~wmask);
    end
    // int_rd_addr_axil3_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil3_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL3_ADDR_0)
            int_rd_addr_axil3_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil3_0 & ~wmask);
    end
    // int_rd_addr_axil3_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil3_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL3_ADDR_1)
            int_rd_addr_axil3_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil3_1 & ~wmask);
    end
    // int_rd_size_axil3_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil3_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL3_ADDR_0)
            int_rd_size_axil3_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil3_0 & ~wmask);
    end
    // int_rd_size_axil3_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil3_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL3_ADDR_1)
            int_rd_size_axil3_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil3_1 & ~wmask);
    end
    // int_flitcnt_axil3_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil3_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL3_ADDR_0)
            int_flitcnt_axil3_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil3_0 & ~wmask);
    end
    // int_flitcnt_axil3_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil3_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL3_ADDR_1)
            int_flitcnt_axil3_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil3_1 & ~wmask);
    end
    // int_rd_addr_axil4_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil4_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL4_ADDR_0)
            int_rd_addr_axil4_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil4_0 & ~wmask);
    end
    // int_rd_addr_axil4_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil4_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL4_ADDR_1)
            int_rd_addr_axil4_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil4_1 & ~wmask);
    end
    // int_rd_size_axil4_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil4_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL4_ADDR_0)
            int_rd_size_axil4_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil4_0 & ~wmask);
    end
    // int_rd_size_axil4_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil4_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL4_ADDR_1)
            int_rd_size_axil4_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil4_1 & ~wmask);
    end
    // int_flitcnt_axil4_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil4_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL4_ADDR_0)
            int_flitcnt_axil4_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil4_0 & ~wmask);
    end
    // int_flitcnt_axil4_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil4_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL4_ADDR_1)
            int_flitcnt_axil4_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil4_1 & ~wmask);
    end
    // int_rd_addr_axil5_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil5_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL5_ADDR_0)
            int_rd_addr_axil5_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil5_0 & ~wmask);
    end
    // int_rd_addr_axil5_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil5_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL5_ADDR_1)
            int_rd_addr_axil5_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil5_1 & ~wmask);
    end
    // int_rd_size_axil5_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil5_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL5_ADDR_0)
            int_rd_size_axil5_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil5_0 & ~wmask);
    end
    // int_rd_size_axil5_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil5_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL5_ADDR_1)
            int_rd_size_axil5_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil5_1 & ~wmask);
    end
    // int_flitcnt_axil5_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil5_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL5_ADDR_0)
            int_flitcnt_axil5_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil5_0 & ~wmask);
    end
    // int_flitcnt_axil5_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil5_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL5_ADDR_1)
            int_flitcnt_axil5_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil5_1 & ~wmask);
    end
    // int_rd_addr_axil6_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil6_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL6_ADDR_0)
            int_rd_addr_axil6_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil6_0 & ~wmask);
    end
    // int_rd_addr_axil6_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil6_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL6_ADDR_1)
            int_rd_addr_axil6_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil6_1 & ~wmask);
    end
    // int_rd_size_axil6_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil6_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL6_ADDR_0)
            int_rd_size_axil6_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil6_0 & ~wmask);
    end
    // int_rd_size_axil6_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil6_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL6_ADDR_1)
            int_rd_size_axil6_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil6_1 & ~wmask);
    end
    // int_flitcnt_axil6_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil6_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL6_ADDR_0)
            int_flitcnt_axil6_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil6_0 & ~wmask);
    end
    // int_flitcnt_axil6_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil6_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL6_ADDR_1)
            int_flitcnt_axil6_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil6_1 & ~wmask);
    end
    // int_rd_addr_axil7_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil7_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL7_ADDR_0)
            int_rd_addr_axil7_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil7_0 & ~wmask);
    end
    // int_rd_addr_axil7_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil7_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL7_ADDR_1)
            int_rd_addr_axil7_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil7_1 & ~wmask);
    end
    // int_rd_size_axil7_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil7_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL7_ADDR_0)
            int_rd_size_axil7_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil7_0 & ~wmask);
    end
    // int_rd_size_axil7_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil7_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL7_ADDR_1)
            int_rd_size_axil7_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil7_1 & ~wmask);
    end
    // int_flitcnt_axil7_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil7_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL7_ADDR_0)
            int_flitcnt_axil7_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil7_0 & ~wmask);
    end
    // int_flitcnt_axil7_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil7_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL7_ADDR_1)
            int_flitcnt_axil7_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil7_1 & ~wmask);
    end
    // int_rd_addr_axil8_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil8_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL8_ADDR_0)
            int_rd_addr_axil8_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil8_0 & ~wmask);
    end
    // int_rd_addr_axil8_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil8_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL8_ADDR_1)
            int_rd_addr_axil8_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil8_1 & ~wmask);
    end
    // int_rd_size_axil8_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil8_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL8_ADDR_0)
            int_rd_size_axil8_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil8_0 & ~wmask);
    end
    // int_rd_size_axil8_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil8_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL8_ADDR_1)
            int_rd_size_axil8_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil8_1 & ~wmask);
    end
    // int_flitcnt_axil8_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil8_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL8_ADDR_0)
            int_flitcnt_axil8_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil8_0 & ~wmask);
    end
    // int_flitcnt_axil8_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil8_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL8_ADDR_1)
            int_flitcnt_axil8_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil8_1 & ~wmask);
    end
    // int_rd_addr_axil9_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil9_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL9_ADDR_0)
            int_rd_addr_axil9_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil9_0 & ~wmask);
    end
    // int_rd_addr_axil9_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil9_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL9_ADDR_1)
            int_rd_addr_axil9_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil9_1 & ~wmask);
    end
    // int_rd_size_axil9_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil9_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL9_ADDR_0)
            int_rd_size_axil9_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil9_0 & ~wmask);
    end
    // int_rd_size_axil9_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil9_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL9_ADDR_1)
            int_rd_size_axil9_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil9_1 & ~wmask);
    end
    // int_flitcnt_axil9_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil9_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL9_ADDR_0)
            int_flitcnt_axil9_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil9_0 & ~wmask);
    end
    // int_flitcnt_axil9_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil9_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL9_ADDR_1)
            int_flitcnt_axil9_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil9_1 & ~wmask);
    end
    // int_rd_addr_axil10_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil10_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL10_ADDR_0)
            int_rd_addr_axil10_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil10_0 & ~wmask);
    end
    // int_rd_addr_axil10_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil10_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL10_ADDR_1)
            int_rd_addr_axil10_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil10_1 & ~wmask);
    end
    // int_rd_size_axil10_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil10_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL10_ADDR_0)
            int_rd_size_axil10_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil10_0 & ~wmask);
    end
    // int_rd_size_axil10_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil10_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL10_ADDR_1)
            int_rd_size_axil10_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil10_1 & ~wmask);
    end
    // int_flitcnt_axil10_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil10_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL10_ADDR_0)
            int_flitcnt_axil10_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil10_0 & ~wmask);
    end
    // int_flitcnt_axil10_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil10_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL10_ADDR_1)
            int_flitcnt_axil10_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil10_1 & ~wmask);
    end
    // int_rd_addr_axil11_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil11_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL11_ADDR_0)
            int_rd_addr_axil11_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil11_0 & ~wmask);
    end
    // int_rd_addr_axil11_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil11_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL11_ADDR_1)
            int_rd_addr_axil11_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil11_1 & ~wmask);
    end
    // int_rd_size_axil11_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil11_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL11_ADDR_0)
            int_rd_size_axil11_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil11_0 & ~wmask);
    end
    // int_rd_size_axil11_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil11_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL11_ADDR_1)
            int_rd_size_axil11_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil11_1 & ~wmask);
    end
    // int_flitcnt_axil11_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil11_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL11_ADDR_0)
            int_flitcnt_axil11_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil11_0 & ~wmask);
    end
    // int_flitcnt_axil11_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil11_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL11_ADDR_1)
            int_flitcnt_axil11_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil11_1 & ~wmask);
    end
    // int_rd_addr_axil12_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil12_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL12_ADDR_0)
            int_rd_addr_axil12_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil12_0 & ~wmask);
    end
    // int_rd_addr_axil12_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil12_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL12_ADDR_1)
            int_rd_addr_axil12_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil12_1 & ~wmask);
    end
    // int_rd_size_axil12_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil12_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL12_ADDR_0)
            int_rd_size_axil12_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil12_0 & ~wmask);
    end
    // int_rd_size_axil12_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil12_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL12_ADDR_1)
            int_rd_size_axil12_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil12_1 & ~wmask);
    end
    // int_flitcnt_axil12_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil12_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL12_ADDR_0)
            int_flitcnt_axil12_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil12_0 & ~wmask);
    end
    // int_flitcnt_axil12_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil12_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL12_ADDR_1)
            int_flitcnt_axil12_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil12_1 & ~wmask);
    end
    // int_rd_addr_axil13_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil13_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL13_ADDR_0)
            int_rd_addr_axil13_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil13_0 & ~wmask);
    end
    // int_rd_addr_axil13_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil13_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL13_ADDR_1)
            int_rd_addr_axil13_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil13_1 & ~wmask);
    end
    // int_rd_size_axil13_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil13_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL13_ADDR_0)
            int_rd_size_axil13_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil13_0 & ~wmask);
    end
    // int_rd_size_axil13_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil13_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL13_ADDR_1)
            int_rd_size_axil13_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil13_1 & ~wmask);
    end
    // int_flitcnt_axil13_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil13_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL13_ADDR_0)
            int_flitcnt_axil13_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil13_0 & ~wmask);
    end
    // int_flitcnt_axil13_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil13_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL13_ADDR_1)
            int_flitcnt_axil13_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil13_1 & ~wmask);
    end
    // int_rd_addr_axil14_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil14_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL14_ADDR_0)
            int_rd_addr_axil14_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil14_0 & ~wmask);
    end
    // int_rd_addr_axil14_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil14_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL14_ADDR_1)
            int_rd_addr_axil14_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil14_1 & ~wmask);
    end
    // int_rd_size_axil14_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil14_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL14_ADDR_0)
            int_rd_size_axil14_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil14_0 & ~wmask);
    end
    // int_rd_size_axil14_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil14_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL14_ADDR_1)
            int_rd_size_axil14_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil14_1 & ~wmask);
    end
    // int_flitcnt_axil14_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil14_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL14_ADDR_0)
            int_flitcnt_axil14_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil14_0 & ~wmask);
    end
    // int_flitcnt_axil14_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil14_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL14_ADDR_1)
            int_flitcnt_axil14_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil14_1 & ~wmask);
    end
    // int_rd_addr_axil15_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil15_0 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL15_ADDR_0)
            int_rd_addr_axil15_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil15_0 & ~wmask);
    end
    // int_rd_addr_axil15_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_addr_axil15_1 <= 32'b0;
        else if (w_hs && waddr == RD_ADDR_AXIL15_ADDR_1)
            int_rd_addr_axil15_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_addr_axil15_1 & ~wmask);
    end
    // int_rd_size_axil15_0
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil15_0 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL15_ADDR_0)
            int_rd_size_axil15_0 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil15_0 & ~wmask);
    end
    // int_rd_size_axil15_1
    always_ff @(posedge clk) begin
        if (rst)
            int_rd_size_axil15_1 <= 32'b0;
        else if (w_hs && waddr == RD_SIZE_AXIL15_ADDR_1)
            int_rd_size_axil15_1 <= (s_axil_wdata[31:0] & wmask) | (int_rd_size_axil15_1 & ~wmask);
    end
    // int_flitcnt_axil15_0
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil15_0 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL15_ADDR_0)
            int_flitcnt_axil15_0 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil15_0 & ~wmask);
    end
    // int_flitcnt_axil15_1
    always_ff @(posedge clk) begin
        if (rst)
            int_flitcnt_axil15_1 <= 32'b0;
        else if (w_hs && waddr == FLITCNT_AXIL15_ADDR_1)
            int_flitcnt_axil15_1 <= (s_axil_wdata[31:0] & wmask) | (int_flitcnt_axil15_1 & ~wmask);
    end
    assign reset_axil = int_reset_axil_0[0:0];
    assign mm2s_start_axil = int_mm2s_start_axil_0[0:0];
    assign channel_en_axil[15:0] = int_channel_en_axil_0[15:0];
    assign repeat_cnt_axil[31:0] = int_repeat_cnt_axil_0[31:0];
    assign rd_addr_axil[0][31:0] = int_rd_addr_axil0_0[31:0];
    assign rd_addr_axil[0][63:32] = int_rd_addr_axil0_1[31:0];
    assign rd_size_axil[0][31:0] = int_rd_size_axil0_0[31:0];
    assign rd_size_axil[0][63:32] = int_rd_size_axil0_1[31:0];
    assign flitcnt_axil[0][31:0] = int_flitcnt_axil0_0[31:0];
    assign flitcnt_axil[0][63:32] = int_flitcnt_axil0_1[31:0];
    assign rd_addr_axil[1][31:0] = int_rd_addr_axil1_0[31:0];
    assign rd_addr_axil[1][63:32] = int_rd_addr_axil1_1[31:0];
    assign rd_size_axil[1][31:0] = int_rd_size_axil1_0[31:0];
    assign rd_size_axil[1][63:32] = int_rd_size_axil1_1[31:0];
    assign flitcnt_axil[1][31:0] = int_flitcnt_axil1_0[31:0];
    assign flitcnt_axil[1][63:32] = int_flitcnt_axil1_1[31:0];
    assign rd_addr_axil[2][31:0] = int_rd_addr_axil2_0[31:0];
    assign rd_addr_axil[2][63:32] = int_rd_addr_axil2_1[31:0];
    assign rd_size_axil[2][31:0] = int_rd_size_axil2_0[31:0];
    assign rd_size_axil[2][63:32] = int_rd_size_axil2_1[31:0];
    assign flitcnt_axil[2][31:0] = int_flitcnt_axil2_0[31:0];
    assign flitcnt_axil[2][63:32] = int_flitcnt_axil2_1[31:0];
    assign rd_addr_axil[3][31:0] = int_rd_addr_axil3_0[31:0];
    assign rd_addr_axil[3][63:32] = int_rd_addr_axil3_1[31:0];
    assign rd_size_axil[3][31:0] = int_rd_size_axil3_0[31:0];
    assign rd_size_axil[3][63:32] = int_rd_size_axil3_1[31:0];
    assign flitcnt_axil[3][31:0] = int_flitcnt_axil3_0[31:0];
    assign flitcnt_axil[3][63:32] = int_flitcnt_axil3_1[31:0];
    assign rd_addr_axil[4][31:0] = int_rd_addr_axil4_0[31:0];
    assign rd_addr_axil[4][63:32] = int_rd_addr_axil4_1[31:0];
    assign rd_size_axil[4][31:0] = int_rd_size_axil4_0[31:0];
    assign rd_size_axil[4][63:32] = int_rd_size_axil4_1[31:0];
    assign flitcnt_axil[4][31:0] = int_flitcnt_axil4_0[31:0];
    assign flitcnt_axil[4][63:32] = int_flitcnt_axil4_1[31:0];
    assign rd_addr_axil[5][31:0] = int_rd_addr_axil5_0[31:0];
    assign rd_addr_axil[5][63:32] = int_rd_addr_axil5_1[31:0];
    assign rd_size_axil[5][31:0] = int_rd_size_axil5_0[31:0];
    assign rd_size_axil[5][63:32] = int_rd_size_axil5_1[31:0];
    assign flitcnt_axil[5][31:0] = int_flitcnt_axil5_0[31:0];
    assign flitcnt_axil[5][63:32] = int_flitcnt_axil5_1[31:0];
    assign rd_addr_axil[6][31:0] = int_rd_addr_axil6_0[31:0];
    assign rd_addr_axil[6][63:32] = int_rd_addr_axil6_1[31:0];
    assign rd_size_axil[6][31:0] = int_rd_size_axil6_0[31:0];
    assign rd_size_axil[6][63:32] = int_rd_size_axil6_1[31:0];
    assign flitcnt_axil[6][31:0] = int_flitcnt_axil6_0[31:0];
    assign flitcnt_axil[6][63:32] = int_flitcnt_axil6_1[31:0];
    assign rd_addr_axil[7][31:0] = int_rd_addr_axil7_0[31:0];
    assign rd_addr_axil[7][63:32] = int_rd_addr_axil7_1[31:0];
    assign rd_size_axil[7][31:0] = int_rd_size_axil7_0[31:0];
    assign rd_size_axil[7][63:32] = int_rd_size_axil7_1[31:0];
    assign flitcnt_axil[7][31:0] = int_flitcnt_axil7_0[31:0];
    assign flitcnt_axil[7][63:32] = int_flitcnt_axil7_1[31:0];
    assign rd_addr_axil[8][31:0] = int_rd_addr_axil8_0[31:0];
    assign rd_addr_axil[8][63:32] = int_rd_addr_axil8_1[31:0];
    assign rd_size_axil[8][31:0] = int_rd_size_axil8_0[31:0];
    assign rd_size_axil[8][63:32] = int_rd_size_axil8_1[31:0];
    assign flitcnt_axil[8][31:0] = int_flitcnt_axil8_0[31:0];
    assign flitcnt_axil[8][63:32] = int_flitcnt_axil8_1[31:0];
    assign rd_addr_axil[9][31:0] = int_rd_addr_axil9_0[31:0];
    assign rd_addr_axil[9][63:32] = int_rd_addr_axil9_1[31:0];
    assign rd_size_axil[9][31:0] = int_rd_size_axil9_0[31:0];
    assign rd_size_axil[9][63:32] = int_rd_size_axil9_1[31:0];
    assign flitcnt_axil[9][31:0] = int_flitcnt_axil9_0[31:0];
    assign flitcnt_axil[9][63:32] = int_flitcnt_axil9_1[31:0];
    assign rd_addr_axil[10][31:0] = int_rd_addr_axil10_0[31:0];
    assign rd_addr_axil[10][63:32] = int_rd_addr_axil10_1[31:0];
    assign rd_size_axil[10][31:0] = int_rd_size_axil10_0[31:0];
    assign rd_size_axil[10][63:32] = int_rd_size_axil10_1[31:0];
    assign flitcnt_axil[10][31:0] = int_flitcnt_axil10_0[31:0];
    assign flitcnt_axil[10][63:32] = int_flitcnt_axil10_1[31:0];
    assign rd_addr_axil[11][31:0] = int_rd_addr_axil11_0[31:0];
    assign rd_addr_axil[11][63:32] = int_rd_addr_axil11_1[31:0];
    assign rd_size_axil[11][31:0] = int_rd_size_axil11_0[31:0];
    assign rd_size_axil[11][63:32] = int_rd_size_axil11_1[31:0];
    assign flitcnt_axil[11][31:0] = int_flitcnt_axil11_0[31:0];
    assign flitcnt_axil[11][63:32] = int_flitcnt_axil11_1[31:0];
    assign rd_addr_axil[12][31:0] = int_rd_addr_axil12_0[31:0];
    assign rd_addr_axil[12][63:32] = int_rd_addr_axil12_1[31:0];
    assign rd_size_axil[12][31:0] = int_rd_size_axil12_0[31:0];
    assign rd_size_axil[12][63:32] = int_rd_size_axil12_1[31:0];
    assign flitcnt_axil[12][31:0] = int_flitcnt_axil12_0[31:0];
    assign flitcnt_axil[12][63:32] = int_flitcnt_axil12_1[31:0];
    assign rd_addr_axil[13][31:0] = int_rd_addr_axil13_0[31:0];
    assign rd_addr_axil[13][63:32] = int_rd_addr_axil13_1[31:0];
    assign rd_size_axil[13][31:0] = int_rd_size_axil13_0[31:0];
    assign rd_size_axil[13][63:32] = int_rd_size_axil13_1[31:0];
    assign flitcnt_axil[13][31:0] = int_flitcnt_axil13_0[31:0];
    assign flitcnt_axil[13][63:32] = int_flitcnt_axil13_1[31:0];
    assign rd_addr_axil[14][31:0] = int_rd_addr_axil14_0[31:0];
    assign rd_addr_axil[14][63:32] = int_rd_addr_axil14_1[31:0];
    assign rd_size_axil[14][31:0] = int_rd_size_axil14_0[31:0];
    assign rd_size_axil[14][63:32] = int_rd_size_axil14_1[31:0];
    assign flitcnt_axil[14][31:0] = int_flitcnt_axil14_0[31:0];
    assign flitcnt_axil[14][63:32] = int_flitcnt_axil14_1[31:0];
    assign rd_addr_axil[15][31:0] = int_rd_addr_axil15_0[31:0];
    assign rd_addr_axil[15][63:32] = int_rd_addr_axil15_1[31:0];
    assign rd_size_axil[15][31:0] = int_rd_size_axil15_0[31:0];
    assign rd_size_axil[15][63:32] = int_rd_size_axil15_1[31:0];
    assign flitcnt_axil[15][31:0] = int_flitcnt_axil15_0[31:0];
    assign flitcnt_axil[15][63:32] = int_flitcnt_axil15_1[31:0];
endmodule
