module pgblock (input logic [14:0] a, b,
		output logic [14:0] p, g);

   assign p = a | b;
   assign g = a & b;

endmodule // pgblock

module pgblackblock (input logic [7:0] pik, gik, pkj, gkj,
		     output logic [7:0] pij, gij);

   assign pij = pik & pkj;
   assign gij = gik | (pik & gkj);

endmodule // pgblack

module sumblock (input logic [15:0] a, b, g,
		 output logic [15:0] sum);

   assign sum = a ^ b ^ g;

endmodule // sumblock
   
module prefixadd16 (input logic [15:0]  a, b,
		    input logic 	cin,
		    output logic [15:0] sum,
		    output logic 	cout);

   logic [14:0] 			g, p;
   logic [7:0] 				pij_0, gij_0, pij_1, gij_1;
   logic [7:0] 				pij_2, gij_2, pij_3, gij_3;
   logic [15:0] 			gen;

   pgblock pgblock_top(a[14:0], b[14:0], p, g);
   pgblackblock pgblackblock_0({p[14], p[12], p[10], p[8], 
				p[6], p[4], p[2], p[0]}, 
			       {g[14], g[12], g[10], g[8],
				g[6], g[4], g[2], g[0]},
			       {p[13], p[11], p[9], p[7], 
				p[5], p[3], p[1], 1'b0}, 
			       {g[13], g[11], g[9], g[7],
				g[5], g[3], g[1], cin},
			       pij_0, gij_0);
   pgblackblock pgblackblock_1({pij_0[7], p[13], pij_0[5],
				p[9], pij_0[3], p[5], 
				pij_0[1], p[1]},
			       {gij_0[7], g[13], gij_0[5],
				g[9], gij_0[3], g[5], 
				gij_0[1], g[1]},
			       {{2{pij_0[6]}}, {2{pij_0[4]}},
				{2{pij_0[2]}}, {2{pij_0[0]}}},
			       {{2{gij_0[6]}}, {2{gij_0[4]}},
				{2{gij_0[2]}}, {2{gij_0[0]}}},
			       pij_1, gij_1);
   pgblackblock pgblackblock_2({pij_1[7], pij_1[6], pij_0[6],
				p[11], pij_1[3], pij_1[2],
				pij_0[2], p[3]},
			       {gij_1[7], gij_1[6], gij_0[6],
				g[11], gij_1[3], gij_1[2],
				gij_0[2], g[3]},
			       {{4{pij_1[5]}}, {4{pij_1[1]}}},	
			       {{4{gij_1[5]}}, {4{gij_1[1]}}},
			       pij_2, gij_2);
   pgblackblock pgblackblock_3({pij_2[7], pij_2[6], pij_2[5],
				pij_2[4], pij_1[5], pij_1[4],
				pij_0[4], p[7]},
			       {gij_2[7], gij_2[6], gij_2[5],
				gij_2[4], gij_1[5], gij_1[4], 
				gij_0[4], g[7]},
			       {8{pij_2[3]}}, {8{gij_2[3]}},	
			       pij_3, gij_3);

   assign gen = {gij_3, gij_2[3:0], gij_1[1:0], gij_0[0], cin};
   assign cout = (a[15] & b[15]) | (gen[15] & (a[15] | b[15]));

   sumblock sum_out(a, b, gen, sum);

endmodule // prefixadd16

