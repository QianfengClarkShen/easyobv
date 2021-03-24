`timescale 1ns/1ps
module decoder_fifo #
(
    parameter DWIDTH_IN = 64,
    parameter DWIDTH_OUT = 64,
    parameter DEPTH = 16
)
(
    input logic s_axis_aclk,
    input logic m_axis_aclk,
    input logic s_axis_rst,
    input logic m_axis_rst,
    input logic rst,
    input logic [DWIDTH_IN-1:0] s_axis_tdata,
    input logic s_axis_tvalid,
    output logic s_axis_tready,
    output logic [DWIDTH_OUT-1:0] m_axis_tdata,
    output logic m_axis_tvalid,
    input logic m_axis_tready
);
if (DWIDTH_IN < DWIDTH_OUT) begin
    localparam int RATIO = DWIDTH_OUT/DWIDTH_IN;
    localparam bit [$clog2(RATIO)-1:0] INPUT_VALID_CNT = RATIO-1;
//input reg
    logic [$clog2(RATIO)-1:0] input_cnt;
    logic [DWIDTH_OUT-1:0] input_reg;
//fifo wires
    logic [DWIDTH_OUT-1:0] fifo_tdata;
    logic fifo_tvalid;
    logic fifo_tready;
//input reg control
    always_ff @(posedge s_axis_aclk) begin
        if (s_axis_rst) begin
            input_cnt <= {$clog2(RATIO){1'b0}};
            input_reg <= {DWIDTH_OUT{1'b0}};
        end
        else if (s_axis_tvalid && (input_cnt != INPUT_VALID_CNT || fifo_tready)) begin
            input_cnt <= input_cnt + 1'b1;
            input_reg <= {s_axis_tdata,input_reg[DWIDTH_OUT-1:DWIDTH_IN]};
        end        
    end
//fifo
    easy_fifo_axis_async #(
        .DWIDTH     (DWIDTH_OUT),
        .DEPTH      (DEPTH),
        .INPUT_REG  (1),
        .OUTPUT_REG (1)
    ) u_easy_fifo_axis_async(
        .*,
        .s_axis_tdata  (fifo_tdata),
        .s_axis_tvalid (fifo_tvalid),
        .s_axis_tready (fifo_tready)
    );
    
    assign fifo_tdata = {s_axis_tdata,input_reg[DWIDTH_OUT-1:DWIDTH_IN]};
    assign fifo_tvalid = (input_cnt == INPUT_VALID_CNT) && s_axis_tvalid;
    assign s_axis_tready = fifo_tready || input_cnt != INPUT_VALID_CNT;
end
else if (DWIDTH_IN == DWIDTH_OUT) begin
    easy_fifo_axis_async #(
        .DWIDTH     (DWIDTH_IN),
        .DEPTH      (DEPTH),
        .INPUT_REG  (1),
        .OUTPUT_REG (1)
    ) u_easy_fifo_axis_async(.*);
end
else begin
    localparam int RATIO = DWIDTH_IN/DWIDTH_OUT;
    localparam bit [$clog2(RATIO)-1:0] OUTPUT_VALID_CNT = RATIO-1;
//output reg
    logic [$clog2(RATIO)-1:0] output_cnt;
    logic [DWIDTH_IN-1:0] output_reg;
//fifo wires
    logic [DWIDTH_IN-1:0] fifo_tdata;
    logic fifo_tvalid;
    logic fifo_tready;    

    easy_fifo_axis_async #(
        .DWIDTH     (DWIDTH_IN),
        .DEPTH      (DEPTH),
        .INPUT_REG  (1),
        .OUTPUT_REG (1)
    ) u_easy_fifo_axis_async(
        .*,
        .m_axis_tdata  (fifo_tdata),
        .m_axis_tvalid (fifo_tvalid),
        .m_axis_tready (fifo_tready)
    );
    always_ff @(posedge m_axis_aclk) begin
        if (m_axis_rst) begin
            output_cnt <= {$clog2(RATIO){1'b0}};
            output_reg <= {DWIDTH_IN{1'b0}};
            m_axis_tvalid <= 1'b0;
        end
        else begin
            if (m_axis_tready && m_axis_tvalid)
                output_cnt <= output_cnt + 1'b1;
            if (fifo_tready) begin
                output_reg <= fifo_tdata;
                m_axis_tvalid <= fifo_tvalid;
            end
            else if (m_axis_tready & m_axis_tvalid) begin
                output_reg <= {{DWIDTH_OUT{1'b0}},output_reg[DWIDTH_IN-1:DWIDTH_OUT]};
            end
        end
    end

    assign fifo_tready = ((output_cnt == OUTPUT_VALID_CNT) && m_axis_tready) || ~m_axis_tvalid;
    assign m_axis_tdata = output_reg[DWIDTH_OUT-1:0];
end
endmodule