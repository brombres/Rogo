@if not exist Build mkdir Build

call roguec Source/Rogo.rogue --main --output=Build\Rogo-Windows
cl /Ob2ity /GF /Gy /EHsc /nologo Build\Rogo-Windows.c /FoBuild\Rogo-Windows.obj /FeBuild\rogo.exe

@if "%~1" == "build" goto DONE
@echo Add the following to Environment Variables ^> User variables ^> Path:
@echo   %CD%\Build

:DONE

