@if "%VS90COMNTOOLS%"=="" goto check_vs2010
@call "%VS90COMNTOOLS%vsvars32.bat"
@goto editb

:check_vs2010
@if "%VS100COMNTOOLS%"=="" goto check_vs2012
@call "%VS100COMNTOOLS%vsvars32.bat"
@goto editb

:check_vs2012
@if "%VS110COMNTOOLS%"=="" goto check_vs2013
@call "%VS110COMNTOOLS%vsvars32.bat"

:check_vs2013
@if "%VS120COMNTOOLS%"=="" goto error_no_vs
@call "%VS120COMNTOOLS%vsvars32.bat"

:editb
@call editbin /LARGEADDRESSAWARE XviD4PSP.exe
@if errorlevel 1 @pause
@call editbin /LARGEADDRESSAWARE WPF_VideoPlayer.exe
@if errorlevel 1 @pause

@goto :eof

:error_no_vs
@echo ERROR: VS90COMNTOOLS, VS100COMNTOOLS, VS110COMNTOOLS, VS120COMNTOOLS variables aren't set.
@echo ERROR: Can't determine where to find Visual Studio Tools directory!
@echo ERROR: Run "editbin.exe /LARGEADDRESSAWARE XviD4PSP.exe" by yourself..
@echo ERROR: Run "editbin.exe /LARGEADDRESSAWARE WPF_VideoPlayer.exe" by yourself..
@pause

@goto :eof

----------

Or you can add this text to "Project->Properties->Build Event->Post-build event command line"
and XviD4PSP.exe will be patched during the compilation:

call "$(DevEnvDir)..\tools\vsvars32.bat"
editbin /LARGEADDRESSAWARE "$(TargetPath)"