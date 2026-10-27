module hello_detector (
    input  wire       clk,       // 50 MHz clock
    input  wire       reset_n,   // Active-low reset
    input  wire [7:0] rx_data,   // Received byte from your UART
    input  wire       rx_valid,  // One-clock pulse per received byte

    output reg        detected,

    output reg [7:0] HEX0,
    output reg [7:0] HEX1,
    output reg [7:0] HEX2,
    output reg [7:0] HEX3,
    output reg [7:0] HEX4,
    output reg [7:0] HEX5
);

    // States represent the characters matched so far.
    localparam [2:0]
        WAIT_H    = 3'd0,
        HAVE_H    = 3'd1,
        HAVE_HE   = 3'd2,
        HAVE_HEL  = 3'd3,
        HAVE_HELL = 3'd4;

    reg [2:0] state;

    // Convert lowercase ASCII letters to uppercase.
    wire [7:0] character;

    assign character =
        (rx_data >= 8'h61 && rx_data <= 8'h7A)
        ? rx_data - 8'h20
        : rx_data;

    // -----------------------------------------------------
    // Word detector FSM
    // -----------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state    <= WAIT_H;
            detected <= 1'b0;
        end
        else if (rx_valid) begin
            case (state)
                WAIT_H: begin
                    if (character == "H")
                        state <= HAVE_H;
                    else
                        state <= WAIT_H;
                end

                HAVE_H: begin
                    if (character == "E")
                        state <= HAVE_HE;
                    else if (character == "H")
                        state <= HAVE_H;
                    else
                        state <= WAIT_H;
                end

                HAVE_HE: begin
                    if (character == "L")
                        state <= HAVE_HEL;
                    else if (character == "H")
                        state <= HAVE_H;
                    else
                        state <= WAIT_H;
                end

                HAVE_HEL: begin
                    if (character == "L")
                        state <= HAVE_HELL;
                    else if (character == "H")
                        state <= HAVE_H;
                    else
                        state <= WAIT_H;
                end

                HAVE_HELL: begin
                    if (character == "O") begin
                        detected <= 1'b1;
                        state    <= WAIT_H;
                    end
                    else if (character == "H")
                        state <= HAVE_H;
                    else
                        state <= WAIT_H;
                end

                default: state <= WAIT_H;
            endcase
        end
    end

    // -----------------------------------------------------
    // Blink timing: 0.5 seconds ON, 0.5 seconds OFF
    // -----------------------------------------------------
    reg [24:0] blink_count;
    reg        blink_on;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            blink_count <= 25'd0;
            blink_on    <= 1'b1;
        end
        else if (!detected) begin
            blink_count <= 25'd0;
            blink_on    <= 1'b1;
        end
        else if (blink_count == 25'd24_999_999) begin
            blink_count <= 25'd0;
            blink_on    <= ~blink_on;
        end
        else begin
            blink_count <= blink_count + 25'd1;
        end
    end

    // -----------------------------------------------------
    // HEX outputs: {dp, g, f, e, d, c, b, a}
    // Active-low segments: 0 = ON.
    // -----------------------------------------------------
    always @(*) begin
        HEX0 = 8'hFF;
        HEX1 = 8'hFF;
        HEX2 = 8'hFF;
        HEX3 = 8'hFF;
        HEX4 = 8'hFF;
        HEX5 = 8'hFF;

        if (detected && blink_on) begin
            HEX4 = 8'b10001001; // H
            HEX3 = 8'b10000110; // E
            HEX2 = 8'b11000111; // L
            HEX1 = 8'b11000111; // L
            HEX0 = 8'b11000000; // O
        end
    end

endmodule