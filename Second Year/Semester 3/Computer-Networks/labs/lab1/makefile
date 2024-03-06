# Structure-related variables
BUILD_DIR ?= bin
SOURCE_DIR ?= src
SOURCES = $(wildcard $(SOURCE_DIR)/*.c)  # Change to .c for C source files
OBJECTS = $(patsubst $(SOURCE_DIR)/%.c, $(BUILD_DIR)/%.o, $(SOURCES))  # Change to .c for C source files

# Project-related variables
PROJECT = main  # Change to your project name

# Compiler-related variables
CC = gcc  # Change to the C compiler (e.g., gcc)
CFLAGS ?=
CFLAGS += -g -Wall -Werror

# Alias definitions
def: default
cdef: clean default
default: $(PROJECT)
clean:
	@rm -vrf $(BUILD_DIR)

# Custom compiling rules (define them below)

# Default compiling rules
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.c  # Change to .c for C source files
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Custom linking rules (define them below)

# Default linking rules
$(PROJECT) : $(OBJECTS)
	$(CC) $(CFLAGS) $^ -o $(BUILD_DIR)/$@
