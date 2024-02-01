module fsm (input logic clk, reset, a, b,
	    output logic q);

   typedef enum logic [1:0] {S0, S1, S2} statetype;
   statetype state, nextstate;
   
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
	  S0: if (a) nextstate = S1;
	  else nextstate = S0;
	  S1: if (b) nextstate = S2;
	  else nextstate = S0;
	  S2: if (a & b) nextstate = S2;
	  else nextstate = S0;
	  default: nextstate = S0;
	endcase
     end // always_comb

   // Output Logic
   always_comb
     case (state)
       S0:          q = 0;
       S1:          q = 0;
       S2: if (a&b) q = 1;
       else         q = 0;
       default:     q = 0;
     endcase // case (state)   

endmodule // FSM

