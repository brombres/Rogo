.PHONY: build

BUILD_FOLDER=Build
INSTALL_FOLDER=/usr/local/bin

all: install

build: $(BUILD_FOLDER)/rogo

install: $(INSTALL_FOLDER)/rogo

$(BUILD_FOLDER)/rogo: Source/Rogo.rogue
	mkdir -p "$(BUILD_FOLDER)"
	r2 Source/Rogo.rogue  --main --output=Build/Rogo --target=Console,C,macOS
	cc -O3 -Wall Build/Rogo.c -o Build/rogo

$(INSTALL_FOLDER)/rogo: $(BUILD_FOLDER)/rogo
	mkdir -p "$(INSTALL_FOLDER)" || (echo Retrying with sudo... && sudo mkdir -p "$(INSTALL_FOLDER)")
	cp "$(BUILD_FOLDER)/rogo" "$(INSTALL_FOLDER)/rogo" || \
		(echo Retrying with sudo... && sudo cp "$(BUILD_FOLDER)/Rogo" "$(INSTALL_FOLDER)/rogo")

uninstall:
	rm -rf $(BUILD_FOLDER) || (echo Retrying with sudo... && sudo rm -rf $(BUILD_FOLDER))
	rm -rf $(INSTALL_FOLDER)/rogo || (echo Retrying with sudo... && sudo rm -rf $(INSTALL_FOLDER)/rogo)

