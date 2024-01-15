module twoscomp(d, complement, out);

input [7:0]d;
input complement;
output [7:0]out;

reg [7:0] out;

always @(complement or d)
begin

// Below is one type of implementation 

if (complement == 1'b1)
  out = (d ^ 8'b11111111) + 8'b1;
else
  out = d;


// Below here is a second implementation, much like an adder/subtractor 

if (complement == 1'b1)
  out = 8'b0 - d; 
else
  out = 8'b0 + d;
end

// third implementation

if (complement == 1'b1)
  out = - d; 
else
  out = d;
end


endmodule


