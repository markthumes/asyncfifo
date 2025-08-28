module cordic(
	input  wire clk,
	output reg [1:0] ctr
);
	initial ctr = 0;
	always @(posedge clk) begin
		ctr <= ctr + 1;
	end
endmodule
