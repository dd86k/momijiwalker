module pathutils;

import std.algorithm.iteration : splitter;
import std.file : exists, isDir, getcwd;
import std.path : buildPath, dirName, dirSeparator, pathSeparator;
import std.process : environment;
import std.string : toStringz, fromStringz;

class PathCache
{
    this(string target)
    {
        // Start by adding search paths to imitate LoadLibrary behavior.
        // https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-search-order
        
        // NOTE: The order added to cache is important!
        // NOTE: Currently only supports classic (unpackaged) Windows applications.
        // NOTE: Unsafe search paths not supported.
        
        // TODO: Standard search order for packaged Windows apps (UWP)
        //       1. DLL redirection.
        //       2. API sets.
        //       3. Desktop apps only (not UWP apps). SxS manifest redirection.
        //       4. Loaded-module list.
        //       5. Known DLLs.
        //       6. The package dependency graph of the process. This is the application's package plus any dependencies specified as <PackageDependency> in the <Dependencies> section of the application's package manifest. Dependencies are searched in the order they appear in the manifest.
        //       7. The folder the calling process was loaded from (the executable's folder).
        //       8. The system folder (%SystemRoot%\system32).
        
        // Unpackaged Windows (classic Win32) application paths
        
        // TODO: 1. DLL Redirection.
        //          https://learn.microsoft.com/en-us/windows/win32/dlls/dynamic-link-library-redirection
        
        // TODO: 2. API sets.
        
        // TODO: 3. SxS manifest redirection.
        
        // TODO: 4. Loaded-module list.
        
        // TODO: 5. Known DLLs.
        
        // TODO: 6. Windows 11, version 21H2 (10.0; Build 22000), and later.
        //          The package dependency graph of the process. This is the application's
        //          package plus any dependencies specified as <PackageDependency> in the
        //          <Dependencies> section of the application's package manifest. Dependencies
        //          are searched in the order they appear in the manifest.
        
        // 7. The folder from which the application loaded.
        paths ~= dirName(target);
        
        // TODO: 8. The system folder.
        //          Use the GetSystemDirectory function to retrieve the path of this folder.
        
        // TODO: 9. The 16-bit system folder.
        //          There's no function that obtains the path of this folder, but it is searched.
        
        // TODO: 10. The Windows folder.
        //           Use the GetWindowsDirectory function to get the path of this folder.
        
        // TODO: 11. The current folder.
        // TODO: Provide alternative base directory path in ctor.
        //PATH ~= getcwd();
        
        // 12. The directories that are listed in the PATH environment variable.
        //     This doesn't include the per-application path specified by the App
        //     Paths registry key. The App Paths key isn't used when computing the
        //     DLL search path.
        string PATH = environment["PATH"];
        foreach (path; splitter(PATH, pathSeparator))
        {
            paths ~= path;
        }
    }
    
    string get(string name)
    {
        if (const(string) *pp = name in cache)
        {
            return cast()*pp;
        }
        return findInPath(name);
    }
    
private:
    
    // walk all directories from PATH to find library path
    string findInPath(string basename)
    {
        foreach (string dir; paths)
        {
            string p = buildPath(dir, basename);
            if (exists(p))
            {
                cache[basename] = p;
                return p;
            }
        }
        return null;
    }
    
    // Known paths
    string[] paths;
    
    // Cache for `findInPath` results
    string[string] cache;
}
