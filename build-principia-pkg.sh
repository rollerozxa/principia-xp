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
zip -r ../principia.zip principia
