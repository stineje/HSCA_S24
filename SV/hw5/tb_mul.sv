`timescale 1ns/1ps
module stimulus;

   logic 	       reset;   
   logic               StallM, FlushM;
   logic [31:0]        SrcAE, SrcBE;
   logic [2:0] 	       Funct3E;
   logic [63:0]        ProdM;
   
   logic signed [63:0]        p_correct;
   
   logic 	       clk;
   logic [31:0]        errors;
   logic [31:0]        vectornum;      
   
   integer 	       handle3;
   integer 	       i;  
   integer 	       j;
   integer 	       y_integer;   
   integer 	       sum;
   
   // Instantiate the Device Under Test
   mul #(32) dut (clk, reset, StallM, FlushM, SrcAE, SrcBE, Funct3E, ProdM);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   // Define the output file
   initial
     begin
	handle3 = $fopen("mul.out");
	reset = 0;	
	StallM = 0;
	FlushM = 0;	
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	Funct3E = 3'b001;	
	// Number of tests
	for (j=0; j < 4; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  // allows better output of randomized signals
		  assert(std::randomize(SrcAE));
		  assert(std::randomize(SrcBE));		  
	       end
	     @(negedge clk)
	       begin
		  p_correct = $signed(SrcAE)*$signed(SrcBE);
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (p_correct != ProdM)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h", 
				SrcAE, SrcBE, ProdM, p_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %b", 
			       SrcAE, SrcBE, ProdM, p_correct, (ProdM == p_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
