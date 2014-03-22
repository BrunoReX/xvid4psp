@ECHO OFF

CALL "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
msbuild /m /t:XviD4PSP_2010 /p:Configuration=Release /p:BuildProjectReferences=false XviD4PSP_2010.sln
CD bin
CALL "4Gb patcher.bat"
PAUSE