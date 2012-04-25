# README

This repository contains the source code for the Jump "cding" command line tool.

Jump helps you to navigate faster on your file system. It is designed to be simple and independent. In fact, Jump makes heavy use of basic UNIX/GNU tools in order to achieve its goals and thereby only needs a basic *NIX platform and a Bash.

Please refer also to the following projects:
- [Autojump](https://github.com/joelthelion/autojump/wiki)
- [Apparix](http://www.micans.org/apparix/)
- [Gnome Do](http://do.davebsd.com/)

## Usage

	j add d ~/Documents	# add ~/Documents with alias d
	j d					# jump to directory alias'd d
	j ls				# list aliases
	j rm d				# remove alias for d
	j add h				# add current dir with alias h
	j [TAB]				# show all alias as in 'j ls'
	j d[TAB]			# show all alias beginning with d,
	  					# or, if unique match, replace d with real path
	j /path/to/r[TAB]	# normal bash autocomplete

## Licence

GPLv3, see COPYING FILE

## Personal Notes
This is my first own "open source" project. I am not an bash expert, so comments, bug fixes, etc. are very welcome!

## TODO
- Make a zsh version ?

## Author(s)
Rolf Schröder
