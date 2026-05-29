module Register #(parameter WIDTH = 24) (
    input logic clock,
    input logic clear_n,
    input logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q
);

always_ff @(posedge clock) begin
    if(clear_n == 1'b0) begin
        //q <= 24'h000000;
        q <= 'h0;
    end else begin
        q <= d;
    end
end

endmodule
