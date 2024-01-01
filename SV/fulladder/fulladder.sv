module testbench();
   
   logic        clk;
   logic 	reset;
   logic        a, b, c, s, cout;
   logic 	sum_expected, cout_expected;
   logic [31:0] vectornum, errors;
   logic [4:0] 	testvectors[10000:0];
   
   integer 	handle3;
   
   // instantiate device under test
   fulladder dut(a, b, c, s, cout);
   
   // generate clock
   always 
     begin
	clk = 1; #5; clk = 0; #5;
     end
   
   // at start of test, load vectors and pulse reset
   initial
     begin
	handle3 = $fopen("fulladder.out");	
	$readmemb("fulladder.tv", testvectors);
	vectornum = 0; errors = 0;
	reset = 1; #22; reset = 0;
     end
   
   // apply test vectors on rising edge of clk
   always @(posedge clk)
     begin
	#1; {a, b, c, cout_expected, sum_expected} = testvectors[vectornum];
     end
   
   // check results on falling edge of clk
   always @(negedge clk)
     if (~reset) begin // skip during reset
	$fdisplay(handle3, "%b %b %b || result (cout/sum): %b %b | expected (cout/sum): %b %b", 
		  a, b, c, cout, s, cout_expected, sum_expected);	
	
	if (s !== sum_expected | cout !== cout_expected) begin  // check result
           $display("Error: inputs = %b", {a, b, c});
           $display("  outputs cout s = %b%b (%b%b expected)",cout, s, cout_expected, sum_expected);
           errors = errors + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 5'bx) begin 
           $display("%d tests completed with %d errors", 
	            vectornum, errors);
           $stop;
	end
     end
endmodule

module fulladder(input  logic a, b, c,
                 output logic s, cout);

  assign s = a ^ b ^ c;
  assign cout = (a & b) | (a & c) | (b & c); 
endmodule
