module adder(cout, sum, a, b, cin);

	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;

	wire p14, g13, g6, p13, p8, g9, p6, p2, g4, p9, p10, p7, g7, g2, p12, p5, p0, p1, g0, p3, g5, g1, g_lsb, g3, p_lsb, p4, p11, g8, g14, g12, g11, g10;
	wire n48, n49, n50, n51, n52, n54, n55, n57, n58, n59, n60, n61, n62, n65, n66, n69, n70, n71, n72, n73, n74, n77, n78, n81, n82, n83, n84, n85, n86, n89, n90, n93, n94, n95, n96, n97, n98, n99, n100, n102, n103, n105, n106, n108, n109, n111, n112, n113, n114, n115, n116, n117, n118, n119, n120, n123, n124, n127, n128, n131, n132, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n150, n151, n153, n154, n156, n157, n159, n160, n162, n163, n165, n166, n168, n169, n171, n173, n175, n177, n179, n181, n183, n185, n187, n188, n189, n190, n191, n192, n193, n194;

// start of pre-processing logic

	ppa_first_pre ppa_first_pre_0_0 ( .cin( {cin} ), .pout( {p_lsb} ), .gout( {g_lsb} ) );
	ppa_pre ppa_pre_1_0 ( .a_in( {a[0]} ), .b_in( {b[0]} ), .pout( {p0} ), .gout( {g0} ) );
	ppa_pre ppa_pre_2_0 ( .a_in( {a[1]} ), .b_in( {b[1]} ), .pout( {p1} ), .gout( {g1} ) );
	ppa_pre ppa_pre_3_0 ( .a_in( {a[2]} ), .b_in( {b[2]} ), .pout( {p2} ), .gout( {g2} ) );
	ppa_pre ppa_pre_4_0 ( .a_in( {a[3]} ), .b_in( {b[3]} ), .pout( {p3} ), .gout( {g3} ) );
	ppa_pre ppa_pre_5_0 ( .a_in( {a[4]} ), .b_in( {b[4]} ), .pout( {p4} ), .gout( {g4} ) );
	ppa_pre ppa_pre_6_0 ( .a_in( {a[5]} ), .b_in( {b[5]} ), .pout( {p5} ), .gout( {g5} ) );
	ppa_pre ppa_pre_7_0 ( .a_in( {a[6]} ), .b_in( {b[6]} ), .pout( {p6} ), .gout( {g6} ) );
	ppa_pre ppa_pre_8_0 ( .a_in( {a[7]} ), .b_in( {b[7]} ), .pout( {p7} ), .gout( {g7} ) );
	ppa_pre ppa_pre_9_0 ( .a_in( {a[8]} ), .b_in( {b[8]} ), .pout( {p8} ), .gout( {g8} ) );
	ppa_pre ppa_pre_10_0 ( .a_in( {a[9]} ), .b_in( {b[9]} ), .pout( {p9} ), .gout( {g9} ) );
	ppa_pre ppa_pre_11_0 ( .a_in( {a[10]} ), .b_in( {b[10]} ), .pout( {p10} ), .gout( {g10} ) );
	ppa_pre ppa_pre_12_0 ( .a_in( {a[11]} ), .b_in( {b[11]} ), .pout( {p11} ), .gout( {g11} ) );
	ppa_pre ppa_pre_13_0 ( .a_in( {a[12]} ), .b_in( {b[12]} ), .pout( {p12} ), .gout( {g12} ) );
	ppa_pre ppa_pre_14_0 ( .a_in( {a[13]} ), .b_in( {b[13]} ), .pout( {p13} ), .gout( {g13} ) );
	ppa_pre ppa_pre_15_0 ( .a_in( {a[14]} ), .b_in( {b[14]} ), .pout( {p14} ), .gout( {g14} ) );

// start of post-processing logic

	ppa_post ppa_post_0_5 ( .gin( {n171} ), .pin( {p0} ), .sum( {sum[0]} ) );
	ppa_post ppa_post_1_5 ( .gin( {n173} ), .pin( {p1} ), .sum( {sum[1]} ) );
	ppa_post ppa_post_2_5 ( .gin( {n175} ), .pin( {p2} ), .sum( {sum[2]} ) );
	ppa_post ppa_post_3_5 ( .gin( {n177} ), .pin( {p3} ), .sum( {sum[3]} ) );
	ppa_post ppa_post_4_5 ( .gin( {n179} ), .pin( {p4} ), .sum( {sum[4]} ) );
	ppa_post ppa_post_5_5 ( .gin( {n181} ), .pin( {p5} ), .sum( {sum[5]} ) );
	ppa_post ppa_post_6_5 ( .gin( {n183} ), .pin( {p6} ), .sum( {sum[6]} ) );
	ppa_post ppa_post_7_5 ( .gin( {n185} ), .pin( {p7} ), .sum( {sum[7]} ) );
	ppa_post ppa_post_8_5 ( .gin( {n187} ), .pin( {p8} ), .sum( {sum[8]} ) );
	ppa_post ppa_post_9_5 ( .gin( {n188} ), .pin( {p9} ), .sum( {sum[9]} ) );
	ppa_post ppa_post_10_5 ( .gin( {n189} ), .pin( {p10} ), .sum( {sum[10]} ) );
	ppa_post ppa_post_11_5 ( .gin( {n190} ), .pin( {p11} ), .sum( {sum[11]} ) );
	ppa_post ppa_post_12_5 ( .gin( {n191} ), .pin( {p12} ), .sum( {sum[12]} ) );
	ppa_post ppa_post_13_5 ( .gin( {n192} ), .pin( {p13} ), .sum( {sum[13]} ) );
	ppa_post ppa_post_14_5 ( .gin( {n193} ), .pin( {p14} ), .sum( {sum[14]} ) );
	ppa_post ppa_post_15_5 ( .gin( {n194} ), .pin( {p15} ), .sum( {sum[15]} ) );

