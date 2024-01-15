library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Note that since both the arith and unsigned libraries are used
-- in this design, use the explicit switch for compiling this design 
-- in ModelSim
-- eg. vcom -explicit twoscomp.vhd
entity twoscomp is

port (  d: in std_logic_vector (7 downto 0);
    complement: in std_logic;
    s: out std_logic_vector (7 downto 0)
  );
end twoscomp;

architecture twoscomp_arch of twoscomp is

begin


-- Below is one type of implementation
add_sub: process(complement, d)
begin

  if (complement = '1') then
     s <= (d XOR "11111111") + '1';
  else
     s <= d;
  end if;

-- Below here is a second implementation, much like an adder/subtractor
     
  if (complement = '1') then
     s <=  "00000000" - d;
  else
     s <= "00000000" + d;
  end if;
end process add_sub;



end twoscomp_arch;
