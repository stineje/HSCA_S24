module adder(cout, sum, a, b, cin);

	input [15:0] a, b;
	input cin;
	output [15:0] sum;
	output cout;

	wire p14, g13, g6, p13, p8, g9, p6, p2, g4, p9, p10, p7, g7, g2, p12, p5, p0, p1, g0, p3, g5, g1, g_lsb, g3, p_lsb, p4, p11, g8, g14, g12, g11, g10;
	wire n62, n63, n64, n65, n66, n68, n69, n71, n72, n75, n76, n79, n80, n83, n84, n87, n88, n91, n92, n95, n96, n99, n100, n103, n104, n107, n108, n111, n112, n115, n116, n119, n120, n121, n122, n123, n124, n125, n126, n128, n129, n131, n132, n134, n135, n137, n138, n141, n142, n145, n146, n149, n150, n153, n154, n157, n158, n161, n162, n165, n166, n169, n170, n171, n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, n182, n184, n185, n187, n188, n190, n191, n193, n194, n196, n197, n199, n200, n202, n203, n205, n207, n209, n211, n213, n215, n217, n219, n221, n222, n223, n224, n225, n226, n227, n228;

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

	ppa_post ppa_post_0_5 ( .gin( {n205} ), .pin( {p0} ), .sum( {sum[0]} ) );
	ppa_post ppa_post_1_5 ( .gin( {n207} ), .pin( {p1} ), .sum( {sum[1]} ) );
	ppa_post ppa_post_2_5 ( .gin( {n209} ), .pin( {p2} ), .sum( {sum[2]} ) );
	ppa_post ppa_post_3_5 ( .gin( {n211} ), .pin( {p3} ), .sum( {sum[3]} ) );
	ppa_post ppa_post_4_5 ( .gin( {n213} ), .pin( {p4} ), .sum( {sum[4]} ) );
	ppa_post ppa_post_5_5 ( .gin( {n215} ), .pin( {p5} ), .sum( {sum[5]} ) );
	ppa_post ppa_post_6_5 ( .gin( {n217} ), .pin( {p6} ), .sum( {sum[6]} ) );
	ppa_post ppa_post_7_5 ( .gin( {n219} ), .pin( {p7} ), .sum( {sum[7]} ) );
	ppa_post ppa_post_8_5 ( .gin( {n221} ), .pin( {p8} ), .sum( {sum[8]} ) );
	ppa_post ppa_post_9_5 ( .gin( {n222} ), .pin( {p9} ), .sum( {sum[9]} ) );
	ppa_post ppa_post_10_5 ( .gin( {n223} ), .pin( {p10} ), .sum( {sum[10]} ) );
	ppa_post ppa_post_11_5 ( .gin( {n224} ), .pin( {p11} ), .sum( {sum[11]} ) );
	ppa_post ppa_post_12_5 ( .gin( {n225} ), .pin( {p12} ), .sum( {sum[12]} ) );
	ppa_post ppa_post_13_5 ( .gin( {n226} ), .pin( {p13} ), .sum( {sum[13]} ) );
	ppa_post ppa_post_14_5 ( .gin( {n227} ), .pin( {p14} ), .sum( {sum[14]} ) );
	ppa_post ppa_post_15_5 ( .gin( {n228} ), .pin( {p15} ), .sum( {sum[15]} ) );

// start of custom pre/post logic

	ppa_pre ppa_pre_cout ( .a_in( a[15] ), .b_in( b[15] ), .pout ( p15 ), .gout ( g15 ) );
	ppa_grey ppa_grey_cout ( .gin ( {g15,n228} ), .pin ( p15 ), .gout ( cout ) );

