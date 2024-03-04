# Structure-related variables
BUILD_DIR ?= bin
SOURCE_DIR ?= src
SOURCES = $(shell find $(SOURCE_DIR) -type f -name '*.cpp')
OBJECTS = $(patsubst $(SOURCE_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SOURCES))

# Project-related variables
PROJECT = main

# Compiler-related variables
CXX = g++
CXXFLAGS ?=
CXXFLAGS += -g -Wall -Werror -fprofile-arcs -ftest-coverage -fPIC -O0

# Alias definitions
def: default
cdef: clean default
default: $(PROJECT)
clean:
	@rm -vrf $(BUILD_DIR)

# Custom compiling rules (define them below)

# Default compiling rules
$(BUILD_DIR)/%.o: $(SOURCE_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Custom linking rules (define them below)

# Default linking rules
$(PROJECT) : $(OBJECTS)
	$(CXX) $(CXXFLAGS) $^ -o $(BUILD_DIR)/$@
