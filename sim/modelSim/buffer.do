onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_brvalid
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_brtag
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_brtagpar
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_brad
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ah_brlat
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ah_brdata
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ah_brpar
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwvalid
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwtag
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwtagpar
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwad
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwdata
add wave -noupdate -expand -group {Buffer Interface} -radix hexadecimal sim:/top/a0/ha_bwpar
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
