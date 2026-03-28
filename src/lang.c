/**
 * @package showcase-asciidoxy
 *
 * @file lang.c
 * @namespace showcase_asciidoxy
 * @copyright 2024-present Christoph Kappel <christoph@unexist.dev>
 * @version $Id$
 *
 * This program can be distributed under the terms of the Apache License.
 * See the file LICENSE for details.
 **/

#include <strings.h>

#define LENGTH(a) (sizeof(a) / sizeof(a[0])) ///< Array length

/**
 * @struct language_t
 * @brief Storage class for languages
 **/

struct language_t {
    char *name; ///< Language name
    char *world; ///< Language translation of the word 'world'
};

/**
 * @typedef Language
 * @brief Convenience type definition for languages
 **/

typedef struct language_t Language;

static Language languages[] = {
    { .name = "EN", .world = "World" },
    { .name = "DE", .world = "Welt" },
    { .name = "NL", .world = "Wereld" }
};

/**
 * @details
 * We iterate through the @ref language_t instance to find the given language
 * and return the default language if nothing could be found.
 **/

char *get_lang(const char *name) {
    char *retval = languages[0].world;

    if (name) {
        for (int i = 0; i < LENGTH(languages); i++) {
            if (!strncasecmp(languages[i].name, name, 2)) {
                retval = languages[i].world;

                break;
            }
        }
    }

    return retval;
}
