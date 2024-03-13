ECEN 4233
Notes on Compiling
<PRE>
The proecedure for compiling is, as follows:

1.) gcc -c disp.c 

 This will create a disp.o intermediate file

2.) gcc -c gdiv.c

 Again, this will create an intermediate file, gdiv.o

3.) gcc -o gdiv gdiv.o disp.o -lm

 The -o indicates the output name.  On a PC, you should
 probably name it gdiv.exe
</PRE>

The same procedure is followed for gsqrt.c where gsqrt.c is
substituted for gdiv.c in steps 2 and 3.  Or, you can use the Makefile
given that easily compiles everything, provided you have Make
installed.

Warning:  this code is given to help you but it is no substitute for
your brain in checking things.  Never assume anything is right without
checking it.  
