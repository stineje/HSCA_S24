module rfa (g, p, Sum, A, B, Cin);

   input A;
   input B;
   input Cin;

   output g;
   output p;
   output Sum;

   assign Sum = A ^ B ^ Cin;
   assign g = A & B;
   assign p = A | B;
   
endmodule // rfa

module bclg4 (cout, gout, pout, g, p, cin);

   input [3:0]  g;
   input [3:0] 	p;
   input 	cin;
   
   output [3:0] cout;
   output 	gout;
   output 	pout;

   assign cout[1] = g[0] | p[0]&cin;
   assign cout[2] = g[1] | p[1]&g[0] | p[1]&p[0]&cin;
   assign cout[3] = g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&cin;
   assign gout = g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0];
   assign pout = p[3] & p[2] & p[1] & p[0];
   
endmodule // bclg4

// 64-bit Carry-Lookahead Adder with bclg4 (i.e., r=4)
module cla64 (Sum, A, B, cin);
   
   input [63:0]   A;
   input [63:0]   B;
   input 	  cin;   
   
   logic [63:0]   gtemp1;
   logic [63:0]   ptemp1;
   logic [63:0]   ctemp1;
   logic [63:0]   Bbar;      
   logic [3:0] 	  ctemp2;
   logic [3:0] 	  ctemp3;
   logic [3:0] 	  ctemp4;
   logic [3:0] 	  ctemp5;
   logic [3:0] 	  ctemp6;
   logic [3:0] 	  gouta;
   logic [3:0] 	  pouta;
   logic [3:0] 	  goutb;
   logic [3:0] 	  poutb;
   logic [3:0] 	  goutc;
   logic [3:0] 	  poutc;
   logic [3:0] 	  goutd;
   logic [3:0] 	  poutd;
   logic [3:0] 	  gout2;
   logic [3:0] 	  pout2;
   logic 	  gout3;
   logic 	  pout3;
   
   output [63:0]  Sum;

   rfa  r01(gtemp1[0], ptemp1[0], Sum[0], A[0], B[0], cin);
   rfa  r02(gtemp1[1], ptemp1[1], Sum[1], A[1], B[1], ctemp1[1]);
   rfa  r03(gtemp1[2], ptemp1[2], Sum[2], A[2], B[2], ctemp1[2]);
   rfa  r04(gtemp1[3], ptemp1[3], Sum[3], A[3], B[3], ctemp1[3]);
   bclg4 b1(ctemp1[3:0], gouta[0], pouta[0], gtemp1[3:0], ptemp1[3:0], cin);
   
   rfa  r05(gtemp1[4], ptemp1[4], Sum[4], A[4], B[4], ctemp2[1]);
   rfa  r06(gtemp1[5], ptemp1[5], Sum[5], A[5], B[5], ctemp1[5]);
   rfa  r07(gtemp1[6], ptemp1[6], Sum[6], A[6], B[6], ctemp1[6]);
   rfa  r08(gtemp1[7], ptemp1[7], Sum[7], A[7], B[7], ctemp1[7]);
   bclg4  b2(ctemp1[7:4], gouta[1], pouta[1], gtemp1[7:4], 
	     ptemp1[7:4], ctemp2[1]);
   
   rfa  r09(gtemp1[8], ptemp1[8], Sum[8], A[8], B[8], ctemp2[2]);
   rfa  r10(gtemp1[9], ptemp1[9], Sum[9], A[9], B[9], ctemp1[9]);
   rfa  r11(gtemp1[10], ptemp1[10], Sum[10], A[10], B[10], ctemp1[10]);
   rfa  r12(gtemp1[11], ptemp1[11], Sum[11], A[11], B[11], ctemp1[11]);
   bclg4  b3(ctemp1[11:8], gouta[2], pouta[2], gtemp1[11:8], 
	     ptemp1[11:8], ctemp2[2]);
   
   rfa  r13(gtemp1[12], ptemp1[12], Sum[12], A[12], B[12], ctemp2[3]);
   rfa  r14(gtemp1[13], ptemp1[13], Sum[13], A[13], B[13], ctemp1[13]);
   rfa  r15(gtemp1[14], ptemp1[14], Sum[14], A[14], B[14], ctemp1[14]);
   rfa  r16(gtemp1[15], ptemp1[15], Sum[15], A[15], B[15], ctemp1[15]);
   bclg4  b4(ctemp1[15:12], gouta[3], pouta[3], gtemp1[15:12], 
	     ptemp1[15:12], ctemp2[3]);
   bclg4  b5(ctemp2, gout2[0], pout2[0], gouta, pouta, cin);
   
   rfa  r17(gtemp1[16], ptemp1[16], Sum[16], A[16], B[16], ctemp6[1]);
   rfa  r18(gtemp1[17], ptemp1[17], Sum[17], A[17], B[17], ctemp1[17]);
   rfa  r19(gtemp1[18], ptemp1[18], Sum[18], A[18], B[18], ctemp1[18]);
   rfa  r20(gtemp1[19], ptemp1[19], Sum[19], A[19], B[19], ctemp1[19]);
   bclg4  b6(ctemp1[19:16], goutb[0], poutb[0], gtemp1[19:16], 
	     ptemp1[19:16], ctemp6[1]);
   
   rfa  r21(gtemp1[20], ptemp1[20], Sum[20], A[20], B[20], ctemp3[1]);
   rfa  r22(gtemp1[21], ptemp1[21], Sum[21], A[21], B[21], ctemp1[21]);
   rfa  r23(gtemp1[22], ptemp1[22], Sum[22], A[22], B[22], ctemp1[22]);
   rfa  r24(gtemp1[23], ptemp1[23], Sum[23], A[23], B[23], ctemp1[23]);
   bclg4  b7(ctemp1[23:20], goutb[1], poutb[1], gtemp1[23:20], 
	     ptemp1[23:20], ctemp3[1]);
   
   rfa  r25(gtemp1[24], ptemp1[24], Sum[24], A[24], B[24], ctemp3[2]);
   rfa  r26(gtemp1[25], ptemp1[25], Sum[25], A[25], B[25], ctemp1[25]);
   rfa  r27(gtemp1[26], ptemp1[26], Sum[26], A[26], B[26], ctemp1[26]);
   rfa  r28(gtemp1[27], ptemp1[27], Sum[27], A[27], B[27], ctemp1[27]);
   bclg4  b8(ctemp1[27:24], goutb[2], poutb[2], gtemp1[27:24], 
	     ptemp1[27:24], ctemp3[2]);
   
   rfa  r29(gtemp1[28], ptemp1[28], Sum[28], A[28], B[28], ctemp3[3]);
   rfa  r30(gtemp1[29], ptemp1[29], Sum[29], A[29], B[29], ctemp1[29]);
   rfa  r31(gtemp1[30], ptemp1[30], Sum[30], A[30], B[30], ctemp1[30]);
   rfa  r32(gtemp1[31], ptemp1[31], Sum[31], A[31], B[31], ctemp1[31]);
   bclg4  b9(ctemp1[31:28], goutb[3], poutb[3], gtemp1[31:28], 
	     ptemp1[31:28], ctemp3[3]);
   bclg4  b10(ctemp3, gout2[1], pout2[1], goutb, poutb, ctemp6[1]);
      
   //---------------------------------------------------------------------
   
   rfa  r33(gtemp1[32], ptemp1[32], Sum[32], A[32], B[32], ctemp6[2]);
   rfa  r34(gtemp1[33], ptemp1[33], Sum[33], A[33], B[33], ctemp1[33]);
   rfa  r35(gtemp1[34], ptemp1[34], Sum[34], A[34], B[34], ctemp1[34]);
   rfa  r36(gtemp1[35], ptemp1[35], Sum[35], A[35], B[35], ctemp1[35]);
   bclg4  b11(ctemp1[35:32], goutc[0], poutc[0], gtemp1[35:32], 
	      ptemp1[35:32], ctemp6[2]);
   
   rfa  r37(gtemp1[36], ptemp1[36], Sum[36], A[36], B[36], ctemp4[1]);
   rfa  r38(gtemp1[37], ptemp1[37], Sum[37], A[37], B[37], ctemp1[37]);
   rfa  r39(gtemp1[38], ptemp1[38], Sum[38], A[38], B[38], ctemp1[38]);
   rfa  r40(gtemp1[39], ptemp1[39], Sum[39], A[39], B[39], ctemp1[39]);
   bclg4  b12(ctemp1[39:36], goutc[1], poutc[1], gtemp1[39:36], 
	      ptemp1[39:36], ctemp4[1]);
   
   rfa  r41(gtemp1[40], ptemp1[40], Sum[40], A[40], B[40], ctemp4[2]);
   rfa  r42(gtemp1[41], ptemp1[41], Sum[41], A[41], B[41], ctemp1[41]);
   rfa  r43(gtemp1[42], ptemp1[42], Sum[42], A[42], B[42], ctemp1[42]);
   rfa  r44(gtemp1[43], ptemp1[43], Sum[43], A[43], B[43], ctemp1[43]);
   bclg4  b13(ctemp1[43:40], goutc[2], poutc[2], gtemp1[43:40], ptemp1[43:40], ctemp4[2]);
   
   rfa  r45(gtemp1[44], ptemp1[44], Sum[44], A[44], B[44], ctemp4[3]);
   rfa  r46(gtemp1[45], ptemp1[45], Sum[45], A[45], B[45], ctemp1[45]);
   rfa  r47(gtemp1[46], ptemp1[46], Sum[46], A[46], B[46], ctemp1[46]);
   rfa  r48(gtemp1[47], ptemp1[47], Sum[47], A[47], B[47], ctemp1[47]);
   bclg4  b14(ctemp1[47:44], goutc[3], poutc[3], gtemp1[47:44], 
	      ptemp1[47:44], ctemp4[3]);
   bclg4  b15(ctemp4, gout2[2], pout2[2], goutc, poutc, ctemp6[2]);
   
   rfa  r49(gtemp1[48], ptemp1[48], Sum[48], A[48], B[48], ctemp6[3]);
   rfa  r50(gtemp1[49], ptemp1[49], Sum[49], A[49], B[49], ctemp1[49]);
   rfa  r51(gtemp1[50], ptemp1[50], Sum[50], A[50], B[50], ctemp1[50]);
   rfa  r52(gtemp1[51], ptemp1[51], Sum[51], A[51], B[51], ctemp1[51]);
   bclg4  b16(ctemp1[51:48], goutd[0], poutd[0], gtemp1[51:48], 
	      ptemp1[51:48], ctemp6[3]);
   
   rfa  r53(gtemp1[52], ptemp1[52], Sum[52], A[52], B[52], ctemp5[1]);
   rfa  r54(gtemp1[53], ptemp1[53], Sum[53], A[53], B[53], ctemp1[53]);
   rfa  r55(gtemp1[54], ptemp1[54], Sum[54], A[54], B[54], ctemp1[54]);
   rfa  r56(gtemp1[55], ptemp1[55], Sum[55], A[55], B[55], ctemp1[55]);
   bclg4  b17(ctemp1[55:52], goutd[1], poutd[1], gtemp1[55:52], 
	      ptemp1[55:52], ctemp5[1]);
   
   rfa  r57(gtemp1[56], ptemp1[56], Sum[56], A[56], B[56], ctemp5[2]);
   rfa  r58(gtemp1[57], ptemp1[57], Sum[57], A[57], B[57], ctemp1[57]);
   rfa  r59(gtemp1[58], ptemp1[58], Sum[58], A[58], B[58], ctemp1[58]);
   rfa  r60(gtemp1[59], ptemp1[59], Sum[59], A[59], B[59], ctemp1[59]);
   bclg4  b18(ctemp1[59:56], goutd[2], poutd[2], gtemp1[59:56], 
	      ptemp1[59:56], ctemp5[2]);
   
   rfa  r61(gtemp1[60], ptemp1[60], Sum[60], A[60], B[60], ctemp5[3]);
   rfa  r62(gtemp1[61], ptemp1[61], Sum[61], A[61], B[61], ctemp1[61]);
   rfa  r63(gtemp1[62], ptemp1[62], Sum[62], A[62], B[62], ctemp1[62]);
   rfa  r64(gtemp1[63], ptemp1[63], Sum[63], A[63], B[63], ctemp1[63]);
   bclg4  b19(ctemp1[63:60], goutd[3], poutd[3], 
	      gtemp1[63:60], ptemp1[63:60], ctemp5[3]);
   bclg4  b20(ctemp5, gout2[3], pout2[3], goutd, poutd, ctemp6[3]);
   
   bclg4  b21(ctemp6, gout3, pout3, gout2, pout2, cin);
  
endmodule // cla64
