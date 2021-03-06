#include "_preprocess.iss"

[Setup]
AppName={#APP_NAME_DSC}
AppVerName={#APP_NAME}
DefaultDirName={code:WCBase}\Plugins\
DefaultGroupName={#APP_NAME}
;LicenseFile={#APP_NAME}\license.txt
Compression=lzma
SolidCompression=true
OutputDir=\_WPLabs\_Installers\_Installers_WKPlugs
OutputBaseFilename={#APP_NAME}
AllowNoIcons=yes
AppCopyright=WiredPlane labs
AppPublisherURL=http://www.wiredplane.com/ 
AlwaysShowDirOnReadyPage=true
AlwaysShowGroupOnReadyPage=true
ShowLanguageDialog=yes
Uninstallable=no
CreateUninstallRegKey=no
UpdateUninstallLogAppName=no
DirExistsWarning=no
DisableDirPage=no

[Files]

Source: {#APP_NAME}\*; DestDir: {code:WCBase}\Plugins\; Flags: recursesubdirs ignoreversion createallsubdirs uninsrestartdelete

[Code]
var
  UserData: String;
  
function WCBase(Param: String): String;
begin
  Result := UserData;
end;

function InitializeSetup(): Boolean;
begin
  Result := True;
  UserData := ExpandConstant('{reg:HKCU\Software\WiredPlane\WireKeys,InstallPath3|none}');
  if UserData = 'none' then begin
	UserData := ExpandConstant('{pf}\WireKeys');    //MsgBox('WireKeys 2.9 or higher not found. You should install WireKeys before installing additional components. Visit http://www.wiredplane.com for details. Installation cancelled.', mbError, MB_OK);
    //Result := False;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  MainWnd: HWND;
begin
    if CurStep = ssPostInstall then
    begin
   	  MainWnd := FindWindowByWindowName('WK_ROOT');
      if(MainWnd <> 0) then
    	 begin
       PostMessage(MainWnd, 273, 32983, 1);
       MsgBox('Installation finished. Check plugins section of preferences to configure newly installed component', mbInformation, MB_OK);
       end;
    	 //begin PostMessage(MainWnd, 16, 0, 0); end;
      if(MainWnd = 0) then
       begin MsgBox('Installation finished. Restart WireKeys to see newly installed component', mbInformation, MB_OK); end;
    end;
end;
end.


