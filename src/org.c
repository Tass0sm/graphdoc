#include "org.h"

#define MAX_NAME_LENGTH 80

org_entry getTopLevelEntry(char * name, FILE * pFile) {

	char line[MAX_NAME_LENGTH];

	do {
		fgets(line, MAX_NAME_LENGTH, pFile);

		if (isTopLevelEntry(line) && strcmpToEnd(name, line, 2) == 0) {
			printf("%s", line);
			printTopLevelEntryContents(pFile);
		}

	} while (!feof(pFile));

	org_entry result;
	return result;
}

void printTopLevelEntryContents(FILE * pFile) {

	char line[MAX_NAME_LENGTH] = "";

	do {
		printf("%s", line);
		fgets(line, MAX_NAME_LENGTH, pFile);
	} while (!isTopLevelEntry(line) && !feof(pFile));
}

int isEntry(char * line) {
	return line[0] == '*';
}

int isTopLevelEntry(char * line) {
	return line[0] == '*' && line[1] == ' ';
}
