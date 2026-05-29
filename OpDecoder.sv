module OpDecoder (
    input  logic [2:0] opcode,
    output logic op_add,
    output logic op_sub,
    output logic op_and,
    output logic op_or,
    output logic op_xor,
    output logic op_outA,
    output logic op_outB,
    output logic op_mult
);

    always_comb begin
        {op_add, op_sub, op_and, op_or, op_xor, op_outA, op_outB} = 7'b0;
        case (opcode)
            3'b000: op_add  = 1'b1;
            3'b001: op_sub  = 1'b1;
            3'b010: op_and  = 1'b1;
            3'b011: op_or   = 1'b1;
            3'b100: op_xor  = 1'b1;
            3'b101: op_outA = 1'b1;
            3'b110: op_outB = 1'b1;
            3'b111: op_mult = 1'b1;
            default: ;
        endcase
    end
endmodule
