module magcompare2c (LT, GT, A, B);
 
   input logic [1:0] A;
   input logic [1:0] B;
   
   output logic      LT;
   output logic      GT;
 
   assign LT = B[1] | (!A[1]&B[0]);
   assign GT = A[1] | (!B[1]&A[0]);
 
endmodule // magcompare2b
