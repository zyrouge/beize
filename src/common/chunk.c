#include "chunk.h"

#include "darray.h"

void beize_chunk_init(beize_chunk* chunk) {
    chunk->count = 0;
    chunk->capacity = 0;
    chunk->codes = NULL;
    chunk->lines = NULL;
}

void beize_chunk_free(beize_chunk* chunk) {
    DARRAY_FREE(uint8_t, chunk->codes, chunk->capacity);
    DARRAY_FREE(int, chunk->lines, chunk->capacity);
    beize_chunk_init(chunk);
}

int beize_chunk_append(beize_chunk* chunk, uint8_t code, int line) {
    if (chunk->capacity < chunk->count + 1) {
        int old_capacity = chunk->capacity;
        chunk->capacity = DARRAY_GROW_CAPACITY(old_capacity);
        uint8_t* new_codes = DARRAY_GROW(uint8_t, chunk->codes, old_capacity, chunk->capacity);
        if (!new_codes) {
            return -1;
        }
        chunk->codes = new_codes;
        uint8_t* new_lines = DARRAY_GROW(int, chunk->lines, old_capacity, chunk->capacity);
        if (!new_lines) {
            return -1;
        }
        chunk->lines = new_lines;
    }
    chunk->codes[chunk->count] = code;
    chunk->lines[chunk->count] = line;
    chunk->count++;
    return 0;
}
