`timescale 1ns/1ps
module tb;

   logic [11:0] Y;
   logic [15:0] X;
   logic [27:0] Z;
   
   logic signed [27:0] p_correct;
   
   logic 	       clk;
   logic [31:0]        errors;
   logic [31:0]        vectornum;      
   
   integer 	       handle3;
   integer 	       i;  
   integer 	       j;
   integer 	       y_integer;   
   integer 	       sum;
   
   // Instantiate the Device Under Test
   mult dut (Z, X, Y);   

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("prob1.out");
	// Tells when to finish simulation
	#500 $finish;		
     end

 // Test vector 
   initial
     begin
	// Number of tests
	for (j=0; j < 32; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
		  assert(std::randomize(X));
		  assert(std::randomize(Y));
	       end
	     @(negedge clk)
	       begin
		  p_correct = $signed(X)*$signed(Y);
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (p_correct != Z)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h", 
				X, Y, Z, p_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h", 
			       X, Y, Z, p_correct);		  
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
