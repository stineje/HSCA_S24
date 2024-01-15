/*
   This is an adder-subtractor Verilog module.
   The module is a parallel loadable, synchronous
   set/reset, clock enabled adder-subtractor.
   this code implements a simple and compact 
   adder-subtractor.

   Input(s): a, b, subtract, cin, load_value, load, reset, set, enable, clk
   Output(s): sum
*/


// declare the module
module add_sub(sum,a, b, subtract, cin, load_value, load, reset, set, enable, clk);

// a and b are the input numbers to be added

input [7:0]a;
input [7:0]b;

// subtract signal determins if a and b are added or subtracted
input subtract;

// cin is the carry in used for the add
input cin;

// load_value is the value which is to be loaded on assertion of the
// load signal
input [8:0]load_value;
input load;

// reset resets the counter register value to all zeros
// set will set the counter to all ones
input reset;
input set;

// enable enables the registers on the counter output value
input enable;

// clk is the clock signal used to drive the counter registers
input clk;

// sum is the output value since it is clocked, define it as a reg 
output [8:0]sum;
reg [8:0]sum;

// specify the output to change on a rising edge of the clock.
// since everything is synchronous, we don't have to worry
// about the other signals in the list.
always @(posedge(clk)) 
begin

  // if the reset is asserted, set the counter value to zeros
  if (reset == 1'b1)
     sum = 9'b0;

  // if the set is asserted, set the counter value to ones
  // here use a hexadecimal defination for easy reading.
  else if (set == 1'b1)
     sum = 9'h1FF;

  // if the load signal is asserted, load what is on the load inputs
  else if (load == 1'b1)
     sum = load_value;

  // finally, if the adder/subtractor is enabled, do the operation,
  // which is dependant on the subtract input signal.
  
  else if (enable == 1'b1)
  begin
    if (subtract == 1'b1)
       sum = {1'b0,a} - {1'b0,b};
    else
       sum = {1'b0,a} + {1'b0,b} + cin;
  end

end

endmodule


