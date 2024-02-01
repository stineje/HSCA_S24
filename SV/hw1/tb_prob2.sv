module stimulus();
   
   logic        clk;
   logic 	reset;
   logic [3:0] 	data;
   logic [6:0] 	segments;
   logic [6:0]	seg_expected;
   logic [31:0] vectornum, errors;
   logic [10:0] testvectors[10000:0];
   
   integer 	handle3;
   
   // instantiate device under test
   sevenseg dut (data, segments);   
   
   // generate clock
   always 
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // at start of test, load vectors and pulse reset
   initial
     begin
	handle3 = $fopen("prob2.out");	
	$readmemb("7segment.tv", testvectors);
	vectornum = 0; errors = 0;
	reset = 1; #22; reset = 0;
     end
   
   // apply test vectors on rising edge of clk
   always @(posedge clk)
     begin
	#1; {data, seg_expected} = testvectors[vectornum];
     end
   
   // check results on falling edge of clk
   always @(negedge clk)
     if (~reset) begin // skip during reset
	$fdisplay(handle3, "%b || result (segments): %b | expected (segments): %b", 
		  data, segments, seg_expected);	
	
	if (segments !== seg_expected) begin  // check result
           $display("Error: inputs = %b", {data});
           $display("  outputs segments = %b (%b expected)", segments, seg_expected);
           errors = errors + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 11'bx) begin 
           $display("%d tests completed with %d errors", 
	            vectornum, errors);
           $stop;
	end
     end
endmodule
