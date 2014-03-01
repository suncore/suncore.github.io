## The Cero Programming Language

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

###Example

File myprint.ce:

    +++ public
    // This part becomes the .h file
    +decl // declarations preceded by a + sign end up here
    +++ private
    // This part becomes the .cpp file
    #include 
    +void myprint(string s)
        std::cout << s

File main.ce:

    +++ private
    import myprint
    -decl // declarations preceded by a - sign end up here, declared as "static"
    int main(int argc, char *argv[])
        s := hello()
        for i := 0..5
            myprint(s)
        
    -string hello()
        return "Hello World"

Building:

    $ cero b main.ce

No Makefile required

###Licensing

The cero compiler is licensed under the BSD license. This allows embedding of the cero implementation into any development toolchain.
