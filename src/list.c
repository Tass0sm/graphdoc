#include "org.c"

int listMain(int argc, char *argv[]) {
	if (argc < 3) {
		printf("Supply arguments for the list command.\n");
		exit(1);
	}

	char * type = argv[2];

	extern char load_path[256];
	FILE * pFile = fopen(load_path, "r");

	int result = 0;
	if (strcmp(type, "all") == 0) {
		result = getAllTopLevelEntries(pFile);
	} else {
		printf("Bad type: %s\n", type);
		result = 1;
	}

	fclose(pFile);

	return result;
}
