#include <stdio.h>
#include <stdlib.h>

#include "define.c"
#include "config.c"
#include "assimilate.c"

int main(int argc, char *argv[])
{
	if (argc < 2) {
		printf("Supply arguments.\n");
		exit(1);
	}

	setConfigPath();
	parseConfigFile();

	char * command = argv[1];

	if (strcmp(command, "define") == 0) {
		defineMain(argc, argv);
	} else if (strcmp(command, "config") == 0) {
		configMain(argc, argv);
	} else if (strcmp(command, "assimilate") == 0) {
		assimilateMain(argc, argv);
	} else {
		printf("Bad subcommand: %s\n", command);
		exit(1);
	}

	return 0;
}
