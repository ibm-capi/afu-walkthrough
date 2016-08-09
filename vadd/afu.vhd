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

ENTITY afu IS
PORT
(
-- Command Interface
  ah_cvalid     : OUT STD_LOGIC;                      -- Command valid 
  ah_ctag       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Command tag
  ah_ctagpar    : OUT STD_LOGIC;                      -- Command tag parity
  ah_com        : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);  -- Command code
  ah_compar     : OUT STD_LOGIC;                      -- Command code parity
  ah_cabt       : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);   -- Command ABT
  ah_cea        : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);  -- Command address
  ah_ceapar     : OUT STD_LOGIC;                      -- Command address parity
  ah_cch        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);  -- Command context handle
  ah_csize      : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);  -- Command size
  ha_croom      :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Command room
-- Buffer Interface
  ha_brvalid    :  IN STD_LOGIC;                      -- Buffer read valid
  ha_brtag      :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Buffer read tag
  ha_brtagpar   :  IN STD_LOGIC;                      -- Buffer read tag parity
  ha_brad       :  IN STD_LOGIC_VECTOR(5 DOWNTO 0);   -- Buffer read address
  ah_brlat      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);   -- Buffer resd latency
  ah_brdata     : OUT STD_LOGIC_VECTOR(511 DOWNTO 0); -- Buffer read data
  ah_brpar      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Buffer read parity
  ha_bwvalid    :  IN STD_LOGIC;                      -- Buffer write valid
  ha_bwtag      :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Buffer write tag
  ha_bwtagpar   :  IN STD_LOGIC;                      -- Buffer write tag parity
  ha_bwad       :  IN STD_LOGIC_VECTOR(5 DOWNTO 0);   -- Buffer write address
  ha_bwdata     :  IN STD_LOGIC_VECTOR(511 DOWNTO 0); -- Buffer write data
  ha_bwpar      :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Buffer write parity
-- Response Interface
  ha_rvalid     :  IN STD_LOGIC;                      -- Response valid
  ha_rtag       :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Response tag
  ha_rtagpar    :  IN STD_LOGIC;                      -- Response tag parity
  ha_response   :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Response code
  ha_rcredits   :  IN STD_LOGIC_VECTOR(8 DOWNTO 0);   -- Response credits
  ha_rcachestate:  IN STD_LOGIC_VECTOR(1 DOWNTO 0);   -- Response cache state
  ha_rcachepos  :  IN STD_LOGIC_VECTOR(12 DOWNTO 0);  -- Response cache pos
-- MMIO Interface
  ha_mmval      :  IN STD_LOGIC;                      -- MMIO valid
  ha_mmcfg      :  IN STD_LOGIC;                      -- MMIO AFU desc. space
  ha_mmrnw      :  IN STD_LOGIC;                      -- MMIO read/write
  ha_mmdw       :  IN STD_LOGIC;                      -- MMIO wordsize
  ha_mmad       :  IN STD_LOGIC_VECTOR(23 DOWNTO 0);  -- MMIO address
  ha_mmadpar    :  IN STD_LOGIC;                      -- MMIO address parity
  ha_mmdata     :  IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- MMIO write data
  ha_mmdatapar  :  IN STD_LOGIC;                      -- MMIO write data parity
  ah_mmack      : OUT STD_LOGIC;                      -- MMIO write ack/read valid
  ah_mmdata     : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);  -- MMIO read data
  ah_mmdatapar  : OUT STD_LOGIC;                      -- MMIO read data parity
