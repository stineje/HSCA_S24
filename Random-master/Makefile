CC      = gcc
CFLAGS  = 
SRCS    = $(wildcard *.c)
PROGS 	= $(patsubst %.c,%,$(SRCS))

all:		$(PROGS)

%:		%.c
		$(CC) $(CFLAGS) -o $@ $< -lm

clean:
		rm -f random
		rm -f random_int
		rm -f random_int16
		rm -f random_int32
		rm -f random_int64
		rm -f random_uint32
		rm -f random_uint64
		rm -f *~

