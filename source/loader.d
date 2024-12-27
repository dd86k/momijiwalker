module loader;

import std.conv : text;
import std.string : toStringz, fromStringz;
import adbg.error;
import adbg.objectserver;
import adbg.objects.pe;

class AlicedbgException : Exception
{
    this()
    {
        super(text("Alicedbg: ", fromStringz(adbg_error_message())));
    }
}

struct Import
{
    string name; // e.g., KERNEL32.dll
    pe_import_descriptor_t* descriptor;
}

struct ImportSymbol
{
    string name; // e.g., GetStdHandle, etc.
    ushort hint;
    uint rva;
}

struct Binary
{
    this(string path)
    {
        o = adbg_object_open_file(toStringz(path), 0);
        if (o == null)
            throw new AlicedbgException();

        string type = cast(string) fromStringz(adbg_object_type_shortname(o));
        switch (type)
        {
        case "pe32":
            objformat = FORMAT_PE32;
            break;
        default:
            throw new Exception(text("Format '", type, "' not supported"));
        }

        origpath = path;
    }

    ~this()
    {
        adbg_object_close(o);
    }

    Import[] imports()
    {
        Import[] list;
        final switch (objformat) {
        case FORMAT_PE32:
            pe_import_descriptor_t* im = void;
            size_t i;
            while ((im = adbg_object_pe_import(o, i++)) != null)
            {
                // NOTE: dupping strings due to Stringz making only a reference
                Import imp;
                imp.descriptor = im;
                imp.name = adbg_object_pe_import_module_name(o, im)
                    .fromStringz()
                    .idup;

                list ~= imp;
            }
            break;
        }
        return list;
    }

    ImportSymbol[] importSymbols(ref Import imp)
    {
        ImportSymbol[] syms;
        final switch (objformat) {
        case FORMAT_PE32:
            assert(imp.descriptor);
            size_t i;
            void* entry = void;
            while ((entry = adbg_object_pe_import_entry(o, imp.descriptor, i++)) != null)
            {
                ImportSymbol sym;
                sym.name = adbg_object_pe_import_entry_string(o, imp.descriptor, entry)
                    .fromStringz()
                    .idup;
                sym.hint = adbg_object_pe_import_entry_hint(o, imp.descriptor, entry);
                sym.rva = adbg_object_pe_import_entry_rva(o, imp.descriptor, entry);
                syms ~= sym;
            }
            break;
        }
        return syms;
    }

private:
    enum
    {
        FORMAT_PE32 = 1
    }

    adbg_object_t* o;
    int objformat;
    string origpath;
}

class ImportCache
{
    // path = path must exist
    Import[] getImports(string path)
    {
        if (const(Import[])* cached = path in cache)
        {
            return cast(Import[])*cached;
        }
        
        Binary bin = Binary(path);
        Import[] imports = bin.imports();
        cache[path] = imports;
        return imports;
    }

private:
    Import[][string] cache;
}
