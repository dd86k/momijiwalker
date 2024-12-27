# MomijiWalker

MomijiWalker is a library dependency walker. It was inspired from
[Dependency Walker](https://www.dependencywalker.com/).

It is named after
[Momiji Inubashiri](https://en.touhouwiki.net/wiki/Momiji_Inubashiri)
from the Touhou Project series for her ability to see a thousand
[ri](https://en.wikipedia.org/wiki/Li_(unit)) ahead.

A dependency walker is a tool that traverses the list of used dynamic libraries
(DLL on Windows, DYLIB on macOS, and SO on other platforms) and show a list of
required symbols.

Features:
- List immediate and sub dependencies (with a set maximum sublevel).
- Support for PE32 executables (EXE) and dynamic libraries (DLL).
- Output results as JSON and as HTML.

TODO:
- List PE32 import symbols.
- List PE32 export symbols.
- Support packaged (UWP) Windows applications.
- Support for macOS and Mach-O binaries.
- Support for POSIX platforms and ELF binaries.
- String-read dependency list.
  - e.g., looking for `*.dll` in data sections or whole file (separate flags).

# Usage

Check dependencies of executable:
```text
>momijiwalker momijiwalker.exe
.\momijiwalker.exe
+- C:\WINDOWS\system32\SHELL32.dll
+- C:\WINDOWS\system32\ADVAPI32.dll
+- C:\WINDOWS\system32\KERNEL32.dll
```

Check sub-dependencies with a maximum sub-level of 1:
```text
>momijiwalker --max=1 momijiwalker.exe
.\momijiwalker.exe
+- C:\WINDOWS\system32\SHELL32.dll
   +- C:\WINDOWS\system32\msvcp_win.dll
   +- C:\Program Files\LLVM\bin\api-ms-win-crt-string-l1-1-0.dll
   +- C:\Program Files\LLVM\bin\api-ms-win-crt-runtime-l1-1-0.dll
   +- C:\Program Files\LLVM\bin\api-ms-win-crt-private-l1-1-0.dll
   +- Not found: api-ms-win-core-heap-l2-1-0.dll
   +- Not found: api-ms-win-core-registry-l1-1-0.dll
   +- Not found: api-ms-win-core-libraryloader-l1-2-0.dll
  [...]
```

As JSON output (prettified here for the sake of being an example):
```json
>momijiwalker --output-json example.dll
{
  "depends": [
    {
      "name": "SHELL32.dll",
      "path": "C:\\WINDOWS\\system32\\SHELL32.dll"
    },
    {
      "name": "SECRET.dll" // No path: Not found in PATH
    }
  ],
  "name": ".\\momijiwalker.exe"
}
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

## Import List Only

This program depends on the import directory for its dependency list, which
excludes dynamic libraries loaded later at run-time.

So, results may be impartial for the moment being. There is currently no support
for scanning for text strings.

For more information, visit:
https://learn.microsoft.com/en-us/cpp/build/linking-an-executable-to-a-dll