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
        if (depfull)
            printName(level, depfull, null);
        else
            printName(level, dep, "(Not found)");
        
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

void processHTML(int level, int max, string path, Walker walker)
{
    writeln(`<ul>`);
    try foreach (string dep; walker.dependsOn(path))
    {
        string depfull = walker.findInPath(dep);
        if (depfull)
        {
            writeln(`<li>`, depfull, `</li>`);
        }
        else
        {
            writeln(`<li>`, dep, ` (not found)</li>`);
        }
        
        if (level < max)
        {
            processHTML(level + 1, max, dep, walker);
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
    // TODO: --no-cache (doubt it'll use that much memory but never know)
    // TODO: --info: Print library info (flags, symbol flags, etc.)
    try optres = getopt(args, config.caseSensitive,
        "max",      "Maximum dependency level (default=3)", &omax,
        "output-html", "Output as HTML", &ohtml,
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
        else if (ohtml)
        {
            static immutable string htmlprefix =
`<!DOCTYPE html>
<html>
<head>
  <title>test</title>
</head>
<body>
`;
            writeln(htmlprefix);
            
            writeln(`<p>`, root.name, `</p>`);
            processHTML(0, omax, root.name, walker);
            
            static immutable string htmlpostfix =
`</body>
</html>`;
            writeln(htmlpostfix);
        }
        else
        {
            writeln(root.name);
            process(0, omax, root.name, walker);
        }
    }
    
    return 0;
}
