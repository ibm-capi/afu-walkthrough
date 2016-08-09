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

LIBRARY work;
USE work.vadd_pkg.ALL;

ENTITY datapath IS
PORT
(
  ha_pclock           :  IN STD_LOGIC;
  ha_jea              :  IN STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Command Interface
  ah_cvalid           : OUT STD_LOGIC;
  ah_ctag             : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  ah_ctagpar          : OUT STD_LOGIC;
  ah_com              : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
  ah_compar           : OUT STD_LOGIC;
  ah_cabt             : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
  ah_cea              : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
  ah_ceapar           : OUT STD_LOGIC;
  ah_cch              : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
  ah_csize            : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
  ha_croom            :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
-- Buffer Interface
  ha_brvalid          :  IN STD_LOGIC;
  ha_brtag            :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_brtagpar         :  IN STD_LOGIC;
  ha_brad             :  IN STD_LOGIC_VECTOR(5 DOWNTO 0);
  ah_brlat            : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
  ah_brdata           : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
  ah_brpar            : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_bwvalid          :  IN STD_LOGIC;
  ha_bwtag            :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_bwtagpar         :  IN STD_LOGIC;
  ha_bwad             :  IN STD_LOGIC_VECTOR(5 DOWNTO 0);
  ha_bwdata           :  IN STD_LOGIC_VECTOR(511 DOWNTO 0);
  ha_bwpar            :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
-- Response Interface
  ha_rvalid           :  IN STD_LOGIC;
  ha_rtag             :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_rtagpar          :  IN STD_LOGIC;
  ha_response         :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  ha_rcredits         :  IN STD_LOGIC_VECTOR(8 DOWNTO 0);
  ha_rcachestate      :  IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  ha_rcachepos        :  IN STD_LOGIC_VECTOR(12 DOWNTO 0);
-- User signals
  reset_datapath      :  IN STD_LOGIC;
  datapath_running    :  IN STD_LOGIC;
  datapath_done       : OUT STD_LOGIC;
  datapath_error      : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE logic OF datapath IS
-- CAPI PSL Command Opcodes 
CONSTANT READ_CL_NA   : STD_LOGIC_VECTOR(12 DOWNTO 0) := '0' & X"A00";
CONSTANT WRITE_NA     : STD_LOGIC_VECTOR(12 DOWNTO 0) := '0' & X"D00";
CONSTANT RESET_COM    : STD_LOGIC_VECTOR(12 DOWNTO 0) := '0' & X"001";
-- Buffer Interface read latency. Currently req. to be 1
CONSTANT READ_LAT     : STD_LOGIC_VECTOR(3 DOWNTO 0) := X"1";
-- Tags for read and write commands
CONSTANT WED_TAG      : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
CONSTANT INPUT1_TAG   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"01";
CONSTANT INPUT2_TAG   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"02";
CONSTANT OUTPUT_TAG   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"03";
CONSTANT DONE_TAG     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"04";
CONSTANT COUNT_TAG    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"05";
CONSTANT RESET_TAG    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"06";
-- Response codes for Response Interface
CONSTANT DONE_RESP    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";
CONSTANT FLUSHED_RESP : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"06";
CONSTANT PAGED_RESP   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0A";
-- WED offset for done flag and cycle count register
CONSTANT DONE_OFFSET  : INTEGER := 32;
CONSTANT COUNT_OFFSET : INTEGER := 40;
-- WED ranges for size, input pointers, and output pointer
SUBTYPE  SIZE_RANGE   IS NATURAL RANGE 63 DOWNTO 0; 
SUBTYPE  IN1_RANGE    IS NATURAL RANGE 127 DOWNTO 64;
SUBTYPE  IN2_RANGE    IS NATURAL RANGE 191 DOWNTO 128;
SUBTYPE  OUT_RANGE    IS NATURAL RANGE 255 DOWNTO 192;

TYPE DATAPATH_STATE IS (RESET, WED_REQ, READ_REQ, WRITE_REQ, WRITE_DONE, 
    WRITE_COUNT, WAIT_REQ, RESET_REQ, DONE);

SIGNAL data_cur_state : DATAPATH_STATE := RESET;
SIGNAL data_next_state: DATAPATH_STATE := RESET;
-- Register for size 
SIGNAL problem_size   : STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Register for input1 pointer
SIGNAL in_ptr1        : STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Register for input2 pointer
SIGNAL in_ptr2        : STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Register for output pointer
SIGNAL out_ptr        : STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Valid for WED input
SIGNAL wed_valid      : STD_LOGIC;
-- Valid for input1 on Buffer Interface
SIGNAL in1_valid      : STD_LOGIC;
-- Valid for input2 on Buffer Interface
SIGNAL in2_valid      : STD_LOGIC;
-- Response for input1 read command on Response Interface
SIGNAL in1_response   : STD_LOGIC;
-- Response for input2 read command on Response Interface
SIGNAL in2_response   : STD_LOGIC;
-- Response for output write command on Response Interface
SIGNAL out_response   : STD_LOGIC;
-- Response for reset command on Response Interface
SIGNAL reset_response : STD_LOGIC;
-- ha_response DONE (command successful)
SIGNAL response_done  : STD_LOGIC;
-- ha_response PAGED or FLUSHED (need to issue reset command)
SIGNAL response_retry : STD_LOGIC;
-- ha_response AERROR, DERROR, NLOCK, NRES, FAULT, or FAILED (error occured)
SIGNAL response_error : STD_LOGIC;
-- Register for input1 data
SIGNAL input1_data    : STD_LOGIC_VECTOR(1023 DOWNTO 0);
-- Register for input2 data
SIGNAL input2_data    : STD_LOGIC_VECTOR(1023 DOWNTO 0);
-- output data
SIGNAL output_line    : STD_LOGIC_VECTOR(1023 DOWNTO 0);
-- Register for output data
SIGNAL output_data    : STD_LOGIC_VECTOR(511 DOWNTO 0);
-- Register for ha_brad
SIGNAL brad           : STD_LOGIC_VECTOR(5 DOWNTO 0);
-- Register for current position
SIGNAL curr_pos       : STD_LOGIC_VECTOR(63 DOWNTO 0);
-- Register for input select
SIGNAL input_select   : STD_LOGIC;
-- Register for word index for write on Buffer Interface
SIGNAL word_index     : STD_LOGIC;
-- Little endian of ha_bwdata
SIGNAL bwdata         : STD_LOGIC_VECTOR(511 DOWNTO 0);
-- Register for clock counter
SIGNAL clock_count    : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN 

my_state: PROCESS(ha_pclock, reset_datapath, datapath_running, data_cur_state)
BEGIN
  IF(reset_datapath = '1') THEN
    data_next_state <= RESET;
  ELSE 
    CASE data_cur_state IS
      WHEN RESET =>
        data_next_state <= RESET;
        IF(datapath_running = '1') THEN
          data_next_state <= WED_REQ;
        END IF;
      WHEN WED_REQ =>
        data_next_state <= WAIT_REQ;
      WHEN READ_REQ =>
        data_next_state <= WAIT_REQ;
      WHEN WRITE_REQ =>
        data_next_state <= WAIT_REQ;
      WHEN RESET_REQ =>
        data_next_state <= WAIT_REQ;
      WHEN WRITE_DONE =>
        data_next_state <= WAIT_REQ;
      WHEN WRITE_COUNT =>
        data_next_state <= WAIT_REQ;
      WHEN WAIT_REQ =>
        data_next_state <= WAIT_REQ;
        IF(response_done = '1') THEN
          CASE ha_rtag IS
            WHEN WED_TAG =>
              data_next_state <= READ_REQ;
            WHEN INPUT1_TAG =>
              data_next_state <= READ_REQ;
              IF(input_select = '1') THEN
                data_next_state <= WRITE_REQ;
              END IF;     
            WHEN INPUT2_TAG =>
              data_next_state <= READ_REQ;
              IF(input_select = '1') THEN
                data_next_state <= WRITE_REQ;
              END IF;
            WHEN OUTPUT_TAG =>
              data_next_state <= READ_REQ;
              IF((UNSIGNED(curr_pos) + TO_UNSIGNED(32, curr_pos'LENGTH)) 
                  >= UNSIGNED(problem_size)) THEN
                data_next_state <= WRITE_COUNT;
              END IF;
            WHEN DONE_TAG =>
              data_next_state <= DONE;  
            WHEN COUNT_TAG =>
              data_next_state <= WRITE_DONE;
            WHEN RESET_TAG =>
              data_next_state <= READ_REQ;
            WHEN OTHERS =>
              data_next_state <= WAIT_REQ;
          END CASE;
        ELSIF(response_retry = '1') THEN
          data_next_state <= RESET_REQ; 
        ELSIF(response_error = '1') THEN
          data_next_state <= DONE;  
        END IF;
      WHEN DONE =>
        data_next_state <= DONE;
    END CASE;
  END IF;
  -- Reset values for all registers
  IF(reset_datapath = '1') THEN
    data_cur_state <= RESET;
    input_select <= '0';
    word_index <= '0';
    brad <= (OTHERS => '0');
    in_ptr1 <= (OTHERS => '0');
    in_ptr2 <= (OTHERS => '0');
    out_ptr <= (OTHERS => '0');
    input1_data <= (OTHERS => '0');
    input2_data <= (OTHERS => '0');
    output_data <= (OTHERS => '0');
    curr_pos <= (OTHERS => '0');
    clock_count <= (OTHERS => '0');
    datapath_error <= (OTHERS => '0');
  ELSIF(ha_pclock = '1' AND ha_pclock'EVENT) THEN
    data_cur_state <= data_next_state;
    -- Match one cycle latency for reads on Buffer Interface
    brad <= ha_brad;
    -- Increment clock counter while datapath is running
    IF(datapath_running = '1' AND data_cur_state /= DONE) THEN
      clock_count <= STD_LOGIC_VECTOR(UNSIGNED(clock_count) 
          + TO_UNSIGNED(1, clock_count'LENGTH));
    END IF;
    -- Error has occured. Forward response code to host
    IF(response_error = '1') THEN
      datapath_error <= ha_response;
    END IF;
    -- Writes on Buffer Interface send half cache line each cycle
    IF(ha_bwvalid = '1') THEN
      word_index <= NOT word_index;
    END IF;
    -- Grab the information from the WED read command
    IF(wed_valid = '1' AND word_index = '0') THEN
      problem_size <= bwdata(SIZE_RANGE);

      in_ptr1 <= bwdata(IN1_RANGE);
      in_ptr2 <= bwdata(IN2_RANGE);
      out_ptr <= bwdata(OUT_RANGE);
    ELSIF(in1_response = '1' AND ha_response = X"00") THEN
      -- Increment input1 pointer
      in_ptr1 <= STD_LOGIC_VECTOR(UNSIGNED(in_ptr1) + 
          TO_UNSIGNED(128, in_ptr1'LENGTH));
    ELSIF(in2_response = '1' AND ha_response = X"00") THEN
      -- Increment input2 pointer
      in_ptr2 <= STD_LOGIC_VECTOR(UNSIGNED(in_ptr2) +
          TO_UNSIGNED(128, in_ptr2'LENGTH));
    ELSIF(out_response = '1' AND ha_response = X"00") THEN
      -- Increment output pointer
      out_ptr <= STD_LOGIC_VECTOR(UNSIGNED(out_ptr) +
          TO_UNSIGNED(128, out_ptr'LENGTH));
      -- Increment current position
      curr_pos <= STD_LOGIC_VECTOR(UNSIGNED(curr_pos) +
          TO_UNSIGNED(32, curr_pos'LENGTH));
    END IF;
    IF(in1_response = '1' OR in2_response = '1') THEN
      IF(ha_response = X"00") THEN
        -- Toggle input select (input1 or input2)
        input_select <= NOT input_select;
      ELSE
        -- Invalid response (not DONE)
        input_select <= '0';
      END IF;
    END IF;
    IF(in1_valid = '1') THEN
      -- Grab entire cache line for input1 read command
      CASE word_index IS
        WHEN '0' =>
          input1_data(511 DOWNTO 0) <= bwdata;
        WHEN '1' =>
          input1_data(1023 DOWNTO 512) <= bwdata;
        WHEN OTHERS =>
      END CASE;
    END IF;
    IF(in2_valid = '1') THEN
      -- Grab entire cache line for input2 read command
      CASE word_index IS
        WHEN '0' =>
          input2_data(511 DOWNTO 0) <= bwdata;
        WHEN '1' =>
          input2_data(1023 DOWNTO 512) <= bwdata;
        WHEN OTHERS =>
      END CASE;
    END IF;
    -- Register output data to match read latency of Buffer Interface
    IF(brad = "000001") THEN
      output_data <= output_line(1023 DOWNTO 512); 
    ELSE 
      output_data <= output_line(511 DOWNTO 0);
    END IF;  
  END IF;
END PROCESS;

my_signals: PROCESS(data_cur_state, ha_rvalid)
BEGIN
  ah_cvalid <= '0';
  ah_ctag <= (OTHERS => '0');
  ah_ctagpar <= '0';
  ah_com <= (OTHERS => '0');
  ah_compar <= '0';
  ah_cabt <= (OTHERS => '0');
  ah_cea <= (OTHERS => '0');
  ah_ceapar <= '0';
  ah_csize <= STD_LOGIC_VECTOR(TO_UNSIGNED(128, ah_csize'LENGTH));

  datapath_done <= '0';

  CASE data_cur_state IS
    WHEN RESET =>
      ah_cvalid <= '0';
    WHEN WED_REQ =>
      ah_cvalid <= '1';
      ah_ctag <= WED_TAG;
      ah_ctagpar <= odd_parity(WED_TAG);
      ah_com <= READ_CL_NA;
      ah_compar <= odd_parity(READ_CL_NA);
      ah_cea <= ha_jea;
      ah_ceapar <= odd_parity(ha_jea);
    WHEN READ_REQ =>
      ah_cvalid <= '1';
      ah_com <= READ_CL_NA;
      ah_compar <= odd_parity(READ_CL_NA);
      IF(input_select = '1') THEN
        ah_ctag <= INPUT1_TAG;
        ah_ctagpar <= odd_parity(INPUT1_TAG);
        ah_cea <= in_ptr1;
        ah_ceapar <= odd_parity(in_ptr1);   
      ELSE 
        ah_ctag <= INPUT2_TAG;
        ah_ctagpar <= odd_parity(INPUT2_TAG);
        ah_cea <= in_ptr2;
        ah_ceapar <= odd_parity(in_ptr2);   
      END IF;   
    WHEN WRITE_REQ =>
      ah_cvalid <= '1';
      ah_ctag <= OUTPUT_TAG;
      ah_ctagpar <= odd_parity(OUTPUT_TAG);
      ah_com <= WRITE_NA;
      ah_compar <= odd_parity(WRITE_NA);
      ah_cea <= out_ptr;
      ah_ceapar <= odd_parity(out_ptr);
    WHEN RESET_REQ =>
      ah_cvalid <= '1';
      ah_ctag <= RESET_TAG;
      ah_ctagpar <= odd_parity(RESET_TAG);
      ah_com <= RESET_COM;
      ah_compar <= odd_parity(RESET_COM);
    WHEN WRITE_DONE => 
      ah_cvalid <= '1';
      ah_ctag <= DONE_TAG;
      ah_ctagpar <= odd_parity(DONE_TAG);
      ah_com <= WRITE_NA;
      ah_compar <= odd_parity(WRITE_NA);
      -- Address of done flag in WED
      ah_cea <= STD_LOGIC_VECTOR(UNSIGNED(ha_jea) + DONE_OFFSET);
      ah_ceapar <= odd_parity(STD_LOGIC_VECTOR(UNSIGNED(ha_jea) 
          + DONE_OFFSET));
      -- Only write done flag
      ah_csize <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, ah_csize'LENGTH));
    WHEN WRITE_COUNT =>
      ah_cvalid <= '1';
      ah_ctag <= COUNT_TAG;
      ah_ctagpar <= odd_parity(COUNT_TAG);
      ah_com <= WRITE_NA;
      ah_compar <= odd_parity(WRITE_NA);
      -- Address of cycle count in WED
      ah_cea <= STD_LOGIC_VECTOR(UNSIGNED(ha_jea) + COUNT_OFFSET);
      ah_ceapar <= odd_parity(STD_LOGIC_VECTOR(UNSIGNED(ha_jea) 
          + COUNT_OFFSET));
      -- Only write cycle count register
      ah_csize <= STD_LOGIC_VECTOR(TO_UNSIGNED(8, ah_csize'LENGTH));
    WHEN WAIT_REQ =>
    WHEN DONE =>
      datapath_done <= '1';
  END CASE;

  -- Decode response codes from Response Interface
  -- DONE: Successful command completion
  -- FLUSHED: PSL in flush state. Need to send reset command
  -- PAGED: O/S has requested AFU to continue. Need to send reset command
  -- All other responses indicate an error for this AFU
  response_done <= '0';
  response_retry <= '0';
  response_error <= '0';
  IF(ha_rvalid = '1') THEN
    CASE ha_response IS
      WHEN DONE_RESP =>
        response_done <= '1';
      WHEN PAGED_RESP =>
        response_retry <= '1';
      WHEN FLUSHED_RESP =>
        response_retry <= '1';
      WHEN OTHERS =>
        response_error <= '1';
    END CASE;
  END IF;
END PROCESS;

-- Data valid for writes on Buffer Interface
wed_valid <= '1' WHEN ha_bwtag = WED_TAG AND ha_bwvalid = '1' ELSE '0';
in1_valid <= '1' WHEN ha_bwtag = INPUT1_TAG AND ha_bwvalid = '1' ELSE '0';
in2_valid <= '1' WHEN ha_bwtag = INPUT2_TAG AND ha_bwvalid = '1' ELSE '0';
-- Power Service Layer is Big-endian
bwdata <= endian_swap(ha_bwdata);
-- Response tags received on Response Interface
in1_response <= '1' WHEN ha_rtag = INPUT1_TAG AND ha_rvalid = '1' ELSE '0';
in2_response <= '1' WHEN ha_rtag = INPUT2_TAG AND ha_rvalid = '1' ELSE '0';
out_response <= '1' WHEN ha_rtag = OUTPUT_TAG AND ha_rvalid = '1' ELSE '0';
reset_response <= '1' WHEN ha_rtag = RESET_TAG AND ha_rvalid = '1' ELSE '0';
-- Select output for read on Buffer Interface
output_line <= (OTHERS => '1') WHEN ha_brtag = DONE_TAG
    ELSE STD_LOGIC_VECTOR(SHIFT_LEFT(RESIZE(UNSIGNED(clock_count), output_line'LENGTH), 320)) 
        WHEN ha_brtag = COUNT_TAG
    ELSE vadd(input1_data, input2_data);
-- Power Service Layer is Big-endian
ah_brdata <= endian_swap(output_data);
ah_brpar <= odd_parity_64dw(output_data);
-- Default value for CAPI User Guide
ah_cch <= (OTHERS => '0');

ah_brlat <= READ_LAT;

END ARCHITECTURE;

