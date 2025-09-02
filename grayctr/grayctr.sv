// vim: set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab syntax=verilogpp nu:
`define TIME_UNIT_PS 100
`define TIME_PRECISION_PS 10
`timescale `TIME_UNIT_PS ps / `TIME_PRECISION_PS ps
`default_nettype none

module grayctr #(
	parameter int WIDTH = 8
)(
	input  wire clk,
	input  wire rstn,
	input  wire [WIDTH-1:0] inc,
	output reg  [WIDTH-1:0] gray,
	output wire [WIDTH-1:0] gnext,
	output wire [WIDTH-1:0] bin
);
	reg [WIDTH-1:0] ctr;
	wire [WIDTH-1:0] bnext;
	assign bnext = ctr + inc;
	assign gnext = bnext ^ (bnext >> 1);

	always @(posedge clk or negedge rstn) begin
		if( !rstn ) ctr <= 0;
		else        ctr <= bnext;
	end

	always @(posedge clk or negedge rstn) begin
		if( !rstn ) gray <= 0;
		else        gray <= gnext;
	end

	assign bin = ctr[WIDTH-1:0];

endmodule
