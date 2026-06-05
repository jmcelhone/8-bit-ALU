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

logic [15:0] multOut;

logic [7:0] andOut;

logic [7:0] orOut;

logic [7:0] xorOut;

Register #(.WIDTH(2)) statereg(
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

AndInstruct andInstruct(
    .A(a),
    .B(b),
    .out(andOut)
    );
    
OrInstruct orInstruct(
    .A(a),
    .B(b),
    .out(orOut)
    );

XorInstruct xorInstruct(
    .A(a),
    .B(b),
    .out(xorOut)
    );

Multiply(
    .clock(clock),
    .a(a),
    .b(b),
    .multOut(multOut)
    );


always_comb
    nextState[0] <= (~state[0] & state[1] & ~nextStateButton) | (state[0] & state[1] & nextStateButton);

    nextState[1] <= (state[0] | state[1] | ~nextStateButton) & (~state[0] | ~state[1] | nextStateButton);
end

always_ff @(posedge clock or negedge reset) begin
    if(!reset) begin
        a <= '0;
        b <= '0;
        opcode <= '0;
        aluOut <= '0;
        carryOut <= '0;
        state <= '0;
    end
    if(~(state[0]) & ~(state[1])) begin
        opcode <= in;
    end
    if(~state[0] & state[1]) begin
        a <= in;
    end
    if(state[0] & state[1]) begin
        b <= in;
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
        aluOut <= andOut;
        carryOut <= 1'b0;
    end
    else if(op_or) begin
        aluOut <= orOut;
        carryOut <= 1'b0;
    end
    else if(op_xor) begin
        aluOut <= xorOut;
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
        aluOut <= multOut[7:0];
        carryOut <= multOut[8];
    end
end


endmodule
