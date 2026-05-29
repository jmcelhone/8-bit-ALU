module ALU(
    input logic clock,
    input logic reset,
    input logic [7:0] in,
    input logic nextStateButton,
    output logic [7:0] aluOut,
    output logic carryOut
);

logic [7:0] opcode;
logic [7:0] a;
logic [7:0] b;

logic [7:0] opcodeOut;
logic [7:0] aOut;
logic [7:0] bOut;

logic [1:0] state;
logic [1:0] nextState;

logic op_add;
logic op_sub;
logic op_and;
logic op_or;
logic op_xor;
logic op_outA;
logic op_outB;
logic op_outmult;

logic [7:0] adderOut;
logic adderCarry;

logic [7:0] subOut;
logic subCarry;

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

OpDecoder decoder(
    .opcode(opcode[2:0]),
    .op_add(op_add),
    .op_sub(op_sub),
    .op_and(op_and),
    .op_or(op_or),
    .op_xor(op_xor),
    .op_outA(op_outA),
    .op_outB(op_outB),
    .op_mult(op_mult) 
    );

Add adder(
    .a(a),
    .b(b),
    .sign('0),
    .sum(adderOut),
    .carry(adderCarry)
    );

Add sub(
    .a(a),
    .b(b),
    .sign(1'b1),
    .sum(subOut),
    .carry(subCarry)
    );    

always_ff @(posedge clock negedge reset) begin
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
        if(~state[0] & state[1]) begin
            a <= in;
        end
        if(state[0] & state[1]) begin
            b <= in;
        end
    end
    if(op_add) begin
        aluOut <= adderOut;
        carryOut <= adderCarry;
    end
    else if(op_sub) begin
        aluOut <= subOut;
        carryOut <= subCarry;
    end
    else if(op_and) begin
        aluOut <= a & b;
        carryOut <= 1'b0;
    end
    else if(op_or) begin
        aluOut <= a | b;
        carryOut <= 1'b0;
    end
    else if(op_xor) begin
        aluOut <= a ^ b;
        carryOut <= 1'b0;
    end
    else if(op_outA) begin
        aluOut <= a;
        carryOut <= 1'b0;
    end
    else if(op_outB) begin
        aluOut <= b;
        carryOut <= 1'b0;
    end
    //Mult not implemented yet
    else if(op_mult) begin
        aluOut <= 1'b0;
        carryOut <= 1'b0;
    end
end


endmodule
