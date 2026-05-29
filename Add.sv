module Add(
input logic [7:0] a,
input logic [7:0] b,
output logic [7:0] sum,
output logic carry
);

logic [7:0] c;

initial begin
c = 8'h00;
carry = 1'h0;
end

always_comb begin
sum[0] = a[0]^b[0];
c[0] = a[0]&b[0];

for(int i=0;i<7;i++)begin
sum[i+1] = a[i]^b[i]^c[i];
c[i+1] = a[i]&(b[i]|c[i]) | b[i]&c[i];
end

carry = c[7];

end

endmodule
