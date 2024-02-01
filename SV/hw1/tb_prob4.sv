module stimulus ();

   logic       clk;
   logic       reset;
   
   logic [2:0] q;
   
   integer     handle3;
   integer     desc3;
   
   // Instantiate DUT
   graycounter dut (clk, reset, q);   

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("prob4.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b || %b", 
		     reset, q);
     end   
   
   initial 
     begin
	#0  reset = 1'b1;
	#32 reset = 1'b0;	
     end

endmodule // FSM_tb

