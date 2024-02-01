`timescale 1ns/1ps
module stimulus;

   logic [63:0]         a;   
   logic [63:0] 	b;
   logic [63:0] 	c;   
   logic [127:0] 	z;
   logic signed [127:0] z2;   
   
   logic [127:0] 	z_correct;
   logic signed [127:0] z2_correct;   
   
   logic 		clk;
   logic [31:0] 	errors;
   logic [31:0] 	vectornum;      
   
   integer 		handle3;
   integer 		i;  
   integer 		j;
   integer 		y_integer;   
   integer 		sum; 
   
   // Instantiate the Device Under Test
   sample dut (a, b, c, z, z2);
   
   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("prob1.out");
	vectornum = 0;
	errors = 0;		
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
		  assert(std::randomize(a));
		  assert(std::randomize(b));
		  assert(std::randomize(c));
	       end
	     @(negedge clk)
	       begin
		  z_correct = a*b+c;
		  z2_correct = $signed(a)*$signed(b)+$signed(c);		  
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (z2_correct != z2)
		    begin
		       errors = errors + 1;
		       $display("%h %h %h || %h %h || %h %h", 
				a, b, c, z, z_correct, z2, z2_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h %h || %h %h %b || %h %h %b", 
			       a, b, c, z, z_correct, (z == z_correct), z2, z2_correct, (z2 == z2_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
