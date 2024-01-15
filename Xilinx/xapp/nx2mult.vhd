library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Note that since both the arith and unsigned libraries are used
-- in this design, use the explicit switch for compiling this design 
-- in ModelSim
-- eg. vcom -explicit nx2mult.vhd

entity Nx2mult is

  generic (data_width : integer := 8);

  port (
    a: in std_logic_vector (data_width-1 downto 0);
    b: in std_logic_vector (1 downto 0);
    p: out std_logic_vector (data_width+1 downto 0));
end Nx2mult;

architecture Nx2mult_arch of Nx2mult is

begin

  p <=a*b;

end Nx2mult_arch;


