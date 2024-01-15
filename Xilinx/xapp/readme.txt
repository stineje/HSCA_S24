XAPP215 Design Files

Verilog and VHDL files are distinguished by the .v and .vhd file 
extensions respectively.

The following files are used to discuss design considerations for coding in HDL:
ldenaddsub.v ldenaddsub.vhd- Load Enabled Adder/Subtractor

Magnitude comparator for Signed numbers in Verilog:
mag_comp_sign.v

The following files are used in Summary of Synthesis Results Table:
addsub.v addsub.vhd- Adder/Subtractor module
comparator.v comparator.vhd- Comparator module
magcomp.v magcomp.vhd- Magnitude Comparator module
nx2mult.v nx2mult.vhd- N x 2-bit multiplier module
twoscomp.v twoscomp.vhd- 2's complement module

When using ModelSim to compile/analyze VHDL files use
vcom -explicit
The "explicit" switch resolves subtle differences in arithmetic 
functions between 2 libraries that may be invoked in the same design 
file such as the following:
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;