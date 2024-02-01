module graycounter (input logic clk, reset, up, load,
		    input logic [2:0]  in,
		    output logic [2:0] q);

   typedef enum logic [2:0] {S0=3'b000, S1=3'b001, 
			     S2=3'b011, S3=3'b010, 
			     S4=3'b110, S5=3'b111, 
			     S6=3'b101, S7=3'b100} statetype;
   statetype [2:0] state, nextstate;
   
   // State Register
   always_ff @ (posedge clk, posedge reset) 
     begin
	if (reset) state <= S0;
	else       state <= nextstate;
     end   

   // Next State Logic
   always_comb 
     begin
	case (state)
	  S0: if (up&~load) nextstate = S1;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S7;
	  S1: if (up&~load) nextstate = S2;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S0;
	  S2: if (up&~load) nextstate = S3;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S1;
	  S3: if (up&~load) nextstate = S4;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S2;
	  S4: if (up&~load) nextstate = S5;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S3;
	  S5: if (up&~load) nextstate = S6;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S4;
	  S6: if (up&~load) nextstate = S7;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S5;
	  S7: if (up&~load) nextstate = S0;
	      else if (load) nextstate = in;	  
	      else if (~up&~load) nextstate = S6;
	  default: nextstate = S0;
	endcase
     end // always_comb

   // Output Logic
   assign q = state;

endmodule 

