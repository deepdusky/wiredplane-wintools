del %4.zip

rem Crypting...
rem "C:\Program Files\EXECryptor\EXECrypt.exe" z:\_WPLabs\_Installers\_ExecryptorKeys\%1.ep2

del /S /F /Q %4\*.exp
del /S /F /Q %4\*.bak
del /S /F /Q %4\*.lib
del /S /F /Q %4\*.ilk
del /S /F /Q %4\*.ini
del /S /F /Q %4\*.log

rem Затираем русскую историю
copy /Y z:\_WPLabs\PROJECTS_ROOT\%4\Help\history.shtml Z:\_WPLabs\PROJECTS_ROOT\%4\Help1\history.shtml
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\*.gif Z:\_WPLabs\_Wwwroot\%3-help\*.gif
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\*.jpg Z:\_WPLabs\_Wwwroot\%3-help\*.jpg
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\*.png Z:\_WPLabs\_Wwwroot\%3-help\*.png
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\*.h Z:\_WPLabs\_Wwwroot\%3-help\*.h
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\*.shtml Z:\_WPLabs\_Wwwroot\%3-help\*.shtml
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\history.shtml Z:\_WPLabs\_Installers\%4\history.html
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\license.rtf Z:\_WPLabs\_Installers\%4\license.rtf
"hhc.exe" Z:\_WPLabs\PROJECTS_ROOT\%4\Help\%4_l0.hhp
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help\%4_l0.chm Z:\_WPLabs\_Installers\%4\%4_l0.chm
"hhc.exe" Z:\_WPLabs\PROJECTS_ROOT\%4\Help1\%4_l1.hhp
copy Z:\_WPLabs\PROJECTS_ROOT\%4\Help1\%4_l1.chm Z:\_WPLabs\_Installers\%4\%4_l1.chm

IF NOT EXIST %4.iss GOTO __JustCopy__
echo #define APP_NAME	"%1">"_preprocess.iss"
echo #define APP_VER	"%2">>"_preprocess.iss"
echo #define APP_AFNAME	"%4">>"_preprocess.iss"

"C:\Program Files\Inno Setup 5\ISCC.exe" %4.iss
pkzip25.exe -add "%4.zip" %1.exe
GOTO __AddLic__

:__JustCopy__
pkzip25.exe -add "%4.zip" %4\*.*

:__AddLic__
pkzip25.exe -add "%4.zip" %4\license.rtf
pkzip25.exe -add "%4.zip" %4\file_id.diz
copy %4.zip Z:\_WPLabs\_Wwwroot\download\%4.zip
del %1.exe

copy Z:\_WPLabs\PROJECTS_ROOT\_Data\%4.xml Z:\_WPLabs\_Wwwroot\download\%4.xml
fart.exe -V -C -P Z:\_WPLabs\_Wwwroot\download\%4.xml \x3CProgram_Version\x3E*\x3C/Program_Version\x3E %2
fart.exe -V -C -P Z:\_WPLabs\_Wwwroot\download\%4.xml \x3CProgram_Release_Month\x3E*\x3C/Program_Release_Month\x3E \mMONTH
fart.exe -V -C -P Z:\_WPLabs\_Wwwroot\download\%4.xml \x3CProgram_Release_Day\x3E*\x3C/Program_Release_Day\x3E \mDAY
fart.exe -V -C -P Z:\_WPLabs\_Wwwroot\download\%4.xml \x3CProgram_Release_Year\x3E*\x3C/Program_Release_Year\x3E \mYEAR
fart.exe -V -C -P Z:\_WPLabs\_Wwwroot\download\%4.xml \x3CProgram_Change_Info\x3E*\x3C/Program_Change_Info\x3E \i%4.nfo
echo %2>"Z:\_WPLabs\_Wwwroot\download\%4.ver"