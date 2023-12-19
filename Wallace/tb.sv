`timescale 1ns/1ps
module stimulus;

   logic [15:0] a;   
   logic [15:0] b;
   logic 	tc;   
   logic [31:0] sum;
   logic [31:0] carry;   

   logic [31:0] z_correct;
   
   logic 	clk;
   logic [31:0] errors;
   logic [31:0] vectornum;      
   
   integer 	 handle3;
   integer 	 i;  
   integer       j;
   integer 	 y_integer;   

   mult_cs #(16) dut (a, b, tc, sum, carry);   

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	handle3 = $fopen("wallace.out");
	tc = 1;	
	vectornum = 0;
	errors = 0;		
     end

   initial
     begin
	for (j=0; j < 8; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  a = $random;
		  b = $random;
	       end
	     @(negedge clk)
	       begin
		  z_correct = a*b;
		  vectornum = vectornum + 1;		       
		  if ((sum+carry) != z_correct)
		    begin
		       errors = errors + 1;
		       $display("%h %h || %h %h %h", 
				a, b, sum, carry, z_correct);
		    end		       
		  #0 $fdisplay(handle3, "%h %h || %h %h %h %b", 
			       a, b, sum, carry, z_correct, ((sum+carry) == z_correct));
	       end // @(negedge clk)		  
	  end // for (j=0; j < 8; j=j+1)	
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end // initial begin   

endmodule // stimulus
