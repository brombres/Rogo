@if not exist Build mkdir Build

roguec Source/Rogo.rogue --compile --compile-arg="/Ob2ity /GF /Gy" --output=Build\rogo

@echo Add the following to Environment Variables ^> User variables ^> Path:
@echo %CD%\Build
