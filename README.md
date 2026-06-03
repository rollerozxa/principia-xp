This repository contains buildscripts for making 32-bit builds of Principia targeting Windows XP. A GCC-based mingw-w64 cross-compiler toolchain is built from source targetting XP, and all other libraries are also built from source in order to ensure everything is compatible on XP.

In general, the steps for the scripts are as follows:

1. `build-mingw.sh` to build a GCC mingw toolchain to `mingw/`
1. `build-libs.sh` to build dependency libraries using the compiled toolchain, outputting to `libs/`
1. `git clone https://github.com/Bithack/principia`
1. `build-principia.sh` to build Principia in `build_principia/`
1. `build-principia-pkgs.sh` to bundle everything up into a `principia.zip` archive
