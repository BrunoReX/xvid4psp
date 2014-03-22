#define AppVer "5.10.333.0"

#ifexist "..\revision.h"
	#include "..\revision.h"
	#ifdef REVISION
		#define AppVer "5.10." + str(REVISION) + ".0"
	#endif
#endif

#include "embedded\plugins\idp\idp.iss"

#define AppExeName "XviD4PSP"
#define AppName AppExeName + " 5"
#define AppVerName AppExeName + " " + AppVer

[Setup]
AppName={#AppName}
AppVerName={#AppVerName}
AppPublisher=Winnydows & fcp team
AppPublisherURL=http://xvid4psp.googlecode.com/
AppSupportURL=http://xvid4psp.googlecode.com/
AppUpdatesURL=http://code.google.com/p/xvid4psp/downloads/list
AppMutex={#AppExeName}5_Setup
DefaultDirName={pf}\{#AppName}
DefaultGroupName={#AppName}
SetupIconFile=embedded\installer.ico
UninstallDisplayIcon={app}\{#AppExeName}.exe
OutputBaseFilename={#AppVerName}
DisableDirPage=auto
DisableProgramGroupPage=auto
ChangesAssociations=yes
AllowNoIcons=yes
LicenseFile=embedded\License.txt
WizardImageFile=embedded\WizardImage.bmp
WizardSmallImageFile=embedded\WizardSmallImage.bmp

[Files]
Source: "embedded\unzip.exe"; Flags: dontcopy
Source: "..\bin\SafeOpenDialog.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "..\bin\WPF_VideoPlayer.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "..\bin\XviD4PSP.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\vcredist_x86.exe"; DestDir: "{tmp}"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\aften\aften.exe"; DestDir: "{app}\apps\aften"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\aften\COPYING"; DestDir: "{app}\apps\aften"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\avc2avi\avc2avi.exe"; DestDir: "{app}\apps\avc2avi"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\avc2avi\license.txt"; DestDir: "{app}\apps\avc2avi"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\AVIMux_GUI.exe"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\AVIMux_GUI.exe.manifest"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\config.ini.amg"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\gui.amg.xml"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\gui_profiles\gui.cleartype.amg.xml"; DestDir: "{app}\apps\AVI-Mux\gui_profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\gui_profiles\gui.normalfont.amg.xml"; DestDir: "{app}\apps\AVI-Mux\gui_profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Language Files\English.lang"; DestDir: "{app}\apps\AVI-Mux\Language Files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\language_codes.txt"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\languages.amg"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Profiles\Profile - CDVD AVI.amg"; DestDir: "{app}\apps\AVI-Mux\Profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Profiles\Profile - low overhead.amg"; DestDir: "{app}\apps\AVI-Mux\Profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Profiles\Profile - Standalone AVI - AC3.amg"; DestDir: "{app}\apps\AVI-Mux\Profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Profiles\Profile - Standalone AVI - MP3.amg"; DestDir: "{app}\apps\AVI-Mux\Profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\Profiles\readme.txt"; DestDir: "{app}\apps\AVI-Mux\Profiles"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\rtfm.txt"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\silence files\FILL-2ch-192kbps.ac3"; DestDir: "{app}\apps\AVI-Mux\silence files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\silence files\FILL-6ch-1509kbps.dts"; DestDir: "{app}\apps\AVI-Mux\silence files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\silence files\FILL-6ch-384kbps.ac3"; DestDir: "{app}\apps\AVI-Mux\silence files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\silence files\FILL-6ch-448kbps.ac3"; DestDir: "{app}\apps\AVI-Mux\silence files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AVI-Mux\silence files\FILL-6ch-768kbps.dts"; DestDir: "{app}\apps\AVI-Mux\silence files"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\AvsP.exe"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\copying.txt"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\filterdb.dat"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\Microsoft.VC90.CRT.manifest"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\msvcm90.dll"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\msvcp90.dll"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\msvcr90.dll"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\python27.dll"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\_ctypes.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\_hashlib.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\_socket.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\_ssl.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\bz2.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\gdiplus.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\library.zip"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\select.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\unicodedata.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._controls_.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._core_.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._gdi_.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._misc_.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._stc.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wx._windows_.pyd"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxbase28uh_net_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxbase28uh_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxmsw28uh_adv_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxmsw28uh_core_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxmsw28uh_html_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\lib\wxmsw28uh_stc_vc.dll"; DestDir: "{app}\apps\AvsP\lib"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Bookmarks at Intervals.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Bookmarks to Chapter.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\ConditionalReader file from bookmarks.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\DeleteFrame.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\DuplicateFrame.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[01].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[02].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[03].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[04].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[10] ---.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[11].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[12].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[13].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[14].py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[20] ---.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[21] Customized.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[30] ---.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[31] rrr bilinear.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[32] rrr bicubic.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[33] rrr lanczos.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[34] RRR spline36.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[40] ---.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[41] ccc create new tab.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Example (Resize)\[42] CCC force mod 2.py"; DestDir: "{app}\apps\AvsP\macros\Example (Resize)"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[0] Template example.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[1] Batch example.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[2] Image processing.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[3] ---.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[3] Manual Telecide.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[4] Secondary preview.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[5] Encoding example.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[6] Encoding example 2.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Examples\[7] Optimize Sliders.py"; DestDir: "{app}\apps\AvsP\macros\Examples"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Import bookmarks from file.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\macros_readme.txt"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Preview from current point.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Random Clip Order.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Save Image Sequence.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\macros\Shift Bookmarks by frames.py"; DestDir: "{app}\apps\AvsP\macros"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\avs2avi.exe"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\avs2avi_gui.py"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\encoder_gui.py"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\MP3Info.py"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\resize_calc.py"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\ToolsMenu.py"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\x264.presets"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\AvsP\tools\xvid.presets"; DestDir: "{app}\apps\AvsP\tools"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\cfourcc\cfourcc.exe"; DestDir: "{app}\apps\cfourcc"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\Custom\fake.m4a"; DestDir: "{app}\apps\Custom"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\Custom\tools.ini"; DestDir: "{app}\apps\Custom"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\AVCQuickStart.html"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\DGAVCDecode.dll"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\DGAVCDecodeManual.html"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\dgavcindex.bmp"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\DGAVCIndex.exe"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\DGAVCIndex.ini"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\DGAVCIndexManual.html"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\libavcodec.dll"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\libavcodec.txt"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGAVCDec\ReadMeFirstAVC.html"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\Bugs_Limitations.txt"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\COPYING.txt"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGDecode.dll"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGDecodeManual.html"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGIndex.exe"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGIndex.ini"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGIndexManual.html"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGVfapi.txt"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\DGVfapi.vfp"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\FullChanges.html"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGMPGDec\QuickStart.html"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGPulldown\COPYING.txt"; DestDir: "{app}\apps\DGPulldown"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGPulldown\DGPulldown.exe"; DestDir: "{app}\apps\DGPulldown"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGPulldown\DGPulldown.txt"; DestDir: "{app}\apps\DGPulldown"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DGPulldown\GOPNote.txt"; DestDir: "{app}\apps\DGPulldown"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\DirectX_Update\dxwebsetup.exe"; DestDir: "{app}\apps\DirectX_Update"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\ffmpeg\COPYING.GPLv3"; DestDir: "{app}\apps\ffmpeg"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\ffmpeg\ffmpeg.exe"; DestDir: "{app}\apps\ffmpeg"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\ffmpeg\README.txt"; DestDir: "{app}\apps\ffmpeg"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\lame\lame.exe"; DestDir: "{app}\apps\lame"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\Launcher.exe"; DestDir: "{app}\apps"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\COPYING.txt"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\MKVcleaver.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\mkvextract.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\mkvinfo.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\mkvmerge.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\mkvpropedit.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MKVtoolnix\mmg.exe"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\js32.dll"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\libgpac.dll"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\License.txt"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\MediaInfo\MediaInfo.dll"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\MP4Box.exe"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\Yamb.exe"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\MP4Box\lang\English.ini"; DestDir: "{app}\apps\MP4Box\lang"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\neroAacEnc\download.txt"; DestDir: "{app}\apps\neroAacEnc"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\PgcDemux\lgpl.txt"; DestDir: "{app}\apps\PgcDemux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\PgcDemux\PgcDemux.exe"; DestDir: "{app}\apps\PgcDemux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\PgcDemux\ReadmePgcDemux.txt"; DestDir: "{app}\apps\PgcDemux"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\libgcc_s_sjlj-1.dll"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\libsoxconvolver.dll"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\libsoxr.dll"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\msvcp120.dll"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\msvcr120.dll"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\qaac.exe"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\qaac\refalac.exe"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\tsMuxeR\tsMuxeR.exe"; DestDir: "{app}\apps\tsMuxeR"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\tsMuxeR\tsMuxerGUI.exe"; DestDir: "{app}\apps\tsMuxeR"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\AuxSetup.exe"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\aviproxy\proxyoff.reg"; DestDir: "{app}\apps\VirtualDubMod\aviproxy"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\aviproxy\proxyon.reg"; DestDir: "{app}\apps\VirtualDubMod\aviproxy"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\aviproxy\readme.txt"; DestDir: "{app}\apps\VirtualDubMod\aviproxy"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\AviSynthLexer.lexer"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\Codecs.ini"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\copying"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\corona.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\license_corona.txt"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\ogg.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\plugins\readme.txt"; DestDir: "{app}\apps\VirtualDubMod\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\readme_virtualdubmod_dlls.txt"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\SciLexer.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\template\avisource.avst"; DestDir: "{app}\apps\VirtualDubMod\template"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\template\default.avst"; DestDir: "{app}\apps\VirtualDubMod\template"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\template\directshow.avst"; DestDir: "{app}\apps\VirtualDubMod\template"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\template\mpeg2dec.avst"; DestDir: "{app}\apps\VirtualDubMod\template"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\template\mpegdecoder.avst"; DestDir: "{app}\apps\VirtualDubMod\template"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\vdicmdrv.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\vdremote.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\vdsvrlnk.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\VirtualDub.vdhelp"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\VirtualDubMod.chm"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\VirtualDubMod.exe"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\VirtualDubMod.exe.manifest"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\VirtualDubMod.vdi"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\VirtualDubMod\vorbis.dll"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x262\x262.exe"; DestDir: "{app}\apps\x262"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264\avs4x264.exe"; DestDir: "{app}\apps\x264"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264\x264.exe"; DestDir: "{app}\apps\x264"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264\x264_64.exe"; DestDir: "{app}\apps\x264"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264_10b\avs4x264.exe"; DestDir: "{app}\apps\x264_10b"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264_10b\x264.exe"; DestDir: "{app}\apps\x264_10b"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264_10b\x264_64.exe"; DestDir: "{app}\apps\x264_10b"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\1.2.2\aviwriter.dll"; DestDir: "{app}\apps\xvid_encraw\1.2.2"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\1.2.2\xvid_encraw.exe"; DestDir: "{app}\apps\xvid_encraw\1.2.2"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\1.2.2\xvidcore.dll"; DestDir: "{app}\apps\xvid_encraw\1.2.2"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\xvid_encraw.exe"; DestDir: "{app}\apps\xvid_encraw"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\xvidcore.dll"; DestDir: "{app}\apps\xvid_encraw"; Components: Main; Flags: ignoreversion
Source: "{app}\Changelog_eng.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\Changelog_installer_eng.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\Changelog_installer_rus.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\Changelog_rus.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\AviSynthWrapper.dll"; DestDir: "{app}\dlls\AviSynth"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\functions\AudioFunctions.avs"; DestDir: "{app}\dlls\AviSynth\functions"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\functions\VideoFunctions.avs"; DestDir: "{app}\dlls\AviSynth\functions"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\a60224.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\aa.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AAD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ab16.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\acobw.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\acobw_sse2.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AdaptDBMC_beta.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AddGrain.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AddGrainC.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AGC.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ALBR-1.0.2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AllInclude.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ALMerge_v1.3.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AnimeIVTC - v1[1].06.1mod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AnimeIVTC 2.00.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AnimeIVTC 2.12.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\asharp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AutoCrop.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AutoGain.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\autolevel.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\autolevels.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\autolevels_0.6.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\automttap3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AutoYUY2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Average.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\avsfilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AvsFilterNet.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\AVSInpaint.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\avss.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\avstimer.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\avstimerF.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\avstp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\aWarpSharp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\aWarpSharp2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\badframes.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BalanceBorders.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_aac.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_ac3.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_adx.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_alac.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_ape.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_cda.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_flac.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_mpc.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_ofr.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_spx.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_tta.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_wadsp.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_wma.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bass_wv.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\bassAudio.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bass\OptimFROG.dll"; DestDir: "{app}\dlls\AviSynth\plugins\bass"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bifrost.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BitDepth.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Blah.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlendBob.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlindDeHalo3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlindDeHalo3_mt2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlowUp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlowUp_mod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BlowUpmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\bob_repair.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\BT709ToBT601.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\C_DeblockSolutions.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\C_Shortcuts.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Calm.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ccc.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ccc720.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ccd_sse2.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Cdeblend.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Cdeblend_v1.1b.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\cg.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\cgGL.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\checkmate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ChromaShift.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ChubbyRain2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Cloo.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\cnr2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ColorMatrix.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Combi_DeInterMotion.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ConditionalSmoothBob.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Contra.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ContraHD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ContraMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ContraSharpen_mod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ContraSharpen_mod_16.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ContraSharpening.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ConvertTofix.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Convolution3D.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\corrector.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\CullResize.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\daa3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Dbilateral 4.32.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DCT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DctFilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DctFilter_YUY2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dctfun4b.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\De.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deathray.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeBand.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeBanding.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeBarrel.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeBlend.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\deblock.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeBlock.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deblock_QED_MT2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deblock_QEDmod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Decomb.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeCross.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeCrow.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeDup.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deen.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\deen_1.0.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\defish.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deflick.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\deflicker.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\defreq.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\degrainmedian.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DegrainX.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dehal_crap2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeHalo_2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeHalo_alpha.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeHalo_alpha_2BD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeHaloH.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeintPart.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeJitter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Demo.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Demosaic.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Denoise.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DenoiseMD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DenoiseSharpen.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DePan.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DePanEstimate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DePulse.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DePulseC.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeRainbow.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeRainbow2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeSaltPepper.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\descratch.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Deshaker.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\despot.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Destripe 03.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DeStripe.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Destripemod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\deVCR.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dfttest.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dfttestMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dfttestmod.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dither.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\dither.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Dnr2_for_25.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\??????????? ?? ??????? Deshaker.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\???_EN.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AAD (???? ????? Decomb) ??????????? ????????????.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AAD_015a - Read me (chs).html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AddGrain.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AnimeIVTC 2.00-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\asharp.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AutoCrop.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AutoGain.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\autolevels.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Autolevels_ReadMe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AutoYUY2Help.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\AVSInpaint.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\aWarpSharp.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\aWarpSharp2 eu-rus.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\aWarpSharp2.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\badframes-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\bifrost.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\BlendBob_ReadMe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\changelog.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\chromashift.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Cnr2.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\colormatrix.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\corrector-rus.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\dbilateral.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Deathray readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeBarrel.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeBlock.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeBlock.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeCross.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Deen.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\defish.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\degrainmedian-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeJitter.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeNoise.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\depan-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\depulse.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\depulsec.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DeSaltPepper.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\despot-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Destripe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\dfttest - README.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\dfttest - README_rus.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\dfttest_mod - README.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\directshowsource.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\dither.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\DustReadMeV5.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\EEDI3 - Readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\exinpaint-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Exorcist.mht"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\FanFilter.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\ffmpegsource.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\FFMPEGSOURCE_COPYING.GPL"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\ffms2-avisynth.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\ffms2-changelog.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\fft3dfilter-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\fft3dgpu.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\flash3kyuu_deband.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\FQFocusDefocus.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\frfun3b.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\frfun3d.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\frfun7.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\german.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\gnoise.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\gpl-rus.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\hd2sd.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\hdragc-help.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\hqdn3d.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\HybridFuPP 0991b Readme en.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\HybridQ.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\img\earthlights_small1.png"; DestDir: "{app}\dlls\AviSynth\plugins\Docs\img"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\img\earthlights_small2.png"; DestDir: "{app}\dlls\AviSynth\plugins\Docs\img"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\InpaintFunc - Avisynth.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\InterFrame.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\InterFrame2.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\LeakKernelDeintHelp.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\loaddll.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MaskTools.mht"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mc_spuds.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MosquitoNR.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mrestore.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MSharpen.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MSU_FRC.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MT.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mt_masktools.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mt_masktools.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\MVExtras.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mvtools2.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mvtools2mod.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mvtools2-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\mvtools-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\NicAudio Readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\nnedi.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\nnedi2 - Readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\nnedi3 - Readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\PointSize_readme.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\QTGMC-3.32.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\QTSource_usage.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\rawsource.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Readme_UnDot.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\RedAverage.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\RemapFrames.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\RemoveDirt.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\RemoveGrain.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\RemoveGrainHD.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\repal.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\ResampleHQ.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\rotate-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SangNom.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\Sashimi.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\sd2hd.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\smooth_hiq_as.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SmoothAdjust.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SmoothDeinterlacer.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SoftSharpen.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SoftSharpen.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\SoxFilter.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TBilateral - ReadMe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\tcanny - ReadMe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TComb - ReadMe.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TDecimate - READ ME.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\tdeint.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\tdeint_rus.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TFM - READ ME.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TIVTC - READ ME.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TMM - READ ME.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TNLMeans - Read Me.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\TomsMoComp.htm"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\unblock.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\unsharpHQ.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\unsharpHQ_v04.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\vaguedenoiser-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\VariableBlur.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\VSFilter.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\yadifmod.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\yadif-rus.html"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Docs\yv12torgb24hq.txt"; DestDir: "{app}\dlls\AviSynth\plugins\Docs"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DoubleFPS.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Down10.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Dup.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\DustV5.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EdgeCleaner.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ediaa.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EDImod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EEDI2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EEDI2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EEDI2_imp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EEDI2AA.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\eedi3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\EnhancePAL.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ESharpAAMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ExBlend.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ExBorders.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\exinpaint.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Exorcist.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\f3kgrain_v0.4.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FanFilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FastLineDarken 1.4x MT MOD.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FastLineDarkenMod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FDecimate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FFMpegSource.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FFMS2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ffms2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ffmsindex.exe"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FFT3DFilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FFT3dGPU.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\fft3dgpu.hlsl"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\filldropsI.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FillMargins.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FilterCompare_v0.1.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\findpos_h.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FineSharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\firniture.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FixBlendIVTC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FizzKiller.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\flash3kyuu_deband.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FlatMask.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Flux5framesT.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FluxSmooth.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Focus.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FQFocusDefocus.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\frfun3b.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\frfun3d.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\frfun7.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\fslg_dither_to_n_bits.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\fsn.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\FSx.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ftoon.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ftoon2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GetDups.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GetSystemEnv.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\gnoise.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\gradfun2db.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GradFun2DBmod 1.5.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GradFun2DBmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GradFunkMirror.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainFactory3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainFactory3mod_v1.2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainFactoryLite_v1.2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainOpt.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainStabilize_v0.3.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrainStabilizeMC_v0.4.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GrapeSmoother.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\GScript.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\gsharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\hd2sd.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HighPassSharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HighPassSharpen.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\hipsharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\histogram_luma_16.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HPblur.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\hqd.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HQDegrain.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HQDering.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HQDeringmod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\hqdmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\hqdn3d.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\HybridFuPP.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ILU.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ILUT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\InpaintFunc.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\InterFrame.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\InterFrame2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Interlacing2Reader.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\InterleavedConversions.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\jdl-interlace.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\jdl-util.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Killer.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Killer_VG.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Lanczosmtplus.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LeakKernelDeint.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LEM.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LGhost.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\libflowgpu.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\libflowsse.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LimitedRemoveDust.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LimitedSharpenFaster MOD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LimitedSharpenFaster.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LimitedSupport_09Jan06B.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\linedarken_toon.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LoadDll.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LoadPluginEx.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LRemoveDust.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LSDlite.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LSDvlite.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LSharpAAF.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LSharpAAF.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LSMASHSource.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LumaDB_v0.7.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LumaDBLite_v0.7.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LumaMask.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LUTDeCrawl.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\LUTDeRainbow.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\maa.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\madResize.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\makediff16.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Masked_DHA.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MasksPack.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MaskTools.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MaskTools149.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\matchclips.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MC_Spuds.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MC_Spuds_mvt.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MC_SpudsMod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCAA.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCaWarpSharp2.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCBob.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCBob_mod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCBob_v03u5_MVT2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCBobmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCBobUv6.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCDegrain.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCDegrainmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\McDegrainSharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCGRMultiSE.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCTDmod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MCTemporalDenoise.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MDegrain2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MDegrain2i2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MDegrain2i2_CS.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Median1.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Median2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\medianblur.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MedSharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MedSharp2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MedSharpD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MessageClipEx2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mfToon-v0.52.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mfToon-v0.54.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mfToon-v0.74.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MinBlur.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\minblur3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MinMapBlur.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\minmax.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MipSmooth.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ML3DexGPU.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MosquitoNR.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Motion_12Dec05.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MotionProtectedFPS.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MPEG2DEC_ER.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MPEG2DEC2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mrestore.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mrestore_v23e.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MSharpen.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MSR_mod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MSRmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MStabilize v1.0.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\msvcp110.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\msvcr100.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\msvcr110.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mt_masktools-25.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mt_masktools-26.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mt_xxpand_multi.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MTstack.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\muksun.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MultiAdjust.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MultiSWAR_V2-Beta4.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MVDouble.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\MVExtras.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtools.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtools2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtools2mod.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtools2svp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtools2T.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\mvtoolsMT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NCPP.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NeatVideo.dat"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NeatVideo.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NicAudio.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NLMeansCL_netautoload.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\nnedi.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\nnedi2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\nnedi3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NNEDI3AA.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NNEDI3resize.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\nnediaa.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NoiseGenerator.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NoMoreMoire_a2_MT.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NoMoreMoire_a3.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NonlinUSM.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\nrLSResize.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\NSLF 3D.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\O16mod_v1.6.1.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\optimoz.css"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\PlanarConversions.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\PlaygroundPack.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\PNLM.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\PointSize.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ProcessLine.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\qqfix.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\QSdeinterlace.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\QTGMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\QTGMC-3.33d.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\QTSource.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RAA.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rainbow_smooth.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rainbow_smooth2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RangeFix.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rawsource.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RawSource_2.5x.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rawsource-25.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rawsource-26.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\readv210new.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ReCon.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RedAverage.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ReduceFlicker.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ReduceFlickerSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ReduceFlickerSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemapFrames.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveColorBleeding.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\removecrap3C2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirt.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirt.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirt09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtMC_03.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtMC_SE 1.0.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtMC_SE.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtS09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveDirtSSE209.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrain.cpp"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrain.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrain09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainHD.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainHDS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainS09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainSSE209.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainSSE309.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainTSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveGrainTSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveNonBobDiff.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RemoveSpots.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Repair.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\repair_ff.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Repair09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairS09.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairSSE209.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairSSE309.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairTSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RepairTSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\repal.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ReplaceFramesMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\resamplehq-x86.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ResizersPack.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RestoreFPS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\rgbhack.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RGBManipulate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Rm_logo.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Rotate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpen.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenT.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenTSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\RSharpenTSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\s_ExLogo.AVS"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SAA.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SangNom.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\sangnom2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\santiag.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\santiag2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SantiagMod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Sashimi.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\sbr.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SCDetect.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Scripted_MVDegrain5.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\sd2hd.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SDIAdapt.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SeeSaw.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SelSah_v1.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SelSah_v2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SeparateFieldsMod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SeparateResize_v1.6.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SharpAAMCmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ShowHistMod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SimpleResize.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SimpleSampleNet_netautoload.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SimpleSlugUpscale.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmartFFT.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmartSSIQ.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SMDegrain.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothAdjust-ICL-x64.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothAdjust-ICL-x86.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothAdjust-MSVC-x64.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothAdjust-MSVC-x86.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothContrast.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothD2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothDeinterlacer.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothHiQ.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\smoothnnedi3bob.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SmoothUV.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SoftCubicResize.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SoftSharpen.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Soothe.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SootheCl.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\soxfilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SplineResize.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SpotRemover.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SpotRemover.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Spresso.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SpressoY.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\srestore.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\srestore_v265.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ss_resize.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSE2Tools.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSE3Tools.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSETools.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSEToolsS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ssiq.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ssr.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSSharp.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SSSharpFaster.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Stab.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Stint_v1.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\STPresso.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\SubtitleEx.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\supa_degrain.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\super_tc.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\sv.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\svpflow_cpu.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\svpflow_gpu.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\svpflow1.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\svpflow2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\t_linecandy.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TAA.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TBilateral.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Tblur4.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TblurNL.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\tcanny.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TComb.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TDeint.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TdeintTMMnnedi2up.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TEdgeMask.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempGaussMC_beta1mod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempGaussMC_beta1mod_rus.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempGaussMC_beta1mod2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempGaussMC_beta2.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempGaussMC_beta2u.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TempLinearApproximate.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalCleaner.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDegrain.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDegrain_beta.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDegrain_ChromaMod V1.0.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDegrain_MT.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDegrainmt.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TemporalDfttestMC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TGMC_SVP_Test.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TGMCmod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TIVTC.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TMM.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TNLMeans.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TomsMoComp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Toon.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Toon-v1.0.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Toon-v1.1.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TTempSmooth.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Tweak.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\tweak3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\TweakColor.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\U16.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\unblend.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\unblock.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\UnDot.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\UnFilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Unflicker.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Unsharp.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\unsharpen.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\unsharpHQ_v03fix.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\unsharpHQ_v04.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VagueDenoiser.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VariableBlur.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VariableBlur1.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VerticalCleaner.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VerticalCleanerS.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VerticalCleanerSSE2.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VerticalCleanerSSE3.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Video_Size_Edition.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Vinverse.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\vinverse.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VinverseD.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VinverseDenoise.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\vmToon-v0.74.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VScope.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\VSFilter.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\WarpSharp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\WarpSharp_2007.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\whitebalance.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\yadif.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\yadifmod.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YAHR.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YAHRmod.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\yats.vdf"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YBFR.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YFRC.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YLevels.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ysharp.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\Yushko.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YUVInterleaved.avsi"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YUY2ToYV12i.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\yv12torgb24hq.dll"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YV12ToYUY2i.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YV12ToYUY2i_26.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\YV12ToYUY2imod.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\ZoomBox.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\zzz_denoise.avs"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\avcodec-lav-55.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\avfilter-lav-4.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\avformat-lav-55.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\avresample-lav-1.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\avutil-lav-52.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\COPYING"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\IntelQuickSyncDecoder.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\LAVAudio.ax"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\LAVSplitter.ax"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\LAVVideo.ax"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\libbluray.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\swscale-lav-2.dll"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\MediaInfo\License.html"; DestDir: "{app}\dlls\MediaInfo"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\MediaInfo\MediaInfo.dll"; DestDir: "{app}\dlls\MediaInfo"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\DirectShowLib-2005.dll"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\License (DirectShowLib).txt"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\License (SharpDX).txt"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\MediaBridge.dll"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\SharpDX.DirectSound.dll"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\Player\SharpDX.dll"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\VStrip\history.txt"; DestDir: "{app}\dlls\VStrip"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\VStrip\license.txt"; DestDir: "{app}\dlls\VStrip"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\VStrip\vStrip.dll"; DestDir: "{app}\dlls\VStrip"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\??????? ???????????? ?? ????????????? ??????? ??.docx"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\???????? ??????? ???????? ??? ??? ???????? ??? ????????? ???????????? ?? ???????? ????.txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\??????????? ??????????? ??????? XviD+ VAQ.txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\???????????? ? ?????????? Colormatrix.txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\About filtering (by Tempter57).txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\LICENSE LSMASHSource.txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\docs\MT-modes.txt"; DestDir: "{app}\docs"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Chinese.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\English.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Estonian.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\French.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\German.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Hebrew.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Hungarian.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Italian.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Portuguese.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Russian.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Spanish.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\languages\Ukrainian.txt"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion
Source: "{app}\License_eng.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\License_rus.txt"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\3GP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\Custom.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\3GP\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\3GP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\FLAC Fast.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\FLAC Slow.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\qAAC ALAC.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Audio\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\Audio\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI DV NTSC\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\AVI DV NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI DV NTSC\video\DV Video.txt"; DestDir: "{app}\presets\encoding\AVI DV NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI DV PAL\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\AVI DV PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI DV PAL\video\DV Video.txt"; DestDir: "{app}\presets\encoding\AVI DV PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\MPEG4 1P 3000k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\MPEG4 2P 3000k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD 1P 3000k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD 2P 3000k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD 2P 3000k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware HD\video\XviD Q2.0 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware HD\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\MPEG4 1P 1500k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\MPEG4 2P 1500k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.08 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.08 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.37 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.37 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.46 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1.46 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1100k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1300k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1300k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1500k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1500k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1500k MTK 6000 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1500k MTK 6000 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1500k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1700k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1700k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1700k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1900k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1900k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1900k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 1CD Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 2.18 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 2.18 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 2000k MTK (QPel).txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 275 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 293 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 367 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 450 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 464k Mobile Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 500 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 500 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 554 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 554 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 700 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 740 mb Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 740 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P 900k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD 2P TEST.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q2.0 Balanced.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q2.0 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q2.0 Fast.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q2.0 HQ.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q3.0 Balanced.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q3.0 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Hardware\video\XviD Q3.0 HQ.txt"; DestDir: "{app}\presets\encoding\AVI Hardware\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP2 224k.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI iRiver Clix 2\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI iRiver Clix 2\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP2 224k.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\MPEG4 2P 640k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI Meizu M6\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI Meizu M6\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\AVI\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\FFV1 LossLess.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\HUFF LossLess.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MJPEG 3000k.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MJPEG HQ.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MPEG4 1P 1500k Turbo.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MPEG4 2P 1500k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.08 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.08 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.37 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.37 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.46 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1.46 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1100k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1300k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1300k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1500k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1500k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1500k MTK 6000 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1500k MTK 6000 Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1500k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1700k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1700k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1700k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1900k Cartoon.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1900k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1900k Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 1CD Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 2.18 GB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 2.18 GB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 2000k MTK (QPel).txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 275 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 293 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 367 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 450 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 464k Mobile Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 500 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 500 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 554 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 554 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 700 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 740 MB Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 740 MB Ultra.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P 900k Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD 2P TEST.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q2.0 Balanced.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q2.0 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q2.0 Fast.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q2.0 HQ.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q3.0 Balanced.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q3.0 Extreme.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\AVI\video\XviD Q3.0 HQ.txt"; DestDir: "{app}\presets\encoding\AVI\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\BluRay\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q1 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q2 Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q2 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q3 2P Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q3 Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\MPEG2 Q3 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 16384k 2P Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 16384k 2P Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 4450MB 2P Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 4450MB 2P Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 8150MB 2P Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 8150MB 2P Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 1080i25.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 1080i30.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 1080p24.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 480i30.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 480p24.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 576i25.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 576p25.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 720p24.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 720p50.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Blu-Ray 720p60.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q16 Extreme.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q16 Medium.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q16 Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q16 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q18 Extreme.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q18 Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q18 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q21 2P Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q21 Extreme.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q21 Turbo.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\BluRay\video\x264 Q21 Ultra.txt"; DestDir: "{app}\presets\encoding\BluRay\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\qAAC ALAC.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\Custom\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\FFV1 LossLess.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\HUFF LossLess.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MJPEG 3000k.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MJPEG HQ.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MPEG4 1P 1500k Turbo.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MPEG4 2P 1500k Ultra.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P DVD5 Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 2P Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD 1P 1500k Turbo.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\Custom\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\Custom\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\audio\MP2 128k.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 1P 384k Ultra.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 2P 384k Ultra.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\DPG Nintendo DS\video\MPEG1 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\DPG Nintendo DS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 CBR 96k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\FLV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 1P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 2P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\FLV1 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 1P 1000k HQ.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 2P 768k HQ.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 Q22 Fast.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 Q22 HQ.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 Q22 HQS.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\FLV\video\x264 Q22 Insane.txt"; DestDir: "{app}\presets\encoding\FLV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\M2TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q1 Ultra.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q2 Turbo.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q2 Ultra.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q3 2P Ultra.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q3 Turbo.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\MPEG2 Q3 Ultra.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x262 MainProfile-High1440Level.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x262 MainProfile-HighLevel.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x262 MainProfile-MainLevel.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P DVD5 Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 2P Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\M2TS\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\M2TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\FLAC Fast.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\FLAC Slow.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\qAAC ALAC.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MKV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P DVD5 Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 2P Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MKV\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MKV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR Q100.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AAC-LC VBR Q90.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MOV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MOV\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MOV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR Q100.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\AAC-LC VBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Apple TV\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Apple TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 1P 1536k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 2P 1536k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 2P 1536k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD 1P 1536k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD 2P 1536k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD 2P 1536k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Archos 5G\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Archos 5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8100\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8100\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8800\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 BlackBerry 8830\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 BlackBerry 8830\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 1P 768k Fast.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 512k HQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 512k HQS.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 512k Insane.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 600k GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 600k HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 600k HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 2P 768k GQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q21 GQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q21 HQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q21 HQS.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q21 Insane.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q22 GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q22 HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\x264 Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPhone or Touch\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPhone or Touch\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.0G\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.0G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 1P 768k Fast.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 512k HQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 512k HQS.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 512k Insane.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 600k GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 600k HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 600k HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 2P 768k GQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q21 GQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q21 HQ.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q21 HQS.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q21 Insane.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q22 GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q22 HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\x264 Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 iPod 5.5G\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 iPod 5.5G\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Motorola K1\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Motorola K1\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 2P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\x264 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD 2P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Nokia 5700\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Nokia 5700\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Prada\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Prada\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\video\x264 Q21 Fast.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PS3 or XBOX360\video\x264 Q21 HQ.txt"; DestDir: "{app}\presets\encoding\MP4 PS3 or XBOX360\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP ASP\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 PSP ASP\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 1P 768k Fast.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 512k HQS-LB.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 600k GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 600k HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 600k HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 600k Insane Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 608k GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 608k HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 608k HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 608k Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 768k GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 768k HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P 768k HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 2P Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q21 GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q22 GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q22 HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC TV\video\x264 Q22 Insane Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC TV\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 1P 768k Fast.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 512k HQS-LB.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 600k GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 600k HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 600k HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 600k Insane Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 608k GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 608k HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 608k HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 608k Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 768k GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 768k HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P 768k HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 2P Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q21 GQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q22 GQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q22 HQ Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q22 HQS Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 PSP AVC\video\x264 Q22 Insane Animation.txt"; DestDir: "{app}\presets\encoding\MP4 PSP AVC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 CBR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD 2P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K610\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K610\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 CBR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD 1P 512k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD 2P 512k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD 2P 512k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 SonyEricsson K800\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 SonyEricsson K800\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\AAC-LC ABR 96k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\MP3 ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\qAAC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\MPEG4 2P 640k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\MPEG4 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\MPEG4 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\MPEG4 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\XviD 2P 640k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4 Toshiba G900\video\XviD HQ3 Ultra.txt"; DestDir: "{app}\presets\encoding\MP4 Toshiba G900\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\MP4\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P DVD5 Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 2P Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD 1P 768k Turbo.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD 2P 768k Extreme.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD 2P 768k Ultra.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD HQ Extreme.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MP4\video\XviD HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MP4\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 1P 2000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 1P 2500k Turbo.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 2P 2000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG1 PS\video\MPEG1 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG1 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 1P 8000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 2P 8000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 CBR 9200k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\MPEG2 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 NTSC\video\x262 NTSC.txt"; DestDir: "{app}\presets\encoding\MPEG2 NTSC\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 1P 8000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 2P 8000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 CBR 9200k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\MPEG2 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PAL\video\x262 PAL.txt"; DestDir: "{app}\presets\encoding\MPEG2 PAL\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\MPEG2 1P 10000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\MPEG2 2P 10000k Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\MPEG2 HQ Turbo.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\MPEG2 HQ Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\MPEG2 HQ2 Ultra.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\x262 MainProfile-High1440Level.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\x262 MainProfile-HighLevel.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\MPEG2 PS\video\x262 MainProfile-MainLevel.txt"; DestDir: "{app}\presets\encoding\MPEG2 PS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-HE ABR 64k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-HE CBR 64k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-HEPS ABR 32k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-HEPS ABR 48k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC ABR  96k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC ABR 128k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC ABR 192k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.35.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.40.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.45.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.50.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.60.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 0.90.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AAC-LC VBR 1.00.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AC3 192k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AC3 256k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AC3 384k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AC3 448k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\AC3 640k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP2 192k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 CBR 128k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 CBR 192k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 CBR 256k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 CBR 320k Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 VBR Q0 Quality.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\MP3 VBR Q4.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\PCM 16bit.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\qAAC ABR 228k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\qAAC HE-AAC 64k.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\audio\qAAC TrueVBR Q90.txt"; DestDir: "{app}\presets\encoding\TS\audio"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q1 Ultra.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q2 Turbo.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q2 Ultra.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q3 2P Ultra.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q3 Turbo.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\MPEG2 Q3 Ultra.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x262 MainProfile-High1440Level.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x262 MainProfile-HighLevel.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x262 MainProfile-MainLevel.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P 2xCD Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P DVD5 Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 2P Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Lossless.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q18 Fast.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q18 HQ.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q18 HQS.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q18 Insane.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-HD-HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-HD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-HD-Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-SD-HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-SD-HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 DXVA-SD-Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 HQ Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 HQS Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q21 Insane Film.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-HD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-HD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-HD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-SD-HQ Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-SD-HQS Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 DXVA-SD-Insane Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 HQ Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 HQS Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\encoding\TS\video\x264 Q22 Insane Animaton.txt"; DestDir: "{app}\presets\encoding\TS\video"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\ffrebuilder\MKV CRF x264-Vorbis.txt"; DestDir: "{app}\presets\ffrebuilder"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\ffrebuilder\OGV 1000k Theora-Vorbis.txt"; DestDir: "{app}\presets\ffrebuilder"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\ffrebuilder\WEBM 1500k VP8-Vorbis.txt"; DestDir: "{app}\presets\ffrebuilder"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\filtering\1.Info.avs"; DestDir: "{app}\presets\filtering"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\filtering\10 bit Anime DeBanding.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10 bit Anime MC1 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10 bit DeBanding.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Anime DHMC1 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Anime Dither DNDB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Anime DnDFT.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Anime MCAA.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Anime TAA.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Convert.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit DBHP.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit DenoiseMD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Gradfun2DBmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit MCTDmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit SMDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit STpresso.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\10bit Upscale SD_HD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\ACOBW.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime AAA Up.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Blendbob.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime chroma DeBland.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime CSmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Deblock.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime DHMC1 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime DHMC1.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime DHMC2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Dither DBM.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Dither DNDB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime HD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime LSharpAAF.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime magic.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime MCTDmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime MD2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime MDegrain2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Mmulti GF3.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime old Median1 STB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime old stabilization.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Quality transdithering.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime Slower.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime SMDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime TAA CSmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime TAA.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime YouTube.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Anime.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AnimeIVTC 2.00 DHMC1 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AnimeIVTC 2.00 DHMC1.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AnimeIVTC 2.00 HD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AnimeIVTC_1.06.1mod Multi.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AVCHD MCompensate.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AVCHD MCompensate2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\AVCHD MDegrainN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD DeGrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD Denoice.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD HQDeringmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD hqdn3d.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MCompensate Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MCompensate.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MCompensate2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MDegrain1 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MDegrain2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MDR2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MedianCompensate.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD MedianDegrain2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD Multi MCDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD SPresso.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BD TemporalDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BlowUp.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\BlowUpmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Cartoon DeBland.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Cartoon Degrainless.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Cartoon MC2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Cartoon QTGMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Cartoon SMDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Deblock dfttestMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Deblock.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Deblock_ FFT .avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DeHalo Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DeHalo_2BD MDegrainN.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DeSpot.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC  Fizzkiller.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC Despot.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC MDegrain2i2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC MDegrain3_2 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC MDegrainN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC Molotov Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC QTGMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC RemoveDirt HLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC RemoveDirtMC_SE 1.0.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC RemoveDirtMC_SE.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC TemporalDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC_VHS Deflicker.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVC_VHS RemoveDirtMC_SE.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD DDN MMB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD DeCrawl NTSC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD DeDotCrawl NTSC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Deflicker Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD dfttest Deblock.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD dfttestMC LSF.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD exelent.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD FizzKiller.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD FustSoft.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD HybridFuPP.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Killer Flux5framesT.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Killer.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MC Flux5fT.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MCDS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MCompensate.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MCompensate2 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MD2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain1 AG.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain1 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain2 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain2 mask4 Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain2 mask4 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain2 mask4_IF.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain2 pc mask4 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrain3 mask6 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN BG.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN CF.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN MedSharp.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN NLM.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN ReCon.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN S.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN SL.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDegrainN SLux.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD MDMC21.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Molotov Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Old STB_DB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD RemoveDirt Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD RFK Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD Twister Sharpen.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_BW MDegrain3  DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_BW TD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_SAT Gsharp.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_SAT PRE QTGMC .avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_SAT QTGMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\DVD_SAT RemoveDirtMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\FFT3DFilter DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\FFT3DFilter DS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\FFT3DGPU DS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\FractalDenoising Cartoon.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\FractalDenoising LS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\GrainStabilizeMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDTV DDN MMB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV MCompensate.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV MDegrainN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV Molotov1i1.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV MolotovN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV TemporalDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV_DV.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV_DVD QTGMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\HDV2SD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\InterFrame.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\InterFrame2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\LEM.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\LSFmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MC_Spuds Cartoon.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MC_Spuds Deblock.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MC_Spuds.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MC_Spuds_mod Flow.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MC_Spuds_mod MD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCDegrain AA.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\McDegrainSharp.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCGRMultiSE.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCTDmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCTemporalDenoise Cartoon.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCTemporalDenoise DB.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MCTemporalDenoise.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\MSRmod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\QTGMC BadDeInt.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\QTGMC DeRainbow Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\QTGMC DeRainbow.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\QTGMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\RemoveDirt MDegrain2i2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\RePal.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\RestoreFPS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT DeBlend Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT Deblock Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT DeCrawl.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT FFT.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT FustMiddle.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT FustSoft.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT LEM.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MCDS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MCGRMultiSE.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MCompensate Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MD2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDC1.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrain1 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrain2 BL.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrain2 CF.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrain2 DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrain2 NLM.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDegrainN Dither.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDMC11.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT MDMC21.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT Median Fust.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT SMDegrain.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SAT Twister Sharpen.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SD2HD.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SeeSaw.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SimpleSlugUpscale.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\SpotRemover.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Srestore.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TemporalCleaner LS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TemporalDegrain_beta.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TemporalDegrain_ChromaMod.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TemporalDfttestMC.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Test DeInterlaced.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TGMC_SVP_Test.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TV Fizzkiller.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TV MDegrain2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TV molotov2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TV_SAT Molotov2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\TV_SAT2.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VC FFT.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VC FSN.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS Cam3 LS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS Depulse yup.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS Depulse.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS DLS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS Fizzkiller.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS Magic.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS MDegrain2 LS.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\VHS RemoveDirt.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\filtering\Zamedlenie.avs"; DestDir: "{app}\presets\filtering"; Components: Plugins; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Acailas.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Andreas 78er.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Andreas DivX Quelle.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Andreas Doppelte 99er.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Andreas Einfache 99er.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Andreas SVCD.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Angel Best Low.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Angel Best Very Low.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\AUTO-Q1.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\AUTO-Q2.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\AVAMAT6.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Bulletproof's Heavy Compression.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Bulletproof's High Quality.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\CCE Smooth (CG etc.).cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\CCE Ultra Low Bitrate.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\CCE Very Low Bitrate.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Didees SixOfNine.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Didees SixOfNine-HVS.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\EthanoliX Four Rooms.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Fl0ppy iVCD.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Fl0ppy Packed DVD.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Fox Home Entertainment.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\HC.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\heini_mr.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\HVS Best Picture.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\HVS Better Picture.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\HVS Good Picture.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Jawor_2CD_Matrix.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Jawor_ZSM.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Jawor's 1CD Quantization.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Kika Trickfilm High.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Kika Trickfilm Low.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\KVCD 320x432 CQ65.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\KVCD 448x320 CQ65.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\KVCD Notch.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Low Bitrate Matrix.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Max GE 1900 kbps.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Max LT 1900 kbps.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\MVCD 2.6.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Professional.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\QLB.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM V1.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v2.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v3EHR.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v3HR.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v3LR.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v3UHR.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Sharktooth's EQM v3ULR.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Soulhunters V3.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Soulhunters V5.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Soulhunters V6.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Soulhunters V8 (HVS3).cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\TMPEGEnc CG.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\Ultimate.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\cqm\YACQM.cqm"; DestDir: "{app}\presets\matrix\cqm"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\matrices.zip"; DestDir: "{app}\presets\matrix"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\txt\KVCD Notch.txt"; DestDir: "{app}\presets\matrix\txt"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\matrix\txt\MPEG.txt"; DestDir: "{app}\presets\matrix\txt"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\sbc\GhostsBusters MPEG2Fix.avs"; DestDir: "{app}\presets\sbc"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\sbc\GhostsBusters.avs"; DestDir: "{app}\presets\sbc"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\sbc\MPEG2Fix.avs"; DestDir: "{app}\presets\sbc"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\sbc\Vivid MPEG2Fix.avs"; DestDir: "{app}\presets\sbc"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\sbc\Vivid.avs"; DestDir: "{app}\presets\sbc"; Components: Main; Flags: ignoreversion
Source: "{sys}\avsfilter.dll"; DestDir: "{sys}"; Components: Main; Flags: restartreplace uninsrestartdelete 
Source: "{sys}\AvsRecursion.dll"; DestDir: "{sys}"; Components: Main; Flags: restartreplace uninsrestartdelete 
Source: "{sys}\fftw3.dll"; DestDir: "{sys}"; Components: Main; Flags: restartreplace uninsrestartdelete 
Source: "{sys}\i420vfw.dll"; DestDir: "{sys}"; Components: HelixYUV;
Source: "{sys}\libfftw3f-3.dll"; DestDir: "{sys}"; Components: Main; Flags: restartreplace uninsrestartdelete 
Source: "{sys}\MediaBridgeSourceFilter.ax"; DestDir: "{sys}"; Components: Main; Flags: regserver 
Source: "{sys}\MSVCP71.DLL"; DestDir: "{sys}"; Components: MSVCR; Flags: onlyifdoesntexist 
Source: "{sys}\MSVCR71.DLL"; DestDir: "{sys}"; Components: MSVCR; Flags: onlyifdoesntexist 
Source: "{sys}\PmpSplitter.ax"; DestDir: "{sys}"; Components: PMP; Flags: regserver 
Source: "{sys}\yv12vfw.dll"; DestDir: "{sys}"; Components: HelixYUV;

[Dirs]
Name: "{app}\presets\encoding\Audio\video\";
Name: "{app}\presets\encoding\WMV\audio\";
Name: "{app}\presets\encoding\WMV\video\";

[Registry]
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32"; ValueName: "vidc.i420"; ValueType: String; ValueData: "i420vfw.dll"; Components: HelixYUV; Flags: uninsdeletevalue uninsdeletekeyifempty 
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Drivers32"; ValueName: "vidc.yv12"; ValueType: String; ValueData: "yv12vfw.dll"; Components: HelixYUV; Flags: uninsdeletevalue uninsdeletekeyifempty 
Root: HKCR; Subkey: ".tsks"; ValueType: String; ValueData: "XviD4PSP5Tasks"; Components: XviD4PSP5Tasks; Flags: uninsdeletevalue 
Root: HKCR; Subkey: "XviD4PSP5Tasks"; ValueType: String; ValueData: "XviD4PSP5 Tasks"; Components: XviD4PSP5Tasks; Flags: uninsdeletekey 
Root: HKCR; Subkey: "XviD4PSP5Tasks\DefaultIcon"; ValueType: String; ValueData: "{app}\XviD4PSP.exe,0"; Components: XviD4PSP5Tasks;
Root: HKCR; Subkey: "XviD4PSP5Tasks\shell\open\command"; ValueType: String; ValueData: """{app}\XviD4PSP.exe"" ""%1"""; Components: XviD4PSP5Tasks;

[INI]
FileName: "{app}\apps\MP4Box\Yamb.cfg"; Section: "Main"; Flags: uninsdeletesection 
FileName: "{app}\apps\MP4Box\Yamb.cfg"; Section: "Main"; Key: "MKVextract_path"; String: "{app}\apps\MKVtoolnix\mkvextract.exe";
FileName: "{app}\apps\MP4Box\Yamb.cfg"; Section: "Main"; Key: "MP4Box_path"; String: "{app}\apps\MP4Box\MP4Box.exe";

[Run]
Filename: "{app}\XviD4PSP.exe"; WorkingDir: "{app}"; Description: "{cm:LaunchProgram,XviD4PSP 5}"; Flags: postinstall unchecked skipifsilent nowait
Filename: "{tmp}\vcredist_x86.exe"; Parameters: "/q:a"; WorkingDir: "{app}"; Description: "{cm:vcredist}"; Flags: shellexec postinstall skipifsilent nowait
Filename: "{app}\Changelog_{cm:ChangelogLang}.txt"; WorkingDir: "{app}"; Description: "{cm:ViewChangelog}"; Flags: shellexec postinstall skipifsilent nowait
Filename: "{app}\Changelog_installer_{cm:ChangelogLangInst}.txt"; WorkingDir: "{app}"; Description: "{cm:ViewChangelogInst}"; Flags: shellexec postinstall unchecked skipifsilent nowait
Filename: "{app}\License_{cm:LicenseLang}.txt"; WorkingDir: "{app}"; Description: "{cm:ViewLicense}"; Flags: shellexec postinstall unchecked skipifsilent nowait

[Icons]
Name: "{group}\XviD4PSP 5"; Filename: "{app}\XviD4PSP.exe";
Name: "{group}\WPF Video Player"; Filename: "{app}\WPF_VideoPlayer.exe";
Name: "{group}\{cm:ProgramOnTheWeb,XviD4PSP 5}"; Filename: "http://xvid4psp.googlecode.com/";
Name: "{group}\{cm:UninstallProgram,XviD4PSP 5}"; Filename: "{uninstallexe}";
Name: "{commondesktop}\XviD4PSP 5"; Filename: "{app}\XviD4PSP.exe"; Tasks: desktopicon;
Name: "{group}\Tools\DGIndex"; Filename: "{app}\apps\DGMPGDec\DGIndex.exe";
Name: "{group}\Tools\MKVmerge GUI"; Filename: "{app}\apps\MKVtoolnix\mmg.exe";
Name: "{group}\Tools\Yamb"; Filename: "{app}\apps\MP4Box\Yamb.exe";
Name: "{group}\Tools\tsMuxeR"; Filename: "{app}\apps\tsMuxeR\tsMuxerGUI.exe";
Name: "{group}\Tools\PgcDemux"; Filename: "{app}\apps\PgcDemux\PgcDemux.exe";
Name: "{group}\Tools\VirtualDubMod"; Filename: "{app}\apps\VirtualDubMod\VirtualDubMod.exe";

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";
Name: "reset_settings"; Description: "{cm:ResetSettings}"; GroupDescription: "{cm:Other}";

[Components]
Name: "main"; Description: "XviD4PSP 5.10.330.0"; Types: "custom compact full";
Name: "plugins"; Description: "AviSynth Additional Plugins"; Types: "custom full";
Name: "helixyuv"; Description: "Helix YUV Codecs 1.3.0.0"; Types: "custom compact full";
Name: "pmp"; Description: "PMP Splitter 1.0.1.1"; Types: "custom full";
Name: "msvcr"; Description: "Microsoft Visual C/C++ Libraries"; Types: "custom full";
Name: "xvid4psp5tasks"; Description: "XviD4PSP5 *.tsks file association"; Types: "custom full";
Name: "neroaac"; Description: "Nero AAC Encoder (requires internet connection)"; Types: "full";

[InstallDelete]
Type: files; Name: "{group}\*XviD4PSP 5*";
Type: filesandordirs; Name: "{group}\Tools";

[UninstallDelete]
Type: files; Name: "{app}\apps\AVI-Mux\logfile.*";
Type: files; Name: "{app}\apps\MP4Box\Yamb.cfg";
Type: files; Name: "{app}\apps\MKVtoolnix\*.*";
Type: files; Name: "{app}\apps\neroAacEnc\*.*";
Type: files; Name: "{app}\apps\AvsP\*.*";
Type: files; Name: "{app}\apps\AvsP\tools\*.*";
Type: files; Name: "{app}\apps\AvsP\macros\*.*";
Type: files; Name: "{app}\License.txt";
Type: files; Name: "{app}\apps\x264\vfw4x264.exe";
Type: files; Name: "{app}\apps\x264\avs4x264_source.7z";
Type: dirifempty; Name: "{app}\apps";
Type: dirifempty; Name: "{app}";

[Types]
Name: "full"; Description: "Full installation"
Name: "compact"; Description: "Compact installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[CustomMessages]
ChangelogLang=eng
ChangelogLangInst=eng
DeleteSettings=Preform clean XviD4PSP 5 installation? All previous files will be deleted.
LicenseLang=eng
Other=Other tasks:
ResetSettings=Reset settings to default
SetupIsRunning=XviD4PSP 5 setup is already running!
UninstallPrevious=Warning: Old Version XviD4PSP 5 will be removed!
UninstallPreviousError=Uninstall Failure
ViewChangelog=View Changelog
ViewChangelogInst=View Installer Changelog
ViewLicense=View License
vcredist=Install Microsoft Visual C++ 2005 Service Pack 1 Redistributable Package ATL Security Update

Chinese.AdditionalIcons=附加图标：
Chinese.AddonHostProgramNotFound=在你选择的文件夹中找不到 %1。%n%n是否仍然继续？
Chinese.AssocFileExtension=将 %1 与 %2 文件扩展名关联(&A)
Chinese.AssocingFileExtension=正在将 %1 与 %2 文件扩展名关联…
Chinese.AutoStartProgram=自动启动 %1
Chinese.AutoStartProgramGroupDescription=启动：
Chinese.CreateDesktopIcon=创建桌面图标(&D)
Chinese.CreateQuickLaunchIcon=创建快速启动栏图标(&Q)
Chinese.DeleteSettings=干净安装
Chinese.LaunchProgram=运行 %1
Chinese.NameAndVersion=%1 版本 %2
Chinese.Other=其他任务:
Chinese.ProgramOnTheWeb=%1 网站
Chinese.ResetSettings=重置设置
Chinese.SetupIsRunning=XviD4PSP 5 安装程序已在运行中！
Chinese.UninstallProgram=卸载 %1
Chinese.ViewChangelog=查看更新日志

English.AdditionalIcons=Additional icons:
English.AddonHostProgramNotFound=%1 could not be located in the folder you selected.%n%nDo you want to continue anyway?
English.AssocFileExtension=&Associate %1 with the %2 file extension
English.AssocingFileExtension=Associating %1 with the %2 file extension...
English.AutoStartProgram=Automatically start %1
English.AutoStartProgramGroupDescription=Startup:
English.CreateDesktopIcon=Create a &desktop icon
English.CreateQuickLaunchIcon=Create a &Quick Launch icon
English.LaunchProgram=Launch %1
English.NameAndVersion=%1 version %2
English.ProgramOnTheWeb=%1 on the Web
English.UninstallProgram=Uninstall %1

Estonian.AdditionalIcons=Täiendavad ikoonid:
Estonian.AddonHostProgramNotFound=%1 ei asu sinu valitud kaustas.%n%nKas soovid sellegipoolest jätkata?
Estonian.AssocFileExtension=&Seosta %1 %2 faililaiendiga
Estonian.AssocingFileExtension=Seostan %1 %2 faililaiendiga...
Estonian.AutoStartProgram=Käivita %1 automaatselt
Estonian.AutoStartProgramGroupDescription=Käivitus:
Estonian.CreateDesktopIcon=Loo &töölaua ikoon
Estonian.CreateQuickLaunchIcon=Loo &kiirkäivituse ikoon
Estonian.LaunchProgram=Käivita %1
Estonian.NameAndVersion=%1 versiooniga %2
Estonian.ProgramOnTheWeb=%1 veebis
Estonian.UninstallProgram=%1 - eemalda
Estonian.ViewChangelog=Vaata Changelog

French.AdditionalIcons=Icônes supplémentaires :
French.AddonHostProgramNotFound=%1 n'a pas été trouvé dans le dossier que vous avez choisi.%n%nVoulez-vous continuer malgré tout ?
French.AssocFileExtension=&Associer %1 avec l'extension de fichier %2
French.AssocingFileExtension=Associe %1 avec l'extension de fichier %2...
French.AutoStartProgram=Démarrer automatiquement %1
French.AutoStartProgramGroupDescription=Démarrage :
French.CreateDesktopIcon=Créer une icône sur le &Bureau
French.CreateQuickLaunchIcon=Créer une icône dans la barre de &Lancement rapide
French.DeleteSettings=Nettoyer l'installation
French.LaunchProgram=Exécuter %1
French.NameAndVersion=%1 version %2
French.Other=Autres tâches:
French.ProgramOnTheWeb=Page d'accueil de %1
French.ResetSettings=Initialisation des paramètres
French.SetupIsRunning=L'installation de XviD4PSP 5 est déjà en cours d'exécution!
French.UninstallProgram=Désinstaller %1
French.ViewChangelog=Voir la liste des changements

German.AdditionalIcons=Zusätzliche Symbole:
German.AddonHostProgramNotFound=%1 konnte im ausgwählten Ordner nicht gefunden werden.%n%nMöchten Sie dennoch fortfahren?
German.AssocFileExtension=&Registriere %1 mit der %2-Dateierweiterung
German.AssocingFileExtension=%1 wird mit der %2-Dateierweiterung registriert...
German.AutoStartProgram=Starte automatisch%1
German.AutoStartProgramGroupDescription=Beginn des Setups:
German.CreateDesktopIcon=&Desktop-Symbol erstellen
German.CreateQuickLaunchIcon=Symbol in der Schnellstartleiste erstellen
German.DeleteSettings=Reinigen installieren.
German.LaunchProgram=%1 starten
German.NameAndVersion=%1 Version %2
German.Other=Andere Aufgaben:
German.ProgramOnTheWeb=%1 im Internet
German.ResetSettings=Einstellungen zurücksetzen
German.SetupIsRunning=XviD4PSP 5 Setup wird bereits ausgeführt!
German.UninstallProgram=%1 entfernen
German.ViewChangelog=Zeige Änderungsprotokoll
German.ViewChangelogInst=Zeige Änderungsprotokoll des Installers

Hebrew.AdditionalIcons=סימלונים נוספים:
Hebrew.AddonHostProgramNotFound=%1 לא נמצא בתיקיה שבחרת.%n%nאתה רוצה להמשיך בכל זאת?
Hebrew.AssocFileExtension=&קשר את %1 עם סיומת הקובץ %2
Hebrew.AssocingFileExtension=מקשר את %1 עם סיומת הקובץ %2
Hebrew.AutoStartProgram=הפעל אוטומטית %1
Hebrew.AutoStartProgramGroupDescription=הפעלה אוטומטית:
Hebrew.CreateDesktopIcon=צור קיצור דרך על &שולחן העבודה
Hebrew.CreateQuickLaunchIcon=צור סימלון בשורת ההרצה המהירה
Hebrew.LaunchProgram=הפעל %1
Hebrew.NameAndVersion=%1 גירסה %2
Hebrew.ProgramOnTheWeb=%1 ברשת
Hebrew.UninstallProgram=הסר את %1

Hungarian.AdditionalIcons=További ikonok:
Hungarian.AddonHostProgramNotFound=A(z) %1 nem található a kiválasztott mappában.%n%nMindenképpen folytatni kívánja?
Hungarian.AssocFileExtension=A(z) %1 &társítása a(z) %2 fájlkiterjesztéssel
Hungarian.AssocingFileExtension=A(z) %1 társítása a(z) %2 fájlkiterjesztéssel...
Hungarian.AutoStartProgram=%1 automatikus indítása
Hungarian.AutoStartProgramGroupDescription=Indítópult:
Hungarian.CreateDesktopIcon=Ikon létrehozása az &Asztalon
Hungarian.CreateQuickLaunchIcon=Ikon létrehozása a &Gyorsindítás eszköztáron
Hungarian.DeleteSettings=Tiszta telepítés.
Hungarian.LaunchProgram=%1 elindítása
Hungarian.NameAndVersion=%1 %2 verzió
Hungarian.Other=Egyéb feladatok:
Hungarian.ProgramOnTheWeb=%1 a weben
Hungarian.ResetSettings=Beállítások alaphelyzetbe állítása
Hungarian.SetupIsRunning=Az XviD4PSP 5 telepítő már fut!
Hungarian.UninstallProgram=%1 eltávolítása
Hungarian.ViewChangelog=Verziótörténet megtekintése

Italian.AdditionalIcons=Icone aggiuntive:
Italian.AddonHostProgramNotFound=Impossibile individuare %1 nella cartella selezionata.%n%nProseguire ugualmente?
Italian.AssocFileExtension=&Associa l'estensione %2 a %1
Italian.AssocingFileExtension=Associazione dell'estensione %2 a %1 in corso...
Italian.AutoStartProgram=Avvia automaticamente %1
Italian.AutoStartProgramGroupDescription=Avvio automatico:
Italian.CreateDesktopIcon=Crea un'icona sul &desktop
Italian.CreateQuickLaunchIcon=Crea un'icona nella &barra Avvio veloce
Italian.DeleteSettings=Installazione pulita.
Italian.LaunchProgram=Avvia %1
Italian.NameAndVersion=%1 versione %2
Italian.Other=Altre operazioni:
Italian.ProgramOnTheWeb=%1 sul Web
Italian.ResetSettings=Ripristina impostazioni
Italian.SetupIsRunning=L'installazione di XviD4PSP 5 è già in corso!
Italian.UninstallProgram=Disinstalla %1
Italian.ViewChangelog=Visualizza Changelog

Japanese.AdditionalIcons=アイコンを追加する:
Japanese.AddonHostProgramNotFound=選択されたフォルダーに %1 が見つかりませんでした。%n%nこのまま続行しますか？
Japanese.AssocFileExtension=ファイル拡張子 %2 に %1 を関連付けます。
Japanese.AssocingFileExtension=ファイル拡張子 %2 に %1 を関連付けています...
Japanese.AutoStartProgram=%1 を自動的に開始する
Japanese.AutoStartProgramGroupDescription=スタートアップ:
Japanese.CreateDesktopIcon=デスクトップ上にアイコンを作成する(&D)
Japanese.CreateQuickLaunchIcon=クイック起動アイコンを作成する(&Q)
Japanese.LaunchProgram=%1 を実行する
Japanese.NameAndVersion=%1 バージョン %2
Japanese.ProgramOnTheWeb=%1 on the Web
Japanese.UninstallProgram=%1 をアンインストールする

Portuguese.AdditionalIcons=Ícones adicionais:
Portuguese.AddonHostProgramNotFound=Não foi possível localizar %1 na pasta seleccionada.%n%nDeseja continuar de qualquer forma?
Portuguese.AssocFileExtension=Associa&r o %1 aos ficheiros com a extensão %2
Portuguese.AssocingFileExtension=A associar o %1 aos ficheiros com a extensão %2...
Portuguese.AutoStartProgram=Iniciar %1 automaticamente
Portuguese.AutoStartProgramGroupDescription=Inicialização Automática:
Portuguese.CreateDesktopIcon=Criar ícone no Ambiente de &Trabalho
Portuguese.CreateQuickLaunchIcon=&Criar ícone na barra de Iniciação Rápida
Portuguese.LaunchProgram=Executar o %1
Portuguese.NameAndVersion=%1 versão %2
Portuguese.ProgramOnTheWeb=%1 na Web
Portuguese.SetupIsRunning=A instalação do XviD4PSP 5 ja está sendo executada!
Portuguese.UninstallProgram=Desinstalar o %1
Portuguese.ViewChangelog=Visualizar Changelog

Russian.AdditionalIcons=Дополнительные значки:
Russian.AddonHostProgramNotFound=%1 не найден в указанной вами папке.%n%nВы всё равно хотите продолжить?
Russian.AssocFileExtension=Св&язать %1 с файлами, имеющими расширение %2
Russian.AssocingFileExtension=Связывание %1 с файлами %2...
Russian.AutoStartProgram=Автоматически запускать %1
Russian.AutoStartProgramGroupDescription=Автозапуск:
Russian.ChangelogLang=rus
Russian.ChangelogLangInst=rus
Russian.CreateDesktopIcon=Создать значок на &Рабочем столе
Russian.CreateQuickLaunchIcon=Создать значок в &Панели быстрого запуска
Russian.DeleteSettings=Произвести чистую установку XviD4PSP 5 с предварительным удалением всех старых файлов?
Russian.LaunchProgram=Запустить %1
Russian.LicenseLang=rus
Russian.NameAndVersion=%1, версия %2
Russian.Other=Другие задачи:
Russian.ProgramOnTheWeb=Сайт %1 в Интернете
Russian.ResetSettings=Сбросить настройки программы (пользовательские пресеты и файлы не удаляются)
Russian.SetupIsRunning=Установка XviD4PSP 5 уже запущена!
Russian.UninstallPrevious=Внимание: предыдущая версия XviD4PSP 5 будет удалена с вашего компьютера.
Russian.UninstallPreviousError=Ошибка деинсталляции
Russian.UninstallProgram=Деинсталлировать %1
Russian.ViewChangelog=Просмотр списка изменений
Russian.ViewChangelogInst=Просмотр списка изменений инсталлятора
Russian.ViewLicense=Просмотр лицензии
Russian.vcredist=Установить Microsoft Visual C++ 2005 Service Pack 1 Redistributable Package ATL Security Update (необходим для работы некоторых плагинов)

Spanish.AdditionalIcons=Iconos adicionales:
Spanish.AddonHostProgramNotFound=%1 no pudo ser localizado en la carpeta seleccionada.%n%n¿Desea continuar de todas formas?
Spanish.AssocFileExtension=&Asociar %1 con la extensión de archivo %2
Spanish.AssocingFileExtension=Asociando %1 con la extensión de archivo %2...
Spanish.AutoStartProgram=Iniciar automáticamente %1
Spanish.AutoStartProgramGroupDescription=Inicio:
Spanish.CreateDesktopIcon=Crear un icono en el &escritorio
Spanish.CreateQuickLaunchIcon=Crear un icono de &Inicio Rápido
Spanish.DeleteSettings=Instalación limpia.
Spanish.LaunchProgram=Ejecutar %1
Spanish.NameAndVersion=%1 versión %2
Spanish.Other=Otras tareas:
Spanish.ProgramOnTheWeb=%1 en la Web
Spanish.ResetSettings=Restaurar preferencias
Spanish.SetupIsRunning=La instalación de XviD4PSP 5 ya se esta ejecutando!
Spanish.UninstallProgram=Desinstalar %1
Spanish.ViewChangelog=Ver registro de cambios

Ukrainian.AdditionalIcons=Додаткові ярлики:
Ukrainian.AddonHostProgramNotFound=%1 не знайдений у вказаній вами папці%n%nВи все одно бажаєте продовжити?
Ukrainian.AssocFileExtension=&Асоціювати %1 з розширенням файлу %2
Ukrainian.AssocingFileExtension=Асоціювання %1 з розширенням файлу %2...
Ukrainian.AutoStartProgram=Автоматично завантужувати %1
Ukrainian.AutoStartProgramGroupDescription=Автозавантаження:
Ukrainian.CreateDesktopIcon=Створити ярлики на &Робочому столі
Ukrainian.CreateQuickLaunchIcon=Створити ярлики на &Панелі швидкого запуску
Ukrainian.DeleteSettings=Чиста установка.
Ukrainian.LaunchProgram=Відкрити %1
Ukrainian.NameAndVersion=%1, версія %2
Ukrainian.Other=Інші завдання:
Ukrainian.ProgramOnTheWeb=Сайт %1 в Інтернеті
Ukrainian.ResetSettings=Скинути налаштування
Ukrainian.SetupIsRunning=Встановлення XviD4PSP 5 вже запущено!
Ukrainian.UninstallProgram=Видалити %1
Ukrainian.ViewChangelog=Показати журнал змін

[Languages]
Name: "English"; MessagesFile: "compiler:Default.isl"
Name: "French"; MessagesFile: "compiler:Languages\French.isl"
Name: "German"; MessagesFile: "compiler:Languages\German.isl"
Name: "Hebrew"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "Hungarian"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "Italian"; MessagesFile: "compiler:Languages\Italian.isl";
Name: "Japanese"; MessagesFile: "compiler:Languages\Japanese.isl";
Name: "Portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl";
Name: "Russian"; MessagesFile: "compiler:Languages\Russian.isl";
Name: "Spanish"; MessagesFile: "compiler:Languages\Spanish.isl";
Name: "Ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl";
Name: "Estonian"; MessagesFile: "embedded\Estonian.isl";
Name: "Chinese"; MessagesFile: "embedded\ChineseSimplified.isl";

[Code]
procedure InitializeWizard;
begin
  idpDownloadAfter(wpReady);
end;

procedure ResetSettings();
begin
  RegDeleteKeyIncludingSubkeys(HKCU, 'Software\Winnydows\XviD4PSP5');
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpReady then
  begin
    idpClearFiles;

    if IsComponentSelected('neroaac') then
      idpAddFile('http://ftp6.nero.com/tools/NeroAACCodec-1.5.1.zip', ExpandConstant('{tmp}\NeroAACCodec-1.5.1.zip'));
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if (CurStep = ssPostInstall) then
  begin
    if IsTaskSelected('reset_settings') then
      ResetSettings();
	  
    if IsComponentSelected('neroaac') then
    begin
      ExtractTemporaryFile('unzip.exe');
      Exec(ExpandConstant('{tmp}\unzip.exe'), '-j "'+ExpandConstant('{tmp}\NeroAACCodec-1.5.1.zip')+'"', ExpandConstant('{app}\apps\neroAacEnc'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;


