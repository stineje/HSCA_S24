--
-- This is the adder-subtractor vhdl module.
-- this code implements a simple and compact 
-- adder-subtractor.
--
-- Input(s): a, b, subtract
-- Output(s): sum
--

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
-- eg. vcom -explicit add_sub.vhd

entity add_sub is

-- define input and output ports 
  port (
    a: in std_logic_vector (7 downto 0);
    b: in std_logic_vector (7 downto 0);
    subtract: in std_logic;
    sum: out std_logic_vector (7 downto 0)

  );
end add_sub;

architecture add_sub_arch of add_sub is

begin

-- specify the output to change on a change to any input
add_sub: process(a, b, subtract)
begin

-- if the input signal 'subtract' is a logic '1' then
-- the output should be a subtraction of a-b else it's a+b
  if(subtract = '1') then
    sum <= a - b;
  else
    sum <= a + b;
  end if;
end process add_sub;

end add_sub_arch;

