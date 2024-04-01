`timescale 1ns/1ps
module stimulus;

   logic [31:0]  op1;   
   logic [31:0]  op2;   
   logic [2:0] 	 rm;		
   logic 	 op_type;	
   
   logic 	 start;
   logic 	 reset;
   
   logic [63:0]  AS_Result;	
   logic [4:0] 	 Flags;   	
   logic 	 Denorm;   	
   logic 	 done;
   
   logic 	 clk;
   logic [31:0]  yexpected;
   logic [63:0]  vectornum, errors;    // bookkeeping variables
   logic [103:0] testvectors[50000:0]; // array of testvectors
   logic [7:0] 	 flags_expected;
   
   integer 	 handle3;
   integer 	 desc3;   

   // instantiate device under test
   fpdiv dut (done, AS_Result, Flags, Denorm, op1, op2, rm, op_type, 
	      start, reset, clk);

   // 1 ns clock
   initial 
     begin	
	clk = 1'b1;
	forever #5 clk = ~clk;
     end

   initial
     begin
	handle3 = $fopen("f32_div_rne.out");
	$readmemh("f32_div_rne.tv", testvectors);
	vectornum = 0; errors = 0;
	start = 1'b0;
	// reset
	reset = 1; #27; reset = 0;
     end

   // Test vector
   always @(posedge clk)
     begin
	if (~reset)
	  begin
	     #0; {op1, op2, yexpected, flags_expected} = testvectors[vectornum];
	     #50 start = 1'b1;
	     repeat (2)
	       @(posedge clk);
	     // deassert start after 2 cycles
	     start = 1'b0;	
	     repeat (10)
	       @(posedge clk);
	     $fdisplay(desc3, "%h_%h_%h_%b_%b | %h_%b", op1, op2, AS_Result, Flags, Denorm, yexpected, (AS_Result==yexpected));
	     vectornum = vectornum + 1;
	     if ((testvectors[vectornum] === 104'bx)) begin
		$display("Simulation succeeded");
		$stop;
	     end	     
	  end // if (~reset)
	$display("%d vectors processed", vectornum);	
     end // always @ (posedge clk)
   
endmodule // stimulus
