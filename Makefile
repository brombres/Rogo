INSTALL_FOLDER=/usr/local/bin

all: $(INSTALL_FOLDER)/rogo

homebrew: all

$(INSTALL_FOLDER)/rogo: Source/Rogo.rogue
	mkdir -p Build
	roguec Source/Rogo.rogue --compile --compile-arg="-O3" --output=Build
	cp Build/Rogo "$(INSTALL_FOLDER)/rogo" || sudo cp Build/Rogo "$(INSTALL_FOLDER)/rogo"

clean:
	rm -rf Build

