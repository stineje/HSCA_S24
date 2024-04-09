`timescale 1ns/1ps
module stimulus;

   logic 	       reset;   
   logic               StallM, FlushM;
   logic [31:0]        SrcAE;
   logic [31:0]        SrcBE;
   logic [2:0] 	       Funct3E;
   logic [63:0]        ProdM;
   
   logic signed [63:0] p_correct;
   
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
	handle3 = $fopen("prob3.out");
	reset = 0;	
	StallM = 0;
	FlushM = 0;	
	vectornum = 0;
	errors = 0;		
     end

   // Test vector 
   initial
     begin
	// What function should I use
	Funct3E = 3'b011;	
	// Number of tests
	for (j=0; j < 128; j=j+1)
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
		  case (Funct3E)
		    3'h0: p_correct = SrcAE*SrcBE;
		    3'h1: p_correct = $signed(SrcAE)*$signed(SrcBE);
		    // When you multily signed and unsigned numbers,
		    // the expression type will be determined as
		    // unsigned. This will be propagated back to
		    // operands and all signed will be treated as
		    // unsigned as well.  This fix will allow it to
		    // operate correctly of signed x unsigned
		    3'h2: p_correct = $signed(SrcAE)*$signed({1'b0,SrcBE});
		    3'h3: p_correct = SrcAE*SrcBE;
		  endcase // case (Funct3E)
		  vectornum = vectornum + 1;
		  // Check if output of DUT is the same as the correct output
		  if (p_correct != ProdM)
		    begin
		       errors = errors + 1;
		       $display("%h %h %b || %h %h", 
				SrcAE, SrcBE, Funct3E, ProdM, p_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %b", 
			       SrcAE, SrcBE, ProdM, p_correct, (ProdM == p_correct));
	       end // @(negedge clk)		  
	  end // for (i=0; i < 16; i=i+1)
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end 

endmodule // stimulus
