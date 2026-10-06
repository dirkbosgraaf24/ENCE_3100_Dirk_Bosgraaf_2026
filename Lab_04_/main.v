module main(
    // Pinout Assignment
   input MAX10_CLK1_50,
	input	[9:0]	SW,
	input	[9:0] key, 
	output[9:0]	LEDR,
	output [35:0] GPI0, 
	output [7:0] Hex0,
	output [7:0] Hex1,
	output [7:0] Hex2,
	output [7:0] Hex3,
	output [7:0] Hex4,
	output [7:0] Hex5
);
	
	
	//assign LEDR[9:0] = SW[9:0];
    // T flip-flop instance
  /*
  T_flipflop T0(
	.T(SW[0]),
	.clk(key[0]),
	.clear(SW[1]),
	.Qt(LEDR[7:0])
	);
  */
/*  
	Bit_8 Bit(
	.T(SW[0]),
	.ena(SW[1]),
	.clear(SW[3]),
	.clk(SW[4]),
	.qt(LEDR[7:0])


*/
	//Counter_1Hz count_1(
	//.in_clk(MAX10_CLK1_50),
	//.clear(SW[0]),
	//.out_clk(w_clk)
	hello_ticker ht0(
    .CLOCK_50(MAX10_CLK1_50),
    .reset_n(SW[9]),

    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .HEX6(HEX6),
    .HEX7(HEX7)
);
endmodule