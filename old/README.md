# Borg / Untitled Documentation Manager #

This program is a documentation manager. The name is undecided.

## Usage ##

Get documentation for some function:

    borg define some-function
    
List all documented entities:

    borg list all
    
## Reasoning ##

Looking up documentation online is not fun. Using a self documenting system is
much nicer. For example, Emacs with Emacs lisp uses this workflow:

1. Move cursor over whatever.
2. Enter help command.

        C-h f/v/o

Borg lets me use local files to quickly locate documentation for any language or
library. The files are also easily readable on their own. Other programs like
editors can interface with Borg to make the experience faster still.

See [borg-mode](https://github.com/Tass0sm/borg-mode.el ).

## My Implementation ##

Borg currently just uses the outline.el / org-mode format for documentation
files. Configuration is done with one YAML file.

## TODO ##

1. Doc Assimilation

In the future, I think [pandoc](https://pandoc.org ) will be used for converting
existing documents to the preferred format and extra functionality will be added
to help converting entire project documentation trees in one convenient
motion. This should preserve cross references and things.

2. Multiple documentation files.
3. More org-mode feature compatibility?
