module main;

import std.stdio;
import std.getopt;
import walker;

static immutable string VERSION = "0.0.0";

void printSpacing(int level)
{
    for (int i; i < level; ++i)
        write("   ");
}

void printEntry(ref Library lib, int level)
{
    printSpacing(level);
    writeln("+- ", lib.name);
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
    bool oversion;
    GetoptResult optres = void;
    try optres = getopt(args, config.caseSensitive,
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
    
    Library root = walker.scan(args[1]);
    
    // Print root level
    writeln(root.name);
    
    // Print dependencies
    int level;
    foreach (ref Library dep; root.dependencies)
    {
        printEntry(dep, level);
    }
    
    return 0;
}
