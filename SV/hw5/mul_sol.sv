///////////////////////////////////////////
// mul.sv
//
// Written: David_Harris@hmc.edu 16 February 2021
// Modified: james.stine@okstate.edu 14 March 2024
//
// Purpose: Multiply instruction
// 
// A component of the Wally configurable RISC-V project.
// 
// Copyright (C) 2021 Harvey Mudd College & Oklahoma State University
//
// MIT LICENSE
// Permission is hereby granted, free of charge, to any person obtaining a copy of this 
// software and associated documentation files (the "Software"), to deal in the Software 
// without restriction, including without limitation the rights to use, copy, modify, merge, 
// publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
// to whom the Software is furnished to do so, subject to the following conditions:
//
//   The above copyright notice and this permission notice shall be included in all copies or 
//   substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//   INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//   PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS 
//   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
//   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE 
//   OR OTHER DEALINGS IN THE SOFTWARE.
////////////////////////////////////////////////////////////////////////////////////////////////

module mul #(parameter XLEN=32) (
  input logic 		    clk, reset,
  input logic 		    StallM, FlushM,
  input logic [XLEN-1:0]    SrcAE, SrcBE, 
  input logic [2:0] 	    Funct3E,
  output logic [XLEN*2-1:0] ProdM);

   
   logic [XLEN*2-1:0] 	     ProdE;
   logic [XLEN-1:0] 	     MulDivResultE, MulDivResultM;
   logic [XLEN-1:0] 	     PrelimResultE;
   logic [XLEN*2-3:0] 	     Pp;
   logic [XLEN-2:0] 	     PA,PB;
   logic 		     Pm;
   

   // Partial products
   assign Pp = SrcAE[XLEN-2:0] * SrcBE[XLEN-2:0];
   assign PA = {(XLEN-1){SrcBE[XLEN-1]}} & SrcAE[XLEN-2:0];
   assign PB = {(XLEN-1){SrcAE[XLEN-1]}} & SrcBE[XLEN-2:0];
   assign Pm = SrcAE[XLEN-1] & SrcBE[XLEN-1]; 	 
   // Make product
   always_comb
     case (Funct3E)
       3'b000: ProdE = {2'b0,Pp} + {2'b0, PA,{XLEN-1{1'b0}}} +
                       {2'b0, PB,{XLEN-1{1'b0}}} +
                       {1'b0, Pm,{XLEN*2-2{1'b0}}}; // all flavors
       3'b001: ProdE = {2'b0,Pp} + {2'b0,~PA,{XLEN-1{1'b0}}} +
                        {2'b0,~PB,{XLEN-1{1'b0}}} +
                       {1'b1, Pm,{XLEN-3{1'b0}}, 1'b1,{XLEN{1'b0}}}; // signed x signed
       3'b010: ProdE = {2'b0,Pp} + {2'b0, PA,{XLEN-1{1'b0}}} + 
		       {2'b0,~PB,{XLEN-1{1'b0}}} + 
		       {1'b1,~Pm,{XLEN-2{1'b0}},1'b1,{XLEN-1{1'b0}}}; // signed x unsigned
       3'b011: ProdE = {2'b0,Pp} + {2'b0, PA,{XLEN-1{1'b0}}} + 
		       {2'b0, PB,{XLEN-1{1'b0}}} + 
		       {1'b0, Pm,{XLEN*2-2{1'b0}}}; // unsigned x unsigned
     endcase
   
   //////////////////////////////
   // Memory Stage Register
   //////////////////////////////
   //flopenrc #(XLEN*2) ProdMReg(clk, reset, FlushM, ~StallM, ProdE, ProdM);
   assign ProdM = ProdE;   
 endmodule

