`timescale 1ns/1ps
`ifndef WIDTH_VAL
    `define WIDTH_VAL(x) x <= 0 ? 1 : x
`endif
module axis_gen #
(
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
    parameter int INSTR_WIDTH = 32
)
(
    input logic clk,
    input logic rst,
//user signals
    input logic pause,
    input logic clear,
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
    input logic traffic_tready
);
    localparam int TDATA_IDX = DWIDTH-1;
    localparam int TVALID_IDX = TDATA_IDX+1;
    localparam int TREADY_IDX = TVALID_IDX+2*HAS_READY;
    localparam int TKEEP_IDX = TREADY_IDX+DWIDTH/8*HAS_KEEP;
    localparam int TLAST_IDX = TKEEP_IDX+HAS_LAST;
    localparam int TSTRB_IDX = TLAST_IDX+DWIDTH/8*HAS_STRB;
    localparam int TDEST_IDX = TSTRB_IDX+DEST_WIDTH;
    localparam int TUSER_IDX = TDEST_IDX+USER_WIDTH;
    localparam int TID_IDX = TUSER_IDX+ID_WIDTH;
    localparam int TIMEOUT_IDX = TID_IDX+TIMEOUT_BITS;
    localparam int REPEAT_IDX = TIMEOUT_IDX+REPEAT_BITS;

    localparam int TIMEOUT_WIDTH = TIMEOUT_BITS == 0 ? $clog2(DEFAULT_TIMEOUT_VAL+1) : TIMEOUT_BITS;
    localparam bit [TIMEOUT_WIDTH-1:0] TIMEOUT_VAL = (1<<TIMEOUT_WIDTH)-1 > DEFAULT_TIMEOUT_VAL ? DEFAULT_TIMEOUT_VAL : (1<<TIMEOUT_WIDTH)-1;

//catch the user ready signal and process it based on different configs
    //if there's no user field for TREADY and default behavior is ignore tready signal, then set internal tready to 1'b1
    //otherwise, assign user tready to internal tready, so that we respect user tready signal
    logic tready_int;
    if (HAS_READY | PAUSE_ON_NRDY)
        assign tready_int = traffic_tready;
    else
        assign tready_int = 1'b1;

    //set user tready and its mask, mask it 1 when user set TREADY bit to X in csv, means that tready should be ignored
    logic tready_user = 1'b1;
    logic tready_mask;
    if (~HAS_READY) begin
        always_ff @(posedge clk) begin
            tready_user <= 1'b1;
        end
        assign tready_mask = 1'b0;
    end
    else begin
        always_ff @(posedge clk) begin
            if (rst) begin
                tready_user <= 1'b1;
                tready_mask <=  1'b0;
            end
            else begin
                if (instr_tvalid) begin
                    tready_user <= instr_tdata[TREADY_IDX-1];
                    tready_mask <=  instr_tdata[TREADY_IDX];
                end
                else begin
                    tready_user <= 1'b1;
                    tready_mask <=  1'b0;
                end
            end
        end
    end
    //output should change whenever tready output is high
    logic tready_output;
    assign tready_output = ~pause & (tready_mask | (tready_user ~^ tready_int));

