`timescale 1ns/1ps
module stimulus;

   logic [15:0] a;   
   logic [15:0] b;   
   logic 	cin;
   logic [15:0] sum;   

   logic [15:0] sum_correct;
   logic 	cout;   
   
   logic 	clk;
   logic [31:0] errors;
   logic [31:0] vectornum;      
   
   integer 	handle3;
   integer 	i;  
   integer 	j;
   integer 	y_integer;   

   // Instantiate the Device Under Test
   prefixadd16 dut (a, b, cin, sum, cout);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("prob6.out");
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
		  assert(std::randomize(cin));		  		  
	       end
	     @(negedge clk)
	       begin
		  sum_correct = a+b+cin;
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (sum_correct != sum)
		    begin
		       errors = errors + 1;
		       $display("%h %h %b || %h %h", 
				a, b, cin, sum, sum_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h %b || %h %h %b", 
			       a, b, cin, sum, sum_correct, 
			       (sum == sum_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
