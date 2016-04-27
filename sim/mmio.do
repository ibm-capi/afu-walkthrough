onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmval
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmcfg
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmrnw
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmdw
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmad
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmadpar
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmdata
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ha_mmdatapar
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ah_mmack
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ah_mmdata
add wave -noupdate -expand -group {MMIO Interface} -radix hexadecimal sim:/top/a0/ah_mmdatapar
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {26 ns} 0}
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
WaveRestoreZoom {0 ns} {48 ns}
