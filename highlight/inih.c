// https://github.com/benhoyt/inih

#if defined(_MSC_VER) && !defined(_CRT_SECURE_NO_WARNINGS)
#define _CRT_SECURE_NO_WARNINGS
#endif

#include <ctype.h>
#include <stdio.h>
#include <string.h>

#if !INI_USE_STACK
#if INI_CUSTOM_ALLOCATOR
#include <stddef.h>
void *ini_malloc(size_t size);
void ini_free(void *ptr);
void *ini_realloc(void *ptr, size_t size);
#else
#include <stdlib.h>
#define ini_malloc malloc
#define ini_free free
#define ini_realloc realloc
#endif
#endif

/* Used by ini_parse_string() to keep track of string parsing state. */
typedef struct {
    const char *ptr;
    size_t num_left;
} ini_parse_string_ctx;

/* Strip whitespace chars off end of given string, in place. Retrun s. */
static char *rstrip(char *s) {
    char *p = s + strlen(s);
    while (p > s && isspace((unsigned char)(*--p)))
        *p = '\0';
    return s;
}

/* Return pointer to first non-whitespace char in given string.*/
static char *lskip(const char *s) {
    while (*s && isspace((unsigned char)(*s)))
        s++;
    return (char *)s;
}

/* Return pointer to first char (of chars) or inline comment in given string,
   or pointer to NUL at end of string if neither found. Inline comment must
   be prefixed by a whitespace character to register as a comment. */
static char *find_chars_or_comment(const char *s, const char *chars) {}