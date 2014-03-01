
## Cero User Guide

### Indentation

In Cero, like in Python, indentation matters. All code must be correctly indented since this is used to infer placement of curly braces and semicolons. Currently, Cero supports only using 4 spaces as indentation.

### Breaking long lines

Since Cero uses indentation to infer placement of curly braces and semicolons, line breaks of long lines can be problematic. Cero can detect line breaks that should NOT lead to insertion of curly braces and semicolons. If a line ends with one of the following characters

    , - + * / < > & | =

then Cero will treat it as breaking of a long line and not start of a new block.

### No parentheses after for, if, while and switch

In Cero, it is not necessary to place parentheses around expression after for, if, while and switch. This is perfectly ok:

    if n < 5
        a = 0

### Simplified variable definitions

C++11 introduces the auto keyword for variable definitions:

    auto i = 0;

The type of i is inferred from the 0, and the above is equivalent to 

    int i = 0;

In Cero the auto keyword cam be omitted and the follwing syntax can be used (like in Go):

    i := 0; // Note the added ":"

### Simplified for loops

The following cero code:

    for i = 0..MAX

Is converted to

    for (i = 0; i < MAX; i++)
    
This is also allowed (note ":=" instead of "="):

    for i := 0..MAX

Is converted to

    for (auto i = 0; i < MAX; i++)

### No header files

In Cero, the .h file and .cpp file are combined in the .ce file. The .h part is prefixed with a single line

    +++ public

and the .cpp part is prefixed

    +++ private 

Both these are optional so a .ce file can contain only one or the other.

### Modules, importing and the build system

A module in Cero is the .ce file. You can tell the compiler to make available the public functions of one module in another module using the import statement:

    import module

This is compiled into

    #include "module.h"

Even though this may seem unnecessary, the import keyword is important to let the build system find dependencies. When cero builds a file it will search for imported modules and build those first, recursively if necessary. The build system will avoid building if the resulting file is newer than the source.

### No forward declarations

Declarations of functions can be copied to a different part of the .ce file prefixing the definition with + or - and then using the "+decl" or "-decl" keywords. Declarations prefixed by "-" will also be declared static. For example, the following Cero code:

main.ce file:

    +++ public
    +decl
    +++ private
    import main
    -decl
    +void PublicFunction(int i)
    PrivateFunction(5+i)
    -void PrivateFunction(int i)
    cout << i

will be compiled to this C++ code:

main.h file:

    void PublicFunction(int i);

main.cpp file:

    #include "main.h"
    static void PrivateFunction(int i);
    void PublicFunction(int i)
    {  PrivateFunction(5+i); }
    -void PrivateFunction(int i)
    { cout << i; }





