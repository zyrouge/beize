#include "constant.h"

#include "darray.h"

void beize_constant_array_init(beize_constant_array* constant_array) {
    constant_array->count = 0;
    constant_array->capacity = 0;
    constant_array->constants = NULL;
}

void beize_constant_array_free(beize_constant_array* constant_array) {
    DARRAY_FREE(uint8_t, constant_array->constants, constant_array->capacity);
    beize_constant_init(constant_array);
}

void beize_constant_array_append(beize_constant_array* constant_array, uint8_t code, int line) {
    if (constant_array->capacity < constant_array->count + 1) {
        int old_capacity = constant_array->capacity;
        constant_array->capacity = DARRAY_GROW_CAPACITY(old_capacity);
        beize_constant* new_constants = DARRAY_GROW(uint8_t, constant_array->constants, old_capacity, constant_array->capacity);
        if (!new_constants) {
            return -1;
        }
        constant_array->constants = new_constants;
    }
    constant_array->constants[constant_array->count] = code;
    constant_array->count++;
}
