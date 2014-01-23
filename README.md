# Command-line Rock Band 3 tools

This is a collection of command-line tools to construct all the pieces of an
Xbox 360 Rock Band 3 custom song file. Much of the underlying functionality
relies on work done by other community members.

* `ogg2mogg` takes a standard Ogg Vorbis audio file and outputs the same file
with a required header tacked on the front. The file is produced
using a stripped-down version of Harmonix's Magma packaging software, combined
with a special "fake Ogg encoder"
[created by qwertymodo](http://rockband.scorehero.com/forum/viewtopic.php?p=655652#655652)
to use a user-supplied Ogg file. Requires GHC, `cabal-install`, and if on Linux,
Wine (to run MagmaCompiler.exe).

* `rb3albumart` converts any image file into the required album art format. The
algorithm is ported from
[RB3Maker by Technicolor](http://rockband.scorehero.com/forum/viewtopic.php?t=34542).
Requires Ruby and ImageMagick.

* `rb3pkg` is a bare-bones tool to package a folder as a CON-signed, unlocked
Rock Band 3 "save game" song package. The functionality is provided by
[the X360 library by Dalavin](http://skunkiebutt.com/), and much of the code is
from RB3Maker. Requires Visual Studio or Mono.

## Installation

The included script builds and installs all tools:

    sudo ./install.sh

`$PREFIX` is `/usr/local` by default but can be overridden:

    PREFIX=~/ ./install.sh
