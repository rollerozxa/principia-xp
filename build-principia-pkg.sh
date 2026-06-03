#!/bin/bash -eu

# cd to this script's dir
cd "$(dirname "$0")"
TOPDIR="$PWD"

cd build_principia

rm -rf principia
mkdir -p principia
cp principia.exe principia/
cp -r ../principia/data principia/
cp ../libs/bin/*.dll principia/
rm principia/libturbojpeg.dll
cp ../mingw/i686-w64-mingw32/bin/libwinpthread-1.dll principia/
cp ../mingw/i686-w64-mingw32/lib/libgcc_s_sjlj-1.dll principia/
cp ../mingw/i686-w64-mingw32/lib/libstdc++-6.dll principia/
zip -r ../principia.zip principia
