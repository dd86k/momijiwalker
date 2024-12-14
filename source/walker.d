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
    Library[] dependencies;
    string[] symbols;
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
        string paths = environment["PATH"]; // Required
        foreach (path; splitter(paths, pathSeparator))
        {
            PATH ~= path;
        }
    }
    
    // scan dependencies of this file or dynamic library
    // TODO: bool symbols = get exported symbols
    // TODO: int maxlevels = max number of passes to sublibraries
    Library scan(string path)
    {
        // First level is the requested exec/lib
        Library root = scanfile(path);
        
        // Get which libraries the root depends on
        foreach (ref Library dep; root.dependencies)
        {
            
            
        }
        
        return root;
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
        
        // Find mentioned library
        if (exists(path) == false)
        {
            string newpath = findpath(basename);
            if (newpath == null)
                throw new Exception(text("'",path,"' does not exist"));
            path = newpath;
        }
        if (isDir(path))
        {
            throw new Exception(text("'",path,"' is not a path to a file"));
        }
        
        Library lib;
        lib.name = basename;
        const(char) *pathz = toStringz(path);
        adbg_object_t *o = adbg_object_open_file(pathz, 0);
        if (o == null)
            throw new AlicedbgException();
        
        // Depending on the library format, get 
        // TODO: Add obj type enum function in alicedbg
        string type = cast(string)fromStringz( adbg_object_type_shortname(o) );
        switch (type) {
        case "pe32":
            pe_import_descriptor_t *im = void;
            size_t i;
            while ((im = adbg_object_pe_import(o, i++)) != null)
            {
                string modname = cast(string)fromStringz( adbg_object_pe_import_module_name(o, im) );
                lib.dependencies ~= Library(modname, 0, null, null);
            }
            break;
        default:
            throw new Exception(text("Format '", type, "' not supported"));
        }
        
        return lib;
    }
    
    // walk all directories from PATH to find library path
    string findpath(string basename)
    {
        foreach (string dir; PATH)
        {
            string p = buildPath(dir, basename);
            if (exists(p))
            {
                return p;
            }
        }
        return null;
    }
    
    // PATH array
    string[] PATH;
    
    // Symbol list cache
    // key: lib name
    // data: symbol list
    Library[string] cache;
}