
/*
  Verilog Comparator module
  inputs are 'a' and 'b'
  output is 'a_et_b' -- 1'b1 when the inputs are equal to each other
                     -- 1'b0 when the inputs are not equal
*/

/*
  declare the module name and ports
  make the inputs eight bits. This can be selected to be any size
  output is always only one bit
*/

module comp (a_et_b, a, b);
input [7:0]a;
input [7:0]b;
output a_et_b;
reg a_et_b;

always @(a or b)
begin

// if the two inputs are equal, indicate this on the output
// otherwise indicate a non-equality

  if(a == b)
    a_et_b = 1'b1;
  else
    a_et_b = 1'b0;

end

endmodule

