INSTALL_FOLDER=/usr/local

all: $(INSTALL_FOLDER)/bin/rogo

homebrew: all

$(INSTALL_FOLDER)/bin/rogo: Source/Rogo.rogue
	mkdir -p Build
	roguec Source/Rogo.rogue --compile --compile-arg="-O3" --output=Build
	cp Build/Rogo $(INSTALL_FOLDER)/bin/rogo || sudo cp Build/Rogo $(INSTALL_FOLDER)/bin/rogo

clean:
	rm -rf Build

