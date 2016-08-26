onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /top/a0/ah_cvalid
add wave -noupdate -radix hexadecimal /top/a0/ah_ctag
add wave -noupdate -radix hexadecimal /top/a0/ah_ctagpar
add wave -noupdate -radix hexadecimal /top/a0/ah_com
add wave -noupdate -radix hexadecimal /top/a0/ah_compar
add wave -noupdate -radix hexadecimal /top/a0/ah_cabt
add wave -noupdate -radix hexadecimal /top/a0/ah_cea
add wave -noupdate -radix hexadecimal /top/a0/ah_ceapar
add wave -noupdate -radix hexadecimal /top/a0/ah_cch
add wave -noupdate -radix hexadecimal /top/a0/ah_csize
add wave -noupdate -radix hexadecimal /top/a0/ha_croom
add wave -noupdate -radix hexadecimal /top/a0/ha_brvalid
add wave -noupdate -radix hexadecimal /top/a0/ha_brtag
add wave -noupdate -radix hexadecimal /top/a0/ha_brtagpar
add wave -noupdate -radix hexadecimal /top/a0/ha_brad
add wave -noupdate -radix hexadecimal /top/a0/ah_brlat
add wave -noupdate -radix hexadecimal /top/a0/ah_brdata
add wave -noupdate -radix hexadecimal /top/a0/ah_brpar
add wave -noupdate -radix hexadecimal /top/a0/ha_bwvalid
add wave -noupdate -radix hexadecimal /top/a0/ha_bwtag
add wave -noupdate -radix hexadecimal /top/a0/ha_bwtagpar
add wave -noupdate -radix hexadecimal /top/a0/ha_bwad
add wave -noupdate -radix hexadecimal /top/a0/ha_bwdata
add wave -noupdate -radix hexadecimal /top/a0/ha_bwpar
add wave -noupdate -radix hexadecimal /top/a0/ha_rvalid
add wave -noupdate -radix hexadecimal /top/a0/ha_rtag
add wave -noupdate -radix hexadecimal /top/a0/ha_rtagpar
add wave -noupdate -radix hexadecimal /top/a0/ha_response
add wave -noupdate -radix hexadecimal /top/a0/ha_rcredits
add wave -noupdate -radix hexadecimal /top/a0/ha_rcachestate
add wave -noupdate -radix hexadecimal /top/a0/ha_rcachepos
add wave -noupdate -radix hexadecimal /top/a0/ha_mmval
add wave -noupdate -radix hexadecimal /top/a0/ha_mmcfg
add wave -noupdate -radix hexadecimal /top/a0/ha_mmrnw
add wave -noupdate -radix hexadecimal /top/a0/ha_mmdw
add wave -noupdate -radix hexadecimal /top/a0/ha_mmad
add wave -noupdate -radix hexadecimal /top/a0/ha_mmadpar
add wave -noupdate -radix hexadecimal /top/a0/ha_mmdata
add wave -noupdate -radix hexadecimal /top/a0/ha_mmdatapar
add wave -noupdate -radix hexadecimal /top/a0/ah_mmack
add wave -noupdate -radix hexadecimal /top/a0/ah_mmdata
add wave -noupdate -radix hexadecimal /top/a0/ah_mmdatapar
add wave -noupdate -radix hexadecimal /top/a0/ha_jval
add wave -noupdate -radix hexadecimal /top/a0/ha_jcom
add wave -noupdate -radix hexadecimal /top/a0/ha_jcompar
add wave -noupdate -radix hexadecimal /top/a0/ha_jea
add wave -noupdate -radix hexadecimal /top/a0/ha_jeapar
add wave -noupdate -radix hexadecimal /top/a0/ah_jrunning
add wave -noupdate -radix hexadecimal /top/a0/ah_jdone
add wave -noupdate -radix hexadecimal /top/a0/ah_jcack
add wave -noupdate -radix hexadecimal /top/a0/ah_jerror
add wave -noupdate -radix hexadecimal /top/a0/ah_jyield
add wave -noupdate -radix hexadecimal /top/a0/ah_tbreq
add wave -noupdate -radix hexadecimal /top/a0/ah_paren
add wave -noupdate -radix hexadecimal /top/a0/ha_pclock
add wave -noupdate -radix hexadecimal /top/a0/reset_datapath
add wave -noupdate -radix hexadecimal /top/a0/datapath_running
add wave -noupdate -radix hexadecimal /top/a0/datapath_done
add wave -noupdate -radix hexadecimal /top/a0/datapath_error
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
