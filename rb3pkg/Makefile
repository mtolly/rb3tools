PREFIX ?= /usr/local

build:
	cd rb3pkg && xbuild /p:Configuration=Release

install: build
	mkdir -p $(PREFIX)/lib/rb3pkg/
	mkdir -p $(PREFIX)/bin/
	cp -Rf rb3pkg/bin/Release/ $(PREFIX)/lib/rb3pkg/
	cp -f rb3pkg/run.sh $(PREFIX)/bin/rb3pkg
