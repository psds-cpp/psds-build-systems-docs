CC     = cc
CFLAGS = -Wall -O2

all: libcalc.a

libcalc.a: calc.o
	ar rcs $@ $^

calc.o: calc.c calc.h
	$(CC) $(CFLAGS) -c calc.c -o calc.o

clean:
	rm -f calc.o libcalc.a

.PHONY: all clean
