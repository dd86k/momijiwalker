module main;

import std.stdio;
import std.getopt;
import std.json;
import walker;

static immutable string VERSION = "0.0.0";

void printName(int level, string name, string post = null)
{
    for (int i; i < level; ++i)
        write("   ");
    write("+- ", name);
    if (post) write(" ", post);
    writeln();
}

void printSpacing(int level)
{
    for (int i; i < level; ++i)
        write("   ");
}

void printSymbols(ref Library lib, int level)
{
    foreach (symbol; lib.symbols)
    {
        printSpacing(level + 1);
        writeln(symbol);
    }
}

void printError(string text)
{
    stderr.writeln("error: ", text);
}

void process(int level, int max, string path, Walker walker)
{
    try foreach (string dep; walker.dependsOn(path))
    {
        string depfull = walker.findInPath(dep);
        printName(level, dep, depfull ? null : "(Not found)");
        
        if (level < max)
        {
            process(level + 1, max, dep, walker);
        }
    }
    catch (Exception)
    {
        
    }
}

JSONValue[] processJSON(int level, int max, string path, Walker walker)
{
    JSONValue[] jdeps;
    try foreach (string dep; walker.dependsOn(path))
    {
        string depfull = walker.findInPath(dep);
        
        JSONValue jdep;
        jdep["name"] = dep;
        jdep["exists"] = depfull !is null;
        if (depfull) jdep["path"] = depfull;
        
        if (level < max)
        {
            JSONValue[] subs = processJSON(level + 1, max, dep, walker);
            if (subs.length)
                jdep["depends"] = subs;
        }
        
        jdeps ~= jdep;
    }
    catch (Exception)
    {
        
    }
    return jdeps;
}

int main(string[] args)
{
    int omax = 0;
    bool ojson;
    bool oversion;
    GetoptResult optres = void;
    // TODO: Output as HTML?
    // TODO: --info: Print library info (flags, symbol flags, etc.)
    try optres = getopt(args, config.caseSensitive,
        "max",      "Maximum dependency level (default=3)", &omax,
        "output-json", "Output as JSON", &ojson,
        "version",  "Print version page and exit", &oversion);
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
    
    scope Walker walker = new Walker();
    foreach (string arg; args[1..$])
    {
        Library root = walker.scan(arg);
        
        if (ojson)
        {
            JSONValue j;
            j["name"] = root.name;
            j["depends"] = processJSON(0, omax, root.name, walker);
            write(j.toString());
        }
        else
        {
            writeln(root.name);
            process(0, omax, root.name, walker);
            
            /*
            foreach (string dep; root.dependencies)
            {
                string depfull = walker.findInPath(dep);
                printName(1, dep, depfull ? null : "(Not found)");
                
                // 1. Only should sub-dependencies if asked
                // 2. Can't continue if sub level unavailable
                if (osubdep == false || depfull is null)
                    continue;
                
                foreach (string sub; walker.dependsOn(dep))
                {
                    string subfull = walker.findInPath(sub);
                    printName(2, sub, subfull ? null : "(Not found)");
                }
            }
            */
        }
    }
    
    return 0;
}
