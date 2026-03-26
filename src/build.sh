#/bin/zsh

CC=clang        ##< Selected compiler
BIN_NAME=hello  ##< Name of the created binary

## @fn wildcard()
## @brief Get all files by wildcard mask
## @param  $1  Pattern to use (e.g. "*.c")
wildcard() {
    find -iname "$1"
}

## @fn compile()
## @brief Compile program
compile() {
    $CC -Wall $(wildcard "*.c") -o $BIN_NAME
}

compile
