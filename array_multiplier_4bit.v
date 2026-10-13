module array_multiplier_4bit (
    input  wire [3:0] A,
    input  wire [3:0] B,
    output wire [7:0] P
);

    // Partial products
    wire [3:0] pp0, pp1, pp2, pp3;

    // Sum outputs of each full-adder row
    wire [3:0] s1, s2, s3;

    // Carry chains: index 0 is the initial carry-in
    wire [4:0] c1, c2, c3;

    // Inputs from the previous partial-product/addition row
    wire [3:0] row1_in, row2_in, row3_in;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : partial_products
            and (pp0[i], A[i], B[0]);
            and (pp1[i], A[i], B[1]);
            and (pp2[i], A[i], B[2]);
            and (pp3[i], A[i], B[3]);
        end
    endgenerate

    // The least-significant product bit needs no addition.
    assign P[0] = pp0[0];

    // Align the remaining bits for each addition row.
    assign row1_in = {1'b0,  pp0[3:1]};
    assign row2_in = {c1[4], s1[3:1]};
    assign row3_in = {c2[4], s2[3:1]};

    // Each row starts with carry-in = 0.
    assign c1[0] = 1'b0;
    assign c2[0] = 1'b0;
    assign c3[0] = 1'b0;

    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_rows

            full_adder fa_row1 (
                .a    (row1_in[i]),
                .b    (pp1[i]),
                .cin  (c1[i]),
                .sum  (s1[i]),
                .cout (c1[i+1])
            );

            full_adder fa_row2 (
                .a    (row2_in[i]),
                .b    (pp2[i]),
                .cin  (c2[i]),
                .sum  (s2[i]),
                .cout (c2[i+1])
            );

            full_adder fa_row3 (
                .a    (row3_in[i]),
                .b    (pp3[i]),
                .cin  (c3[i]),
                .sum  (s3[i]),
                .cout (c3[i+1])
            );

        end
    endgenerate

    // Connect the product outputs as shown in the diagram.
    assign P[1]   = s1[0];
    assign P[2]   = s2[0];
    assign P[6:3] = s3;
    assign P[7]   = c3[4];

endmodule