module hz50_counter (
    input  wire       CLOCK_50,
    input  wire       clear,
    output reg  [6:0] HEX0
);

    reg [25:0] count;
    reg [3:0] digit;
    reg one_second;

    always @(posedge CLOCK_50) begin
        if (clear) begin
            count      <= 26'd0;
            one_second <= 1'b0;
        end
        else if (count == 26'd49_999_999) begin
            count      <= 26'd0;
            one_second <= 1'b1;
        end
        else begin
            count      <= count + 26'd1;
            one_second <= 1'b0;
        end
    end

    always @(posedge CLOCK_50) begin
        if (clear) begin
            digit <= 4'd0;
        end
        else if (one_second) begin
            if (digit == 4'd9)
                digit <= 4'd0;
            else
                digit <= digit + 4'd1;
        end
    end

    always @(*) begin
        case (digit)
            4'd0:    HEX0 = 7'b1000000;
            4'd1:    HEX0 = 7'b1111001;
            4'd2:    HEX0 = 7'b0100100;
            4'd3:    HEX0 = 7'b0110000;
            4'd4:    HEX0 = 7'b0011001;
            4'd5:    HEX0 = 7'b0010010;
            4'd6:    HEX0 = 7'b0000010;
            4'd7:    HEX0 = 7'b1111000;
            4'd8:    HEX0 = 7'b0000000;
            4'd9:    HEX0 = 7'b0010000;
            default: HEX0 = 7'b1111111;
        endcase
    end

endmodule