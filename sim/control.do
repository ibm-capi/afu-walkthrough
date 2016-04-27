onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_jval
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_jcom
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_jcompar
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_jea
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_jeapar
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_jrunning
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_jdone
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_jcack
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_jerror
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_jyield
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_tbreq
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ah_paren
add wave -noupdate -expand -group {Control Interface} -radix hexadecimal /top/a0/ha_pclock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {1 us}