//ready signal face to the instruction interface
    logic [INSTR_WIDTH-1:0] instr_tdata_reg;
    if (REPEAT_BITS == 0) begin
        assign instr_tready = tready_output; 
        assign instr_tdata_reg = instr_tdata & {INSTR_WIDTH{instr_tvalid}};
    end
    else begin
        logic [REPEAT_BITS-1:0] repeat_cnt;
        always_ff @(posedge clk) begin
            if (rst)
                repeat_cnt <= {REPEAT_BITS{1'b0}};
            else if (tready_output) begin
                if (repeat_cnt != {REPEAT_BITS{1'b0}})
                    repeat_cnt <= repeat_cnt - 1'b1;
                else if (instr_tvalid && instr_tdata[REPEAT_IDX-:REPEAT_BITS] != {REPEAT_BITS{1'b0}})
                    repeat_cnt <= instr_tdata[REPEAT_IDX-:REPEAT_BITS]-1'b1;
            end
        end
        always_ff @(posedge clk) begin
            if (rst)
                instr_tdata_reg <= {INSTR_WIDTH{1'b0}};
            else if (instr_tready) begin
                if (instr_tvalid)
                    instr_tdata_reg <= instr_tdata;
                else
                    instr_tdata_reg <= {INSTR_WIDTH{1'b0}};
            end
        end
        assign instr_tready = repeat_cnt == {REPEAT_BITS{1'b0}} && tready_output;
    end

//timeout logic
    if (HAS_READY | PAUSE_ON_NRDY) begin
        logic [TIMEOUT_WIDTH-1:0] timeout_cnt = TIMEOUT_VAL;
        if (TIMEOUT_BITS == 0) begin
            always_ff @(posedge clk) begin
                if (rst)
                    timeout_cnt <= TIMEOUT_VAL;
                else if (tready_mask | (tready_user ~^ tready_int))
                    timeout_cnt <= TIMEOUT_VAL;
                else if (timeout_cnt != {TIMEOUT_WIDTH{1'b0}})
                    timeout_cnt <= timeout_cnt - 1'b1;
            end
        end
        else begin
            always_ff @(posedge clk) begin
                if (rst)
                    timeout_cnt <= TIMEOUT_VAL;
                else if (clear)
                    timeout_cnt <= TIMEOUT_VAL;
                else if (tready_mask | (tready_user ~^ tready_int))
                    if (instr_tdata[TIMEOUT_IDX-:TIMEOUT_WIDTH] == {TIMEOUT_WIDTH{1'b0}})
                        timeout_cnt <= TIMEOUT_VAL;
                    else
                        timeout_cnt <= instr_tdata[TIMEOUT_IDX-:TIMEOUT_WIDTH];
                else if (timeout_cnt != {TIMEOUT_WIDTH{1'b0}})
                    timeout_cnt <= timeout_cnt - 1'b1;
            end            
        end
        always_ff @(posedge clk) begin
            if (rst)
                timeout <= 1'b0;
            else if (clear)
                timeout <= 1'b0;
            else if (timeout_cnt == {TIMEOUT_WIDTH{1'b0}})
                timeout <= 1'b1;
        end
    end
    else
        assign timeout = 1'b0;

//AXI4-Stream fields
    always_ff @(posedge clk) begin
        if (rst)
            traffic_tdata <= {DWIDTH{1'b0}};
        else if (tready_output)
            traffic_tdata <= instr_tdata_reg[TDATA_IDX-:DWIDTH];
    end
    
    always_ff @(posedge clk) begin
        if (rst)
            traffic_tvalid <= 1'b0;
        else if (tready_output)
            traffic_tvalid <= instr_tdata_reg[TVALID_IDX];
    end
    
    if (HAS_KEEP) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tkeep <= {DWIDTH/8{1'b0}};
            else if (tready_output)
                traffic_tkeep <= instr_tdata_reg[TKEEP_IDX-:DWIDTH/8];
        end
    end
    else
        assign traffic_tkeep = {DWIDTH/8{1'b0}};
    
    if (HAS_LAST) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tlast <= 1'b0;
            else if (tready_output)
                traffic_tlast <= instr_tdata_reg[TLAST_IDX];
        end
    end
    else
        assign traffic_tlast = 1'b0;
    
    if (HAS_STRB) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tstrb <= {DWIDTH/8{1'b0}};
            else if (tready_output)
                traffic_tstrb <= instr_tdata_reg[TSTRB_IDX-:DWIDTH/8];
        end
    end
    else
        assign traffic_tstrb = {DWIDTH/8{1'b0}};
    
    if (DEST_WIDTH !=0) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tdest <= {DEST_WIDTH{1'b0}};
            else if (tready_output)
                traffic_tdest <= instr_tdata_reg[TDEST_IDX-:DEST_WIDTH];
        end
    end
    else
        assign traffic_tdest = {`WIDTH_VAL(DEST_WIDTH){1'b0}};
    
    if (USER_WIDTH !=0) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tuser <= {USER_WIDTH{1'b0}};
            else if (tready_output)
                traffic_tuser <= instr_tdata_reg[TUSER_IDX-:USER_WIDTH];
        end
    end
    else
        assign traffic_tuser = {`WIDTH_VAL(USER_WIDTH){1'b0}};
    
    if (ID_WIDTH !=0) begin
        always_ff @(posedge clk) begin
            if (rst)
                traffic_tid <= {ID_WIDTH{1'b0}};
            else if (tready_output)
                traffic_tid <= instr_tdata_reg[TID_IDX-:ID_WIDTH];
        end
    end
    else
        assign traffic_tid = {`WIDTH_VAL(ID_WIDTH){1'b0}};

endmodule
