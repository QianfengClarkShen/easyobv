module cdc #
(
    parameter int ADDR_WIDTH = 64,
    parameter int N_CHANNELS = 16
)
(
//clk
    input logic mem_clk,
    input logic s_axil_aclk,
    input logic [N_CHANNELS-1:0] instr_clk,
//rst
    input logic rst,
    input logic reset_axil,
    output logic mem_rst,
    output logic s_axil_rst,
    output logic channel_rst[N_CHANNELS-1:0],
//single-bit signals
    input logic core_ready,
    input logic mm2s_start_axil,
    output logic core_ready_axil,
    output logic mm2s_start,
    output logic mm2s_start_done,
//multi-bit signals
    input logic [N_CHANNELS-1:0] channel_en_axil,
    input logic [63:0] rd_addr_axil[N_CHANNELS-1:0],
    input logic [63:0] rd_size_axil[N_CHANNELS-1:0],
    input logic [63:0] flitcnt_axil[N_CHANNELS-1:0],
    input logic [31:0] repeat_cnt_axil,
    output logic [N_CHANNELS-1:0] channel_en,
    output logic [ADDR_WIDTH-1:0] rd_addr[N_CHANNELS-1:0],
    output logic [ADDR_WIDTH-1:0] rd_size[N_CHANNELS-1:0],
    output logic [ADDR_WIDTH-1:0] flitcnt[N_CHANNELS-1:0],
    output logic [31:0] repeat_cnt
);
    genvar i;
    logic mm2s_start_synced, mm2s_start_synced_reg;

    logic mem_rst_int;
    logic usr_rst_mem;
    logic channel_rst_int[N_CHANNELS-1:0];
    logic usr_rst_channel[N_CHANNELS-1:0];
//cdc for resets
    sync_reset #(
        .N_STAGE (6)
    ) u_sync_mem_rst(
        .clk     (mem_clk),
        .rst_in  (rst),
        .rst_out (mem_rst_int)
    );
    sync_reset #(
        .N_STAGE (6)
    ) u_sync_usr_rst_mem(
        .clk     (mem_clk),
        .rst_in  (reset_axil),
        .rst_out (usr_rst_mem)
    );
    assign mem_rst = mem_rst_int | usr_rst_mem;

    sync_reset #(
        .N_STAGE (6)
    ) u_sync_axil_rst(
        .clk     (s_axil_aclk),
        .rst_in  (rst),
        .rst_out (s_axil_rst)
    );

    for (i = 0;i < N_CHANNELS; i++) begin: sync_channel_rst
        sync_reset #(
            .N_STAGE (6)
        ) u_sync_channel_rst(
            .clk     (instr_clk[i]),
            .rst_in  (rst),
            .rst_out (channel_rst_int[i])
        );
        sync_reset #(
            .N_STAGE (6)
        ) u_sync_usr_rst_channel(
            .clk     (instr_clk[i]),
            .rst_in  (reset_axil),
            .rst_out (usr_rst_channel[i])
        );
        assign channel_rst[i] = channel_rst_int[i] | usr_rst_channel[i];
    end

//cdc for mm2s
    sync_signle_bit #(
        .N_STAGE   (5),
        .INPUT_REG (1)
    ) sync_ready(
        .clk_in  (mem_clk),
        .clk_out (s_axil_aclk),
        .rst     (rst),
        .din     (core_ready),
        .dout    (core_ready_axil)
    );

    sync_signle_bit #(
        .N_STAGE   (5),
        .INPUT_REG (1)
    ) sync_start(
        .clk_in  (s_axil_aclk),
        .clk_out (mem_clk),
        .rst     (rst),
        .din     (mm2s_start_axil),
        .dout    (mm2s_start_synced)
    );
    always_ff @(posedge mem_clk) begin
        mm2s_start_synced_reg <= mm2s_start_synced;
    end
    assign mm2s_start = ~mm2s_start_synced_reg & mm2s_start_synced;
    sync_signle_bit #(
        .N_STAGE   (5),
        .INPUT_REG (1)
    ) sync_start_done(
        .clk_in  (mem_clk),
        .clk_out (s_axil_aclk),
        .rst     (rst),
        .din     (mm2s_start_synced),
        .dout    (mm2s_start_done)
    );

    sync_multi_bit #(
        .SIZE       (32),
        .N_STAGE    (5),
        .OUTPUT_REG (1)
    ) sync_repeat_cnt(
        .clk_in   (s_axil_aclk),
        .clk_out  (mem_clk),
        .rst      (rst),
        .din      (repeat_cnt_axil),
        .din_vld  (1'b1),
        .din_rdy  (),
        .dout     (repeat_cnt),
        .dout_vld (),
        .dout_rdy (1'b1)
    );

//cdc for decoders
    for (i = 0;i < N_CHANNELS; i++) begin: sync_decoder
        //user wants all channels to make their best effort to start at the same time,
        //there for cdc shouldn't be used here since the clock period can be a lot different
        always_ff @(posedge instr_clk[i]) begin
            if (rst)
                channel_en[i] <= 1'b0;
            else
                channel_en[i] <= channel_en_axil[i];
        end
    
        sync_multi_bit #(
            .SIZE       (ADDR_WIDTH),
            .N_STAGE    (5),
            .OUTPUT_REG (1)
        ) sync_rd_addr(
            .clk_in   (s_axil_aclk),
            .clk_out  (mem_clk),
            .rst      (rst),
            .din      (rd_addr_axil[i][ADDR_WIDTH-1:0]),
            .din_vld  (1'b1),
            .din_rdy  (),
            .dout     (rd_addr[i]),
            .dout_vld (),
            .dout_rdy (1'b1)
        );    

        sync_multi_bit #(
            .SIZE       (ADDR_WIDTH),
            .N_STAGE    (5),
            .OUTPUT_REG (1)
        ) sync_rd_size(
            .clk_in   (s_axil_aclk),
            .clk_out  (mem_clk),
            .rst      (rst),
            .din      (rd_size_axil[i][ADDR_WIDTH-1:0]),
            .din_vld  (1'b1),
            .din_rdy  (),
            .dout     (rd_size[i]),
            .dout_vld (),
            .dout_rdy (1'b1)
        );

        sync_multi_bit #(
            .SIZE       (ADDR_WIDTH),
            .N_STAGE    (5),
            .OUTPUT_REG (1)
        ) sync_flitcnt(
            .clk_in   (s_axil_aclk),
            .clk_out  (instr_clk[i]),
            .rst      (rst),
            .din      (flitcnt_axil[i][ADDR_WIDTH-1:0]),
            .din_vld  (1'b1),
            .din_rdy  (),
            .dout     (flitcnt[i]),
            .dout_vld (),
            .dout_rdy (1'b1)
        );        
    end

endmodule
