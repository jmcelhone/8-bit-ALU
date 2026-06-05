module Output (
    input logic         clock,
    input logic         reset,
    input logic  [7:0]  in,
    input logic         nextStateButton,
    output logic [6:0]  seg_high,
    output logic [6:0]  seg_low,
    output logic        overflow_led
);

    logic [7:0]  result;
    logic        overflow;


ALU alu(
    .clock          (clock),
    .reset          (reset),
    .in             (in),
    .nextStateButton(nextStateButton),
    .aluOut         (result),
    .carryOut       (overflow)
);

    SevenSegmentDecode decode_high (
        .digit    (result[7:4]),
        .segments (seg_high)
    );

    SevenSegmentDecode decode_low (
        .digit    (result[3:0]),
        .segments (seg_low)
    );

    assign overflow_led = overflow;

endmodule
