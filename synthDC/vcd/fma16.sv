// Example synthesis
module fma16 (x, y, z, mul, add, negr, negz,
	      roundmode, result);
   
   input logic [15:0]  x, y, z;   
   input logic 	       mul, add, negr, negz;
   input logic [1:0]   roundmode;
   
   output logic [15:0] result;

   // Example (not fma)
   assign result = x[7:0]*y[7:0] + z;   
 
endmodule

