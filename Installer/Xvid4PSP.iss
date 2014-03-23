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
Source: "{app}\vcredist_x86.exe"; DestDir: "{tmp}"; Components: Main; Flags: ignoreversion

Source: "{app}\apps\aften\*"; DestDir: "{app}\apps\aften"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\avc2avi\*"; DestDir: "{app}\apps\avc2avi"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\AVI-Mux\*"; DestDir: "{app}\apps\AVI-Mux"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\AvsP\*"; DestDir: "{app}\apps\AvsP"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\cfourcc\*"; DestDir: "{app}\apps\cfourcc"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\Custom\*"; DestDir: "{app}\apps\Custom"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\DGAVCDec\*"; DestDir: "{app}\apps\DGAVCDec"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\DGMPGDec\*"; DestDir: "{app}\apps\DGMPGDec"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\DGPulldown\*"; DestDir: "{app}\apps\DGPulldown"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\DirectX_Update\*"; DestDir: "{app}\apps\DirectX_Update"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\ffmpeg\*"; DestDir: "{app}\apps\ffmpeg"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\lame\*"; DestDir: "{app}\apps\lame"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\MKVtoolnix\*"; DestDir: "{app}\apps\MKVtoolnix"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\MP4Box\*"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\dlls\MediaInfo\MediaInfo.dll"; DestDir: "{app}\apps\MP4Box"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\neroAacEnc\*"; DestDir: "{app}\apps\neroAacEnc"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\PgcDemux\*"; DestDir: "{app}\apps\PgcDemux"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\qaac\*"; DestDir: "{app}\apps\qaac"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\tsMuxeR\*"; DestDir: "{app}\apps\tsMuxeR"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\VirtualDubMod\*"; DestDir: "{app}\apps\VirtualDubMod"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\x262\*"; DestDir: "{app}\apps\x262"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\x264\*"; DestDir: "{app}\apps\x264"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\x264_10b\*"; DestDir: "{app}\apps\x264_10b"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\x264\COPYING"; DestDir: "{app}\apps\x262"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\x264\COPYING"; DestDir: "{app}\apps\x264_10b"; Components: Main; Flags: ignoreversion
Source: "{app}\apps\xvid_encraw\*"; DestDir: "{app}\apps\xvid_encraw\1.2.2"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\apps\Launcher.exe"; DestDir: "{app}\apps"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\functions\*.avs"; DestDir: "{app}\dlls\AviSynth\functions"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\AviSynth\plugins\*"; DestDir: "{app}\dlls\AviSynth\plugins"; Components: Plugins; Flags: ignoreversion recursesubdirs
Source: "{app}\dlls\AviSynth\AviSynthWrapper.dll"; DestDir: "{app}\dlls\AviSynth"; Components: Main; Flags: ignoreversion
Source: "{app}\dlls\LAVFilters\*"; DestDir: "{app}\dlls\LAVFilters"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\dlls\MediaInfo\*"; DestDir: "{app}\dlls\MediaInfo"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\dlls\Player\*"; DestDir: "{app}\dlls\Player"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "{app}\dlls\VStrip\*"; DestDir: "{app}\dlls\VStrip"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "..\docs\*"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "{app}\presets\*"; DestDir: "{app}\presets"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "..\bin\languages\*"; DestDir: "{app}\languages"; Components: Main; Flags: ignoreversion recursesubdirs
Source: "..\bin\SafeOpenDialog.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "..\bin\WPF_VideoPlayer.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion
Source: "..\bin\XviD4PSP.exe"; DestDir: "{app}"; Components: Main; Flags: ignoreversion

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
Name: "lamemp3"; Description: "LAME MP3 Encoder (requires internet connection)"; Types: "full";
Name: "neroaac"; Description: "Nero AAC Encoder (requires internet connection)"; Types: "full";

[InstallDelete]
Type: files; Name: "{group}\*XviD4PSP 5*";
Type: filesandordirs; Name: "{group}\Tools";

[UninstallDelete]
Type: files; Name: "{app}\apps\AVI-Mux\logfile.*";
Type: files; Name: "{app}\apps\AvsP\*.*";
Type: files; Name: "{app}\apps\AvsP\macros\*.*";
Type: files; Name: "{app}\apps\AvsP\tools\*.*";
Type: files; Name: "{app}\apps\lame\*.*";
Type: files; Name: "{app}\apps\MKVtoolnix\*.*";
Type: files; Name: "{app}\apps\MP4Box\Yamb.cfg";
Type: files; Name: "{app}\apps\neroAacEnc\*.*";
Type: files; Name: "{app}\apps\x264\avs4x264_source.7z";
Type: files; Name: "{app}\apps\x264\vfw4x264.exe";
Type: files; Name: "{app}\License.txt";
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

    if IsComponentSelected('lamemp3') then
      idpAddFile('http://www.rarewares.org/files/mp3/lame3.99.5.zip', ExpandConstant('{tmp}\lame3.99.5.zip'));
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

    ExtractTemporaryFile('unzip.exe');

    if IsComponentSelected('neroaac') then
      Exec(ExpandConstant('{tmp}\unzip.exe'), '-j -o "'+ExpandConstant('{tmp}\NeroAACCodec-1.5.1.zip')+'"', ExpandConstant('{app}\apps\neroAacEnc'), SW_HIDE, ewWaitUntilTerminated, ResultCode);

    if IsComponentSelected('lamemp3') then
      Exec(ExpandConstant('{tmp}\unzip.exe'), '-o "'+ExpandConstant('{tmp}\lame3.99.5.zip')+'" -x */*', ExpandConstant('{app}\apps\lame'), SW_HIDE, ewWaitUntilTerminated, ResultCode);
  end;
end;
