// This example is of a signed magnitude comparator
module mag_comp_sign (a, b, a_gtet_b);
input [7:0]a;
input [7:0]b;
output a_gtet_b;
reg a_gtet_b;
// make an intermediate variable used to do a subtraction
wire [8:0]intermediate;
assign intermediate = a - b;
always @(a or b or intermediate)
begin
  // if the subtraction is zero they are equal and we can assert
  //  the greater than equal to signal.
  if(intermediate == 9'd0)
    a_gtet_b = 1'b1; 
  // if the subtraction is not zero, we must find out which number is larger
  else  
    begin
      if(a[7] == 1'b1) // check the msb of 'A' to see if it is negative
        begin
          if(b [7]== 1'b0)  // if B is positive, B is larger
            a_gtet_b = 1'b0;
          else
            begin
              // if the sum of the number is negative, B is larger
              // if the sum is positive, A is larger
              // determine sign by checking sign bit, the MSB
              if(intermediate [8] == 1'b1) 
                a_gtet_b = 1'b0;
              else
                a_gtet_b = 1'b1;
            end
        end         
      else  // since the msb is not a '1', A is positive
        begin
          if(b [7] == 1'b1)  // if B is negative, A is larger
            a_gtet_b = 1'b1;
          else
            begin
              // if the sum is negative, B is larger, else A is larger
              if (intermediate [8] == 1'b1)
                a_gtet_b = 1'b0;
              else
                a_gtet_b = 1'b1;
            end
        end  
    end
end
  
endmodule
