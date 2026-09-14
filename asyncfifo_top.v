// asyncfifo_top.v
module asyncfifo_top #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    // write interface
    input  wire wr_clk,
    input  wire wr_rstn,
    input  wire wr_en,
    input  wire [WIDTH-1:0] wr_data,
    output wire full,

    // read interface
    input  wire rd_clk,
    input  wire rd_rstn,
    input  wire rd_en,
    output wire [WIDTH-1:0] rd_data,
    output wire empty
);

    // Instantiate your actual SystemVerilog FIFO
    asyncfifo #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH)
    ) u_asyncfifo (
        .wr_clk(wr_clk),
        .wr_rstn(wr_rstn),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .full(full),
        .rd_clk(rd_clk),
        .rd_rstn(rd_rstn),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .empty(empty)
    );

endmodule
