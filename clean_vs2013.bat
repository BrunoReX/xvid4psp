@ECHO OFF

CALL "%VS120COMNTOOLS%..\..\VC\vcvarsall.bat"
msbuild /m /t:XviD4PSP_2010:clean /p:Configuration=Release /p:BuildProjectReferences=false XviD4PSP_2010.sln
PAUSE