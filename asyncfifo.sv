// vim: set tabstop=2 shiftwidth=2 softtabstop=2 noexpandtab syntax=verilogpp nu:
`define TIME_UNIT_PS 100
`define TIME_PRECISION_PS 10
`timescale `TIME_UNIT_PS ps / `TIME_PRECISION_PS ps
`default_nettype none

/* verilator lint_off WIDTHEXPAND */
//TODO: Add Almost-Full and Almost-Empty
module asyncfifo #(
	parameter WIDTH = 8,
	parameter DEPTH = 16
)(
	//read interface
	input  wire wr_clk,
	input  wire wr_rstn,
	input  wire wr_en,
	input  wire [WIDTH-1:0] wr_data,
	output reg full,

	//write interface
	input  wire rd_clk,
	input  wire rd_rstn,
	input  wire rd_en,
	output reg  [WIDTH-1:0] rd_data,
	output reg empty
);
	//One extra bit wide to support MSB indicator
	//MSB indicator signifies that the address has wrapped
	
	//Number of address bits required to access the entire FIFO memory buffer
	localparam N = $clog2(DEPTH)-1;

	//Instantiate memory
`ifdef VENDOR_RAM
	//TODO
`else
	reg [WIDTH-1:0] memory [0:DEPTH-1];
	assign rd_data = memory[rd_addr];
`endif
	always @(posedge wr_clk) begin
		if( wr_en && !full ) memory[wr_addr] <= wr_data;
	end

	//Read Pointer Grey Code
	reg [N:0] rd_addr; //Read clock domain (addresses RAM)
	reg [N+1:0] rd_ptr; //Synchronized into write clock domain
	reg [N+1:0] rd_graynext;
	//Named after Frank GRAY
	grayctr #(
		.WIDTH(N+2)
	) read_grayctr (
		.clk(rd_clk),
		.rstn(rd_rstn),
		.inc(rd_en & ~empty),
		.gray(rd_ptr),
		.gnext(rd_graynext),
		.bin(rd_addr) 
	);
	//Read domain to write domain address synchronizer
	//TODO: Calculate MTBF and add synchronizers as required
	reg [N+1:0] rd_ptr1, rd_ptr2;
	always @(posedge wr_clk or negedge wr_rstn) begin
		if( !wr_rstn ) {rd_ptr1, rd_ptr2} <= 0;
		else {rd_ptr2, rd_ptr1} <= {rd_ptr1, rd_ptr};
	end

	//Write Pointer Grey Code
	reg [N:0] wr_addr; //Write clock domain (addresses RAM)
	reg [N+1:0] wr_ptr; //Synchronized into read clock domain
	reg [N+1:0] wr_graynext;
	grayctr #(
		.WIDTH(N+2)
	) write_grayctr (
		.clk(wr_clk),
		.rstn(wr_rstn),
		.inc(wr_en & ~full),
		.gray(wr_ptr),
		.gnext(wr_graynext),
		.bin(wr_addr) 
	);
	//Write domain to read domain address synchronizer
	//TODO: Calculate MTBF and add synchronizers as required
	reg [N+1:0] wr_ptr1, wr_ptr2;
	always @(posedge rd_clk or negedge rd_rstn) begin
		if( !rd_rstn ) {wr_ptr1, wr_ptr2} <= 0;
		else {wr_ptr2, wr_ptr1} <= {wr_ptr1, wr_ptr};
	end

	//Check empty
	always @(posedge rd_clk or negedge rd_rstn) begin
		if( !rd_rstn ) empty <= 1;
		else           empty <= (rd_graynext == wr_ptr2);
	end

	//Check full
	always @(posedge wr_clk or negedge wr_rstn) begin
		if( !wr_rstn ) full <= 0;
		else           full <= ((wr_graynext[N+1]   != rd_ptr2[N+1]) &&
			                      (wr_graynext[N+0]   != rd_ptr2[N+0]) &&
														(wr_graynext[N-1:0] == rd_ptr2[N-1:0]));
	end
	

endmodule
