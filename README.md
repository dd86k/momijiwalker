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
```
>momijiwalker momijiwalker.exe
momijiwalker.exe
+- SHELL32.dll
+- ADVAPI32.dll
+- KERNEL32.dll
```

Check all dependencies of shell32.dll, in PATH:
```
>momijiwalker shell32.dll
shell32.dll
+- msvcp_win.dll
   +- api-ms-win-crt-string-l1-1-0.dll
   +- api-ms-win-crt-locale-l1-1-0.dll
   +- api-ms-win-crt-runtime-l1-1-0.dll
   +- api-ms-win-crt-private-l1-1-0.dll
   +- api-ms-win-core-synch-l1-1-0.dll
   +- api-ms-win-core-file-l1-1-0.dll
   +- api-ms-win-core-file-l1-2-0.dll
   +- api-ms-win-core-file-l2-1-0.dll
   +- api-ms-win-core-string-l1-1-0.dll
   +- api-ms-win-core-errorhandling-l1-1-0.dll
   +- api-ms-win-core-handle-l1-1-0.dll
   +- api-ms-win-core-util-l1-1-0.dll
   +- api-ms-win-core-heap-obsolete-l1-1-0.dll
   +- api-ms-win-core-localization-l1-2-0.dll
   +- api-ms-win-core-synch-l1-2-0.dll
   +- api-ms-win-core-rtlsupport-l1-1-0.dll
   +- api-ms-win-core-processthreads-l1-1-0.dll
   +- api-ms-win-core-sysinfo-l1-2-0.dll
   +- api-ms-win-core-processthreads-l1-1-1.dll
   +- api-ms-win-core-threadpool-l1-2-0.dll
   +- api-ms-win-core-libraryloader-l1-1-0.dll
   +- api-ms-win-core-profile-l1-1-0.dll
   +- api-ms-win-core-sysinfo-l1-1-0.dll
   +- api-ms-win-core-interlocked-l1-1-0.dll
   +- api-ms-win-core-debug-l1-1-0.dll
   +- api-ms-win-core-delayload-l1-1-0.dll
   +- api-ms-win-core-delayload-l1-1-1.dll
+- api-ms-win-crt-string-l1-1-0.dll
+- api-ms-win-crt-runtime-l1-1-0.dll
+- api-ms-win-crt-private-l1-1-0.dll
+- api-ms-win-core-heap-l2-1-0.dll (Not found)
+- api-ms-win-core-registry-l1-1-0.dll (Not found)
+- api-ms-win-core-libraryloader-l1-2-0.dll (Not found)
+- api-ms-win-core-sysinfo-l1-1-0.dll
+- api-ms-win-core-memory-l1-1-0.dll
+- api-ms-win-core-file-l1-1-0.dll
+- api-ms-win-core-handle-l1-1-0.dll
+- api-ms-win-core-libraryloader-l1-2-1.dll (Not found)
+- api-ms-win-core-string-l1-1-0.dll
+- api-ms-win-core-synch-l1-1-0.dll
+- api-ms-win-core-errorhandling-l1-1-0.dll
+- api-ms-win-core-processthreads-l1-1-0.dll
+- api-ms-win-core-string-l2-1-0.dll (Not found)
+- api-ms-win-core-file-l2-1-0.dll
+- api-ms-win-core-processenvironment-l1-1-0.dll
+- api-ms-win-security-base-l1-1-0.dll (Not found)
+- api-ms-win-core-synch-l1-2-0.dll
+- api-ms-win-core-heap-l1-1-0.dll
+- api-ms-win-core-util-l1-1-0.dll
+- api-ms-win-core-threadpool-l1-2-0.dll (Not found)
+- api-ms-win-core-localization-l1-2-0.dll
+- api-ms-win-core-debug-l1-1-0.dll
+- api-ms-win-core-timezone-l1-1-0.dll
+- api-ms-win-core-psapi-l1-1-0.dll (Not found)
+- api-ms-win-core-path-l1-1-0.dll (Not found)
+- api-ms-win-core-file-l1-2-0.dll
+- api-ms-win-core-io-l1-1-0.dll (Not found)
+- api-ms-win-core-datetime-l1-1-0.dll
+- api-ms-win-core-profile-l1-1-0.dll
+- api-ms-win-core-sysinfo-l1-2-0.dll (Not found)
+- api-ms-win-core-string-l2-1-1.dll (Not found)
+- api-ms-win-core-registry-l1-1-1.dll (Not found)
+- api-ms-win-core-file-l2-1-2.dll (Not found)
+- api-ms-win-core-file-l1-2-1.dll (Not found)
+- api-ms-win-core-file-l1-2-4.dll (Not found)
+- api-ms-win-core-wow64-l1-1-0.dll (Not found)
+- api-ms-win-core-wow64-l1-1-1.dll (Not found)
+- api-ms-win-core-localization-l1-2-2.dll (Not found)
+- api-ms-win-core-processthreads-l1-1-1.dll
+- api-ms-win-core-realtime-l1-1-0.dll (Not found)
+- api-ms-win-core-localization-l2-1-0.dll (Not found)
+- api-ms-win-core-io-l1-1-1.dll (Not found)
+- api-ms-win-core-version-l1-1-0.dll (Not found)
+- api-ms-win-core-sysinfo-l1-2-3.dll (Not found)
+- api-ms-win-core-memory-l1-1-1.dll (Not found)
+- api-ms-win-eventing-provider-l1-1-0.dll (Not found)
+- api-ms-win-eventing-classicprovider-l1-1-0.dll (Not found)
+- api-ms-win-core-delayload-l1-1-1.dll (Not found)
+- api-ms-win-core-delayload-l1-1-0.dll (Not found)
+- api-ms-win-core-interlocked-l1-1-0.dll
+- api-ms-win-core-rtlsupport-l1-1-0.dll
+- api-ms-win-core-shlwapi-obsolete-l1-1-0.dll (Not found)
+- api-ms-win-core-string-obsolete-l1-1-0.dll (Not found)
+- api-ms-win-core-stringansi-l1-1-0.dll (Not found)
+- api-ms-win-core-heap-obsolete-l1-1-0.dll (Not found)
+- api-ms-win-core-localization-obsolete-l1-2-0.dll (Not found)
+- api-ms-win-core-privateprofile-l1-1-0.dll (Not found)
+- api-ms-win-core-atoms-l1-1-0.dll (Not found)
+- api-ms-win-core-shlwapi-legacy-l1-1-0.dll (Not found)
+- api-ms-win-core-kernel32-legacy-l1-1-0.dll (Not found)
+- api-ms-win-core-kernel32-legacy-l1-1-1.dll (Not found)
+- api-ms-win-core-threadpool-legacy-l1-1-0.dll (Not found)
+- api-ms-win-core-kernel32-legacy-l1-1-2.dll (Not found)
+- api-ms-win-core-url-l1-1-0.dll (Not found)
+- api-ms-win-core-registryuserspecific-l1-1-0.dll (Not found)
+- api-ms-win-core-kernel32-private-l1-1-0.dll (Not found)
+- api-ms-win-core-apiquery-l1-1-0.dll (Not found)
+- api-ms-win-core-sidebyside-l1-1-0.dll (Not found)
+- api-ms-win-shell-shellcom-l1-1-0.dll (Not found)
+- KERNELBASE.dll
   +- ntdll.dll
   +- api-ms-win-eventing-provider-l1-1-0.dll
   +- api-ms-win-core-apiquery-l1-1-0.dll
+- USER32.dll
   +- win32u.dll
   +- ntdll.dll
   +- api-ms-win-core-localization-l1-2-0.dll
   +- api-ms-win-core-registry-l1-1-0.dll
   +- api-ms-win-core-heap-l2-1-0.dll
   +- api-ms-win-core-libraryloader-l1-2-0.dll
   +- api-ms-win-eventing-provider-l1-1-0.dll
   +- api-ms-win-core-processthreads-l1-1-0.dll
   +- api-ms-win-core-synch-l1-1-0.dll
   +- api-ms-win-core-string-l1-1-0.dll
   +- api-ms-win-core-sysinfo-l1-1-0.dll
   +- api-ms-win-security-base-l1-1-0.dll
   +- api-ms-win-core-handle-l1-1-0.dll
   +- api-ms-win-core-errorhandling-l1-1-0.dll
   +- api-ms-win-core-string-l2-1-0.dll
   +- api-ms-win-core-synch-l1-2-0.dll
   +- api-ms-win-core-processenvironment-l1-1-0.dll
   +- api-ms-win-core-file-l1-1-0.dll
   +- api-ms-win-core-processthreads-l1-1-1.dll
   +- api-ms-win-core-heap-l1-1-0.dll
   +- api-ms-win-core-debug-l1-1-0.dll
   +- api-ms-win-core-threadpool-l1-2-0.dll
   +- api-ms-win-core-memory-l1-1-0.dll
   +- api-ms-win-core-errorhandling-l1-1-2.dll
   +- api-ms-win-core-profile-l1-1-0.dll
   +- api-ms-win-core-memory-l1-1-3.dll
   +- api-ms-win-core-privateprofile-l1-1-0.dll
   +- api-ms-win-core-atoms-l1-1-0.dll
   +- api-ms-win-core-heap-obsolete-l1-1-0.dll
   +- api-ms-win-core-string-obsolete-l1-1-0.dll
   +- api-ms-win-core-localization-obsolete-l1-2-0.dll
   +- api-ms-win-core-stringansi-l1-1-0.dll
   +- api-ms-win-core-sidebyside-l1-1-0.dll
   +- api-ms-win-core-kernel32-private-l1-1-0.dll
   +- KERNELBASE.dll
   +- api-ms-win-core-kernel32-legacy-l1-1-0.dll
   +- api-ms-win-core-kernel32-legacy-l1-1-1.dll
   +- api-ms-win-core-appinit-l1-1-0.dll
   +- GDI32.dll
   +- api-ms-win-stateseparation-helpers-l1-1-0.dll
   +- api-ms-win-core-delayload-l1-1-1.dll
   +- api-ms-win-core-delayload-l1-1-0.dll
   +- api-ms-win-core-apiquery-l1-1-0.dll
+- ntdll.dll
+- GDI32.dll
   +- ntdll.dll
   +- api-ms-win-core-libraryloader-l1-2-0.dll
   +- api-ms-win-core-processthreads-l1-1-1.dll
   +- api-ms-win-core-processthreads-l1-1-0.dll
   +- api-ms-win-core-heap-l2-1-0.dll
   +- api-ms-win-core-synch-l1-2-0.dll
   +- api-ms-win-core-profile-l1-1-0.dll
   +- api-ms-win-core-sysinfo-l1-1-0.dll
   +- api-ms-win-core-errorhandling-l1-1-0.dll
   +- win32u.dll
   +- api-ms-win-gdi-internal-uap-l1-1-0.dll
   +- api-ms-win-core-delayload-l1-1-1.dll
   +- api-ms-win-core-delayload-l1-1-0.dll
   +- api-ms-win-core-apiquery-l1-1-0.dll
+- api-ms-win-stateseparation-helpers-l1-1-0.dll (Not found)
+- api-ms-win-core-job-l2-1-0.dll (Not found)
+- api-ms-win-crt-time-l1-1-0.dll
```

# Notes

## Sub-dependencies

The sub-dependencies depend on the host operating system. If a Windows executable
or library is opened on another platform, the list of subdenpendencies cannot
be retreieved, since the host is missing them. It's like searching for pears
when the host system only has oranges.

## Required Libraries Only

While a program or library can depend on dynamic libraries at startup,
dynamic libraries can still be loaded at any given time during runtime,
outside of the list of required libraries, which this utility relies
for its information.

So, results may be impartial for the moment being.