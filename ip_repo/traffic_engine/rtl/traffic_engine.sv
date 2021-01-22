`timescale 1ns/1ps
module traffic_engine # (
    parameter int MEM_WIDTH = 512,
    parameter int ADDR_WIDTH = 64,
//up to 16 channels
    parameter bit [3:0] N_CHANNELS = 1,
	parameter int INSTR0_WIDTH = 8,
	parameter int INSTR1_WIDTH = 8,
	parameter int INSTR2_WIDTH = 8,
	parameter int INSTR3_WIDTH = 8,
	parameter int INSTR4_WIDTH = 8,
	parameter int INSTR5_WIDTH = 8,
	parameter int INSTR6_WIDTH = 8,
	parameter int INSTR7_WIDTH = 8,
	parameter int INSTR8_WIDTH = 8,
	parameter int INSTR9_WIDTH = 8,
	parameter int INSTR10_WIDTH = 8,
	parameter int INSTR11_WIDTH = 8,
	parameter int INSTR12_WIDTH = 8,
	parameter int INSTR13_WIDTH = 8,
	parameter int INSTR14_WIDTH = 8,
	parameter int INSTR15_WIDTH = 8
)
(
//clocks and reset
    input logic s_axil_aclk,
    input logic mem_clk,
    input logic instr0_clk,
    input logic instr1_clk,
    input logic instr2_clk,
    input logic instr3_clk,
    input logic instr4_clk,
    input logic instr5_clk,
    input logic instr6_clk,
    input logic instr7_clk,
    input logic instr8_clk,
    input logic instr9_clk,
    input logic instr10_clk,
    input logic instr11_clk,
    input logic instr12_clk,
    input logic instr13_clk,
    input logic instr14_clk,
    input logic instr15_clk,
	input logic rst,
//AXI-Lite Control interface
    input logic [8:0]   s_axil_awaddr,
    input logic			s_axil_awvalid,
    output logic		s_axil_awready,
    input logic [31:0]  s_axil_wdata,
    input logic [3:0]   s_axil_wstrb,
    input logic         s_axil_wvalid,
    output logic        s_axil_wready,
    output logic [1:0]  s_axil_bresp,
    output logic		s_axil_bvalid,
    input logic         s_axil_bready,
    input logic [8:0]   s_axil_araddr,
    input logic         s_axil_arvalid,
    output logic        s_axil_arready,
    output logic [31:0] s_axil_rdata,
    output logic [1:0]  s_axil_rresp,
    output logic		s_axil_rvalid,
    input logic         s_axil_rready,
//AXI-MM interface
    output logic [ADDR_WIDTH-1:0] m_axi_araddr,
    output logic [7:0] m_axi_arlen,
    output logic [2:0] m_axi_arsize,
    output logic [1:0] m_axi_arburst,
    output logic [3:0] m_axi_arcache,
    output logic [2:0] m_axi_arprot,
    output logic [3:0] m_axi_arid,
    output logic m_axi_arvalid,
    input logic m_axi_arready,
    input logic [MEM_WIDTH-1:0] m_axi_rdata,
    input logic [3:0] m_axi_rid,
    input logic [1:0] m_axi_rresp,
    input logic m_axi_rlast,
    input logic m_axi_rvalid,
    output logic m_axi_rready,
//AXIS traffic out
    output logic [INSTR0_WIDTH*8-1:0] instr0_tdata,
	output logic instr0_tvalid,
	input logic instr0_tready,
    output logic [INSTR1_WIDTH*8-1:0] instr1_tdata,
	output logic instr1_tvalid,
	input logic instr1_tready,
    output logic [INSTR2_WIDTH*8-1:0] instr2_tdata,
	output logic instr2_tvalid,
	input logic instr2_tready,
    output logic [INSTR3_WIDTH*8-1:0] instr3_tdata,
	output logic instr3_tvalid,
	input logic instr3_tready,
    output logic [INSTR4_WIDTH*8-1:0] instr4_tdata,
	output logic instr4_tvalid,
	input logic instr4_tready,
    output logic [INSTR5_WIDTH*8-1:0] instr5_tdata,
	output logic instr5_tvalid,
	input logic instr5_tready,
    output logic [INSTR6_WIDTH*8-1:0] instr6_tdata,
	output logic instr6_tvalid,
	input logic instr6_tready,
    output logic [INSTR7_WIDTH*8-1:0] instr7_tdata,
	output logic instr7_tvalid,
	input logic instr7_tready,
    output logic [INSTR8_WIDTH*8-1:0] instr8_tdata,
	output logic instr8_tvalid,
	input logic instr8_tready,
    output logic [INSTR9_WIDTH*8-1:0] instr9_tdata,
	output logic instr9_tvalid,
	input logic instr9_tready,
    output logic [INSTR10_WIDTH*8-1:0] instr10_tdata,
	output logic instr10_tvalid,
	input logic instr10_tready,
    output logic [INSTR11_WIDTH*8-1:0] instr11_tdata,
	output logic instr11_tvalid,
	input logic instr11_tready,
    output logic [INSTR12_WIDTH*8-1:0] instr12_tdata,
	output logic instr12_tvalid,
	input logic instr12_tready,
    output logic [INSTR13_WIDTH*8-1:0] instr13_tdata,
	output logic instr13_tvalid,
	input logic instr13_tready,
    output logic [INSTR14_WIDTH*8-1:0] instr14_tdata,
	output logic instr14_tvalid,
	input logic instr14_tready,
    output logic [INSTR15_WIDTH*8-1:0] instr15_tdata,
	output logic instr15_tvalid,
	input logic instr15_tready,
//rst
    output logic instr0_rst,
    output logic instr1_rst,
    output logic instr2_rst,
    output logic instr3_rst,
    output logic instr4_rst,
    output logic instr5_rst,
    output logic instr6_rst,
    output logic instr7_rst,
    output logic instr8_rst,
    output logic instr9_rst,
    output logic instr10_rst,
    output logic instr11_rst,
    output logic instr12_rst,
    output logic instr13_rst,
    output logic instr14_rst,
    output logic instr15_rst
);
//clk
    logic [15:0] instr_clk;
//rst
    logic s_axil_rst, mem_rst;
    logic channel_rst[15:0];

//axilite
    //to mm2s
    logic core_ready_axil, mm2s_start_axil;
    logic [63:0] rd_addr_axil[15:0];
    logic [63:0] rd_size_axil[15:0];
    //to decoder
    logic [15:0] channel_en_axil;
    logic [63:0] flitcnt_axil[15:0];
// mm2s
    //from axil
    logic core_ready, mm2s_start, mm2s_start_done;
    logic [ADDR_WIDTH-1:0] rd_addr[N_CHANNELS-1:0];
    logic [ADDR_WIDTH-1:0] rd_size[N_CHANNELS-1:0];
    logic [ADDR_WIDTH-1:0] flitcnt[N_CHANNELS-1:0];
    //to decoder
    logic [MEM_WIDTH-1:0] channel_tdata[N_CHANNELS-1:0];
    logic [N_CHANNELS-1:0] channel_tvalid;
    logic [N_CHANNELS-1:0] channel_tready;

//decoder
    //from axil
    logic [N_CHANNELS-1:0] channel_en;
    //from mm2s
//  logic [MEM_WIDTH-1:0] channel_tdata[N_CHANNELS-1:0];
//  logic [N_CHANNELS-1:0] channel_tvalid;
//  logic [N_CHANNELS-1:0] channel_tready;

//assign clocks and resets
    assign instr_clk[0] = instr0_clk;
    assign instr_clk[1] = instr1_clk;
    assign instr_clk[2] = instr2_clk;
    assign instr_clk[3] = instr3_clk;
    assign instr_clk[4] = instr4_clk;
    assign instr_clk[5] = instr5_clk;
    assign instr_clk[6] = instr6_clk;
    assign instr_clk[7] = instr7_clk;
    assign instr_clk[8] = instr8_clk;
    assign instr_clk[9] = instr9_clk;
    assign instr_clk[10] = instr10_clk;
    assign instr_clk[11] = instr11_clk;
    assign instr_clk[12] = instr12_clk;
    assign instr_clk[13] = instr13_clk;
    assign instr_clk[14] = instr14_clk;
    assign instr_clk[15] = instr15_clk;
    assign instr0_rst = channel_rst[0];
    assign instr1_rst = channel_rst[1];
    assign instr2_rst = channel_rst[2];
    assign instr3_rst = channel_rst[3];
    assign instr4_rst = channel_rst[4];
    assign instr5_rst = channel_rst[5];
    assign instr6_rst = channel_rst[6];
    assign instr7_rst = channel_rst[7];
    assign instr8_rst = channel_rst[8];
    assign instr9_rst = channel_rst[9];
    assign instr10_rst = channel_rst[10];
    assign instr11_rst = channel_rst[11];
    assign instr12_rst = channel_rst[12];
    assign instr13_rst = channel_rst[13];
    assign instr14_rst = channel_rst[14];
    assign instr15_rst = channel_rst[15];

    axil u_axil(
        .*,
        .clk (s_axil_aclk),
        .rst (s_axil_rst),
        .n_channels (N_CHANNELS)
    );

    cdc #(
        .ADDR_WIDTH (ADDR_WIDTH),
        .N_CHANNELS (N_CHANNELS)
    ) u_cdc(
        .*,
        .instr_clk        (instr_clk[N_CHANNELS-1:0]),
        .channel_rst      (channel_rst[N_CHANNELS-1:0]),
        .channel_en_axil  (channel_en_axil[N_CHANNELS-1:0]),
        .rd_addr_axil     (rd_addr_axil[N_CHANNELS-1:0]),
        .rd_size_axil     (rd_size_axil[N_CHANNELS-1:0]),
        .flitcnt_axil     (flitcnt_axil[N_CHANNELS-1:0])
    );

    mm2s #(
        .MEM_WIDTH  (MEM_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH),
        .N_CHANNELS (N_CHANNELS)
    ) u_mm2s(
        .*,
    	.clk (mem_clk),
        .rst (mem_rst),
        .start (mm2s_start)
    );

    if (N_CHANNELS > 0) begin
        decoder0 u_decoder_0 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[0]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[0]),
            .rst(rst),
            .enable(channel_en[0]),
            .flitcnt(flitcnt[0]),
            .mem_tdata(channel_tdata[0]),
            .mem_tvalid(channel_tvalid[0]),
            .mem_tready(channel_tready[0]),
            .instr_tdata(instr0_tdata),
            .instr_tvalid(instr0_tvalid),
            .instr_tready(instr0_tready)
        );
    end
    else begin
        assign instr0_tdata = {INSTR0_WIDTH*8{1'b0}};
        assign instr0_tvalid = 1'b0;
    end

    if (N_CHANNELS > 1) begin
        decoder1 u_decoder_1 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[1]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[1]),
            .rst(rst),
            .enable(channel_en[1]),
            .flitcnt(flitcnt[1]),
            .mem_tdata(channel_tdata[1]),
            .mem_tvalid(channel_tvalid[1]),
            .mem_tready(channel_tready[1]),
            .instr_tdata(instr1_tdata),
            .instr_tvalid(instr1_tvalid),
            .instr_tready(instr1_tready)
        );
    end
    else begin
        assign instr1_tdata = {INSTR1_WIDTH*8{1'b0}};
        assign instr1_tvalid = 1'b0;
    end

    if (N_CHANNELS > 2) begin
        decoder2 u_decoder_2 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[2]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[2]),
            .rst(rst),
            .enable(channel_en[2]),
            .flitcnt(flitcnt[2]),
            .mem_tdata(channel_tdata[2]),
            .mem_tvalid(channel_tvalid[2]),
            .mem_tready(channel_tready[2]),
            .instr_tdata(instr2_tdata),
            .instr_tvalid(instr2_tvalid),
            .instr_tready(instr2_tready)
        );
    end
    else begin
        assign instr2_tdata = {INSTR2_WIDTH*8{1'b0}};
        assign instr2_tvalid = 1'b0;
    end

    if (N_CHANNELS > 3) begin
        decoder3 u_decoder_3 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[3]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[3]),
            .rst(rst),
            .enable(channel_en[3]),
            .flitcnt(flitcnt[3]),
            .mem_tdata(channel_tdata[3]),
            .mem_tvalid(channel_tvalid[3]),
            .mem_tready(channel_tready[3]),
            .instr_tdata(instr3_tdata),
            .instr_tvalid(instr3_tvalid),
            .instr_tready(instr3_tready)
        );
    end
    else begin
        assign instr3_tdata = {INSTR3_WIDTH*8{1'b0}};
        assign instr3_tvalid = 1'b0;
    end

    if (N_CHANNELS > 4) begin
        decoder4 u_decoder_4 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[4]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[4]),
            .rst(rst),
            .enable(channel_en[4]),
            .flitcnt(flitcnt[4]),
            .mem_tdata(channel_tdata[4]),
            .mem_tvalid(channel_tvalid[4]),
            .mem_tready(channel_tready[4]),
            .instr_tdata(instr4_tdata),
            .instr_tvalid(instr4_tvalid),
            .instr_tready(instr4_tready)
        );
    end
    else begin
        assign instr4_tdata = {INSTR4_WIDTH*8{1'b0}};
        assign instr4_tvalid = 1'b0;
    end

    if (N_CHANNELS > 5) begin
        decoder5 u_decoder_5 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[5]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[5]),
            .rst(rst),
            .enable(channel_en[5]),
            .flitcnt(flitcnt[5]),
            .mem_tdata(channel_tdata[5]),
            .mem_tvalid(channel_tvalid[5]),
            .mem_tready(channel_tready[5]),
            .instr_tdata(instr5_tdata),
            .instr_tvalid(instr5_tvalid),
            .instr_tready(instr5_tready)
        );
    end
    else begin
        assign instr5_tdata = {INSTR5_WIDTH*8{1'b0}};
        assign instr5_tvalid = 1'b0;
    end

    if (N_CHANNELS > 6) begin
        decoder6 u_decoder_6 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[6]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[6]),
            .rst(rst),
            .enable(channel_en[6]),
            .flitcnt(flitcnt[6]),
            .mem_tdata(channel_tdata[6]),
            .mem_tvalid(channel_tvalid[6]),
            .mem_tready(channel_tready[6]),
            .instr_tdata(instr6_tdata),
            .instr_tvalid(instr6_tvalid),
            .instr_tready(instr6_tready)
        );
    end
    else begin
        assign instr6_tdata = {INSTR6_WIDTH*8{1'b0}};
        assign instr6_tvalid = 1'b0;
    end

    if (N_CHANNELS > 7) begin
        decoder7 u_decoder_7 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[7]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[7]),
            .rst(rst),
            .enable(channel_en[7]),
            .flitcnt(flitcnt[7]),
            .mem_tdata(channel_tdata[7]),
            .mem_tvalid(channel_tvalid[7]),
            .mem_tready(channel_tready[7]),
            .instr_tdata(instr7_tdata),
            .instr_tvalid(instr7_tvalid),
            .instr_tready(instr7_tready)
        );
    end
    else begin
        assign instr7_tdata = {INSTR7_WIDTH*8{1'b0}};
        assign instr7_tvalid = 1'b0;
    end

    if (N_CHANNELS > 8) begin
        decoder8 u_decoder_8 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[8]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[8]),
            .rst(rst),
            .enable(channel_en[8]),
            .flitcnt(flitcnt[8]),
            .mem_tdata(channel_tdata[8]),
            .mem_tvalid(channel_tvalid[8]),
            .mem_tready(channel_tready[8]),
            .instr_tdata(instr8_tdata),
            .instr_tvalid(instr8_tvalid),
            .instr_tready(instr8_tready)
        );
    end
    else begin
        assign instr8_tdata = {INSTR8_WIDTH*8{1'b0}};
        assign instr8_tvalid = 1'b0;
    end

    if (N_CHANNELS > 9) begin
        decoder9 u_decoder_9 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[9]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[9]),
            .rst(rst),
            .enable(channel_en[9]),
            .flitcnt(flitcnt[9]),
            .mem_tdata(channel_tdata[9]),
            .mem_tvalid(channel_tvalid[9]),
            .mem_tready(channel_tready[9]),
            .instr_tdata(instr9_tdata),
            .instr_tvalid(instr9_tvalid),
            .instr_tready(instr9_tready)
        );
    end
    else begin
        assign instr9_tdata = {INSTR9_WIDTH*8{1'b0}};
        assign instr9_tvalid = 1'b0;
    end

    if (N_CHANNELS > 10) begin
        decoder10 u_decoder_10 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[10]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[10]),
            .rst(rst),
            .enable(channel_en[10]),
            .flitcnt(flitcnt[10]),
            .mem_tdata(channel_tdata[10]),
            .mem_tvalid(channel_tvalid[10]),
            .mem_tready(channel_tready[10]),
            .instr_tdata(instr10_tdata),
            .instr_tvalid(instr10_tvalid),
            .instr_tready(instr10_tready)
        );
    end
    else begin
        assign instr10_tdata = {INSTR10_WIDTH*8{1'b0}};
        assign instr10_tvalid = 1'b0;
    end

    if (N_CHANNELS > 11) begin
        decoder11 u_decoder_11 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[11]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[11]),
            .rst(rst),
            .enable(channel_en[11]),
            .flitcnt(flitcnt[11]),
            .mem_tdata(channel_tdata[11]),
            .mem_tvalid(channel_tvalid[11]),
            .mem_tready(channel_tready[11]),
            .instr_tdata(instr11_tdata),
            .instr_tvalid(instr11_tvalid),
            .instr_tready(instr11_tready)
        );
    end
    else begin
        assign instr11_tdata = {INSTR11_WIDTH*8{1'b0}};
        assign instr11_tvalid = 1'b0;
    end

    if (N_CHANNELS > 12) begin
        decoder12 u_decoder_12 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[12]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[12]),
            .rst(rst),
            .enable(channel_en[12]),
            .flitcnt(flitcnt[12]),
            .mem_tdata(channel_tdata[12]),
            .mem_tvalid(channel_tvalid[12]),
            .mem_tready(channel_tready[12]),
            .instr_tdata(instr12_tdata),
            .instr_tvalid(instr12_tvalid),
            .instr_tready(instr12_tready)
        );
    end
    else begin
        assign instr12_tdata = {INSTR12_WIDTH*8{1'b0}};
        assign instr12_tvalid = 1'b0;
    end

    if (N_CHANNELS > 13) begin
        decoder13 u_decoder_13 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[13]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[13]),
            .rst(rst),
            .enable(channel_en[13]),
            .flitcnt(flitcnt[13]),
            .mem_tdata(channel_tdata[13]),
            .mem_tvalid(channel_tvalid[13]),
            .mem_tready(channel_tready[13]),
            .instr_tdata(instr13_tdata),
            .instr_tvalid(instr13_tvalid),
            .instr_tready(instr13_tready)
        );
    end
    else begin
        assign instr13_tdata = {INSTR13_WIDTH*8{1'b0}};
        assign instr13_tvalid = 1'b0;
    end

    if (N_CHANNELS > 14) begin
        decoder14 u_decoder_14 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[14]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[14]),
            .rst(rst),
            .enable(channel_en[14]),
            .flitcnt(flitcnt[14]),
            .mem_tdata(channel_tdata[14]),
            .mem_tvalid(channel_tvalid[14]),
            .mem_tready(channel_tready[14]),
            .instr_tdata(instr14_tdata),
            .instr_tvalid(instr14_tvalid),
            .instr_tready(instr14_tready)
        );
    end
    else begin
        assign instr14_tdata = {INSTR14_WIDTH*8{1'b0}};
        assign instr14_tvalid = 1'b0;
    end

    if (N_CHANNELS > 15) begin
        decoder15 u_decoder_15 (
            .s_axis_aclk(mem_clk),
            .m_axis_aclk(instr_clk[15]),
            .s_axis_rst(mem_rst),
            .m_axis_rst(channel_rst[15]),
            .rst(rst),
            .enable(channel_en[15]),
            .flitcnt(flitcnt[15]),
            .mem_tdata(channel_tdata[15]),
            .mem_tvalid(channel_tvalid[15]),
            .mem_tready(channel_tready[15]),
            .instr_tdata(instr15_tdata),
            .instr_tvalid(instr15_tvalid),
            .instr_tready(instr15_tready)
        );
    end
    else begin
        assign instr15_tdata = {INSTR15_WIDTH*8{1'b0}};
        assign instr15_tvalid = 1'b0;
    end
endmodule
