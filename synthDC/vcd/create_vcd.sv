`timescale 1ps / 1ps

module tb;

   // Declare variables for stimulating input
   logic [15:0]  x, y, z;   
   logic 	       mul, add, negr, negz;
   logic [1:0]   roundmode;
   
   logic [15:0] result;
   
   logic reset, clk;
   
   // Instantiate the design block counter
  fma16 dut (x, y, z, mul, add, negr, negz,
	     roundmode, result);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clk = 1'b0;
	forever #10 clk = ~clk;
     end

   initial 
     begin
	$dumpfile("fma16.vcd");
	$dumpvars (0,tb.dut);
     end
   
   initial 
     begin
	#0 reset = 1'b0;
	#10 reset = 1'b1;
	repeat (1000) 
	  begin
	     // Initialize Inputs
	     #20 x = $random;
	     #0  y = $random;
	     #0  z = $random;
	  end
	$finish();	
     end // initial begin
   
endmodule // tb
