.PHONY: all clean debug

ASFLAGS = 
LDFLAGS = --static

all: exit

debug: ASFLAGS += --gdwarf-2
debug: task

exit:
	as $(ASFLAGS) -o exit.o -c exit.s
	ld $(LDFLAGS) -o exit exit.o

task:
	as $(ASFLAGS) -o task.o -c task.s
	ld $(LDFLAGS) -o task task.o

clean:
	rm -f exit exit.o
	rm -f task task.o
