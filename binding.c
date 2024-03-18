#define _XOPEN_SOURCE 700
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <dirent.h>     
#include <sys/stat.h>
#include <time.h>
#include <limits.h>
#include <regex.h>

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



typedef enum {
    NoCondition,
    SizeCondition,
    DateCondition
} ConditionType;

typedef enum {
    LessThan,
    GreaterThan,
    Equal
} OpType;

Strings* query(const char* dirPath, ConditionType condition, OpType opType, int sizeCondition, const char* dateCondition , const char* pattern) {
    DIR* dir = opendir(dirPath);
    if (dir == NULL) {
        perror("Failed to open directory");
        return NULL;
    }

    Strings* fileList = newStrings();
    if (fileList == NULL) {
        closedir(dir);
        fprintf(stderr, "Failed to create Strings list\n");
        return NULL;
    }

    regex_t regex;
    int regexCompiled = 0;
    if (pattern != NULL) {
        if (regcomp(&regex, pattern, REG_EXTENDED | REG_NOSUB) != 0) {
            fprintf(stderr, "Could not compile regex\n");
            closedir(dir);
            freeStrings(fileList); 
            return NULL;
        }
        regexCompiled = 1;
    }

    struct dirent* entry;
    struct stat fileInfo;
    time_t dateConditionTimestamp = 0;

    // If there's a date condition, convert dateCondition to a timestamp
    if (condition == DateCondition) {
        struct tm tm;
        memset(&tm, 0, sizeof(struct tm));
        strptime(dateCondition, "%Y-%m-%d", &tm);  // Date format is YYYY-MM-DD
        dateConditionTimestamp = mktime(&tm);
    }

    while ((entry = readdir(dir)) != NULL) {
        // Construct full path to item
        char fullPath[PATH_MAX];
        snprintf(fullPath, sizeof(fullPath), "%s/%s", dirPath, entry->d_name);

        // Skip "." and ".." entries
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) continue;

        // Get file info
        if (stat(fullPath, &fileInfo) != 0) continue;  // Skip if cannot access file info

        if (regexCompiled) {
            if (regexec(&regex, entry->d_name, 0, NULL, 0) == 0) {
                append(fileList, entry->d_name);
            }
            continue; // Skip other conditions if regex pattern is provided
        }

        // Initialize matchesCondition as false
        int matchesCondition = 0; 

        // Apply conditions based on the type and operation type
        if (condition == SizeCondition) {
            if ((opType == LessThan && fileInfo.st_size < sizeCondition) ||
                (opType == GreaterThan && fileInfo.st_size > sizeCondition) ||
                (opType == Equal && fileInfo.st_size == sizeCondition)) {
                matchesCondition = 1;
            }
        }
        else if (condition == DateCondition) {
            if ((opType == LessThan && difftime(fileInfo.st_mtime, dateConditionTimestamp) < 0) ||
                (opType == GreaterThan && difftime(fileInfo.st_mtime, dateConditionTimestamp) > 0) ||
                (opType == Equal && difftime(fileInfo.st_mtime, dateConditionTimestamp) == 0)) {
                matchesCondition = 1;
            }
        } else if (condition == NoCondition) {
            matchesCondition = 1;
        }

        // If entry matches the condition, append to list
        if (matchesCondition) append(fileList, entry->d_name);
    }

    if (regexCompiled) {
        regfree(&regex);
    }

    closedir(dir);
    return fileList;
}



#ifdef BUILD_TEST
int main()
{
  const char* testDir = "/home/jayg/Documents/cs4115/grepql_compiler";

  // Call the function with the test directory
  Strings* files = query(testDir,2,1,20000,"2024-03-18","^sast.*");
  if (files == NULL) {
      printf("Test failed: Could not list files in directory '%s'\n", testDir);
      return;
  }
  show(files);
}
#endif


