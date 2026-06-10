#!/bin/bash -eu

# cd to this script's dir
cd "$(dirname "$0")"
TOPDIR="$PWD"

cd build_principia

rm -rf principia
mkdir -p principia
cp principia.exe principia/
cp -r ../principia/data principia/
cp ../curl-ca-bundle.crt principia/data
touch principia/portable.txt
rm -f ../principia-portable.zip
zip -r ../principia-portable.zip principia
