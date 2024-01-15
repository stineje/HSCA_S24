------
-- VHDL module for a comparator
--  this module contains two implementations for the
--  comparsion. Not all synthesis tools will accept
--  both implementations. However, these two implementation
--  have been noticed to work with all tests synthesis tools.
--
-- input(s): a, b
-- output(s): a_et_b_1, a_et_b_2
------

-- include these three standard IEEE libraries.
-- they include arithmetic operations and conversion functions
-- necessary for mathematical operations.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Note that since both the arith and unsigned libraries are used
-- in this design, use the explicit switch for compiling this design 
-- in ModelSim
-- eg. vcom -explicit comparator.vhd

entity comp is

-- define input and output ports 
-- make the inputs 8 bits wide. can actually have any size here
-- output is always only one bit
  port (
    a: in std_logic_vector (7 downto 0);
    b: in std_logic_vector (7 downto 0);
    a_et_b_1: out std_logic;
    a_et_b_2: out std_logic
  );
end comp;

architecture comp_arch of comp is
  
signal int: std_logic_vector (7 downto 0);

begin

-- here a simple comparsion operator is done to test the equality.
-- a one is assigned to the output is the values are equal.
-- this method does not work for all synthesizers.
-- Another method can be used if this coding style does not work
-- with your synthesis tool.
  
a_et_b_1 <= '1' when (a = b) else '0';


-- in the following case a subtraction is used 
-- to test the equality. This explicitly indicates
-- that a mathematical operation is to be used and
-- thus it will utilize the carry chain.

-- the assignment to a_et_b_2 is a check to see if the
-- result of the subtraction is a zero. If it is zero the
-- inputs are equal and the output signal is asserted.
int <= a - b;
a_et_b_2 <= '1' when (int = 0) else '0';
end comp_arch;

