C_FLAGS=-Wall -Wextra -pedantic -std=c99
SRC=$(wildcard status/*.c) $(wildcard buffer/*.c) $(wildcard keyboard/*.c) $(wildcard tab/*.c) marrow.c

marrow: $(SRC)
	$(CC) -o $@ $^ $(C_FLAGS)