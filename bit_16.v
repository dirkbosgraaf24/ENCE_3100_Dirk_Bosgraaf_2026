module bit_16(
	input clk,
	input reset,
	output reg [15:0] q
	

);


	always @(posedge clk) begin
		if (reset) 
			q = 16'd0;
		else
			q <= q+1;
	end
endmodule