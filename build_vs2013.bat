@ECHO OFF

CALL "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
msbuild /m /t:XviD4PSP /p:Configuration=Release /p:BuildProjectReferences=false XviD4PSP.sln
CD bin
CALL "4Gb patcher.bat"
PAUSE