@ECHO OFF

CALL "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
msbuild /m /t:XviD4PSP:clean /p:Configuration=Release /p:BuildProjectReferences=false XviD4PSP.sln
PAUSE