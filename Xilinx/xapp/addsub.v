
//
// This is the adder-subtractor verilog module.
// this code implements a simple and compact
// adder-subtractor.
//
// Input(s): a, b, subtract
// Output(s): sum

// declare the module
module add_sub(sum, a, b, subtract);

output [7:0]sum;
input [7:0]a;
input [7:0]b;
input subtract;
reg [7:0]sum;

// specify the output to change on a change to any input
always @(a or b or subtract)
begin

// if the input signal 'subtract' is a logic '1' then
// the output should be a subtraction of a-b else it's a+b

  if (subtract == 1'b1)
    sum = a - b;
  else
    sum = a + b;

end

endmodule

