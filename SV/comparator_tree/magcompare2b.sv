module magcompare2b (LT, GT, A, B);
 
   input logic [1:0] A;
   input logic [1:0] B;
   
   output logic     LT;
   output logic     GT;
 
   // Determine if A < B  using a minimized sum-of-products expression
   assign LT = ~A[1]&B[1] | ~A[1]&~A[0]&B[0] | ~A[0]&B[1]&B[0];
   // Determine if A > B  using a minimized sum-of-products expression
   assign GT = A[1]&~B[1] | A[1]&A[0]&~B[0] | A[0]&~B[1]&~B[0];
 
endmodule // magcompare2b
