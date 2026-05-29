module ALU(
    input logic clock,
    input logic reset,
    input logic [7:0] in,
    input logic nextStateButton
);

logic [7:0] opcode;
logic [7:0] a;
logic [7:0] b;

logic [7:0] opcodeOut;
logic [7:0] aOut;
logic [7:0] bOut;

logic [1:0] state;
logic [1:0] nextState;

Register #(.WIDTH(2)) state(
    .clock(clock),
    .clear_n(reset),
    .d(nextState),
    .q(state)
    );

Register #(.WIDTH(8)) opcodereg(
    .clock(clock),
    .clear_n(reset),
    .d(opcode),
    .q(opcodeOut)
    );

Register #(.WIDTH(8)) areg(
    .clock(clock),
    .clear_n(reset),
    .d(a),
    .q(aOut)
    );

Register #(.WIDTH(8)) breg(
    .clock(clock),
    .clear_n(reset),
    .d(b),
    .q(bOut)
    );

always_ff @(posedge clock) begin
    nextState[0] <= (~state[0] & state[1] & ~nextStateButton) | (state[0] & state[1] & nextStateButton);

    nextState[1] <= (state[0] | state[1] | ~nextStateButton) & (~state[0] | ~state[1] | nextStateButton);
    if (!reset) begin
        opcode <= '0;
        a      <= '0;
        b      <= '0;
    end else begin
        if(~state[0] & ~state[1]) begin
            opcode <= in;
        end
        // oh noez! these conditions are the same :o
        if(~state[0] & state[1]) begin
            a <= in;
        end
        if(~state[0] & state[1]) begin
            b <= in;
        end
    end
end


endmodule
