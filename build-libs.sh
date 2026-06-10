#!/bin/bash -eu

# cd to this script's dir
cd "$(dirname "$0")"

export PATH="$PWD/mingw/bin:$PATH"

rm -rf libs

cd pkg-buildscripts
rm -rf build

./zlib
./mbedtls
./curl
./freetype
./libjpeg
./libpng
./sdl2

# unzip all resulting zips into ../libs

for zip in *.zip; do
	unzip -o "$zip" -d ../libs
done
