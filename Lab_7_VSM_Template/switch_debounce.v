module switch_debounce #(
    parameter integer DEBOUNCE_CYCLES = 500_000
)(
    input  wire clk,
    input  wire reset,
    input  wire switch_in,

    output reg  switch_clean,
    output wire press_pulse
);

    localparam integer COUNT_WIDTH =
        (DEBOUNCE_CYCLES <= 1) ? 1 : $clog2(DEBOUNCE_CYCLES);

    reg sync_0;
    reg sync_1;
    reg clean_previous;

    reg [COUNT_WIDTH-1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            sync_0         <= 1'b0;
            sync_1         <= 1'b0;
            switch_clean   <= 1'b0;
            clean_previous <= 1'b0;
            count          <= 0;
        end
        else begin
            sync_0 <= switch_in;
            sync_1 <= sync_0;

            clean_previous <= switch_clean;

            if (sync_1 == switch_clean) begin
                count <= 0;
            end
            else if (count == DEBOUNCE_CYCLES - 1) begin
                switch_clean <= sync_1;
                count <= 0;
            end
            else begin
                count <= count + 1'b1;
            end
        end
    end

    assign press_pulse = switch_clean & ~clean_previous;

endmodule