// start of tree row 1

	buffer U1(n63,p_lsb);
	buffer U2(n62,g_lsb);
	ao21 U1(n64,g_lsb,p0,g0);
	and2 U1(n66,p1,p0);
	ao21 U2(n65,g0,p1,g1);
	and2 U1(n69,p2,p1);
	ao21 U2(n68,g1,p2,g2);
	and2 U1(n72,p3,p2);
	ao21 U2(n71,g2,p3,g3);
	and2 U1(n76,p4,p3);
	ao21 U2(n75,g3,p4,g4);
	and2 U1(n80,p5,p4);
	ao21 U2(n79,g4,p5,g5);
	and2 U1(n84,p6,p5);
	ao21 U2(n83,g5,p6,g6);
	and2 U1(n88,p7,p6);
	ao21 U2(n87,g6,p7,g7);
	and2 U1(n92,p8,p7);
	ao21 U2(n91,g7,p8,g8);
	and2 U1(n96,p9,p8);
	ao21 U2(n95,g8,p9,g9);
	and2 U1(n100,p10,p9);
	ao21 U2(n99,g9,p10,g10);
	and2 U1(n104,p11,p10);
	ao21 U2(n103,g10,p11,g11);
	and2 U1(n108,p12,p11);
	ao21 U2(n107,g11,p12,g12);
	and2 U1(n112,p13,p12);
	ao21 U2(n111,g12,p13,g13);
	and2 U1(n116,p14,p13);
	ao21 U2(n115,g13,p14,g14);

// start of tree row 2

	buffer U1(n120,n63);
	buffer U2(n119,n62);
	buffer U1(n122,n0);
	buffer U2(n121,n64);
	ao21 U1(n123,n62,n66,n65);
	ao21 U1(n124,n64,n69,n68);
	and2 U1(n126,n72,n66);
	ao21 U2(n125,n65,n72,n71);
	and2 U1(n129,n76,n69);
	ao21 U2(n128,n68,n76,n75);
	and2 U1(n132,n80,n72);
	ao21 U2(n131,n71,n80,n79);
	and2 U1(n135,n84,n76);
	ao21 U2(n134,n75,n84,n83);
	and2 U1(n138,n88,n80);
	ao21 U2(n137,n79,n88,n87);
	and2 U1(n142,n92,n84);
	ao21 U2(n141,n83,n92,n91);
	and2 U1(n146,n96,n88);
	ao21 U2(n145,n87,n96,n95);
	and2 U1(n150,n100,n92);
	ao21 U2(n149,n91,n100,n99);
	and2 U1(n154,n104,n96);
	ao21 U2(n153,n95,n104,n103);
	and2 U1(n158,n108,n100);
	ao21 U2(n157,n99,n108,n107);
	and2 U1(n162,n112,n104);
	ao21 U2(n161,n103,n112,n111);
	and2 U1(n166,n116,n108);
	ao21 U2(n165,n107,n116,n115);

// start of tree row 3

	buffer U1(n170,n120);
	buffer U2(n169,n119);
	buffer U1(n172,n122);
	buffer U2(n171,n121);
	buffer U1(n174,n0);
	buffer U2(n173,n123);
	buffer U1(n176,n0);
	buffer U2(n175,n124);
	ao21 U1(n177,n119,n126,n125);
	ao21 U1(n178,n121,n129,n128);
	ao21 U1(n179,n123,n132,n131);
	ao21 U1(n180,n124,n135,n134);
	and2 U1(n182,n138,n126);
	ao21 U2(n181,n125,n138,n137);
	and2 U1(n185,n142,n129);
	ao21 U2(n184,n128,n142,n141);
	and2 U1(n188,n146,n132);
	ao21 U2(n187,n131,n146,n145);
	and2 U1(n191,n150,n135);
	ao21 U2(n190,n134,n150,n149);
	and2 U1(n194,n154,n138);
	ao21 U2(n193,n137,n154,n153);
	and2 U1(n197,n158,n142);
	ao21 U2(n196,n141,n158,n157);
	and2 U1(n200,n162,n146);
	ao21 U2(n199,n145,n162,n161);
	and2 U1(n203,n166,n150);
	ao21 U2(n202,n149,n166,n165);

// start of tree row 4

	assign n206 = n170;
	assign n205 = n169;
	assign n208 = n172;
	assign n207 = n171;
	assign n210 = n174;
	assign n209 = n173;
	assign n212 = n176;
	assign n211 = n175;
	assign n214 = n0;
	assign n213 = n177;
	assign n216 = n0;
	assign n215 = n178;
	assign n218 = n0;
	assign n217 = n179;
	assign n220 = n0;
	assign n219 = n180;
	ao21 U1(n221,n169,n182,n181);
	ao21 U1(n222,n171,n185,n184);
	ao21 U1(n223,n173,n188,n187);
	ao21 U1(n224,n175,n191,n190);
	ao21 U1(n225,n177,n194,n193);
	ao21 U1(n226,n178,n197,n196);
	ao21 U1(n227,n179,n200,n199);
	ao21 U1(n228,n180,n203,n202);

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
