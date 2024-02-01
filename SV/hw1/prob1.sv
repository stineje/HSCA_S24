module sample (input logic [63:0] a, b, c, output logic [127:0] z, output logic signed [127:0] z2);

   assign z = a*b+c;
   assign z2 = $signed(a)*$signed(b) + $signed(c);

endmodule // sample
