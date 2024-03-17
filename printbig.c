/*
 *  A function illustrating how to link C code to code generated from LLVM 
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <dirent.h>     // For directory manipulation

/*
 * Font information: one byte per row, 8 rows per character
 * In order, space, 0-9, A-Z
 */
static const char font[] = {
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  0x1c, 0x3e, 0x61, 0x41, 0x43, 0x3e, 0x1c, 0x00,
  0x00, 0x40, 0x42, 0x7f, 0x7f, 0x40, 0x40, 0x00,
  0x62, 0x73, 0x79, 0x59, 0x5d, 0x4f, 0x46, 0x00,
  0x20, 0x61, 0x49, 0x4d, 0x4f, 0x7b, 0x31, 0x00,
  0x18, 0x1c, 0x16, 0x13, 0x7f, 0x7f, 0x10, 0x00,
  0x27, 0x67, 0x45, 0x45, 0x45, 0x7d, 0x38, 0x00,
  0x3c, 0x7e, 0x4b, 0x49, 0x49, 0x79, 0x30, 0x00,
  0x03, 0x03, 0x71, 0x79, 0x0d, 0x07, 0x03, 0x00,
  0x36, 0x4f, 0x4d, 0x59, 0x59, 0x76, 0x30, 0x00,
  0x06, 0x4f, 0x49, 0x49, 0x69, 0x3f, 0x1e, 0x00,
  0x7c, 0x7e, 0x13, 0x11, 0x13, 0x7e, 0x7c, 0x00,
  0x7f, 0x7f, 0x49, 0x49, 0x49, 0x7f, 0x36, 0x00,
  0x1c, 0x3e, 0x63, 0x41, 0x41, 0x63, 0x22, 0x00,
  0x7f, 0x7f, 0x41, 0x41, 0x63, 0x3e, 0x1c, 0x00,
  0x00, 0x7f, 0x7f, 0x49, 0x49, 0x49, 0x41, 0x00,
  0x7f, 0x7f, 0x09, 0x09, 0x09, 0x09, 0x01, 0x00,
  0x1c, 0x3e, 0x63, 0x41, 0x49, 0x79, 0x79, 0x00,
  0x7f, 0x7f, 0x08, 0x08, 0x08, 0x7f, 0x7f, 0x00,
  0x00, 0x41, 0x41, 0x7f, 0x7f, 0x41, 0x41, 0x00,
  0x20, 0x60, 0x40, 0x40, 0x40, 0x7f, 0x3f, 0x00,
  0x7f, 0x7f, 0x18, 0x3c, 0x76, 0x63, 0x41, 0x00,
  0x00, 0x7f, 0x7f, 0x40, 0x40, 0x40, 0x40, 0x00,
  0x7f, 0x7f, 0x0e, 0x1c, 0x0e, 0x7f, 0x7f, 0x00,
  0x7f, 0x7f, 0x0e, 0x1c, 0x38, 0x7f, 0x7f, 0x00,
  0x3e, 0x7f, 0x41, 0x41, 0x41, 0x7f, 0x3e, 0x00,
  0x7f, 0x7f, 0x11, 0x11, 0x11, 0x1f, 0x0e, 0x00,
  0x3e, 0x7f, 0x41, 0x51, 0x71, 0x3f, 0x5e, 0x00,
  0x7f, 0x7f, 0x11, 0x31, 0x79, 0x6f, 0x4e, 0x00,
  0x26, 0x6f, 0x49, 0x49, 0x4b, 0x7a, 0x30, 0x00,
  0x00, 0x01, 0x01, 0x7f, 0x7f, 0x01, 0x01, 0x00,
  0x3f, 0x7f, 0x40, 0x40, 0x40, 0x7f, 0x3f, 0x00,
  0x0f, 0x1f, 0x38, 0x70, 0x38, 0x1f, 0x0f, 0x00,
  0x1f, 0x7f, 0x38, 0x1c, 0x38, 0x7f, 0x1f, 0x00,
  0x63, 0x77, 0x3e, 0x1c, 0x3e, 0x77, 0x63, 0x00,
  0x00, 0x03, 0x0f, 0x78, 0x78, 0x0f, 0x03, 0x00,
  0x61, 0x71, 0x79, 0x5d, 0x4f, 0x47, 0x43, 0x00
};

