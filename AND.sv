module AndInstruct (
    input  logic [7:0] A,
    input  logic [7:0] B,
    output logic [7:0] out
);
    assign out = A & B;

endmodule