-- Control Interface
  ha_jval       :  IN STD_LOGIC;                      -- Control valid
  ha_jcom       :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Control command
  ha_jcompar    :  IN STD_LOGIC;                      -- Control command parity
  ha_jea        :  IN STD_LOGIC_VECTOR(63 DOWNTO 0);  -- Control wed address
  ha_jeapar     :  IN STD_LOGIC;                      -- Control wed parity
  ah_jrunning   : OUT STD_LOGIC;                      -- Control AFU running
  ah_jdone      : OUT STD_LOGIC;                      -- Control AFU done
  ah_jcack      : OUT STD_LOGIC;                      -- Control LLCMD ACK  
  ah_jerror     : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);  -- Control AFU error
  ah_jyield     : OUT STD_LOGIC;                      -- Control yield
  ah_tbreq      : OUT STD_LOGIC;                      -- Control timebase request
  ah_paren      : OUT STD_LOGIC;                      -- Control AFU parity support
  ha_pclock     :  IN STD_LOGIC                       -- Control AFU clock
);
END ENTITY;

ARCHITECTURE logic OF afu IS

SIGNAL reset_datapath   : STD_LOGIC;
SIGNAL datapath_running : STD_LOGIC;
SIGNAL datapath_done    : STD_LOGIC;
SIGNAL datapath_error   : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  CONTROL_INTERFACE: ENTITY work.job_control PORT MAP
  (
    ha_jval => ha_jval,
    ha_jcom => ha_jcom,
    ha_jcompar => ha_jcompar,
    ha_jea => ha_jea,
    ha_jeapar => ha_jeapar,
    ah_jrunning => ah_jrunning,
    ah_jdone => ah_jdone,
    ah_jcack => ah_jcack,
    ah_jerror => ah_jerror,
    ah_jyield => ah_jyield,
    ah_tbreq => ah_tbreq,
    ah_paren => ah_paren,
    ha_pclock => ha_pclock,
    afu_reset => reset_datapath,
    afu_running => datapath_running,
    afu_done => datapath_done,
    afu_error => datapath_error
  );

  MMIO_INTERFACE: ENTITY work.mmio PORT MAP
  (
    ha_mmval => ha_mmval,
    ha_mmcfg => ha_mmcfg,
    ha_mmrnw => ha_mmrnw,
    ha_mmdw => ha_mmdw,
    ha_mmad => ha_mmad,
    ha_mmadpar => ha_mmadpar,
    ha_mmdata => ha_mmdata,
    ha_mmdatapar => ha_mmdatapar,
    ah_mmack => ah_mmack,
    ah_mmdata => ah_mmdata,
    ah_mmdatapar => ah_mmdatapar,
    ha_pclock => ha_pclock
  );
 
  DATAPATH: ENTITY work.datapath PORT MAP
  (
    ha_pclock => ha_pclock,
    ha_jea => ha_jea,
    -- Command Interface
    ah_cvalid => ah_cvalid,
    ah_ctag => ah_ctag,
    ah_ctagpar => ah_ctagpar,
    ah_com => ah_com,
    ah_compar => ah_compar,
    ah_cabt => ah_cabt,
    ah_cea => ah_cea,
    ah_ceapar => ah_ceapar,
    ah_cch => ah_cch,
    ah_csize => ah_csize,
    ha_croom => ha_croom,
    -- Buffer Interface
    ha_brvalid => ha_brvalid,
    ha_brtag => ha_brtag,
    ha_brtagpar => ha_brtagpar,
    ha_brad => ha_brad,
    ah_brlat => ah_brlat,
    ah_brdata => ah_brdata,
    ah_brpar => ah_brpar,
    ha_bwvalid => ha_bwvalid,
    ha_bwtag => ha_bwtag,
    ha_bwtagpar => ha_bwtagpar,
    ha_bwad => ha_bwad,
    ha_bwdata => ha_bwdata,
    ha_bwpar => ha_bwpar,
    -- Response Interface
    ha_rvalid => ha_rvalid,
    ha_rtag => ha_rtag, 
    ha_rtagpar => ha_rtagpar,
    ha_response => ha_response,
    ha_rcredits => ha_rcredits,
    ha_rcachestate => ha_rcachestate,
    ha_rcachepos => ha_rcachepos,
    -- User signals
    reset_datapath => reset_datapath,
    datapath_running => datapath_running,
    datapath_done => datapath_done,
    datapath_error => datapath_error
  ); 

END ARCHITECTURE;

