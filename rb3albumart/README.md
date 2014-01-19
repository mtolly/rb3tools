A small Ruby script to convert an image file into the format required by
a Rock Band 3 song package (256x256 DirectDraw Surface, big endian). It uses
ImageMagick, and you must install a fairly recent version to have DDS write
support (see
[here](http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=23946&start=15#p102574)
)

## Usage

    rb3albumart in.png out_keep.png_xbox

The input image can be any image understood by ImageMagick. It will be resized
and converted appropriately.
