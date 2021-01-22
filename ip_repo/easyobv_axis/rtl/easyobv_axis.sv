`timescale 1ns/1ps
`ifndef WIDTH_VAL
    `define WIDTH_VAL(x) x <= 0 ? 1 : x
`endif
module easyobv_axis #
(
    parameter bit EN_AXIL = 1,
    parameter bit [1:0] MODE = 2'd1,
//AXI4-Stream signals
    parameter int DWIDTH = 32,
    parameter bit HAS_READY = 0,
    parameter bit HAS_KEEP = 0,
    parameter bit HAS_LAST = 0,
    parameter bit HAS_STRB = 0,
    parameter int DEST_WIDTH = 0,
    parameter int USER_WIDTH = 0,
    parameter int ID_WIDTH = 0,
//Control signals
    parameter int DEFAULT_TIMEOUT_VAL = 65535,
    parameter int TIMEOUT_BITS = 0,
    parameter int REPEAT_BITS = 0,
    parameter bit PAUSE_ON_NRDY = 1,
//Instruction width
    parameter int INSTR_WIDTH = 32,
//Traffic Monitor options
    parameter int CMP_FIFO_DEPTH = 16
)
(
    input logic clk,
    input logic rst,
//axi lite
    input logic			s_axil_aclk,
    input logic [6:0]   s_axil_awaddr,
    input logic			s_axil_awvalid,
    output logic		s_axil_awready,
    input logic [31:0]  s_axil_wdata,
    input logic [3:0]   s_axil_wstrb,
    input logic         s_axil_wvalid,
    output logic        s_axil_wready,
    output logic [1:0]  s_axil_bresp,
    output logic		s_axil_bvalid,
    input logic         s_axil_bready,
    input logic [6:0]   s_axil_araddr,
    input logic         s_axil_arvalid,
    output logic        s_axil_arready,
    output logic [31:0] s_axil_rdata,
    output logic [1:0]  s_axil_rresp,
    output logic		s_axil_rvalid,
    input logic         s_axil_rready,
//traffic gen
    //user signals
    input logic pause,
    input logic timeout_clr,
    output logic timeout,
    //instruction
    input logic [INSTR_WIDTH-1:0] instr_tdata,
    input logic instr_tvalid,
    output logic instr_tready,
    //traffic out
    output logic [DWIDTH-1:0] traffic_tdata,
    output logic traffic_tvalid,
    output logic [DWIDTH/8-1:0] traffic_tkeep,
    output logic traffic_tlast,
    output logic [DWIDTH/8-1:0] traffic_tstrb,
    output logic [`WIDTH_VAL(DEST_WIDTH)-1:0] traffic_tdest,
    output logic [`WIDTH_VAL(USER_WIDTH)-1:0] traffic_tuser,
    output logic [`WIDTH_VAL(ID_WIDTH)-1:0] traffic_tid,
    input logic traffic_tready,
//traffic mon
    //rx
    input logic [DWIDTH-1:0] rx_mon_tdata,
    input logic rx_mon_tvalid,
    output logic rx_mon_tready,
    input logic [DWIDTH/8-1:0] rx_mon_tkeep,
    input logic rx_mon_tlast = 1'b1,
    input logic [DWIDTH/8-1:0] rx_mon_tstrb,
    input logic [`WIDTH_VAL(DEST_WIDTH)-1:0] rx_mon_tdest,
    input logic [`WIDTH_VAL(USER_WIDTH)-1:0] rx_mon_tuser,
    input logic [`WIDTH_VAL(ID_WIDTH)-1:0] rx_mon_tid,
    //stats
    output logic [63:0] mismatch_cnt,
    output logic [63:0] time_cnt,
    output logic [63:0] tx_pkt_cnt,
    output logic [63:0] tx_pkt_time_cnt,
    output logic [63:0] tx_pkt_timestamp_sum,
    output logic [63:0] tx_transferred_size,
    output logic [63:0] rx_pkt_cnt,
    output logic [63:0] rx_pkt_time_cnt,
    output logic [63:0] rx_pkt_timestamp_sum,
    output logic [63:0] rx_transferred_size
);
    logic pause_int;
    logic timeout_clr_int;

    if (EN_AXIL) begin
        logic pause_axil;
        logic timeout_clr_axil;
        logic timeout_axil;
        logic loopback_axil;
        logic [63:0] mismatch_cnt_axil;
        logic [63:0] tx_pkt_cnt_axil;
        logic [63:0] tx_pkt_time_cnt_axil;
        logic [63:0] tx_pkt_timestamp_sum_axil;
        logic [63:0] tx_transferred_size_axil;
        logic [63:0] rx_pkt_cnt_axil;
        logic [63:0] rx_pkt_time_cnt_axil;
        logic [63:0] rx_pkt_timestamp_sum_axil;
        logic [63:0] rx_transferred_size_axil;

        axil u_axil(
            .*,
            .clk (s_axil_aclk),
            .rst (s_axil_rst)
        );
        cdc u_cdc(
            .*,
            .pause(pause_int),
            .timeout_clr(timeout_clr_int)
        );
    end
    else begin
        assign pause_int = pause;
        assign timeout_clr_int = timeout_clr;
    end
    axis_gen #(
        .DWIDTH              (DWIDTH              ),
        .HAS_READY           (HAS_READY           ),
        .HAS_KEEP            (HAS_KEEP            ),
        .HAS_LAST            (HAS_LAST            ),
        .HAS_STRB            (HAS_STRB            ),
        .DEST_WIDTH          (DEST_WIDTH          ),
        .USER_WIDTH          (USER_WIDTH          ),
        .ID_WIDTH            (ID_WIDTH            ),
        .DEFAULT_TIMEOUT_VAL (DEFAULT_TIMEOUT_VAL ),
        .TIMEOUT_BITS        (TIMEOUT_BITS        ),
        .REPEAT_BITS         (REPEAT_BITS         ),
        .PAUSE_ON_NRDY       (PAUSE_ON_NRDY       ),
        .INSTR_WIDTH         (INSTR_WIDTH         )
    ) u_axis_gen(
        .*,
        .pause(pause_int),
        .timeout_clr(timeout_clr_int),
        .timeout(timeout)
    );
    if (MODE > 2'd0) begin
        axis_mon #(
            .DWIDTH         (DWIDTH         ),
            .HAS_READY      (HAS_READY      ),
            .HAS_KEEP       (HAS_KEEP       ),
            .HAS_LAST       (HAS_LAST       ),
            .HAS_STRB       (HAS_STRB       ),
            .DEST_WIDTH     (DEST_WIDTH     ),
            .USER_WIDTH     (USER_WIDTH     ),
            .ID_WIDTH       (ID_WIDTH       ),
            .LOOPBACK       (MODE == 2'd2   ),
            .CMP_FIFO_DEPTH (CMP_FIFO_DEPTH )
        ) u_axis_mon(
            .*,
            .tx_mon_tdata  (traffic_tdata),
            .tx_mon_tvalid (traffic_tvalid),
            .tx_mon_tkeep  (traffic_tkeep),
            .tx_mon_tlast  (traffic_tlast),
            .tx_mon_tstrb  (traffic_tstrb),
            .tx_mon_tdest  (traffic_tdest),
            .tx_mon_tuser  (traffic_tuser),
            .tx_mon_tid    (traffic_tid),
            .tx_mon_tready (traffic_tready)
        );
    end
endmodule