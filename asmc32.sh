#!/usr/bin/env bash

compile() {
    local filename="$(basename "$1")"
    local basename="${filename%.*}"

    nasm -f elf32 -g -F dwarf -o "$basename.o" "$filename" && \
        ld -m elf_i386 -o "$basename" "$basename.o" && \
        rm "$basename.o"
}

compile "$@"
