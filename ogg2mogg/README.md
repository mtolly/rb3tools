# ogg2mogg

This is a terrible, terrible hack to add a Rock Band MOGG header to an OGG
Vorbis file from the command line. Internally, it contains a stripped-down copy
of Harmonix's Magma compiler, plus
[qwertymodo's oggenc hack](http://rockband.scorehero.com/forum/viewtopic.php?p=655652#655652)
in order to use a user-supplied OGG file. It compiles a dummy project, while
supplying the given OGG to the hacked oggenc, and then extracts the MOGG out of
the resulting RBA file. This should work on Windows and Linux; on Linux you'll
need to install Wine.

## Usage

`ogg2mogg in.ogg [out.mogg]`
