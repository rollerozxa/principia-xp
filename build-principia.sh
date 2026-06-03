#!/bin/bash -eu

# cd to this script's dir
cd "$(dirname "$0")"
TOPDIR="$PWD"

export PATH="$PWD/mingw/bin:$PATH"

mkdir -p build_principia
cd build_principia

LIBS="$PWD/../libs"
LIB="$LIBS/lib"
INCLUDE="$LIBS/include"
cmake ../principia/ \
	-DCMAKE_TOOLCHAIN_FILE="$TOPDIR/toolchain-i686-w64-mingw32.cmake" \
	-DCMAKE_BUILD_TYPE=Release \
	-DSDL2_DIR="$LIB/cmake/SDL2/" \
	-DCURL_INCLUDE_DIR="$INCLUDE" \
	-DCURL_LIBRARY="$LIB/libcurl.dll.a" \
	-DFREETYPE_INCLUDE_DIR_ftbuild2="$INCLUDE/freetype2" \
	-DFREETYPE_INCLUDE_DIR_freetype2="$INCLUDE/freetype2/freetype" \
	-DFREETYPE_INCLUDE_DIRS="$INCLUDE/freetype2" \
	-DFREETYPE_LIBRARY="$LIB/freetype.dll.a" \
	-DFREETYPE_LIBRARY_RELEASE="$LIB/libfreetype.dll.a" \
	-DJPEG_INCLUDE_DIR="$INCLUDE" \
	-DJPEG_LIBRARY_RELEASE="$LIB/libjpeg.dll.a" \
	-DPNG_PNG_INCLUDE_DIR="$INCLUDE" \
	-DPNG_LIBRARY_RELEASE="$LIB/libpng16.dll.a" \
	-DZLIB_INCLUDE_DIR="$INCLUDE" \
	-DZLIB_LIBRARY_RELEASE="$LIB/libz.dll.a" \
	-DBACKEND_IMGUI=ON \
	-G Ninja

ninja


