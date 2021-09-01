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
vlog -sv mips_single_core_tb.sv
vlog -sv mips_single_cycle.sv
vsim work.mips_single_core_tb
quietly WaveActivateNextPane {} 0
add wave -noupdate /mips_single_core_tb/clk
add wave -noupdate -radix binary /mips_single_core_tb/instruction
add wave -noupdate -radix unsigned /mips_single_core_tb/pc_out
add wave -noupdate -radix unsigned {/mips_single_core_tb/dut_mips/regfile0/mem[31]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29087 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 228
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
WaveRestoreZoom {0 ps} {76546 ps}
run 40ns
