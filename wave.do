onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ALU_testbench/A
add wave -noupdate /ALU_testbench/B
add wave -noupdate /ALU_testbench/sel
add wave -noupdate /ALU_testbench/out
add wave -noupdate /ALU_testbench/Z
add wave -noupdate /ALU_testbench/overflow
add wave -noupdate /ALU_testbench/Cout
add wave -noupdate /ALU_testbench/neg
add wave -noupdate /ALU_testbench/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {126065 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3433112 ps} {3715559 ps}
