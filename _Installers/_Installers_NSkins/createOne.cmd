del %1.zip

echo #define APP_NAME		"%1">"_preprocess.iss"
echo #define APP_NAME_DSC	"Skin '%2'">>"_preprocess.iss"

"C:\Program Files\Inno Setup 5\ISCC.exe" NSkin.iss

pkzip25.exe -add "%1.zip" %1.exe
pkzip25.exe -add "%1.zip" %1\license.txt
del %1.exe

copy %1.zip Z:\_WPLabs\_Wwwroot\download\noteskins\%1.zip