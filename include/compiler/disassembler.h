#ifndef BEIZE_DISASSEMBLER

#include <stdio.h>

#include "chunk.h"

void beize_disassemble_chunk(FILE* stream, beize_chunk* chunk);

int beize_disassemble_instruction(FILE* stream, beize_chunk* chunk, int offset);

#endif
