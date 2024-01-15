`define width 8
module Nx2mult (a, b, p);

input  [`width-1:0] a;
input  [1:0] b;
output [`width+1:0] p;

assign p=a*b;

endmodule