// start of custom pre/post logic

	ppa_pre ppa_pre_cout ( .a_in( a[15] ), .b_in( b[15] ), .pout ( p15 ), .gout ( g15 ) );
	ppa_grey ppa_grey_cout ( .gin ( {g15,n194} ), .pin ( p15 ), .gout ( cout ) );

// start of tree row 1

	assign n49 = p_lsb;
	assign n48 = g_lsb;
	ao21 U1(n50,g_lsb,p0,g0);
	assign n52 = p1;
	assign n51 = g1;
	and2 U1(n55,p2,p1);
	ao21 U2(n54,g1,p2,g2);
	assign n58 = p3;
	assign n57 = g3;
	and2 U1(n60,p4,p3);
	ao21 U2(n59,g3,p4,g4);
	assign n62 = p5;
	assign n61 = g5;
	and2 U1(n66,p6,p5);
	ao21 U2(n65,g5,p6,g6);
	assign n70 = p7;
	assign n69 = g7;
	and2 U1(n72,p8,p7);
	ao21 U2(n71,g7,p8,g8);
	assign n74 = p9;
	assign n73 = g9;
	and2 U1(n78,p10,p9);
	ao21 U2(n77,g9,p10,g10);
	assign n82 = p11;
	assign n81 = g11;
	and2 U1(n84,p12,p11);
	ao21 U2(n83,g11,p12,g12);
	assign n86 = p13;
	assign n85 = g13;
	and2 U1(n90,p14,p13);
	ao21 U2(n89,g13,p14,g14);

// start of tree row 2

	assign n94 = n49;
	assign n93 = n48;
	assign n96 = n0;
	assign n95 = n50;
	ao21 U1(n97,n50,n52,n51);
	ao21 U1(n98,n50,n55,n54);
	assign n100 = n58;
	assign n99 = n57;
	assign n103 = n60;
	assign n102 = n59;
	and2 U1(n106,n62,n60);
	ao21 U2(n105,n59,n62,n61);
	and2 U1(n109,n66,n60);
	ao21 U2(n108,n59,n66,n65);
	assign n112 = n70;
	assign n111 = n69;
	assign n114 = n72;
	assign n113 = n71;
	and2 U1(n116,n74,n72);
	ao21 U2(n115,n71,n74,n73);
	and2 U1(n118,n78,n72);
	ao21 U2(n117,n71,n78,n77);
	assign n120 = n82;
	assign n119 = n81;
	assign n124 = n84;
	assign n123 = n83;
	and2 U1(n128,n86,n84);
	ao21 U2(n127,n83,n86,n85);
	and2 U1(n132,n90,n84);
	ao21 U2(n131,n83,n90,n89);

// start of tree row 3

	assign n136 = n94;
	assign n135 = n93;
	assign n138 = n96;
	assign n137 = n95;
	assign n140 = n0;
	assign n139 = n97;
	assign n142 = n0;
	assign n141 = n98;
	ao21 U1(n143,n98,n100,n99);
	ao21 U1(n144,n98,n103,n102);
	ao21 U1(n145,n98,n106,n105);
	ao21 U1(n146,n98,n109,n108);
	assign n148 = n112;
	assign n147 = n111;
	assign n151 = n114;
	assign n150 = n113;
	assign n154 = n116;
	assign n153 = n115;
	assign n157 = n118;
	assign n156 = n117;
	and2 U1(n160,n120,n118);
	ao21 U2(n159,n117,n120,n119);
	and2 U1(n163,n124,n118);
	ao21 U2(n162,n117,n124,n123);
	and2 U1(n166,n128,n118);
	ao21 U2(n165,n117,n128,n127);
	and2 U1(n169,n132,n118);
	ao21 U2(n168,n117,n132,n131);

// start of tree row 4

	assign n172 = n136;
	assign n171 = n135;
	assign n174 = n138;
	assign n173 = n137;
	assign n176 = n140;
	assign n175 = n139;
	assign n178 = n142;
	assign n177 = n141;
	assign n180 = n0;
	assign n179 = n143;
	assign n182 = n0;
	assign n181 = n144;
	assign n184 = n0;
	assign n183 = n145;
	assign n186 = n0;
	assign n185 = n146;
	ao21 U1(n187,n146,n148,n147);
	ao21 U1(n188,n146,n151,n150);
	ao21 U1(n189,n146,n154,n153);
	ao21 U1(n190,n146,n157,n156);
	ao21 U1(n191,n146,n160,n159);
	ao21 U1(n192,n146,n163,n162);
	ao21 U1(n193,n146,n166,n165);
	ao21 U1(n194,n146,n169,n168);

endmodule

module ppa_first_pre(cin, pout, gout);

	input cin;
	output pout, gout;

	assign pout=1'b0;
	assign gout=cin;

endmodule

module ppa_grey(gin, pin, gout);

	input[1:0] gin;
	input pin;
	output gout;

	ao21 U1(gout,gin[0],pin,gin[1]);

endmodule

module ppa_post(pin, gin, sum);

	input pin, gin;
	output sum;

	xor2 U1(sum,pin,gin);

endmodule

module ppa_pre(a_in, b_in, pout, gout);

	input a_in, b_in;
	output pout, gout;

	xor2 U1(pout,a_in,b_in);
	and2 U2(gout,a_in,b_in);

endmodule
