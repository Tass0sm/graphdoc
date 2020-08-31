CC=gcc
CFLAGS=-lyaml -loutline

SRC=$(wildcard src/*.c)

borg: $(SRC)
	$(CC) $(CFLAGS) src/main.c -o borg

install: borg
	cp -f borg /usr/local/bin/

uninstall:
	rm /usr/local/bin/borg

clean: borg
	rm -f borg
