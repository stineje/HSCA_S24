 
// This module compares two 64-bit values A and B. LT is '1' if A < B 
// and EQ is '1'if A = B. LT and GT are both '0' if A > B.
// This structure was modified so
// that it only does a strict magnitdude comparison, and only
// returns flags for less than (LT) and eqaual to (EQ). It uses a tree 
// of 63 2-bit magnitude comparators, followed by one OR gates.
//
 
module comparatortree32 (A, B, EQ, LT, LTu);
 
   input logic [31:0] A;
   input logic [31:0] B;

   output logic       EQ;
   output logic       LT;
   output logic       LTu;
 
   logic [31:0]       s;
   logic [31:0]       t;
   logic [15:0]       u;
   logic [15:0]       v;
   logic [7:0]        w;
   logic [7:0]        x;
   logic [3:0]        y;
   logic [3:0]        z;
   logic [1:0]        a0;
   logic [1:0]        b0;
   logic [1:0]        a1;
   logic [1:0]        b1;

   logic 	      GT;
   logic              GTU;
   //logic 	      LT;
   //logic            LTu;
   //logic 	      EQ;
   logic [1:0] 	      A2;
   logic [1:0]        B2;

   logic              sA, sB;
   logic              tA, tB;
   logic              uA, uB;
   logic              vA, vB;
   logic              wA, wB;
   logic              xA, xB;
   logic              yA, yB;
   logic              zA, zB;

   //assign A2 = Sel ? {~A[63], A[62]} : A[63:62];
   //assign B2 = Sel ? {~B[63], B[62]} : B[63:62];
   assign A2 = {~A[31], A[30]};
   assign B2 = {~B[31], B[30]};   
   
   //
   magcompare2b mag21(u[0], v[0], A[1:0], B[1:0]);
   magcompare2b mag22(u[1], v[1], A[3:2], B[3:2]);
   magcompare2b mag23(u[2], v[2], A[5:4], B[5:4]);
   magcompare2b mag24(u[3], v[3], A[7:6], B[7:6]);
   magcompare2b mag25(u[4], v[4], A[9:8], B[9:8]);
   magcompare2b mag26(u[5], v[5], A[11:10], B[11:10]);
   magcompare2b mag27(u[6], v[6], A[13:12], B[13:12]);
   magcompare2b mag28(u[7], v[7], A[15:14], B[15:14]);
   magcompare2b mag29(u[8], v[8], A[17:16], B[17:16]);
   magcompare2b mag2A(u[9], v[9], A[19:18], B[19:18]);
   magcompare2b mag2B(u[10], v[10], A[21:20], B[21:20]);
   magcompare2b mag2C(u[11], v[11], A[23:22], B[23:22]);
   magcompare2b mag2D(u[12], v[12], A[25:24], B[25:24]);
   magcompare2b mag2E(u[13], v[13], A[27:26], B[27:26]);
   magcompare2b mag2F(u[14], v[14], A[29:28], B[29:28]);
   
   magcompare2b mag30a(uA, vA, A2, B2);
   magcompare2b mag30(u[15], v[15], A[31:30], B[31:30]);

   //
   magcompare2c mag31(w[0], x[0], v[1:0], u[1:0]);
   magcompare2c mag32(w[1], x[1], v[3:2], u[3:2]);
   magcompare2c mag33(w[2], x[2], v[5:4], u[5:4]);
   magcompare2c mag34(w[3], x[3], v[7:6], u[7:6]);
   magcompare2c mag35(w[4], x[4], v[9:8], u[9:8]);
   magcompare2c mag36(w[5], x[5], v[11:10], u[11:10]);
   magcompare2c mag37(w[6], x[6], v[13:12], u[13:12]);
   
   magcompare2c mag38a(wA, xA, {vA, v[14]}, {uA, u[14]});
   magcompare2c mag38(w[7], x[7], v[15:14], u[15:14]);

   //
   magcompare2c mag39(y[0], z[0], x[1:0], w[1:0]);
   magcompare2c mag3A(y[1], z[1], x[3:2], w[3:2]);
   magcompare2c mag3B(y[2], z[2], x[5:4], w[5:4]);

   magcompare2c mag3Ca(yA, zA, {xA, x[6]}, {wA, w[6]});
   magcompare2c mag3C(y[3], z[3], x[7:6], w[7:6]);

   //
   magcompare2c mag3D(a0[0], b0[0], z[1:0], y[1:0]);
   magcompare2c mag3Ea(a1[1], b1[1], {zA, z[2]}, {yA, y[2]});
   magcompare2c mag3E(a0[1], b0[1], z[3:2], y[3:2]);

   magcompare2c mag3Fa(LT, GT, {b1[1], b0[0]}, {a1[1], a0[0]});
   magcompare2c mag3F(LTu, GTu, b0[1:0], a0[1:0]);

   assign EQ = ~(LT | GT);
 
endmodule // comp64
