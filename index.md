## The Cero Programming Language


Ugly:

    static int foobar(int arg, int a[])
    {
        int i;
        for (i = 0; i < arg; i++)
        {
            c += a[i];
        }
        return c;
    }

Pretty:

    - int foobar(int arg, int a[])
        for i := 0..arg
            c += a[i]
        return c

Cero is a slightly modified version of C++. By making a few small changes to the base language removing unneeded clutter, the code becomes a lot easier to read and maintain. Some additional features have been added, in an effort to modernize the language, like e.g. a built-in build system that derives build order and dependencies from the code itself. Most of the changes and additions are optional to allow easy transition from C++. A converter from C++ to Cero code is included.

Cero compiles into C++11 and is fully compatible with C/C++ code. Currently it is in beta phase and is supported only on Linux. To build and test, visit the github page to download the code. Just run make to build.

Cero has the following modifications compared to C++:

* No semicolons
* No curly braces
* No parentheses after for, while, if, switch
* Simplified for loops (e.g: for i = 0..5)
* No header files
* No forward declarations
* Variable creation simplfied: "auto i = 0" can be written as "i := 0"
* Built-in build system. Makefiles are not needed.
* No need for #ifndef/#define/#endif for headers to avoid multiple includes

###Example

File myprint.ce:

    [public]
    [+decl]
    [private]
    #include <iostream>
    #include <string>
    +void myprint(std::string s)
        std::cout << s

File main.ce:

    [private]
    #include <string>
    import myprint
    [-decl]
    int main(int argc, char *argv[])
        s := hello()
        for i := 0..5
            myprint(s)
        
    -std::string hello()
        return "Hello World\n"

In Cero, the public (.h) and private (.cpp) parts of a module is combined in one file. Declarations in a module that are private or should be exported can be prefixed with - or +.

Building:

    $ cero b main.ce

No Makefile required

###Licensing

The cero compiler is licensed under the BSD license. This allows embedding of the cero implementation into any development toolchain.
