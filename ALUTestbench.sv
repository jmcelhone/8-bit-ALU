module ALUTestbench();

logic clock;
logic reset;
logic [7:0] in;
logic nextStateButton;
logic [7:0] expected;
logic [7:0] aluOut;
logic carryOut;

ALU ayelyoo(
.clock(clock),
.reset(reset),
.in(in),
.aluOut(aluOut),
.nextStateButton(nextStateButton),
.carryOut(carryOut)
);

task validateReset();
	reset = 1'b0;
	#10;
	reset = 1'b1;
	#10;
	if (aluOut!==8'h00) begin
		$display("%0t ps: Reset failed",$time);
	end
endtask


task validateOutA(input logic [7:0] a, input logic [7:0] b);
	in = 8'h55;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: Output A failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateOutB(input logic [7:0] a, input logic [7:0] b);
	in = 8'h66;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: Output B failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateOr(input logic [7:0] a, input logic [7:0] b);
	in = 8'h33;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a|b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: OR failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateAnd(input logic [7:0] a, input logic [7:0] b);
	in = 8'h22;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a&b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: AND failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateXor(input logic [7:0] a, input logic [7:0] b);
	in = 8'h44;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a^b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: XOR failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateAdd(input logic [7:0] a, input logic [7:0] b);
	in = 8'h00;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a+b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: ADD failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

task validateSub(input logic [7:0] a, input logic [7:0] b);
	in = 8'h11;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = a;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	#10;
	in = b;
	nextStateButton = 1'b1;
	#10;
	nextStateButton = 1'b0;
	expected = a-b;
	#10;
	if (aluOut!==expected) begin
		$display("%0t ps: SUBTRACT failed. a=%1h, b=%1h, expected=%1h, aluOut=%1h",$time,a,b,expected,aluOut);
	end
endtask

initial begin
	clock = 1'b0;
	reset = 1'b1;
	nextStateButton = 1'h0;
	in = 8'h00;
end
always #5 clock=~clock;
initial begin
	validateReset();
	validateOutA(169,42);
	validateOutB(169,42);
	validateOr(169,42);
	validateAnd(169,42);
	validateXor(169,42);
	validateAdd(169,42);
	validateSub(169,42);
    $finish;
end

endmodule
