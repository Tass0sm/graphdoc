#include <liboutline.h>

int defineMain(int argc, char *argv[]) {
	if (argc < 3) {
		printf("Supply arguments for the define command.\n");
		exit(1);
	}

	char * name = argv[2];

	extern char load_path[256];
	outline_file * pFile = outline_open_file(load_path, "r");
	int result = outline_seek_next_named_heading(pFile, name);

	if (result == 1) {
		printf("Nothing found.\n");
	} else {
		outline_print_to_next_leveled_heading(pFile, 1);
	}

	outline_free_file(pFile);

	return result;
}
