`timescale 1ns/1ps
module stimulus;

   logic 	       reset;   
   logic               StallM, FlushM;
   logic [15:0]        A, B;
   logic [8:0] 	       As, Bs; 	       
   logic [31:0]        ProdM;
   logic [15:0]        ProdMsat;   
   logic 	       V;   
   
   logic [31:0]        p_correct;
   logic 	       v_correct;   
   
   logic 	       clk;
   logic [31:0]        errors;
   logic [31:0]        vectornum;      
   
   integer 	       handle3;
   integer 	       i;  
   integer 	       j;
   integer 	       y_integer;   
   integer 	       sum;

   // Instantiate the Device Under Test
   csam16x16 dut(ProdM, ProdMsat, V, A, B);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("csam16x16sat.out");
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	// Number of tests
	for (j=0; j < 128; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
		  assert(std::randomize(As));
		  assert(std::randomize(Bs));
		  assign A = {7'h0, As};
		  assign B = {7'h0, Bs};		  
	       end
	     @(negedge clk)
	       begin
		  p_correct = A*B;
		  assign v_correct = (p_correct > 2**16)|(p_correct == 2**16);
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (p_correct != ProdM)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h || %b %b %h", 
				A, B, ProdM, p_correct, 
				V, v_correct, ProdMsat);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %b || %b %b %h", 
			       A, B, ProdM, p_correct, (ProdM == p_correct),
			       V, v_correct, ProdMsat);
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
