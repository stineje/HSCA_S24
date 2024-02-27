These are Perl scripts I wrote in the way-back-machine and generate
array and dadda multipliers for any size in Verilog.  They require
tadders.v and also require the product to be x+y.  If z \neq x+y then
it will form a truncated multiplier using either Constant (Schulte/Swartzlander),
Variable (King/Swartzlander), or Hybrid (Stine/Duverne)

The array_sv.pl is specifically to generate a SystemVerilog output (not truncated).  To run it, type:  array_sv.pl -x 8 -y 8 -m mult.  It will also assume that the output is a rectangular multiplier.
