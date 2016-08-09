--
-- Copyright 2016 International Business Machines
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY job_control IS
PORT
(
  -- AFU Control Interface
  ha_jval           :  IN STD_LOGIC;
  ha_jcom           :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_jcompar        :  IN STD_LOGIC;
  ha_jea            :  IN STD_LOGIC_VECTOR(63 DOWNTO 0);
  ha_jeapar         :  IN STD_LOGIC;
  ah_jrunning       : OUT STD_LOGIC;
  ah_jdone          : OUT STD_LOGIC;
  ah_jcack          : OUT STD_LOGIC;
  ah_jerror         : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
  ah_jyield         : OUT STD_LOGIC;
  ah_tbreq          : OUT STD_LOGIC;
  ah_paren          : OUT STD_LOGIC;
  ha_pclock         :  IN STD_LOGIC;
  -- User signals
  afu_reset         : OUT STD_LOGIC;
  afu_running       : OUT STD_LOGIC;
  afu_done          :  IN STD_LOGIC;
  afu_error         :  IN STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE logic OF job_control IS

-- Control Commands on ha_jcom
CONSTANT START    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"90";
CONSTANT RESTART  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"80";
-- States in the state machine
TYPE JOB_STATE IS (POWERON, RESET, AFU_WAIT, RUNNING, DONE);

SIGNAL afu_cur_state    : JOB_STATE := POWERON;
SIGNAL afu_next_state   : JOB_STATE := POWERON;
SIGNAL datapath_running : STD_LOGIC;
SIGNAL datapath_done    : STD_LOGIC;
SIGNAL reset_ack        : STD_LOGIC;

BEGIN

  my_state: PROCESS(ha_pclock, afu_cur_state, ha_jval)
  BEGIN
    -- Always handle incoming request
    IF(ha_jval = '1') THEN
      CASE ha_jcom IS
        WHEN START =>
          afu_next_state <= RUNNING;
        WHEN RESTART =>
          afu_next_state <= RESET;
        WHEN OTHERS =>
          afu_next_state <= afu_cur_state;
      END CASE;
    ELSE
      CASE afu_cur_state IS
        WHEN RESET =>
          afu_next_state <= AFU_WAIT;
        WHEN RUNNING =>
          afu_next_state <= RUNNING;
          IF(afu_done = '1') THEN
            afu_next_state <= DONE;
          END IF;
        WHEN DONE =>
          afu_next_state <= AFU_WAIT;
        WHEN OTHERS =>
          afu_next_state <= afu_cur_state;
      END CASE;
    END IF;
    IF(ha_pclock = '1' AND ha_pclock'EVENT) THEN
      afu_cur_state <= afu_next_state;
    END IF;
  END PROCESS;

  my_signals: PROCESS(afu_cur_state, ha_pclock)
  BEGIN
    datapath_running <='0';
    reset_ack <= '0';
    datapath_done<= '0';    
    CASE afu_cur_state IS
      WHEN POWERON =>
      WHEN AFU_WAIT =>
      WHEN RUNNING =>
        datapath_running <='1';
      WHEN RESET =>
        reset_ack <= '1';
      WHEN DONE =>
        datapath_done <='1';
    END CASE;
  END PROCESS;

  ah_jdone <= datapath_done or reset_ack;
  ah_jrunning <= datapath_running;
  -- User signals for datapath
  afu_reset <= reset_ack;
  afu_running <= datapath_running;
  -- AFU supports parity on PSL Interfaces
  ah_paren <= '1';
  -- Error has occured. Forward response code to host
  ah_jerror(ah_jerror'LENGTH-1 DOWNTO afu_error'LENGTH) <= (OTHERS => '0');
  ah_jerror(afu_error'RANGE) <= afu_error;
  -- Signals below are unused and set to default values 
  ah_jcack <= '0';
  ah_jyield <= '0';
  ah_tbreq <= '0';

END logic;

