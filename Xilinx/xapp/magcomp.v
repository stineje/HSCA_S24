//
// Verilog module for an unsigned magnitude comparator
//
// input(s): a, b
// output(s): a_gtet_b
//

module mag_comp_unsign (a, b, a_gtet_b);
input [7:0]a;
input [7:0]b;
output a_gtet_b;

// since we will be assigning to this, make it a reg
reg a_gtet_b;

// modify the output on a change with a or b
always @(a or b)
begin

// this implementation is a simple if statment. by
// structuring the comparsion like this, The circuit
// will be small and compact.

  if (a >= b)
    a_gtet_b = 1'b1;
  else
    a_gtet_b = 1'b0;
end

endmodule

