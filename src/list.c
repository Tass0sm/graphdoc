#include <liboutline.h>

int listMain(int argc, char *argv[]) {
	if (argc < 3) {
		printf("Supply arguments for the list command.\n");
		exit(1);
	}

	char * type = argv[2];

	extern char load_path[256];
	outline_file * pFile = outline_open_file(load_path, "r");

	int result = 0;
	if (strcmp(type, "all") == 0) {
		while (result == 0) {
			result = outline_seek_next_leveled_heading(pFile, 1);
		}
	} else {
		printf("Bad type: %s\n", type);
		result = 1;
	}

	outline_free_file(pFile);

	return result;
}
