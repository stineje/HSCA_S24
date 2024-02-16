 
// This module compares two 64-bit values A and B. LT is '1' if A < B 
// and EQ is '1'if A = B. LT and GT are both '0' if A > B.
// This structure was modified so
// that it only does a strict magnitdude comparison, and only
// returns flags for less than (LT) and eqaual to (EQ). It uses a tree 
// of 63 2-bit magnitude comparators, followed by one OR gates.
//
 
module comparatortree128 (A, B, EQ, LT, LTu);
   
   input logic [127:0] A;
   input logic [127:0] B;
   
   output logic        EQ;
   output logic        LT;
   output logic        LTu;

   logic [63:0]        q;
   logic [63:0]        r;   
   logic [31:0]        s;
   logic [31:0]        t;
   logic [15:0]        u;
   logic [15:0]        v;
   logic [7:0] 	       w;
   logic [7:0] 	       x;
   logic [3:0] 	       y;
   logic [3:0] 	       z;
   logic [1:0] 	       a0;
   logic [1:0] 	       b0;
   logic [1:0] 	       a1;
   logic [1:0] 	       b1;
   
   logic 	       GT;
   logic 	       GTU;
   //logic 	          LT;
   //logic            LTu;
   //logic 	          EQ;
   logic [1:0] 	       A2;
   logic [1:0] 	       B2;

   logic 	       qA, qB;
   logic 	       rA, rB;   
   logic 	       sA, sB;
   logic 	       tA, tB;
   logic 	       uA, uB;
   logic 	       vA, vB;
   logic 	       wA, wB;
   logic 	       xA, xB;
   logic 	       yA, yB;
   logic 	       zA, zB;
   
   //assign A2 = Sel ? {~A[63], A[62]} : A[63:62];
   //assign B2 = Sel ? {~B[63], B[62]} : B[63:62];
   assign A2 = {~A[127], A[126]};
   assign B2 = {~B[127], B[126]};   

   // 6
   magcompare2b mag1(q[0], r[0], A[1:0], B[1:0]);
   magcompare2b mag2(q[1], r[1], A[3:2], B[3:2]);
   magcompare2b mag3(q[2], r[2], A[5:4], B[5:4]);
   magcompare2b mag4(q[3], r[3], A[7:6], B[7:6]);
   magcompare2b mag5(q[4], r[4], A[9:8], B[9:8]);
   magcompare2b mag6(q[5], r[5], A[11:10], B[11:10]);
   magcompare2b mag7(q[6], r[6], A[13:12], B[13:12]);
   magcompare2b mag8(q[7], r[7], A[15:14], B[15:14]);
   magcompare2b mag9(q[8], r[8], A[17:16], B[17:16]);
   magcompare2b magA(q[9], r[9], A[19:18], B[19:18]);
   magcompare2b magB(q[10], r[10], A[21:20], B[21:20]);
   magcompare2b magC(q[11], r[11], A[23:22], B[23:22]);
   magcompare2b magD(q[12], r[12], A[25:24], B[25:24]);
   magcompare2b magE(q[13], r[13], A[27:26], B[27:26]);
   magcompare2b magF(q[14], r[14], A[29:28], B[29:28]);
   magcompare2b mag10(q[15], r[15], A[31:30], B[31:30]);
   magcompare2b mag11(q[16], r[16], A[33:32], B[33:32]);
   magcompare2b mag12(q[17], r[17], A[35:34], B[35:34]);
   magcompare2b mag13(q[18], r[18], A[37:36], B[37:36]);
   magcompare2b mag14(q[19], r[19], A[39:38], B[39:38]);
   magcompare2b mag15(q[20], r[20], A[41:40], B[41:40]);
   magcompare2b mag16(q[21], r[21], A[43:42], B[43:42]);
   magcompare2b mag17(q[22], r[22], A[45:44], B[45:44]);
   magcompare2b mag18(q[23], r[23], A[47:46], B[47:46]);
   magcompare2b mag19(q[24], r[24], A[49:48], B[49:48]);
   magcompare2b mag1A(q[25], r[25], A[51:50], B[51:50]);
   magcompare2b mag1B(q[26], r[26], A[53:52], B[53:52]);
   magcompare2b mag1C(q[27], r[27], A[55:54], B[55:54]);
   magcompare2b mag1D(q[28], r[28], A[57:56], B[57:56]);
   magcompare2b mag1E(q[29], r[29], A[59:58], B[59:58]);
   magcompare2b mag1F(q[30], r[30], A[61:60], B[61:60]);
   magcompare2b mag1G(q[31], r[31], A[63:62], B[63:62]);
   magcompare2b mag1H(q[32], r[32], A[65:64], B[65:64]);
   magcompare2b mag1I(q[33], r[33], A[67:66], B[67:66]);
   magcompare2b mag1J(q[34], r[34], A[69:68], B[69:68]);
   magcompare2b mag1K(q[35], r[35], A[71:70], B[71:70]);
   magcompare2b mag1L(q[36], r[36], A[73:72], B[73:72]);
   magcompare2b mag1M(q[37], r[37], A[75:74], B[75:74]);
   magcompare2b mag1N(q[38], r[38], A[77:76], B[77:76]);
   magcompare2b mag1O(q[39], r[39], A[79:78], B[79:78]);
   magcompare2b mag1P(q[40], r[40], A[81:80], B[81:80]);
   magcompare2b mag1Q(q[41], r[41], A[83:82], B[83:82]);
   magcompare2b mag1R(q[42], r[42], A[85:84], B[85:84]);
   magcompare2b mag1S(q[43], r[43], A[87:86], B[87:86]);
   magcompare2b mag1T(q[44], r[44], A[89:88], B[89:88]);
   magcompare2b mag1U(q[45], r[45], A[91:90], B[91:90]);
   magcompare2b mag1V(q[46], r[46], A[93:92], B[93:92]);
   magcompare2b mag1W(q[47], r[47], A[95:94], B[95:94]);
   magcompare2b mag1X(q[48], r[48], A[97:96], B[97:96]);
   magcompare2b mag1Y(q[49], r[49], A[99:98], B[99:98]);
   magcompare2b mag1Z(q[50], r[50], A[101:100], B[101:100]);
   magcompare2b mag20(q[51], r[51], A[103:102], B[103:102]);
   magcompare2b mag21(q[52], r[52], A[105:104], B[105:104]);
   magcompare2b mag22(q[53], r[53], A[107:106], B[107:106]);
   magcompare2b mag23(q[54], r[54], A[109:108], B[109:108]);
   magcompare2b mag24(q[55], r[55], A[111:110], B[111:110]);
   magcompare2b mag25(q[56], r[56], A[113:112], B[113:112]);
   magcompare2b mag26(q[57], r[57], A[115:114], B[115:114]);
   magcompare2b mag27(q[58], r[58], A[117:116], B[117:116]);
   magcompare2b mag28(q[59], r[59], A[119:118], B[119:118]);
   magcompare2b mag29(q[60], r[60], A[121:120], B[121:120]);
   magcompare2b mag2A(q[61], r[61], A[123:122], B[123:122]);
   magcompare2b mag2B(q[62], r[62], A[125:124], B[125:124]);      
   
   magcompare2b mag2C(qA, rA, A2, B2);
   magcompare2b mag2D(q[63], r[63], A[127:126], B[127:126]);

   // 5
   magcompare2c magB021(s[0], t[0], r[1:0], q[1:0]);
   magcompare2c magB022(s[1], t[1], r[3:2], q[3:2]);
   magcompare2c magB023(s[2], t[2], r[5:4], q[5:4]);
   magcompare2c magB024(s[3], t[3], r[7:6], q[7:6]);
   magcompare2c magB025(s[4], t[4], r[9:8], q[9:8]);
   magcompare2c magB026(s[5], t[5], r[11:10], q[11:10]);
   magcompare2c magB027(s[6], t[6], r[13:12], q[13:12]);
   magcompare2c magB028(s[7], t[7], r[15:14], q[15:14]);
   magcompare2c magB029(s[8], t[8], r[17:16], q[17:16]);
   magcompare2c magB02A(s[9], t[9], r[19:18], q[19:18]);
   magcompare2c magB02B(s[10], t[10], r[21:20], q[21:20]);
   magcompare2c magB02C(s[11], t[11], r[23:22], q[23:22]);
   magcompare2c magB02D(s[12], t[12], r[25:24], q[25:24]);
   magcompare2c magB02E(s[13], t[13], r[27:26], q[27:26]);
   magcompare2c magB02F(s[14], t[14], r[29:28], q[29:28]);
   magcompare2c magB02G(s[15], t[15], r[31:30], q[31:30]);
   magcompare2c magB02H(s[16], t[16], r[33:32], q[33:32]);
   magcompare2c magB02I(s[17], t[17], r[35:34], q[35:34]);
   magcompare2c magB02J(s[18], t[18], r[37:36], q[37:36]);
   magcompare2c magB02L(s[19], t[19], r[39:38], q[39:38]);
   magcompare2c magB02M(s[20], t[20], r[41:40], q[41:40]);
   magcompare2c magB02N(s[21], t[21], r[43:42], q[43:42]);
   magcompare2c magB02O(s[22], t[22], r[45:44], q[45:44]);
   magcompare2c magB02P(s[23], t[23], r[47:46], q[47:46]);
   magcompare2c magB02Q(s[24], t[24], r[49:48], q[49:48]);
   magcompare2c magB02R(s[25], t[25], r[51:50], q[51:50]);
   magcompare2c magB02S(s[26], t[26], r[53:52], q[53:52]);
   magcompare2c magB02T(s[27], t[27], r[55:54], q[55:54]);
   magcompare2c magB02U(s[28], t[28], r[57:56], q[57:56]);
   magcompare2c magB02V(s[29], t[29], r[59:58], q[59:58]);
   magcompare2c magB02W(s[30], t[30], r[61:60], q[61:60]);   
   
   magcompare2c magB30a(sA, tA, {rA, r[62]}, {qA, q[62]});
   magcompare2c magB30(s[31], t[31], r[63:62], q[63:62]);		      

   // 4
   magcompare2c magC21(u[0], v[0], t[1:0], s[1:0]);
   magcompare2c magC22(u[1], v[1], t[3:2], s[3:2]);
   magcompare2c magC23(u[2], v[2], t[5:4], s[5:4]);
   magcompare2c magC24(u[3], v[3], t[7:6], s[7:6]);
   magcompare2c magC25(u[4], v[4], t[9:8], s[9:8]);
   magcompare2c magC26(u[5], v[5], t[11:10], s[11:10]);
   magcompare2c magC27(u[6], v[6], t[13:12], s[13:12]);
   magcompare2c magC28(u[7], v[7], t[15:14], s[15:14]);
   magcompare2c magC29(u[8], v[8], t[17:16], s[17:16]);
   magcompare2c magC2A(u[9], v[9], t[19:18], s[19:18]);
   magcompare2c magC2B(u[10], v[10], t[21:20], s[21:20]);
   magcompare2c magC2C(u[11], v[11], t[23:22], s[23:22]);
   magcompare2c magC2D(u[12], v[12], t[25:24], s[25:24]);
   magcompare2c magC2E(u[13], v[13], t[27:26], s[27:26]);
   magcompare2c magC2F(u[14], v[14], t[29:28], s[29:28]);
   
   magcompare2c magC30a(uA, vA, {tA, t[30]}, {sA, s[30]});
   magcompare2c magC30(u[15], v[15], t[31:30], s[31:30]);

   // 3
   magcompare2c magD31(w[0], x[0], v[1:0], u[1:0]);
   magcompare2c magD32(w[1], x[1], v[3:2], u[3:2]);
   magcompare2c magD33(w[2], x[2], v[5:4], u[5:4]);
   magcompare2c magD34(w[3], x[3], v[7:6], u[7:6]);
   magcompare2c magD35(w[4], x[4], v[9:8], u[9:8]);
   magcompare2c magD36(w[5], x[5], v[11:10], u[11:10]);
   magcompare2c magD37(w[6], x[6], v[13:12], u[13:12]);
   
   magcompare2c magD38a(wA, xA, {vA, v[14]}, {uA, u[14]});
   magcompare2c magD38(w[7], x[7], v[15:14], u[15:14]);

   // 2
   magcompare2c magE39(y[0], z[0], x[1:0], w[1:0]);
   magcompare2c magE3A(y[1], z[1], x[3:2], w[3:2]);
   magcompare2c magE3B(y[2], z[2], x[5:4], w[5:4]);

   magcompare2c magE3Ca(yA, zA, {xA, x[6]}, {wA, w[6]});
   magcompare2c magE3C(y[3], z[3], x[7:6], w[7:6]);

   // 1
   magcompare2c magF3D(a0[0], b0[0], z[1:0], y[1:0]);
   
   magcompare2c magF3Ea(a1[1], b1[1], {zA, z[2]}, {yA, y[2]});
   magcompare2c magF3E(a0[1], b0[1], z[3:2], y[3:2]);

   // 0
   magcompare2c magF3Fa(LT, GT, {b1[1], b0[0]}, {a1[1], a0[0]});
   magcompare2c magF3F(LTu, GTu, b0[1:0], a0[1:0]);

   assign EQ = ~(LT | GT);
 
endmodule // stinecomp128