void printbig(int c)
{
  int index = 0;
  int col, data;
  if (c >= '0' && c <= '9') index = 8 + (c - '0') * 8;
  else if (c >= 'A' && c <= 'Z') index = 88 + (c - 'A') * 8;
  do {
    data = font[index++];
    for (col = 0 ; col < 8 ; data <<= 1, col++) {
      char d = data & 0x80 ? 'X' : ' ';
      putchar(d); putchar(d);
    }
    putchar('\n');
  } while (index & 0x7); 
}

char* concat(const char* s1, const char* s2) {
    size_t s1_len = strlen(s1);
    size_t s2_len = strlen(s2);
    char* result = malloc(s1_len + s2_len + 1); // +1 for the null terminator
    if (result == NULL) {
        perror("Failed to allocate memory for string concatenation");
        exit(1);
    }
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}

typedef struct {
    char** items;   // Array of pointers to strings
    int capacity;
    int total;
} Strings;

Strings* newStrings() {
    Strings* list = (Strings*)malloc(sizeof(Strings));
    if (!list) return NULL; // Check for malloc failure

    list->capacity = 4;  // Initial capacity
    list->total = 0;
    list->items = (char**)malloc(sizeof(char*) * list->capacity);
    if (!list->items) {  // Check for malloc failure
        free(list);
        return NULL;
    }
    return list;
}

static void resize(Strings* list, int capacity) {
  char** items = (char**)realloc(list->items, sizeof(char*) * capacity);
  if (items) {
      list->items = items;
      list->capacity = capacity;
  }
}

void append(Strings* list, char* item) {
    if (list->total == list->capacity) {
        resize(list, list->capacity * 2);
    }
    list->items[list->total++] = strdup(item); // Store a copy of the string
}

int size(const Strings* list) {
    if (list == NULL) {
        return -1;  // Return an error code if the list pointer is null.
    }
    return list->total;
}

void show(const Strings* list) {
    for (int i = 0; i < list->total; i++) {
        printf("%s\n", list->items[i]);
    }
}

void freeStrings(Strings* list) {
    for (int i = 0; i < list->total; ++i) {
        free(list->items[i]); // Free each string
    }
    free(list->items); // Free the array of pointers
    free(list); // Free the structure itself
}

char* expandPath(const char* path) {
    if (path[0] == '~') {
        const char* home = getenv("HOME");
        if (home != NULL) {
            // Allocate enough space for the full path: home directory + original path minus ~ + null terminator
            char* fullPath = (char*)malloc(strlen(home) + strlen(path));
            if (fullPath == NULL) {
                perror("Failed to allocate memory for path expansion");
                return NULL;
            }
            strcpy(fullPath, home);
            strcat(fullPath, path + 1); // Skip the tilde and concatenate
            return fullPath;
        }
    }
    // If path does not start with ~, or HOME is not set, return a copy of the original path
    return strdup(path);
}

Strings* query(const char* dirPath) {
    DIR* dir = opendir(dirPath);
    if (dir == NULL) {
        perror("Failed to open directory");
        return NULL;
    }

    struct dirent* entry;
    Strings* fileList = newStrings();
    if (fileList == NULL) {
        closedir(dir);
        fprintf(stderr, "Failed to create Strings list\n");
        return NULL;
    }

    while ((entry = readdir(dir)) != NULL) {
        // Skip "." and ".." entries
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }

        // Check if the entry is a regular file
        if (entry->d_type == DT_REG) {
            append(fileList, entry->d_name);
        }
    }

    closedir(dir);
    return fileList;
}



// #ifdef BUILD_TEST
// int main()
// {
//   char s[] = "HELLO WORLD09AZ";
//   char *c;
//   for ( c = s ; *c ; c++) printbig(*c);
// }
// #endif

// int main()
// {
//   const char* testDir = "/home/jayg/Documents/cs4115/grepql_compiler";

//   // Call the function with the test directory
//   Strings* files = query(testDir);
//   if (files == NULL) {
//       printf("Test failed: Could not list files in directory '%s'\n", testDir);
//       return;
//   }
//   show(files);
// }
