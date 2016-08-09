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

PACKAGE vadd_pkg IS

  FUNCTION odd_parity(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC;
  FUNCTION odd_parity_64dw(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR;
  FUNCTION endian_swap(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR;
  FUNCTION vadd(input1 : STD_LOGIC_VECTOR; input2 : STD_LOGIC_VECTOR) 
      RETURN STD_LOGIC_VECTOR;   

END PACKAGE;

PACKAGE BODY vadd_pkg IS 

FUNCTION odd_parity(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
  VARIABLE result : STD_LOGIC := '0';
BEGIN

  FOR i IN 0 TO data'LENGTH-1 LOOP
    result := result xor data(i);
  END LOOP;
  RETURN NOT result;
END odd_parity;

FUNCTION odd_parity_64dw(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR IS
  VARIABLE result : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
BEGIN 
  FOR i IN 0 TO result'LENGTH-1 LOOP
    FOR j IN 0 TO 63 LOOP
      result(i) := result(i) xor data((result'LENGTH-1-i)*64 + j);
    END LOOP;
  END LOOP;
  RETURN NOT result;
END odd_parity_64dw;

FUNCTION endian_swap(data : STD_LOGIC_VECTOR) RETURN STD_LOGIC_VECTOR IS
  VARIABLE result     : STD_LOGIC_VECTOR(data'RANGE);
  VARIABLE BYTE       : INTEGER := 8;
  VARIABLE NUM_BYTES  : INTEGER := (data'LENGTH/BYTE);
BEGIN
  FOR i IN 0 TO NUM_BYTES-1 LOOP
    result((i+1)*BYTE-1 DOWNTO i*BYTE) := data((NUM_BYTES-i)*BYTE-1 DOWNTO (NUM_BYTES-i-1)*BYTE);
  END LOOP;
  RETURN result;
END endian_swap;

FUNCTION vadd(input1 : STD_LOGIC_VECTOR; input2 : STD_LOGIC_VECTOR) 
    RETURN STD_LOGIC_VECTOR IS
  VARIABLE result     : STD_LOGIC_VECTOR(input1'RANGE);
  VARIABLE DATA_SIZE  : INTEGER := 4*8;
  VARIABLE NUM_ADD    : INTEGER := input1'LENGTH/(DATA_SIZE);
BEGIN
  FOR i IN 0 TO NUM_ADD-1 LOOP
    result((i+1)*DATA_SIZE-1 DOWNTO i*DATA_SIZE) := STD_LOGIC_VECTOR(
        UNSIGNED(input1((i+1)*DATA_SIZE-1 DOWNTO i*DATA_SIZE)) +
        UNSIGNED(input2((i+1)*DATA_SIZE-1 DOWNTO i*DATA_SIZE)));
  END LOOP;
  RETURN result;
END vadd;

END PACKAGE BODY;

