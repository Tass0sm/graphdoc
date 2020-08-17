# Borg #

This program is a documentation manager. The name is a portmanteau of Book/Bib/Biblio and
Org and also a pun on the Borg from Star Trek.

## The Problem ##

Here's how to look up documentation normally:

1. Find the name of interest
2. Open a web browser
3. Search the internet for the name of interest.
Or
3. Locate the online documentation (Doxygen, Sphinx, etc.)
4. Search for the name of interest.

Using a self documenting system is much nicer. Here's Emacs with Emacs lisp:

1. Move cursor over whatever.
2. Enter help command.

        C-h f/v/o

## My Response ##

I would prefer if I could download documentation for any language or library and
store it in a human-readable, standard, simple format. Then I could use any
program to look up names of interest in that open format. Since existing
documentation sources have fine content, this program should also take
documentation in existing formats and convert it to the preferred
format. Another program might also integrate in extensible editors for smoother
use while programming.

## My Implementation ##

I chose to use org-mode for the open standard. Configuration is done with one
YAML file. Right now things are simple but the program just linearly searches
through one file specified in the configuration file for the specified name.

## Examples ##

Defining something:

    borg define some-function

Future utilities will include "assimilating" other documents and changing the
configuration file more easily.

## Goals ##

* TODO A Completely Decided Format
* TODO Ctags/Etags Integration
* TODO Doxygen Conversion (From URL and Files)
* TODO Sphinx Conversion (From URL and Files)

## Concerns ##

There may be something that already tries to manage documentation. I haven't
been able to find it, though.
