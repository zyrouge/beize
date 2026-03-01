#ifndef BEIZE_CONSTANT

#include "types.h"

typedef double beize_constant;

typedef struct {
    int count;
    int capacity;
    beize_constant* constants;
} beize_constant_array;

void beize_constant_array_init(beize_constant_array* constant_array);

void beize_constant_array_free(beize_constant_array* constant_array);

void beize_constant_array_append(beize_constant_array* constant_array, uint8_t code, int line);

#endif
