module Output (
    input logic         clock,
    input logic         reset,
    input logic  [7:0]  in,
    input logic         nextStateButton,
    output logic [6:0]  seg_high,
    output logic [6:0]  seg_low,
    output logic [6:0]  seg_state,
    output logic        overflow_led
);

    logic [7:0]  result;
    logic        overflow;
    logic [3:0]  currentState;

ButtonPulse button_inst (
        .clock(clock),
        .reset(reset),
        .button_in(nextStateButton),
        .pulse_out(clean_pulse)
);


ALU alu(
    .clock          (clock),
    .reset          (reset),
    .in             (in),
    .nextStateButton(clean_pulse),
    .aluOut         (result),
    .carryOut       (overflow),
    .currentState   (currentState)
);

    SevenSegmentDecode decode_high (
        .digit    (result[7:4]),
        .segments (seg_high)
    );

    SevenSegmentDecode decode_low (
        .digit    (result[3:0]),
        .segments (seg_low)
    );

    SevenSegmentDecode decode_state (
        .digit    (currentState),
        .segments (seg_state)
    );

    assign overflow_led = overflow;

endmodule
