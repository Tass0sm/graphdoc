#include <stdio.h>
#include <string.h>

#include "util.c"

typedef struct {
	char name[80];
	char * docstring;
} org_entry;

int getTopLevelEntry(char *, FILE *);
void printTopLevelEntryContents(FILE *);
int isEntry(char *);
int isTopLevelEntry(char *);
