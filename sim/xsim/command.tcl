add_wave_group Command_Interface 
add_wave -into Command_Interface {{/top/a0/DATAPATH/ha_pclock}}
add_wave -into Command_Interface {{/top/a0/DATAPATH/ah_cvalid}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_ctag}}
add_wave -into Command_Interface {{/top/a0/DATAPATH/ah_ctagpar}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_com}}
add_wave -into Command_Interface {{/top/a0/DATAPATH/ah_compar}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_cabt}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_cea}}
add_wave -into Command_Interface {{/top/a0/DATAPATH/ah_ceapar}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_cch}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ah_csize}}
add_wave -into Command_Interface -radix hex {{/top/a0/DATAPATH/ha_croom}}

