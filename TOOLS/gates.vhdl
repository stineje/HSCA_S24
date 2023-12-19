-------------------------------------------------------------------------------
-- File name : gates.vhdl
-- Title     : gates
-- project   : 
-- Library   : gates
-- Author(s) : James E. Stine, Jr.
-- Purpose   : definition of package gates and its architectures
-- notes :   

-- Copyright Oklahoma State University
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

package gates is
  
  component full_adder
    port (A, B, Cin : in  std_logic;
          Sum, Cout : out std_logic);
  end component;
  
  component rfa
    port (A, B, Cin : in  std_logic;
          g, p, Sum : out std_logic);
  end component;
  
  component rha
    port (A, Cin : in  std_logic;
          g, p   : out std_logic;
          Sum    : out std_logic);
  end component;

  component half_adder
    port (A, B      : in  std_logic;
          Sum, Cout : out std_logic);
  end component;

end gates;
-------------------------------------------------------------

package body gates is

end gates;

library IEEE;
use IEEE.std_logic_1164.all;
library WORK;
use work.gates.all;

--Full Adder
entity full_adder is
  port (A, B, component : in  std_logic;
        Sum, Cout : out std_logic);
end full_adder;

architecture structure of full_adder is
begin
  Sum  <= (A xor B xor Cin);
  Cout <= ((A and B) or (B and Cin) or (A and Cin));
end structure;

library IEEE;
use IEEE.std_logic_1164.all;
library WORK;
use work.gates.all;

--Reduced Full Adder
entity rfa is
  port (A, B, Cin : in  std_logic;
        g, p      : out std_logic;
        Sum       : out std_logic);
end rfa;

architecture structure of rfa is
begin
  Sum <= (A xor B xor Cin);
  g   <= A and B;
  p   <= A or B;
end structure;

library IEEE;
use IEEE.std_logic_1164.all;
library WORK;
use work.gates.all;

--Reduced Half Adder
entity rha is
  port (A, B   : in  std_logic;
        g, p   : out std_logic;
        Sum    : out std_logic);
end rha;

architecture structure of rha is

begin
  Sum <= (A xor B);
  g   <= (A and B);
  p   <= (A or B);
end structure;

library IEEE;
use IEEE.std_logic_1164.all;
library WORK;
use work.gates.all;

--Half Adder
entity half_adder is
  port (A, B      : in  std_logic;
        Sum, Cout : out std_logic);
end half_adder;

architecture structure of half_adder is
begin
  Sum  <= A xor B;
  Cout <= A and B;
end structure;
