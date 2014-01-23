#!/bin/bash
set -e

if [[ -z "$PREFIX" ]]; then
  PREFIX=/usr/local
fi

cd ogg2mogg
cabal install --symlink-bindir="$PREFIX/bin"

cd ../rb3albumart
cp rb3albumart "$PREFIX/bin"

cd ../rb3pkg
xbuild /p:Configuration=Release
cd rb3pkg/bin/Release
mkdir -p "$PREFIX/bin/rb3pkg_dir"
cp * "$PREFIX/bin/rb3pkg_dir"
cp ../../../run_rb3pkg.sh "$PREFIX/bin/rb3pkg"
chmod +x "$PREFIX/bin/rb3pkg"
