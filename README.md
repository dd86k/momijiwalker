# MomijiWalker

MomijiWalker is a library dependency walker. It was inspired from
[Dependency Walker](https://www.dependencywalker.com/).

It is named after Momiji Inubashiri from the Touhou Porject series for her
ability to see a thousand ri ahead.

A dependency walker is a tool that traverses the list of used dynamic libraries
(DLL on Windows, DYLIB on macOS, and SO on other platforms) and show a list of
required symbols.

Things it can do:
- List immediate dependencies.

TODO:
- PE32 Symbols.
- Mach-O support and symbols.
- ELF support and symbols.
- Sub-dependencies.
- JSON output.
- String-read dependency list (e.g., looking for `*.dll` in file)

# Notes

## Sub-dependencies

The sub-dependencies depend on the host operating system. If a Windows executable
or library is opened on another platform, the list of subdenpendencies cannot
be retreieved, since the host is missing them. It's like searching for pears
when the host system only has oranges.

## Required Libraries Only

While a program or library can depend on dynamic libraries at startup,
dynamic libraries can still be loaded at any given time during runtime,
outside of the list of required libraries, which this utility uses.

So, results may be impartial for the moment being.