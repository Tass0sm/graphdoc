#ifndef ORG_H
#define ORG_H

#include "org.h"

#define MAX_NAME_LENGTH 80

int getAllTopLevelEntries(FILE * pFile) {

	char line[MAX_NAME_LENGTH];

	do {
		fgets(line, MAX_NAME_LENGTH, pFile);

		if (isTopLevelEntry(line)) {
			printf("%s", line);
		}
	} while (!feof(pFile));

	return 0;
}

int getTopLevelEntry(char * name, FILE * pFile) {

	char line[MAX_NAME_LENGTH];
	int result = 1;

	do {
		fgets(line, MAX_NAME_LENGTH, pFile);

		if (isTopLevelEntry(line) && strcmpToEnd(name, line, 2) == 0) {
			printf("%s", line);
			printTopLevelEntryContents(pFile);

			result = 0;
		}
	} while (!feof(pFile));

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


#endif /* ORG_H */
