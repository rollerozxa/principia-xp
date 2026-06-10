#!/bin/bash -eu

# cd to this script's dir
cd "$(dirname "$0")"
TOPDIR="$PWD"

NSIS_VER=3.12
NSIS_HASH="56581f90db321581c5381193d796fffcf2d24b2f8fed2160a6c6a3baa67f2c4f"

# if nsis/ directory does not exist, download NSIS and extract it there
if [ ! -d "nsis" ]; then
	echo "Downloading NSIS..."
	curl -L -o /tmp/nsis-$NSIS_VER.zip http://downloads.sourceforge.net/project/nsis/NSIS%203/$NSIS_VER/nsis-$NSIS_VER.zip

	echo "$NSIS_HASH  /tmp/nsis-$NSIS_VER.zip" | sha256sum -c -
	if [ $? -ne 0 ]; then
		echo "NSIS hash mismatch"
		exit 1
	fi

	echo "Extracting NSIS..."
	unzip /tmp/nsis-$NSIS_VER.zip -d /tmp/nsis-$NSIS_VER
	mv /tmp/nsis-$NSIS_VER/nsis-$NSIS_VER nsis
fi

wine nsis/makensis.exe principia_install.nsi
