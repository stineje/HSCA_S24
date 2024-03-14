`timescale 1ns/1ps
module stimulus;

   logic 	       reset;   
   logic               StallM, FlushM;
   logic [15:0]        A, B;
   logic [31:0]        ProdM;
   
   logic [31:0]        p_correct;
   
   logic 	       clk;
   logic [31:0]        errors;
   logic [31:0]        vectornum;      
   
   integer 	       handle3;
   integer 	       i;  
   integer 	       j;
   integer 	       y_integer;   
   integer 	       sum;
   
   // Instantiate the Device Under Test
   csam16x16 dut(ProdM, A, B);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("csam16x16.out");
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	// Number of tests
	for (j=0; j < 16; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
		  assert(std::randomize(A));
		  assert(std::randomize(B));		  
	       end
	     @(negedge clk)
	       begin
		  p_correct = A*B;
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (p_correct != ProdM)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h", 
				A, B, ProdM, p_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %b", 
			       A, B, ProdM, p_correct, (ProdM == p_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
