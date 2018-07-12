#ifndef DRY_OPENBSD_STRING_H
#define DRY_OPENBSD_STRING_H

#include <stddef.h>

size_t strlcpy(char *, const char *, size_t);

size_t strlcat(char *, const char *, size_t);

#endif