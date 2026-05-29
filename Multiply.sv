module Multiply(
    input logic clock,
    input logic [7:0] a,
    input logic [7:0] b,
    output logic [15:0] multOut
    );

logic [15:0] product;

always_comb begin
    product = 0;
    for(int i = 0; i < 8; i++) begin
        if(a[i]) begin
            //Cast b to a 16 bits before shifting
            product = product + (16'(b) << i);
        end
    end
end

always_ff @(posedge clock) begin
    multOut <= product;
end

endmodule
