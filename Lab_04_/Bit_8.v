module Bit_8(
	input T,
	input ena,
	input clear,
	input clk,
	output [7:0] qt

);
	
	
	wire [7:0] w_and;
	wire [7:0] w_out;
	
	assign w_and[0] = ena & w_out[0];
	assign w_and[1] = w_and[0] & w_out[1];
	assign w_and[2] = w_and[1] & w_out[2];
	assign w_and[3] = w_and[2] & w_out[3];
	assign w_and[4] = w_and[3] & w_out[4];
	assign w_and[5] = w_and[4] & w_out[5];
	assign w_and[6] = w_and[5] & w_out[6];
	
	
	T_flipflop T0(
        .T      (ena),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[0])
    );
	 
	 T_flipflop T1(
        .T      (w_and[0]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[1])
    );
	 
	 T_flipflop T2(
        .T      (w_and[1]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[2])
    );
	 
	 T_flipflop T3(
        .T      (w_and[2]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[3])
    );
	 
	 T_flipflop T4(
        .T      (w_and[3]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[4])
    );
	 
	 T_flipflop T5(
        .T      (w_and[4]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[5])
    );
	 
	 T_flipflop T6(
        .T      (w_and[5]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[6])
    );
	 
	 T_flipflop T7(
        .T      (w_and[6]),
        .clk    (clk),
        .clear  (clear),
        .Qt      (w_out[7])
    );
	 
	 
	
	
	
endmodule