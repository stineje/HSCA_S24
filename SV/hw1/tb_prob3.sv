module stimulus ();

   logic  clk;
   logic  reset;
   logic  a;
   logic  b;
   
   logic  q;
   
   integer handle3;
   integer desc3;
   
   // Instantiate DUT
   fsm dut (clk, reset, a, b, q);   

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("prob3.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b %b %b || %b", 
		     reset, a, b, q);
     end   
   
   initial 
     begin
	#0  a = 1'b0;
	#0  b = 1'b0;	
	#0  reset = 1'b1;
	#32 reset = 1'b0;	
	#10 a = 1'b0;
	#10 a = 1'b1;
	#10 b = 1'b1;
	#20 b = 1'b0;	
     end

endmodule // FSM_tb

