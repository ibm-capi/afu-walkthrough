onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rvalid
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rtag
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rtagpar
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_response
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rcredits
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rcachestate
add wave -noupdate -expand -group {Response Interface} -radix hexadecimal sim:/top/a0/ha_rcachepos
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
