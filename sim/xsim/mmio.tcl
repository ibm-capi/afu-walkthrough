add_wave_group MMIO_Interface
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmval}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmcfg}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmrnw}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmdw}} 
add_wave -into MMIO_Interface -radix hex {{/top/a0/MMIO_INTERFACE/ha_mmad}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmadpar}} 
add_wave -into MMIO_Interface -radix hex {{/top/a0/MMIO_INTERFACE/ha_mmdata}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_mmdatapar}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ah_mmack}} 
add_wave -into MMIO_Interface -radix hex {{/top/a0/MMIO_INTERFACE/ah_mmdata}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ah_mmdatapar}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/ha_pclock}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/mmio_cur_state}} 
add_wave -into MMIO_Interface {{/top/a0/MMIO_INTERFACE/mmio_next_state}} 

