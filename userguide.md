
## Cero User Guide

Cero is a very small change to C++ so it should be quick to learn if you already know C++. Cero is based on C++11.

### Indentation

In Cero, like in Python, indentation matters. All code must be correctly indented since this is used to infer placement of curly braces and semicolons. Currently, Cero supports only using 4 spaces as indentation.

### No parentheses after for, if, while and switch

It is not necessary to place parentheses around expression after for, if, while and switch. This is perfectly ok:

    if n < 5
        a = 0

### Simplified variable definitions

C++11 introduces the auto keyword for variable definitions so these definitions are equivalent:

    int i = 0;
    auto i = 0; // type of i is inferred from 0

In Cero the auto keyword cam be omitted and the follwing syntax can be used:

    i := 0

### Simplified for loops

The following cero code:

    for i = 0..MAX

Is compiled to

    for (i = 0; i < MAX; i++)
    
This is also allowed (note ":=" instead of "="):

    for i := 0..MAX

This is compiled to

    for (auto i = 0; i < MAX; i++)

### No header files

In Cero, the .h file and .cpp file are combined in the .ce file. The .h part is prefixed with a single line

    [public]

and the .cpp part is prefixed

    [private] 

Both these are optional so a .ce file can contain only one or the other.

### Modules, importing and the build system

A module in Cero is the .ce file. You can tell the compiler to make available the public functions of one module in another module using the import statement:

    import module

This is compiled into

    #include "module.h"

Even though this may seem unnecessary, the import keyword is important to let the build system find dependencies. When cero builds a file it will search for imported modules and build those first. The build system will avoid building if the resulting file is newer than the source.

### No forward declarations

Declarations of functions can be copied during compile time to a different part of the .ce file prefixing the definition with "+" or "-" and then using the "[+decl]" or "[-decl]" keywords. Declarations prefixed by "-" will also be declared static. For example, the following Cero code:

main.ce file:

    [public]
    [+decl]
    [private]
    #include <iostream>
    import main
    [-decl]
    +void PublicFunction(int i)
        PrivateFunction(5+i)
    -void PrivateFunction(int i)
        std::cout << i

will be compiled to this C++ code:

main.h file:

    void PublicFunction(int i);

main.cpp file:

    #include <iostream>
    #include "main.h"
    static void PrivateFunction(int i);
    void PublicFunction(int i)
    {  
        PrivateFunction(5+i); 
    }
    static void PrivateFunction(int i)
    { 
        std::cout << i; 
    }

## The cero compiler

The cero command line tool can be used for compilation of single files or building whole systems and also for conversion of C++ to Cero. Run "cero help" to see available commands.

### Flags and the build folder

To control generation of code, a number of environment flags can be set. This handy build script sums it up (with their defaults):

build.sh:

    #!/bin/sh
    export CC=g++
    export CERO_PATH="."  # Colon separated search path of .ce files
    export CERO_EXE=<file name given to "cero b" stripped of .ce>
    export CFLAGS="-Wall -O3 -std=c++11 -c"
    export LFLAGS=""

    cero b main.ce

Change any part of this script to suit your needs. 

All build output ends up in a separate folder called "build". It is created if necessary.

### Converting C++ to Cero

The Cero command line tool can be used to convert C++ to Cero code. First, you need to make sure the C++ code is correctly indented. Use the supplied indent.sh script and then convert the file:

    indent.sh file.cpp # requires the uncrustify tool, see below
    cero cpp2cero file.cpp file.ce

This will remove unneeded curly braces and semicolons. You will manually have to edit the file to make use of import, private/public declarations, and other Cero specific features.

To install the uncrustify dependency, on Debiand based installations: just run "apt-get install uncrustify".

## Caveats

### No curly braces and semicolons - some exceptions

Semicolons and curly braces are usually unnecessary. Sometimes you need them anyway though. To declare an empty body of a function, use {} on the same line as the function header. E.g.

    void fun() {}

{} or ; can also be used as an empty expression, where needed. 

Care must be taken with preprocessor directives. E.g: If you end the function definition with an #endif, you need to insert a ";" after the #endif so the function will be correctly terminated with a single "}", like this:

    void fun()
    #ifdef ...
        ...
    #endif
        ;

To iniailize a variable, you need to use curly braces but not on separate lines. This is OK:

    int a[] = { 1, 2, 3 }

### Breaking long lines

Since Cero uses indentation to infer placement of curly braces and semicolons, line breaks of long lines can be problematic. However, if a line ends with one of the following characters

    , - + * / < > & | =

then Cero will treat it as breaking of a long line and not insert curlies and semicolons.

