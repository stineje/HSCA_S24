# 
# ECEN 4233
# Makefile
# 

CC     = gcc
CFLAGS = -lm
LIBS   = 
OBJS1  = disp.o gdiv.o 
OBJS2  = disp.o gsqrt.o

all:		gsqrt gdiv

gsqrt:		$(OBJS2)
		$(CC) -g -o gsqrt $(OBJS2) $(CFLAGS)

gdiv:		$(OBJS1)
		$(CC) -g -o gdiv $(OBJS1) $(CFLAGS)

disp.o:		disp.h disp.c
		$(CC) -g -c -o disp.o disp.c 

gdiv.o:		gdiv.c
		$(CC) -g -c -o gdiv.o gdiv.c 

gsqrt.o:	gsqrt.c
		$(CC) -g -c -o gsqrt.o gsqrt.c 

clean:
		rm -f *.o *~
		rm -f div gsqrt
		rm -f core
