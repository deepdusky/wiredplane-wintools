#include "_preprocess.iss"

[Setup]
AppName={#APP_NAME}
AppVerName={#APP_NAME} version {#APP_VER}
DefaultDirName={pf}\WiredPlane\{#APP_NAME}
DefaultGroupName={#APP_NAME}
UninstallDisplayName={#APP_NAME} (remove only)
UninstallDisplayIcon={app}\{#APP_NAME}.exe
LicenseFile={#APP_NAME}\license.rtf
Compression=lzma
SolidCompression=true
OutputDir=\_WPLabs\_Installers
OutputBaseFilename={#APP_NAME}
AppCopyright=WiredPlane labs
AppPublisherURL=http://www.wiredplane.com/ 
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
ShowLanguageDialog=yes

[Files]

Source: {#APP_NAME}\*; DestDir: {app}; Flags: recursesubdirs ignoreversion createallsubdirs uninsrestartdelete
Source: {#APP_NAME}\readme.txt; DestDir: {app}; Flags: isreadme

[Icons]
Name: {group}\{#APP_NAME}; Filename: {app}\{#APP_NAME}.exe
Name: {group}\Visit homepage; Filename: {app}\WiredPlane.url
Name: {group}\{#APP_NAME} Help file; Filename: {app}\{#APP_NAME}_l0.chm
Name: {group}\Uninstall {#APP_NAME}; Filename: "{uninstallexe}"

[INI] 
Filename: "{app}\install.ini"; Section: "Main"; Flags: uninsdeletesection
Filename: "{app}\install.ini"; Section: "Main"; Key: "AffId"; String: "{#APP_AFNAME}";
Filename: "{app}\install.ini"; Section: "Main"; Key: "Date"; String: "{code:InstallDate}"; 

[UninstallDelete] 
Type: files; Name: "{app}\install.ini"

[Run]
FileName: "{app}\{#APP_NAME}.exe"; Description: "Start {#APP_NAME}"; Flags: nowait postinstall

[UninstallRun]
Filename: "http://www.wiredplane.com/guestbook/uninstall.php?who={#APP_NAME}&ver={#APP_VER}&indate={ini:{app}\install.ini,Main,Date|Unknown}&affdat={ini:{app}\install.ini,Main,AffId|Unknown} "; Flags: shellexec nowait runmaximized
;{-#SaveToFile({#APP_NAME}.iss_test)}

[Code]
function InstallDate(Param: String): String;
begin
  Result := GetDateTimeString('dd.mm.yyyy',#0, #0);
end;


