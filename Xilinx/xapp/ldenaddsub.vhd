--
-- This is an adder-subtractor VHDL module.
-- The module is a parallel loadable, synchronous
-- set/reset, clock enabled adder-subtractor.
-- this code implements a simple and compact 
-- adder-subtractor.
--
-- Input(s): a, b, subtract, cin, load_value, load, reset, set, enable, clk
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
    -- a and b are the input numbers to be added
    a: in std_logic_vector (7 downto 0);
    b: in std_logic_vector (7 downto 0);

    -- subtract signal determins if a and b are added or subtracted
    subtract: in std_logic;

    -- carry in signal
    cin: in std_logic;

    -- load_value is the value which is to be loaded on addertion of the
    -- load signal
    load_value: in std_logic_vector (8 downto 0);
    load: in std_logic;

    -- reset resets the counter register value to all zeros
    reset: in std_logic;

    -- set will set the counter to all ones
    set: in std_logic;

    -- enable enables the registers on the counter output value
    enable: in std_logic;

    -- clk is the clock signal used to drive the counter registers
    clk: in std_logic;

    -- sum is the output value 
    sum: out std_logic_vector (8 downto 0)

  );
end add_sub;

architecture add_sub_arch of add_sub is

begin


-- the following is a clocked process. There is a order of precedance
-- for the input signal. 'reset' has the highest precedance, then
-- followed by 'set', 'load' and 'enable' in that order.
add_sub: process(clk)
begin

  -- make the counter output change only on the rising edge of the clock
  if clk'event and clk = '1' then

    -- if the reset is asserted, set the counter value to zeros
    if reset = '1' then
      sum <= (others => '0');

    -- if the set is asserted, set the counter value to ones
    elsif set = '1' then
      sum <= (others => '1');

    -- if the load signal is asserted, load what is on the load inputs
    elsif load = '1' then
      sum <= load_value;

    -- finally, if the adder/subtractor is enabled, do the operation,
    -- which is dependant on the subtract input signal.
    elsif enable = '1' then

     if subtract = '1' then
       sum <= (('0'&a) - ('0'&b));
     else
       sum <= (('0'&a) + ('0'&b)) + cin;
     end if;

    end if;

  end if;
end process add_sub;


end add_sub_arch;


