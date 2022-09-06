.PHONY: build

BUILD_FOLDER=Build
INSTALL_FOLDER=/usr/local/bin

ifeq ($(OS),Windows_NT)
  ifneq (,$(findstring /cygdrive/,$(PATH)))
      PLATFORM = Cygwin
  else
      PLATFORM = Windows
  endif
else
  UNAME_S := $(shell uname -s)
  ifeq ($(UNAME_S),Darwin)
    PLATFORM = macOS
  else
    PLATFORM = Linux
  endif
endif

all: install

build: $(BUILD_FOLDER)/Rogo-$(PLATFORM)

install: $(INSTALL_FOLDER)/rogo

$(BUILD_FOLDER)/Rogo-$(PLATFORM): Source/Rogo.rogue
	mkdir -p "$(BUILD_FOLDER)"
	roguec Source/Rogo.rogue  --main --output=Build/Rogo --target=Console,C,macOS
	cc -O3 -Wall -fno-strict-aliasing Build/Rogo.c -o $(BUILD_FOLDER)/Rogo-$(PLATFORM) -lm

$(INSTALL_FOLDER)/rogo: $(BUILD_FOLDER)/Rogo-$(PLATFORM)
	mkdir -p "$(INSTALL_FOLDER)" || (echo Retrying with sudo... && sudo mkdir -p "$(INSTALL_FOLDER)")
	cp "$(BUILD_FOLDER)/Rogo-$(PLATFORM)" "$(INSTALL_FOLDER)/rogo" || \
		(echo Retrying with sudo... && sudo cp "$(BUILD_FOLDER)/Rogo-$(PLATFORM)" "$(INSTALL_FOLDER)/rogo")

uninstall:
	rm -rf $(BUILD_FOLDER) || (echo Retrying with sudo... && sudo rm -rf $(BUILD_FOLDER))
	rm -rf $(INSTALL_FOLDER)/rogo || (echo Retrying with sudo... && sudo rm -rf $(INSTALL_FOLDER)/rogo)

