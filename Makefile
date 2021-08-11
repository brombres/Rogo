INSTALL_FOLDER=.

all: homebrew

homebrew: $(INSTALL_FOLDER)/bin/rogo

$(INSTALL_FOLDER)/bin/rogo: Source/Rogo.rogue
	mkdir -p Build
	roguec Source/Rogo.rogue --compile --compile-arg="-O3" --output=Build
	mkdir -p $(INSTALL_FOLDER)/bin
	cp Build/Rogo $(INSTALL_FOLDER)/bin/rogo

clean:
	rm -rf Build
	rm -rf $(INSTALL_FOLDER)/bin

