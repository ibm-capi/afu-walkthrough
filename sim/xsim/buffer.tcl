add_wave_group Buffer_Interface 
add_wave -into Buffer_Interface {{/top/a0/DATAPATH/ha_pclock}}
add_wave -into Buffer_Interface {{/top/a0/DATAPATH/ha_brvalid}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_brtag}}
add_wave -into Buffer_Interface {{/top/a0/DATAPATH/ha_brtagpar}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_brad}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ah_brlat}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ah_brdata}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ah_brpar}}
add_wave -into Buffer_Interface {{/top/a0/DATAPATH/ha_bwvalid}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_bwtag}}
add_wave -into Buffer_Interface {{/top/a0/DATAPATH/ha_bwtagpar}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_bwad}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_bwdata}}
add_wave -into Buffer_Interface -radix hex {{/top/a0/DATAPATH/ha_bwpar}}

