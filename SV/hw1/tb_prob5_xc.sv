module stimulus ();

   logic       clk;
   logic       reset;
   logic       up;
   logic       load;
   logic [2:0] in;   
   
   logic [2:0] q;
   
   integer     handle3;
   integer     desc3;
   
   // Instantiate DUT
   graycounter dut (clk, reset, up, load, in, q);   

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("prob5_xc.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b %b %b %b || %b", 
		     reset, up, load, in, q);
     end   
   
   initial 
     begin
	#0  up = 1'b1;
	#0  load = 1'b0;
	// Load this one 
	#0  in = 3'b101;	
	#0  reset = 1'b1;
	#32 reset = 1'b0;
	#35 up = 1'b0;
	#42 load = 1'b1;
	#21 load = 1'b0;
     end

endmodule // FSM_tb

