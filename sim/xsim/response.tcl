add_wave_group Response_Interface 
add_wave -into Response_Interface {{/top/a0/DATAPATH/ha_pclock}}
add_wave -into Response_Interface {{/top/a0/DATAPATH/ha_rvalid}}
add_wave -into Response_Interface -radix hex {{/top/a0/DATAPATH/ha_rtag}}
add_wave -into Response_Interface {{/top/a0/DATAPATH/ha_rtagpar}}
add_wave -into Response_Interface -radix hex {{/top/a0/DATAPATH/ha_response}}
add_wave -into Response_Interface -radix hex {{/top/a0/DATAPATH/ha_rcredits}}
add_wave -into Response_Interface -radix hex {{/top/a0/DATAPATH/ha_rcachestate}}
add_wave -into Response_Interface -radix hex {{/top/a0/DATAPATH/ha_rcachepos}}

