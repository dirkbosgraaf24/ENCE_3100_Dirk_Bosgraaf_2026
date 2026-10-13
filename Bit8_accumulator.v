module Bit8_accumulator (
    input  wire       clk,
    input  wire       reset_n,
    input  wire [7:0] A,
    output wire [7:0] S,
    output wire       Overflow
);

    reg [7:0] s_reg;
    reg [7:0] a_reg;
    reg       Overflow_reg;

    wire [8:0] add_result;

    assign add_result = {1'b0, a_reg} + {1'b0, s_reg};

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            s_reg        <= 8'd0;
            a_reg        <= 8'd0;
            Overflow_reg <= 1'b0;
        end
        else begin
            a_reg        <= A;
            s_reg        <= add_result[7:0];
            Overflow_reg <= add_result[8];
        end
    end

    assign S        = s_reg;
    assign Overflow = Overflow_reg;

endmodule