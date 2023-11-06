


# C++ compiler and flags
CPP := g++
CPP_FLAGS := -Wall -m64 -gdwarf-2 -std=c++17 -c


# C compiler and flags
CC := gcc
CC_FLAGS := -Wall -m64 -gdwarf-2 -c


#	Assembler and flags
ASM := yasm
ASM_FLAGS := -f elf64 -gdwarf2


#	Linker and flags (we use g++ for hybrid programs)
#	Note that the flag "-z noexecstack" is new and now required in most cases.
LINKER := g++
LINKER_FLAGS := -Wall -m64 -gdwarf-2 -no-pie -z noexecstack


# Executable name
BIN_NAME := main
BIN := ./$(BIN_NAME)


run:	build
	@echo "Running program!"
	$(BIN)
.PHONY: run


build:	$(BIN)
.PHONY: build


$(BIN):	driver.o point.o
	$(LINKER) $(LINKER_FLAGS) *.o *.so -o "$@"


driver.o:	driver.cpp
	$(CPP) $(CPP_FLAGS) "$<" -o "$@"


point.o: point.asm
	$(ASM) $(ASM_FLAGS) "$<" -o "$@"


clean:
	-rm *.o
	-rm $(BIN)
.PHONY: clean








