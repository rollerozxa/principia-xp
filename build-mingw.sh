#!/bin/bash -eu

TOPDIR="$PWD"
TOOLCHAIN_PREFIX="$TOPDIR/mingw"
TARBALLDIR="/tmp/tarballs"
TARGET_TRIPLET=i686-w64-mingw32


mkdir -p $TARBALLDIR

BUILDDIR=/tmp/mingw

export PATH=$TOOLCHAIN_PREFIX/bin:$PATH

PREFIX="--prefix=$TOOLCHAIN_PREFIX"
TARGET="--target=$TARGET_TRIPLET"
WITH_GMP="--with-gmp=$TOOLCHAIN_PREFIX"

GMP_VER=6.3.0
GMP_URL="https://ftp.funet.fi/pub/gnu/gnu/gmp/gmp-$GMP_VER.tar.bz2"
MPFR_VER=4.2.2
MPFR_URL="https://ftp.funet.fi/pub/gnu/gnu/mpfr/mpfr-$MPFR_VER.tar.bz2"
MPC_VER=1.4.1
MPC_URL="https://ftp.funet.fi/pub/gnu/gnu/mpc/mpc-$MPC_VER.tar.xz"
BINUTILS_VER=2.46.0
BINUTILS_URL="https://ftp.funet.fi/pub/gnu/gnu/binutils/binutils-$BINUTILS_VER.tar.bz2"
GCC_VER=16.1.0
GCC_URL="https://ftp.funet.fi/pub/gnu/gnu/gcc/gcc-$GCC_VER/gcc-$GCC_VER.tar.xz"
MINGW_VER=14.0.0
MINGW_URL="https://github.com/mingw-w64/mingw-w64/archive/refs/tags/v$MINGW_VER.tar.gz"

get_tar_archive() {
	# $1: folder to extract to, $2: URL
	local filename="${2##*/}"

	wget -nc -c "$2" -O "$TARBALLDIR/$filename" || echo 'ok, reusing archive'
	mkdir -p "$1"
	tar -xaf "$TARBALLDIR/$filename" -C "$1" --strip-components=1
	cd "$1" || exit
}

mk_build_dir() {
	mkdir -p build
	cd build || exit
}

configure_make_install() {
	local _configure_args=${1:-""}
	local _make_opt=${2-""}
	local _install_type=${3-"install"}
	mk_build_dir
    ../configure $_configure_args
    make -j12 $_make_opt
    make $_install_type
}

build() {
	echo "Building $1..."

	pushd "$BUILDDIR" || exit
	"build_$1"
	popd || exit
}

build_gmp() {
	get_tar_archive gmp $GMP_URL
	
	patch -p1 < "$TOPDIR/gmp-gcc-15.patch" || true

	CFLAGS="-std=gnu99" configure_make_install "$PREFIX --disable-shared"
}

build_mpfr() {
	get_tar_archive mpfr $MPFR_URL

	configure_make_install "$PREFIX $WITH_GMP --disable-shared"
}

build_mpc() {
	get_tar_archive mpc $MPC_URL

	configure_make_install "$PREFIX $WITH_GMP --disable-shared"
}

build_binutils() {
	get_tar_archive binutils $BINUTILS_URL

	configure_make_install \
		"$PREFIX $TARGET --disable-werror --disable-multilib" \
		"" \
		"install-strip"
}

build_gcc() {
	get_tar_archive gcc $GCC_URL

	configure_make_install \
		"$PREFIX $TARGET $WITH_GMP --enable-languages=c,c++ --disable-multilib --enable-threads=posix" \
		"all-gcc" \
		"install-strip-gcc"
}

build_mingw() {
	get_tar_archive mingw-w64 $MINGW_URL

	# --with-default-msvcrt=$DEFAULT_CRT
	_COMMON_MINGW_FLAGS="--prefix=$TOOLCHAIN_PREFIX/$TARGET_TRIPLET --host=$TARGET_TRIPLET --with-default-msvcrt=msvcrt --with-default-win32-winnt=0x0501"
	echo $_COMMON_MINGW_FLAGS

	pushd mingw-w64-headers
	mk_build_dir
	../configure $_COMMON_MINGW_FLAGS
	make install
	popd

	pushd mingw-w64-crt
	configure_make_install "${_COMMON_MINGW_FLAGS} --disable-lib64 --enable-lib32"
	popd

	pushd mingw-w64-libraries/winpthreads
	configure_make_install "${_COMMON_MINGW_FLAGS}"
	popd
}

build_gcc_libs() {
	cd gcc
	patch -p1 < "$TOPDIR/gcc-dynamic-load-tzdb.patch" || true

	cd build
    make -j12
    make install-strip
}

mkdir -p $BUILDDIR

build gmp
build mpfr
build mpc
build binutils
build gcc
build mingw
build gcc_libs
