module mm2s #
(
    parameter int MEM_WIDTH = 512,
    parameter int ADDR_WIDTH = 64,
    parameter int N_CHANNELS = 16
)
(
    input logic clk,
    input logic rst,
//AXI MM
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
//User Command
    input logic [ADDR_WIDTH-1:0] rd_addr[N_CHANNELS-1:0],
    input logic [ADDR_WIDTH-1:0] rd_size[N_CHANNELS-1:0],
    input logic start,
    output logic core_ready,
//CHANNELs
    output logic [MEM_WIDTH-1:0] channel_tdata[N_CHANNELS-1:0],
    output logic [N_CHANNELS-1:0] channel_tvalid,
    input logic [N_CHANNELS-1:0] channel_tready
);
    localparam int BURST_LEN = 4096/(MEM_WIDTH/8);
    localparam int ARSIZE = $clog2(MEM_WIDTH/8);
    localparam int LEN_WIDTH = ADDR_WIDTH - ARSIZE;

    logic [3:0] state;

    logic [N_CHANNELS-1:0] core_ready_int = {N_CHANNELS{1'b1}};

    logic [LEN_WIDTH-1:0] rd_addr_int[N_CHANNELS-1:0];
    logic [LEN_WIDTH-1:0] rd_size_int[N_CHANNELS-1:0];
    logic [$clog2(BURST_LEN)+1:0] fifo_cnt[N_CHANNELS-1:0];

    logic [15:0] m_axi_rready_int;

    genvar i;
 //mem read control
    if (N_CHANNELS > 1) begin
        always_ff @(posedge clk) begin
            if (rst) begin
                state <= 'b0;
            end
            else if (core_ready) begin
                state <= 'b0;
            end
            else if (m_axi_arready || rd_size_int[state] == {LEN_WIDTH{1'b0}}) begin
                if (state == N_CHANNELS-1)
                    state <= 'b0;
                else
                    state <= state + 1'b1;
            end
        end
    end
    else begin
        assign state = 4'b0;
    end   

    for (i = 0; i < N_CHANNELS; i++) begin
    //core ready logic (core ready when all channels are idle)
        always_ff @(posedge clk) begin
            if (rst) begin
                core_ready_int[i] <= 1'b1;
            end
            else if (start) begin
                core_ready_int[i] <= 1'b0;
            end
            else if (rd_size_int[i] == {LEN_WIDTH{1'b0}}) begin
                core_ready_int[i] <= 1'b1;
            end
        end
    end

    for (i = 0; i < N_CHANNELS; i++) begin
    //when issue start command, a 
        always_ff @(posedge clk) begin
            if (rst) begin
                rd_addr_int[i] <= {LEN_WIDTH{1'b0}};
                rd_size_int[i] <= {LEN_WIDTH{1'b0}};
            end
            else if (core_ready & start) begin
                rd_addr_int[i] <= rd_addr[i][ADDR_WIDTH-1:ARSIZE];
                rd_size_int[i] <= rd_size[i][ADDR_WIDTH-1:ARSIZE];
            end
            else if (m_axi_arready && fifo_cnt[i] <= BURST_LEN && (state == i)) begin
                if (rd_size_int[i] > BURST_LEN) begin
                    rd_addr_int[i] <= rd_addr_int[i] + BURST_LEN;
                    rd_size_int[i] <= rd_size_int[i] - BURST_LEN;
                end
                else begin
                    rd_size_int[i] <= {LEN_WIDTH{1'b0}};
                end
            end
        end
    end
    always_ff @(posedge clk) begin
        if (start)
            core_ready <= 1'b0;
        else
            core_ready <= &core_ready_int;
    end

    for (i = 0; i < N_CHANNELS; i++) begin: gen_fifo
        easy_fifo_axis_sync #(
            .DWIDTH     (MEM_WIDTH),
            .DEPTH      (BURST_LEN*2),
            .INPUT_REG  (1),
            .OUTPUT_REG (1)
        ) u_easy_fifo_axis_sync(
            .*,
            .s_axis_tdata  (m_axi_rdata),
            .s_axis_tvalid (m_axi_rvalid&&(m_axi_rid == i)),
            .s_axis_tready (m_axi_rready_int[i]),
            .m_axis_tdata  (channel_tdata[i]),
            .m_axis_tvalid (channel_tvalid[i]),
            .m_axis_tready (channel_tready[i]),
            .fifo_cnt      (fifo_cnt[i])
        );
    end
    for (i = N_CHANNELS; i < 16; i++)
        assign m_axi_rready_int[i] = 1'b1;

    assign m_axi_araddr = {rd_addr_int[state],{ARSIZE{1'b0}}};
    assign m_axi_arlen = rd_size_int[state] >= BURST_LEN ? BURST_LEN-1 : rd_size_int[state]-1;
    assign m_axi_arvalid = (|rd_size_int[state]) && (fifo_cnt[state] <= BURST_LEN);
    assign m_axi_arid = state;
    assign m_axi_rready = m_axi_rready_int[m_axi_rid];
//use recommand values for side channels
    assign m_axi_arcache = 4'b0011;
    assign m_axi_arprot = 3'b000;
//only support incr
    assign m_axi_arburst = 2'b01;
    assign m_axi_arsize = ARSIZE;
endmodule
