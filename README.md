<p align="center"><img src="Media/Logo.png"></p>

# Rogo
Rogue-based imperative build-your-own build system

About     | Current Release
----------|-----------------------
Version   | 2.0
Date      | July 15, 2022
Platforms | Windows, macOS, Linux


# Installing

## macOS, Linux, Windows

*Either:*

1. Install [morlock](https://morlock.sh), which also installs Rogo. (recommended)

*Or:*

1. Install [rogue](https://github.com/AbePralle/Rogue).
2. `make install`

Windows: note that 'make' is this project's make.bat script.

# Adding Rogo to a Project

`cd` into the project folder and run `rogo` to see available options. Most commonly, run `rogo --create` to create a simple `Build.rogue` file or `rogo --create --project=ProjName` to create a starter Rogue-based app with a Rogo build file.

    > rogo
    ================================================================================
    ROGO ERROR

    No standard build file exists (Build.rogue, BuildCore.rogue, BuildLocal.rogue)
    and no alternate specified with --build=<filename>.

    Type 'rogo --create [options]' to create Build.rogue with a default framework.

    OPTIONS
      --project=ProjectName
        Creates additional starter framework for the specified ProjectName.

      --bitmap
        Links Build.rogue and the starter project (if --project is specified) with
        libpng and libjpeg libraries.

    If no options are specified then only Build.rogue is created.
    ================================================================================

# Overview

When you run `rogo command [args]` in a folder, Rogo looks for any Rogue files named `Build.rogue`, `BuildCore.rogue`, and/or `BuildLocal.rogue` and executes `routine rogo_command(<parameters>)` that should be in one of those three files.

For example, `rogo add 3 5` would execute `routine rogo_add(a:Value,b:Value)` which might be defined as `println a+b`.

Routines can execute any arbitrary Rogue code which makes Rogo able to handle any build system task.

Routine parameters can be specific datatypes such as `Int32`, `Real64`, and `Logical`; args are coerced into the given parameter type. Parameters can also be general `Value` types. If multiple args are given and only a single `Value` parameter exists, that parameter will be a `Value` list of all args.

Multi-word commands can be used; the build framework will use the longest match possible for the routine name before turning the remainder of the command line args into call args. For example, `rogo alpha bravo charlie` would call `routine rogo_alpha_bravo(arg:String)` and `arg` would be "charlie".

# Rogo Build Files

The following three files are automatically recognized by Rogo as containing build commands. No particular file is required; any combination may be used.

Filename          | Description
------------------|-----------------------------------------
`Build.rogue`     | The standard build file. Often the only file when there are no special build needs.
`BuildCore.rogue` | For any projects that need to define a build system while allowing developers to add on their own project-level build commands, it is recommended that the project maintainer place their build commands in `BuildCore.rogue` and leave `Build.rogue` available for developers to customize.
`BuildLocal.rogue`| Intended for developers to add on their own individual build commands that won't be committed to the repo. It is recommended that `BuildLocal.rogue` be added to `.gitignore`.

Whenever `rogo` is run it checks to see if any of the three build files have been modified relative to the build executable that's placed in hidden folder `.rogo/`. If so then a `roguec` recompile is invoked and then the build executable is launched.

# Rogo Directives

Rogo recognizes a number of *directives* given in the build files. Most directives begin with the special sequence `#$`, making them appear as comments to the RogueC compiler. These directives can also be called "comment directives". They are optional.

## Comment Directives

### CPP

    #$ CPP = g++ -Wall -std=gnu++11 -fno-strict-aliasing -Wno-invalid-offsetof

Defines the C++ command that should be used to compile the RogueC-generated .cpp build file. Can include compiler options.

### CPP_ARGS

    #$ CPP_ARGS = -a -b -c

Gives additional compile options. Stacks such that options are cumulative.

### DEPENDENCIES

    #$ DEPENDENCIES = Library/Rogue/**/*.rogue

Lists additional .rogue source files that Rogo should be aware of. The build executable will be recompiled if any of the listed files are modified. Rogo directives are processed in these files as well.

### LIBRARIES

    #$ LIBRARIES = libname
    #$ LIBRARIES = libname(<package-name>)
    #$ LIBRARIES = libname(package:<package-name> install:<install-cmd> link:<link-flags> which:<which-name>)

Element          | Description
-----------------|----------------------------------------------------
*libname*        | The main name of the library that should be installed, for example `libpng-dev`.
*package*        | The name of the library (such as `libpng`) that is used with `pkg-config` to obtain linking flags. Defaults to *libname* without any `-dev` suffix.
*install*        | The console command that should be executed to install the library. Defaults to a platform-appropriate install such as `brew install <libname>`.
*link*           | The C++ linker flags and other flags which should be sent to the C++ compile step. May also specify `false` to prevent this library from being linked.
*which*          | When installed software is an app rather than a library, `which libname` is used to check and see if it exists. A custom command may be specified here.

Various ways to automatically install (via `brew`, `apt`, or `yum`) and possibly link various third-party libraries into the compilation of the Rogo build file and/or C++ files that Rogo builds.

### LINK

    #$ LINK = true
    #$ LINK = false

Specifies whether any following `#$LIBRARIES` will automatically be linked with the build executable when Rogo recompiles it.

For example:

    # Build.rogue
    #$ LIBRARIES = libpng   # Install libpng but do not link it with this Build.rogue executable
    #$ LINK = true          # Turn on build file linking of following LIBRARIES
    #$ LIBRARIES = libjpeg  # Install libjpeg and link it with this Build.rogue executable

Linking libraries into the build executable allows them to be used from the Rogo build - for example, if PNG and JPEG libs are included then Rogue's `Bitmap` module can be used to load, save, and manipulate images.

### ROGUEC

    #$ ROGUEC = Some/Path/roguec

Specifies the filepath of the Rogue compiler for compiling the build executable. Defaults to simple `roguec`.

### ROGUEC_ARGS

    #$ ROGUEC_ARGS = --some-arg=value

Specifies additional RogueC compile options. Stacks.

## Platform-Specific Directives

    #$ DIRECTIVE = ...
    #$ DIRECTIVE(macOS)     = ...
    #$ DIRECTIVE(Linux)     = ...
    #$ DIRECTIVE(Linux-apt) = ...
    #$ DIRECTIVE(Linux-yum) = ...
    #$ DIRECTIVE(Windows)   = ...

By default Rogo directives apply to all platforms. However you can write e.g. `#$DIRECTIVE(<platform-name>) = ...` to apply a directive to that platform only. For example:

    #$ LIBRARIES(macOS)     = libpng libjpeg zlib
    #$ LIBRARIES(Linux-apt) = libpng-dev libjpeg-dev

# Source-Level Replacements

    $LIBRARY_FLAGS(libname1,...)

When compiling to a build executable, Rogo replaces `$LIBRARY_FLAGS(...)` with the appropriate C++ compiler flags. The given "libname" should be specified in a `#$LIBRARIES` directive.

For an example, create a starter project with `rogo --create --project=Test --bitmap` and see how `$LIBRARY_FLAGS()` is utilized in `Build.rogue`.

