// testbench
module tb ();

   logic [127:0]  op1; 
   logic [127:0]  op2;

   logic 	  clk;
   logic [3:0] 	  EQ_correct;
   logic [3:0] 	  LT_correct;
   logic [3:0] 	  LTu_correct;
   logic 	  EQ;
   logic 	  LT;
   logic 	  LTu;
   logic [63:0]   vectornum, errors;    // bookkeeping variables
   logic [267:0]  testvectors[50000:0]; // array of testvectors

   integer 	  handle3;
   integer 	  desc3;  
   integer 	  j; 
   
   // instantiate device under test
   comparatortree128 dut (op1, op2, EQ, LT, LTu);

   always     
     begin
	clk = 1; #5; clk = 0; #5;
     end

   initial
     begin
	handle3 = $fopen("random_int128b.out");
	$readmemh("./random_int128.tv", testvectors);
	vectornum = 0; 
	errors = 0;
     end

   initial 
     begin
        $dumpfile("comparatortree128.vcd");
        $dumpvars (0,tb.dut);
     end   

   initial
     begin
	for (j=0; j < 8192; j=j+1)
	  begin
	     // Put vectors before beginning of clk
	     @(posedge clk)
	       begin
		  {op1, op2, EQ_correct, LT_correct, LTu_correct} = testvectors[vectornum];
	       end
	     @(negedge clk)
	       begin
		  vectornum = vectornum + 1;		       
		  if ((EQ !== EQ_correct[0]) | (LT !== LT_correct[0]) | (LTu !== LTu_correct[0]))
		    begin
		       errors = errors + 1;
		       $display("%h %h || %b %b %b || %b %b %b", 
				op1, op2, EQ, LT, LTu, EQ_correct[0], LT_correct[0], LTu_correct[0]);
		    end	
		  $fdisplay(handle3, "%h %h || %b %b %b || %b %b %b ||", 
			    op1, op2, EQ, LT, LTu, EQ_correct[0], LT_correct[0], LTu_correct[0]);
	       end // @(negedge clk)		  
	  end 
	$display("%d tests completed with %d errors", vectornum, errors);
	$finish;	
     end // initial begin   
   
endmodule // tb


