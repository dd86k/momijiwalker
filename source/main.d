module main;

import std.stdio;
import std.getopt;
import std.json;
import std.file : exists;
import pathutils, loader;

static immutable string VERSION = "0.0.0";

void printOut(int level, string modulePath, bool found)
{
    for (int i; i < level; ++i) write("   ");
    write("+- ");
    if (found == false) write("Not found: ");
    writeln(modulePath);
}

void printError(string text)
{
    stderr.writeln("error: ", text);
}

//
//
//

void process(int level, string path, int max, PathCache pathcache, ImportCache impcache)
{
    try foreach (ref Import imp; impcache.getImports(path))
    {
        string subfullpath = pathcache.get(imp.name);
        if (subfullpath is null)
        {
            printOut(level, imp.name, false);
            continue;
        }
        
        printOut(level, subfullpath, true);
        
        // TODO: Import symbols
        // TODO: Export symbols
        
        if (level < max)
        {
            process(level + 1, subfullpath, max, pathcache, impcache);
        }
    }
    catch (Exception ex)
    {
        
    }
}

JSONValue[] processJSON(int level, string path, int max, PathCache pathcache, ImportCache impcache)
{
    JSONValue[] jdeps;
    try foreach (ref Import imp; impcache.getImports(path))
    {
        string subfullpath = pathcache.get(imp.name);
        JSONValue jdep;
        jdep["name"] = imp.name;
        
        if (subfullpath)
        {
            jdep["path"] = subfullpath;
        
            // TODO: Import symbols in JSON
            // TODO: Export symbols in JSON
        
            if (level < max)
            {
                JSONValue[] subs = processJSON(level + 1, subfullpath, max, pathcache, impcache);
                if (subs.length)
                    jdep["depends"] = subs;
            }
        }
        
        jdeps ~= jdep;
    }
    catch (Exception)
    {
        
    }
    return jdeps;
}

void processHTML(int level, string path, int max, PathCache pathcache, ImportCache impcache)
{
    writeln(`<ul>`);
    try foreach (ref Import imp; impcache.getImports(path))
    {
        string subfullpath = pathcache.get(imp.name);
        if (subfullpath)
        {
            writeln(`<li>Not found: `, imp.name, `</li>`);
            continue;
        }
        writeln(`<li>`, subfullpath, `</li>`);
        
        // TODO: Import symbols in HTML
        // TODO: Export symbols in HTML
        
        if (level < max)
        {
            processHTML(level + 1, subfullpath, max, pathcache, impcache);
        }
    }
    catch (Exception)
    {
        
    }
    writeln(`</ul>`);
}

int main(string[] args)
{
    int omax;
    bool ojson;
    bool ohtml;
    bool oversion;
    GetoptResult optres = void;
    // TODO: --base: Base directory (to avoid using cwd)
    // TODO: --import-symbols: Include Import symbols
    // TODO: --export-symbols: Include Export symbols
    // TODO: --no-cache (doubt it'll use that much memory but never know)
    // TODO: --info: Print library info (flags, symbol flags, etc.)
    try optres = getopt(args, config.caseSensitive,
        "max",          "Maximum dependency level (default=0)", &omax,
        "output-html",  "Output as HTML", &ohtml,
        "output-json",  "Output as JSON", &ojson,
        "version",      "Print version page and exit", &oversion);
    catch (Exception ex)
    {
        printError(ex.msg);
        return 1;
    }
    
    if (oversion)
    {
        writeln(args[0], " v", VERSION);
        return 0;
    }
    
    if (optres.helpWanted)
    {
        defaultGetoptPrinter("Dependency walker", optres.options);
        return 0;
    }
    
    if (args.length <= 1)
    {
        printError("Missing path argument.");
        return 1;
    }
    
    foreach (string arg; args[1..$])
    {
        // If a name in PATH is mentionned, cache will be able to get it
        // by searching in PATH
        scope PathCache pathcache = new PathCache(arg);
        string fullinit = pathcache.get(arg);
        if (fullinit is null)
        {
            stderr.writeln("error: File '", arg, "' not found at location or in PATH");
            continue;
        }
        
        scope ImportCache impcache = new ImportCache();
        
        if (ojson)
        {
            JSONValue j;
            j["name"] = fullinit;
            j["depends"] = processJSON(0, fullinit, omax, pathcache, impcache);
            write(j.toString());
        }
        else if (ohtml)
        {
            writeln(
`<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="author" content="momijiwalker v`, VERSION, `">
  <title>`, arg, `</title>
</head>
<body>
  <p>`, fullinit, `</p>`);

            processHTML(0, fullinit, omax, pathcache, impcache);
            
            writeln(
`</body>
</html>`);
        }
        else
        {
            writeln(fullinit);
            process(0, fullinit, omax, pathcache, impcache);
        }
    }
    
    return 0;
}
