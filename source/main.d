module main;

import std.stdio;
import std.getopt;
import walker;

static immutable string VERSION = "0.0.0";

void printName(int level, string name, string post = null)
{
    for (int i = 1; i < level; ++i)
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

int main(string[] args)
{
    bool osubdep;
    bool oversion;
    GetoptResult optres = void;
    try optres = getopt(args, config.caseSensitive,
        "sub",     "Get sub-dependencies", &osubdep,
        "version", "Print version page and exit", &oversion);
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
        writeln(root.name);
        
        foreach (string dep; root.dependencies)
        {
            string depfull = walker.findInPath(dep);
            printName(1, dep, depfull ? null : "(Not found)");
            
            // Only should sub-dependencies if asked
            if (osubdep == false)
                continue;
            
            try foreach (string sub; walker.dependsOn(dep))
            {
                printName(2, sub);
            }
            catch (Exception ex)
            {
                
            }
        }
    }
    
    return 0;
}
