module Output (
    input  logic        enable,
    input  logic [7:0]  result,
    input  logic        overflow,
    output logic [6:0]  seg_high,
    output logic [6:0]  seg_low,
    output logic        overflow_led
);

    SevenSegmentDecode decode_high (
        .digit    (enable ? result[7:4] : 4'h0),
        .segments (seg_high)
    );

    SevenSegmentDecode decode_low (
        .digit    (enable ? result[3:0] : 4'h0),
        .segments (seg_low)
    );

    assign overflow_led = enable ? overflow : 1'b0;

endmodule
