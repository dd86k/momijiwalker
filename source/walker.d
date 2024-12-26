module walker;

import adbg.error;
import adbg.objectserver;
import adbg.objects.pe;
import std.algorithm.iteration : splitter;
import std.conv;
import std.file;
import std.path;
import std.process : environment;
import std.string : toStringz, fromStringz;

enum LibraryFlags
{
    notFound = 1,
}
struct Library
{
    string name;
    int flags;
    string[] symbols;
    string[] dependencies;
}

class AlicedbgException : Exception
{
    this()
    {
        super(text("Alicedbg: ", fromStringz(adbg_error_message())));
    }
}

class Walker
{
    this()
    {
        // Add CWD to PATH to imitate LoadLibrary behavior
        PATH ~= getcwd();
        
        // Add paths from PATH
        string paths = environment["PATH"];
        foreach (path; splitter(paths, pathSeparator))
        {
            PATH ~= path;
        }
    }
    
    // walk all directories from PATH to find library path
    string findInPath(string basename)
    {
        if (const(string) *pp = basename in pathCache)
        {
            return cast()*pp;
        }
        foreach (string dir; PATH)
        {
            string p = buildPath(dir, basename);
            if (exists(p))
            {
                pathCache[basename] = p;
                return p;
            }
        }
        return null;
    }
    
    // scan dependencies of this file or dynamic library
    // TODO: bool symbols = get exported symbols
    // TODO: int maxlevels = max number of passes to sublibraries
    Library scan(string path)
    {
        // First level is the requested exec/lib
        Library root = scanfile(path);
        
        return root;
    }
    
    string[] symbols(ref Library lib)
    {
        throw new Exception("Todo");
    }
    
    string[] dependsOn(string path)
    {
        // Find mentioned library
        if (exists(path) == false)
        {
            string newpath = findInPath(path);
            if (newpath is null)
            {
                throw new Exception(text("Not found: '", path, "'"));
            }
            path = newpath;
        }
        
        const(char) *pathz = toStringz(path);
        adbg_object_t *o = adbg_object_open_file(pathz, 0);
        if (o == null)
            throw new AlicedbgException();
        scope(exit) adbg_object_close(o);
        
        // Depending on the library format, get its imports
        // TODO: Add obj type enum function in alicedbg
        string[] libs;
        string type = cast(string)fromStringz( adbg_object_type_shortname(o) );
        switch (type) {
        case "pe32":
            pe_import_descriptor_t *im = void;
            size_t i;
            while ((im = adbg_object_pe_import(o, i++)) != null)
            {
                string modname = cast(string)fromStringz( adbg_object_pe_import_module_name(o, im) );
                libs ~= modname.idup; // dup due to stringz
            }
            break;
        default:
            throw new Exception(text("Format '", type, "' not supported"));
        }
        
        return libs;
    }
    
private:
    
    Library scanfile(string path)
    {
        // Check cache
        string basename = baseName(path);
        if (const(Library) *lib = basename in cache)
        {
            return cast()*lib;
        }
        
        Library lib;
        lib.name = basename;
        
        // Find mentioned library
        if (exists(path) == false)
        {
            string newpath = findInPath(basename);
            if (newpath == null)
            {
                lib.flags = LibraryFlags.notFound;
                return lib;
            }
            path = newpath;
        }
        if (isDir(path))
        {
            throw new Exception(text("'", path, "' is not a path to a file"));
        }
        
        lib.dependencies = dependsOn(path);
        cache[basename] = lib;
        return lib;
    }
    
    // PATH array
    string[] PATH;
    // Cache for findinPath
    string[string] pathCache;
    
    // Symbol list cache
    // key: lib name
    Library[string] cache;
}