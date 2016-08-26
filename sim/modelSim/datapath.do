do control.do
do mmio.do
do command.do
do buffer.do
do response.do

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/reset_datapath
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/datapath_running
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/datapath_done
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/data_cur_state
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/data_next_state
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/problem_size
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in_ptr1
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in_ptr2
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/out_ptr
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/wed_valid
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in1_valid
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in2_valid
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in1_response
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/in2_response
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/out_response
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/input1_data
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/input2_data
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/output_line
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/output_data
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/brad
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/curr_pos
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/input_select
add wave -noupdate -expand -group Datapath -radix hexadecimal /top/a0/DATAPATH/word_index
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

run -all

