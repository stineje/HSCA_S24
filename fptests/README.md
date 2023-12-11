james.stine@okstate.edu 14 Jan 2022

These are the testvectors (TV) to test the floating-point units using
Berkeley TestFloat written originally by John Hauser.  TestFloat
requires both TestFloat and SoftFloat.

The locations at time of this README is found here:
TestFloat-3e:  http://www.jhauser.us/arithmetic/TestFloat.html
SoftFloat-3e:  http://www.jhauser.us/arithmetic/SoftFloat.html

These files have been compiled on a x86_64 environment by going into
the build/Linux-x86_64-GCC directory and typing make.  A script
createX.sh (e.g., create_vectors32.sh) has been included that create
the TV for each rounding mode  and operation.  These scripts must be
run in the build directory of TestFloat.

A set of scripts is also include that runs everything from the
baseline directory.  Please change the BUILD and OUTPUT variable to
change your baseline program where its compiled and where you want to
output the vectors.  By default, the vectors are output into the
vectors subdirectory.

After each TV has been created a script (included) is run called
undy.sh that puts an underscore between vector to allow SystemVerilog
readmemh to read correctly.

