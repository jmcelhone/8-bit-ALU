module Add(
input logic [7:0] a,
input logic [7:0] b,
input logic sign,
output logic [7:0] sum,
output logic carry
);

logic [7:0] c;

initial begin
c = 8'h00;
end

always_comb begin
sum[0] = a[0]^b[0];
c[0] = a[0]&(b[0]|sign) | ~b[0]&sign;
//should probably make a truth table to back up the above line of code

  for(int i=0;i<7;i++)begin
    sum[i+1] = a[i+1]^b[i+1]^c[i]^sign;
    c[i+1] = a[i+1]&((b[i+1]^sign)|c[i]) | (b[i+1]^sign)&c[i];
end

carry = c[7];

end

endmodule
