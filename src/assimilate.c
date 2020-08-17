int assimilateMain(int argc, char *argv[])
{
	if (argc < 3) {
		printf("Supply arguments for the assimilate command.\n");
		exit(1);
	}

	char * name = argv[2];

	printf("I am going to assimilate %s.\n", name);

	return 0;
}
