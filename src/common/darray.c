#include "darray.h"

#include <stdlib.h>

void* darrary_grow_impl(void* pointer, size_t old_size, size_t new_size) {
    if (new_size == 0) {
        free(pointer);
        return NULL;
    }
    void* result = realloc(pointer, new_size);
    return result;
}
