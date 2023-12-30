build:
	swiftc Switcher.swift -o fcitx-remote

install: build
	mkdir -p ~/bin
	cp ./fcitx-remote ~/bin/
	chmod +x ~/bin/fcitx-remote
