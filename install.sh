#!/bin/bash
set -e

cd ogg2mogg
cabal install

cd ../rb3albumart
sudo cp rb3albumart /usr/local/bin

cd ../rb3pkg
xbuild /p:Configuration=Release
cd rb3pkg/bin/Release
sudo mkdir -p /usr/local/bin/rb3pkg_dir
sudo cp * /usr/local/bin/rb3pkg_dir
sudo cp ../../../run_rb3pkg.sh /usr/local/bin/rb3pkg
sudo chmod +x /usr/local/bin/rb3pkg
