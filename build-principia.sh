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
	-DUNITY_BUILD=ON \
	-DUSE_VENDORED_SDL3=ON \
	-DCURL_INCLUDE_DIR="$INCLUDE" \
	-DCURL_LIBRARY="$LIB/libcurl.a;$LIB/libmbedtls.a;$LIB/libmbedcrypto.a;$LIB/libmbedx509.a;$LIB/libz.a;ws2_32.lib" \
	-DFREETYPE_INCLUDE_DIR_freetype2="$INCLUDE/freetype2/freetype" \
	-DFREETYPE_INCLUDE_DIRS="$INCLUDE/freetype2" \
	-DFREETYPE_LIBRARY="$LIB/libfreetype.a" \
	-DJPEG_INCLUDE_DIR="$INCLUDE" \
	-DJPEG_LIBRARY_RELEASE="$LIB/libjpeg.a" \
	-DPNG_PNG_INCLUDE_DIR="$INCLUDE" \
	-DPNG_LIBRARY_RELEASE="$LIB/libpng16.a" \
	-DZLIB_INCLUDE_DIR="$INCLUDE" \
	-DZLIB_LIBRARY_RELEASE="$LIB/libz.a" \
	-DCMAKE_C_FLAGS="-ffunction-sections -fdata-sections" \
	-DCMAKE_CXX_FLAGS="-ffunction-sections -fdata-sections -DCURL_STATICLIB" \
	-DCMAKE_EXE_LINKER_FLAGS="-Wl,--gc-sections -static" \
	-DBACKEND_IMGUI=ON \
	-G Ninja

ninja
