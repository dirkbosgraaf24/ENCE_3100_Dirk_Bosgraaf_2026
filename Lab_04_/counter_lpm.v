module counter_lpm (
    input  wire        clock,
    input  wire        cnt_en,
    input  wire        sclr,
    output wire [15:0] q
);

    lpm_counter lpm_counter_component (
        .clock  (clock),
        .cnt_en (cnt_en),
        .sclr   (sclr),
        .q      (q),

        .aclr   (1'b0),
        .aload  (1'b0),
        .aset   (1'b0),
        .cin    (1'b1),
        .clk_en (1'b1),
        .cout   (),
        .data   (16'd0),
        .eq     (),
        .sload  (1'b0),
        .sset   (1'b0),
        .updown (1'b1)
    );

    defparam
        lpm_counter_component.lpm_width        = 16,
        lpm_counter_component.lpm_direction    = "UP",
        lpm_counter_component.lpm_type         = "LPM_COUNTER",
        lpm_counter_component.lpm_port_updown  = "PORT_UNUSED";

endmodule