# MomijiWalker

MomijiWalker is a library dependency walker. It was inspired from
[Dependency Walker](https://www.dependencywalker.com/).

It is named after Momiji Inubashiri from the Touhou Porject series for her
ability to see a thousand ri ahead.

A dependency walker is a tool that traverses the list of used dynamic libraries
(DLL on Windows, DYLIB on macOS, and SO on other platforms) and show a list of
required symbols.

Things it can do:
- List immediate and sub dependencies (of an additional level so far).
- Support for PE32 executables (EXE) and dynamic libraries (DLL).

TODO:
- List PE32 import symbols.
- List PE32 export symbols.
- Support for Mach-O.
- Support for ELF.
- JSON output.
- String-read dependency list (e.g., looking for `*.dll` in data sections).

# Usage

Check dependencies of executable:
```text
>momijiwalker momijiwalker.exe
momijiwalker.exe
+- SHELL32.dll
+- ADVAPI32.dll
+- KERNEL32.dll
```

Check sub-dependencies of what shell32.dll depends on:
```text
>momijiwalker --max=1 shell32.dll
shell32.dll
+- msvcp_win.dll
   +- api-ms-win-crt-string-l1-1-0.dll
   [...]
   +- api-ms-win-core-delayload-l1-1-1.dll
+- api-ms-win-crt-string-l1-1-0.dll
+- api-ms-win-crt-runtime-l1-1-0.dll
+- api-ms-win-crt-private-l1-1-0.dll
+- api-ms-win-core-heap-l2-1-0.dll (Not found)
+- api-ms-win-core-registry-l1-1-0.dll (Not found)
+- api-ms-win-core-libraryloader-l1-2-0.dll (Not found)
+- api-ms-win-core-sysinfo-l1-1-0.dll
+- api-ms-win-core-memory-l1-1-0.dll
[...]
```

# Notes

## Accuracy

At the moment, the only paths scanned are ones provided in PATH.

Only the first result is taken, depending on the order in PATH.

## Sub-dependencies

The sub-dependencies depend on the host operating system. If a Windows executable
or library is opened on another platform (e.g., Linux), the list of subdenpendencies
cannot be retreieved, because the host is missing them. It's like searching for pears
when the host system only has oranges.

## Required Libraries Only

While a program or library can depend on dynamic libraries at startup (explicit),
dynamic libraries can still be loaded at any given time at runtime (implicit),
outside of the list of required libraries found in the executable image,
which this utility relies for its information.

So, results may be impartial for the moment being. There is currently no support
for scanning for text strings.

For more information, visit:
https://learn.microsoft.com/en-us/cpp/build/linking-an-executable-to-a-dll