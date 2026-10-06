module hello_ticker (
    input CLOCK_50,
    input reset_n,

    output reg [6:0] HEX0,
    output reg [6:0] HEX1,
    output reg [6:0] HEX2,
    output reg [6:0] HEX3,
    output reg [6:0] HEX4,
    output reg [6:0] HEX5,
    output reg [6:0] HEX6,
    output reg [6:0] HEX7
);

    reg [25:0] clock_count;
    reg [2:0] scroll_state;
    reg one_second;

    // Counts 50,000,000 CLOCK_50 pulses = about 1 second
    always @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n) begin
            clock_count <= 26'd0;
            one_second  <= 1'b0;
        end
        else if (clock_count == 26'd49_999_999) begin
            clock_count <= 26'd0;
            one_second  <= 1'b1;
        end
        else begin
            clock_count <= clock_count + 1'b1;
            one_second  <= 1'b0;
        end
    end

    // Update scrolling position every second
    always @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n)
            scroll_state <= 3'd0;
        else if (one_second)
            scroll_state <= scroll_state + 3'd1;
    end

    // Combinational logic for all eight displays
    always @(*) begin

        // Blank every display by default
        HEX7 = 7'b1111111;
        HEX6 = 7'b1111111;
        HEX5 = 7'b1111111;
        HEX4 = 7'b1111111;
        HEX3 = 7'b1111111;
        HEX2 = 7'b1111111;
        HEX1 = 7'b1111111;
        HEX0 = 7'b1111111;

        case (scroll_state)

            // ---HELLO
            3'd0: begin
                HEX4 = 7'b0001001;  // H
                HEX3 = 7'b0000110;  // E
                HEX2 = 7'b1000111;  // L
                HEX1 = 7'b1000111;  // L
                HEX0 = 7'b1000000;  // O
            end

            // --HELLO-
            3'd1: begin
                HEX5 = 7'b0001001;  // H
                HEX4 = 7'b0000110;  // E
                HEX3 = 7'b1000111;  // L
                HEX2 = 7'b1000111;  // L
                HEX1 = 7'b1000000;  // O
            end

            // -HELLO--
            3'd2: begin
                HEX6 = 7'b0001001;  // H
                HEX5 = 7'b0000110;  // E
                HEX4 = 7'b1000111;  // L
                HEX3 = 7'b1000111;  // L
                HEX2 = 7'b1000000;  // O
            end

            // HELLO---
            3'd3: begin
                HEX7 = 7'b0001001;  // H
                HEX6 = 7'b0000110;  // E
                HEX5 = 7'b1000111;  // L
                HEX4 = 7'b1000111;  // L
                HEX3 = 7'b1000000;  // O
            end

            // ELLO---H
            3'd4: begin
                HEX7 = 7'b0000110;  // E
                HEX6 = 7'b1000111;  // L
                HEX5 = 7'b1000111;  // L
                HEX4 = 7'b1000000;  // O
                HEX0 = 7'b0001001;  // H
            end

            // LLO---HE
            3'd5: begin
                HEX7 = 7'b1000111;  // L
                HEX6 = 7'b1000111;  // L
                HEX5 = 7'b1000000;  // O
                HEX1 = 7'b0001001;  // H
                HEX0 = 7'b0000110;  // E
            end

            // LO---HEL
            3'd6: begin
                HEX7 = 7'b1000111;  // L
                HEX6 = 7'b1000000;  // O
                HEX2 = 7'b0001001;  // H
                HEX1 = 7'b0000110;  // E
                HEX0 = 7'b1000111;  // L
            end

            // O---HELL
            3'd7: begin
                HEX7 = 7'b1000000;  // O
                HEX3 = 7'b0001001;  // H
                HEX2 = 7'b0000110;  // E
                HEX1 = 7'b1000111;  // L
                HEX0 = 7'b1000111;  // L
            end

            default: begin
                HEX7 = 7'b1111111;
                HEX6 = 7'b1111111;
                HEX5 = 7'b1111111;
                HEX4 = 7'b1111111;
                HEX3 = 7'b1111111;
                HEX2 = 7'b1111111;
                HEX1 = 7'b1111111;
                HEX0 = 7'b1111111;
            end

        endcase
    end

endmodule