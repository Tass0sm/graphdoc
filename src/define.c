#include "org.c"

int defineMain(int argc, char *argv[]) {
	if (argc < 3) {
		printf("Supply arguments for the define command.\n");
		exit(1);
	}

	char * name = argv[2];

	extern char load_path[256];
	FILE * pFile = fopen(load_path, "r");
	int result = getTopLevelEntry(name, pFile);

	if (result == 1) {
		printf("Nothing found.\n");
	}

	fclose(pFile);

	return result;
}
