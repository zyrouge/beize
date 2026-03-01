#ifndef BEIZE_DARRARY

#include "types.h"

#define DARRAY_GROW_CAPACITY(capacity) ((capacity) < 8 ? 8 : (capacity) * 2)

#define DARRAY_GROW(type, pointer, oldCount, newCount) \
    (type*)darrary_reallocate_impl(pointer, sizeof(type) * (oldCount), sizeof(type) * (newCount))

#define DARRAY_FREE(type, pointer, oldCount) \
    reallocate(pointer, sizeof(type) * (oldCount), 0)

void* darrary_grow_impl(void* pointer, size_t oldSize, size_t newSize);

#endif
