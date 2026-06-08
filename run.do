vlib work
vlog *.sv
vsim work.ALUTestbench
add wave /ALUTestbench/clock
add wave /ALUTestbench/reset
add wave /ALUTestbench/nextStateButton
add wave /ALUTestbench/in
add wave /ALUTestbench/ayelyoo/state
add wave /ALUTestbench/ayelyoo/opcodeOut
add wave /ALUTestbench/ayelyoo/aOut
add wave /ALUTestbench/ayelyoo/bOut
add wave /ALUTestbench/expected
add wave /ALUTestbench/aluOut
radix -hex
run -all
