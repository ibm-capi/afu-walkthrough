add_wave_group Control_Interface
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ha_pclock}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ha_jval}}
add_wave -into Control_Interface -radix hex {{/top/a0/CONTROL_INTERFACE/ha_jcom}}
add_wave -into Control_Interface {{top/a0/CONTROL_INTERFACE/ha_jcompar}}
add_wave -into Control_Interface -radix hex {{/top/a0/CONTROL_INTERFACE/ha_jea}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ha_jeapar}} 
add_wave -into Control_Interface -radix hex {{/top/a0/CONTROL_INTERFACE/ah_jrunning}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ah_jdone}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ah_jcack}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ah_jerror}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ah_jyield}} 
add_wave -into Control_Interface -radix hex {{/top/a0/CONTROL_INTERFACE/ah_tbreq}} 
add_wave -into Control_Interface {{/top/a0/CONTROL_INTERFACE/ah_paren}} 

