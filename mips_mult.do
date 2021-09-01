onerror {resume}
vlib work
vmap work
vlog -sv defs.sv
vlog -sv controller.sv
vlog -sv alu.sv
vlog -sv instruction_decoder.sv
vlog -sv extender.sv
vlog -sv regfile.sv
vlog -sv ram.sv
vlog -sv rom.sv
vlog -sv mips_mult_tb.sv
vlog -sv mips_single_cycle.sv
vsim work.mips_mult_tb
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_mult_tb/clk
add wave -noupdate /mips_mult_tb/instruction
add wave -noupdate -radix decimal {/mips_mult_tb/dut_ram/mem[0]}
add wave -noupdate -radix decimal {/mips_mult_tb/dut_ram/mem[1]}
add wave -noupdate -radix decimal {/mips_mult_tb/dut_ram/mem[2]}
add wave -noupdate -radix decimal {/mips_mult_tb/dut_mips/regfile0/mem[1]}
add wave -noupdate -radix decimal {/mips_mult_tb/dut_mips/regfile0/mem[2]}
add wave -noupdate -radix decimal {/mips_mult_tb/dut_mips/regfile0/mem[3]}
add wave -noupdate -radix unsigned /mips_mult_tb/pc_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {224171 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 245
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {100750 ps} {415750 ps}
run 400ns