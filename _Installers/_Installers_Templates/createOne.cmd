del %1.zip

echo #define APP_NAME		"%1">"_preprocess.iss"
echo #define APP_NAME_DSC	"%1">>"_preprocess.iss"

"C:\Program Files\Inno Setup 5\ISCC.exe" Widgets.iss

pkzip25.exe -add "%1.zip" %1.exe
pkzip25.exe -add "%1.zip" %1\license.txt
pkzip25.exe -add "%1.zip" %1\file_id.diz
del %1.exe

copy %1.zip Z:\_WPLabs\_Wwwroot\download\widgets\%1.zip