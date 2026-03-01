#ifndef BEIZE_CHUNK

#include "types.h"

typedef struct {
    int count;
    int capacity;
    uint8_t* codes;
    int* lines;
} beize_chunk;

void beize_chunk_init(beize_chunk* chunk);

void beize_chunk_free(beize_chunk* chunk);

void beize_chunk_append(beize_chunk* chunk, uint8_t code, int line);

#endif
