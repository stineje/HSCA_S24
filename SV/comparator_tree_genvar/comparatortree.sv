
/////
// This module compares two 64-bit values A and B. LT is '1' if A < B
// and EQ is '1'if A = B. LT and GT are both '0' if A > B.
// This structure was modified so
// that it only does a strict magnitdude comparison, and only
// returns flags for less than (LT) and eqaual to (EQ). It uses a tree
// of 63 2-bit magnitude comparators, followed by one OR gates.
//
// This module has been further modified by Alex Underwood to support
// a parameterized implementation.  Specifying a WIDTH parameter when
// instancing this module will automatically build a correct, minimal
// comparator tree.
/////

module comparatortree #(parameter WIDTH=64) (
  input  logic [WIDTH-1:0] A,
  input  logic [WIDTH-1:0] B,
  output logic             EQ,
  output logic             LT,
  output logic             LTu
);

   localparam W2 = WIDTH/2;
   
   // prefix implementation
   localparam levels = $clog2(WIDTH);
   genvar 		     i;
   genvar 		     level;

   logic [W2-1:0] 	     s[levels-1:0];
   logic [W2-1:0] 	     t[levels-1:0];
   logic 		     ls[levels-1:0];
   logic 		     lt[levels-1:0];            

   logic [1:0] 		     A2;
   logic [1:0] 		     B2;

   assign A2 = {~A[WIDTH-1], A[WIDTH-2]};
   assign B2 = {~B[WIDTH-1], B[WIDTH-2]};

   // 1, 2, 3, 4, 5, 6
   // 32, 16, 8, 4, 2, 1
   for (level=1; level <= levels; level++) begin
      for (i=0; i < WIDTH/(2**level); i++) begin

         if (level == 1) begin
	    if (i != (WIDTH/(2**level)-1))
              magcompare2b cmp1(.LT(s[level-1][i]),
				.GT(t[level-1][i]),
				.A(A[2*i+1:2*i]),
				.B(B[2*i+1:2*i]));
	    else begin
               magcompare2b cmp_A(.LT(ls[level-1]),
				  .GT(lt[level-1]),
				  .A(A2),
				  .B(B2));
	       magcompare2b cmp_B(.LT(s[level-1][i]),
				  .GT(t[level-1][i]),
				  .A(A[2*i+1:2*i]),
				  .B(B[2*i+1:2*i]));	       
	    end
	    
         end else begin	    
	    if (i != (WIDTH/(2**level)-1))	    
              magcompare2c cmp2(.LT(s[level-1][i]),
				.GT(t[level-1][i]),
				.A(t[level-2][2*i+1:2*i]),
				.B(s[level-2][2*i+1:2*i]));
	    else begin
               magcompare2c cmp_C(.LT(ls[level-1]),
				  .GT(lt[level-1]),
				  .A({lt[level-2], t[level-2][2*i]}),
				  .B({ls[level-2], s[level-2][2*i]}));
	       magcompare2c cmp_D(.LT(s[level-1][i]),
				  .GT(t[level-1][i]),
				  .A(t[level-2][2*i+1:2*i]),
				  .B(s[level-2][2*i+1:2*i]));
            end
	 end 
      end // for (i=0; i < W2/(2**level); i++)
   end // for (level=1; level <= levels; level++)


   assign LT = ls[levels-1];
   assign GT = lt[levels-1];
   assign LTu = s[levels-1][0];
   assign GTu = t[levels-1][0];

  assign EQ = ~(LT | GT);

endmodule // comp64

