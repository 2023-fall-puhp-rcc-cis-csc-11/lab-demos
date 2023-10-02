

# C++ compiler and flags
# This will compile C++ source code (e.g., hello.cpp)
CPP := g++
CPP_FLAGS := -Wall -m64 -gdwarf-2 -std=c++17 -c


# C compiler and flags
# This will compile C source code (e.g., hello.c)
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


# Output file name
OUTFILE := output.txt


###### Begin Recipe Section


# The default taregt is the first target that appears in the Makefile
menu:
	@echo
	@echo "*** Main Menu ***"
	@echo
	@echo "make menu      ==> This menu"
	@echo "make build     ==> Build the program"
	@echo "make run       ==> Run the program"
	@echo "make clean     ==> Clean the working area"
	@echo
.PHONY:	menu


# "Phony" target to run our program. "Phony" means the target
#	doesn't name an actual file/folder, but an action to take
#
# Notice we have a dependency here.
# The "build" target is a dependency of the "run" target.
# We denote this by adding the build target's name
#	to the right of the run target's colon
# This means that whenever we execute the "run" target,
#	the "build" target gets ran first.
# This makes sense because we would want to be sure
#	our executable is built before trying to launch
#	the program.
run:	build
	@echo "Running program!"
	$(BIN)
.PHONY: run


# Another "phony" target.
# Notice it depends on the executable $(BIN) being built
#	which will cause the target below to run.
# Notice also it doesn't actually do anything. This means
#	the "build" target is essentially an alias, or shortcut.
build:	$(BIN)
.PHONY: build


# A real (non-phony) target which names the executable
# Trace back up to the variables defined at the top of this file
#	and you'll see that $(BIN) just expands to ./main
# The job of this target is to build your entire program.
$(BIN):	driver.o console_demo.o
	$(LINKER) $(LINKER_FLAGS) *.so *.o -o "$@"


# Compile our driver module
driver.o:	driver.c
	$(CC) $(CC_FLAGS) "$<" -o "$@"


# Compile our console module
console_demo.o:	console_demo.asm
	$(ASM) $(ASM_FLAGS) "$<" -o "$@"


# Clean up our repo (having object files laying around is messsy)
# Cleaning is also sometimes a good idea if you suspect the Makefile isn't 100% correct
#	or compilers aren't refreshing the object files
# (don't remove the shared object file, as you get that elsewhere and aren't actually compiling it)
clean:
	-rm *.o
	-rm $(BIN)
	-rm $(OUTFILE)
.PHONY: clean








