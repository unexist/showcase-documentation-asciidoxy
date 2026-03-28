#!/bin/zsh

## @package showcase-asciidoxy
##
## @file build.sh
## @namespace showcase_asciidoxy
## @copyright 2026-present Christoph Kappel <christoph@unexist.dev>
## @version $Id$
##
## This program can be distributed under the terms of the Apache License.
## See the file LICENSE for details.

CC=clang        ##< Selected compiler
BIN_NAME=hello  ##< Name of the created binary

## @fn wildcard()
## @brief Get all files by wildcard mask
## @param[in]  arg1  Pattern to use (e.g. "*.c")
wildcard() {
    find -iname "$1"
}

## @fn compile()
## @brief Compile program
compile() {
    $CC -Wall $(wildcard "*.c") -o $BIN_NAME
}

compile
