------
-- VHDL module for an unsigned magnitude comparator
--
-- input(s): a, b
-- output(s): a_gtet_b
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
-- eg. vcom -explicit magcomp.vhd

entity magcomp is

-- define input and output ports 
  port (
    a: in std_logic_vector (7 downto 0);
    b: in std_logic_vector (7 downto 0);
    a_gtet_b: out std_logic
  );
end magcomp;

architecture magcomp_arch of magcomp is


begin
  
-- here the output assignment can be a simple evaluation of the input
-- data. This coding style will produce the desired circuit in
-- an efficient and compact way.

a_gtet_b <= '1' when a >= b else '0';

end magcomp_arch;

