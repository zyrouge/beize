#include "disassembler.h"

#include <stdio.h>

#include "op_code.h"

void beize_disassemble_chunk(FILE* stream, beize_chunk* chunk) {
    for (int offset = 0; offset < chunk->count;) {
        offset += beize_disassemble_instruction(stream, chunk, offset);
    }
}

int beize_disassemble_instruction(FILE* stream, beize_chunk* chunk, int offset) {
    uint8_t op_code = chunk->codes[offset];
    uint8_t line = chunk->lines[offset];
    switch (op_code) {
        case BEIZE_OP_RETURN:
            beize_disassemble_instruction_write(stream, "OP_RETURN", offset, line);
            return 1;

        default:
            beize_disassemble_instruction_write(stream, "OP_?", offset, line);
            return 1;
    }
}

static void beize_disassemble_instruction_write(FILE* stream, const char* op_code_name, int offset, int line) {
    vfprintf(stream, "%s\t%d\t%d\n", op_code_name, offset, line);
}

static void beize_disassemble_instruction_write_extra(FILE* stream, const char* op_code_name, int offset, int line, const char* extra) {
    vfprintf(stream, "%s\t%d\t%d\t%s\n", op_code_name, offset, line, extra);
}
