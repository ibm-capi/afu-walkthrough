LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY work;
USE work.vadd_pkg.ALL;

ENTITY mmio IS
PORT 
(
-- MMIO Interface
  ha_mmval        :  IN STD_LOGIC;
  ha_mmcfg        :  IN STD_LOGIC;
  ha_mmrnw        :  IN STD_LOGIC;
  ha_mmdw         :  IN STD_LOGIC;
  ha_mmad         :  IN STD_LOGIC_VECTOR(23 DOWNTO 0);
  ha_mmadpar      :  IN STD_LOGIC;
  ha_mmdata       :  IN STD_LOGIC_VECTOR(63 DOWNTO 0);
  ha_mmdatapar    :  IN STD_LOGIC;
  ah_mmack        : OUT STD_LOGIC;
  ah_mmdata       : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
  ah_mmdatapar    : OUT STD_LOGIC;
  ha_pclock       :  IN STD_LOGIC
);
END ENTITY;

ARCHITECTURE logic OF mmio IS

CONSTANT AFU_DESC  : STD_LOGIC_VECTOR(23 DOWNTO 0) := (OTHERS => '0');

TYPE MMIO_STATE IS (MMIO_WAIT, MMIO_ACK);

SIGNAL mmio_cur_state   : MMIO_STATE := MMIO_WAIT;
SIGNAL mmio_next_state  : MMIO_STATE := MMIO_WAIT;
SIGNAL mmio_cfg_read    : STD_LOGIC_VECTOR(0 TO 63);

BEGIN

  my_state: PROCESS(ha_pclock, ha_mmval, mmio_cur_state)
  BEGIN
    CASE mmio_cur_state IS
      WHEN MMIO_WAIT =>
        IF(ha_mmval = '1' AND ha_mmcfg = '1') THEN
            mmio_next_state <= MMIO_ACK;
        END IF;        
      WHEN MMIO_ACK =>
        mmio_next_state <= MMIO_WAIT;
    END CASE;
    IF(ha_pclock = '1' and ha_pclock'EVENT) THEN
      mmio_cur_state <= mmio_next_state;
    END IF;
  END PROCESS;

  my_signals: PROCESS(mmio_cur_state)
  BEGIN
    ah_mmack <= '0';
    mmio_cfg_read <= (OTHERS => '0');
    CASE mmio_cur_state IS
      WHEN MMIO_WAIT =>
      WHEN MMIO_ACK =>
        CASE ha_mmad IS 
          WHEN AFU_DESC =>
            mmio_cfg_read <= X"0000" & X"0001" & X"0000" & X"8010";
          WHEN OTHERS =>
            mmio_cfg_read <= (OTHERS => '0');
        END CASE;
        ah_mmack <='1';
    END CASE;
  END PROCESS;

  ah_mmdatapar <= odd_parity(mmio_cfg_read);
  ah_mmdata <= mmio_cfg_read;

END ARCHITECTURE;

