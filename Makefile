

#
ASM := yasm
ASM_FLAGS := -gdwarf2 -f elf64

CC := gcc
CC_FLAGS:= -Wall -m64 -gdwarf-2 -c

CPP := g++
CPP_FLAGS := -Wall -std=c++17 -m64 -gdwarf-2 -c

LINKER := gcc
LINKER_FLAGS := -m64 -gdwarf-2 -no-pie

#
BIN_NAME := my-program
BIN := ./$(BIN_NAME)


#
default:	run


#
run:	build
	@echo
	@echo "Running: $(BIN)"
	$(BIN)


#
debug:	build
	@echo
	@echo "Debugging: $(BIN)"
	gdb $(BIN) -x gdb-commands.txt


#
build:	$(BIN)
	@echo "Done building"


#
$(BIN):	main.o display_array.o manager.o reverse.o
	@echo
	@echo "Linking: $@"
	$(LINKER) $(LINKER_FLAGS) *.o *.so -o $@
	@echo "Done linking"


#
main.o:	main.c
	@echo
	@echo "Building: $@"
	$(CC) $(CC_FLAGS) main.c -o $@


#
manager.o: manager.asm
	@echo
	@echo "Building: $@"
	$(ASM) $(ASM_FLAGS) manager.asm -o $@


#
display_array.o: display_array.asm
	@echo
	@echo "Building: $@"
	$(ASM) $(ASM_FLAGS) display_array.asm -o $@


#
reverse.o:	reverse.cpp
	@echo
	@echo "Building: $@"
	$(CPP) $(CPP_FLAGS) reverse.cpp -o $@


#
clean:
	-rm *.o
	-rm $(BIN)



