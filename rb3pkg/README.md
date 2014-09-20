This is a stripped-down command-line version of
[RB3Maker](http://rockband.scorehero.com/forum/viewtopic.php?t=34542)
with the single task of packaging a folder into a Rock Band 3 CON-signed custom
song or upgrade package.

## Install

If you are on a Unix-like with Mono installed:

    make install

This will build with `xbuild` and then install to `$(PREFIX)/bin/rb3pkg`,
with data files in `$(PREFIX)/lib/rb3pkg/`. By default PREFIX is `/usr/local`.

## Usage

    rb3pkg -p "Package Name" -d "Description of package." -f files_dir out.con

Run `rb3pkg -?` to see more options.
