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

int contains(const Strings* list, const char* item) {
    for (int i = 0; i < list->total; i++) {
        if (strcmp(list->items[i], item) == 0) {
            return 1;  
        }
    }
    return 0;  
}

Strings* unionStrings(const Strings* list1, const Strings* list2) {
    Strings* result = newStrings();
    if (!result) return NULL;

    for (int i = 0; i < list1->total; i++) {
        append(result, list1->items[i]);
    }

    for (int i = 0; i < list2->total; i++) {
        if (!contains(result, list2->items[i])) {
            append(result, list2->items[i]);
        }
    }

    return result;
}

Strings* intersectStrings(const Strings* list1, const Strings* list2) {
    Strings* result = newStrings();
    if (!result) return NULL;
    for (int i = 0; i < list1->total; i++) {
        if (contains(list2, list1->items[i])) {
            append(result, list1->items[i]);
        }
    }
    return result;
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

Strings* searchFile(const char *pattern, const char *filename) {
    Strings* results = newStrings();
    FILE *fp;
    char line[1024];
    regex_t regex;
    int reti;

    reti = regcomp(&regex, pattern, REG_EXTENDED);
    if (reti) {
        fprintf(stderr, "Could not compile regex\n");
        freeStrings(results);
        return NULL;
    }

    fp = fopen(filename, "r");
    if (fp == NULL) {
        perror("Error opening file");
        freeStrings(results);
        return NULL;
    }

    while (fgets(line, sizeof(line), fp) != NULL) {
        line[strcspn(line, "\n")] = 0;
        reti = regexec(&regex, line, 0, NULL, 0);
        if (!reti) {
            append(results, line);
        }
    }

    fclose(fp);
    regfree(&regex);

    return results;
}

Strings* searchPath(const char *pattern, const char *path) {
    struct stat path_stat;
    stat(path, &path_stat);

    // Check if path is a directory
    if (S_ISDIR(path_stat.st_mode)) {
        Strings* directoryResults = newStrings();
        DIR *dir;
        struct dirent *entry;

        if ((dir = opendir(path)) == NULL) {
            perror("opendir() error");
            freeStrings(directoryResults);
            return NULL;
        }

        while ((entry = readdir(dir)) != NULL) {
            // Construct full path for each entry
            char fullPath[1024];
            snprintf(fullPath, sizeof(fullPath), "%s/%s", path, entry->d_name);
            
            // Use stat to determine if it's a regular file
            struct stat entry_stat;
            if (stat(fullPath, &entry_stat) == 0) {
                if (S_ISREG(entry_stat.st_mode)) {
                    Strings* fileResults = searchFile(pattern, fullPath);
                    for (int i = 0; i < fileResults->total; i++) {
                        append(directoryResults, fileResults->items[i]);
                    }
                    freeStrings(fileResults);
                }
            }
        }

        closedir(dir);

        return directoryResults;
    } else {
        // Path is a file
        return searchFile(pattern, path);
    }
}



#ifdef BUILD_TEST
int main(int argc, char **argv) {
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <regex> <path>\n", argv[0]);
        return 1;
    }

    Strings* results = searchPath(argv[1], argv[2]);
    if (results) {
        for (int i = 0; i < results->total; i++) {
            printf("%s\n", results->items[i]);
        }
        freeStrings(results);
    }

    return 0;
}
#endif


