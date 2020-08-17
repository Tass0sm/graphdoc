#include <yaml.h>

#define CONFIG_HOME_ENV "XDG_CONFIG_HOME"
#define PROG_NAME "borg"
#define CONFIG_NAME "borg.yaml"

char config_path[256];
char load_path[256];

void setConfigPath() {
	extern char config_path[256];

	char * config_home = getenv(CONFIG_HOME_ENV);

	if (config_home != NULL) {
		snprintf(config_path, sizeof(config_path), "%s/%s/%s",
		         config_home, PROG_NAME, CONFIG_NAME);
	} else {
		snprintf(config_path, sizeof(config_path), "%s/%s/%s/%s",
		         getenv("HOME"), ".config", PROG_NAME, CONFIG_NAME);
	}
}

int parseConfigFile() {
	extern char config_path[256];

	/* Create the Parser object. */
	yaml_parser_t parser;
	yaml_parser_initialize(&parser);

	/* Set a file input. */
	FILE * input = fopen(config_path, "rb");
	yaml_parser_set_input_file(&parser, input);

	/* Begin parsing events */
	int done = 0;
	yaml_event_t primaryEvent;
	yaml_event_t secondEvent;

	while (!done) {
		/* Get the next event. (A Label) */
		if (!yaml_parser_parse(&parser, &primaryEvent))
			goto error;

		if (primaryEvent.type == YAML_SCALAR_EVENT) {
			/* Get the next event. (The Value) */
			if (!yaml_parser_parse(&parser, &secondEvent))
				goto error;

			if (strcmp(primaryEvent.data.scalar.value, "borg-file") == 0) {
				extern char load_path[256];
				snprintf(load_path, 256, "%s", secondEvent.data.scalar.value);
			}
		} else if (primaryEvent.type == YAML_STREAM_END_EVENT) {
			done = 1;
		}

		yaml_event_delete(&primaryEvent);
		yaml_event_delete(&secondEvent);
	}

	/* Destroy the Parser object and Close File. */
	yaml_parser_delete(&parser);
	fclose(input);

	return 1;

 error:

	/* Destroy the Parser object and close file.. */
	yaml_parser_delete(&parser);
	fclose(input);

	return 1;
}


int configMain(int argc, char *argv[])
{
	if (argc < 3) {
		printf("Supply arguments for the config command.\n");
		exit(1);
	}

	return 0;
}
