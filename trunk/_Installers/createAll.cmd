copy z:\_WPLabs\PROJECTS_ROOT\WireKeys\wkplugin.h z:\_WPLabs\PROJECTS_ROOT\WireKeys\Help\wkplugin.h
copy z:\_WPLabs\PROJECTS_ROOT\WireKeys\wkplugin.h z:\_WPLabs\PROJECTS_ROOT\WireKeys\Help1\wkplugin.h
copy z:\_WPLabs\PROJECTS_ROOT\WireKeys\wkplugin.h z:\_WPLabs\_Installers\WireKeys\Plugins\wkplugin.h

rem Название Версия Каталогдляпадов КаталогАффилиат

call createOne.cmd WireChanger 3.7.2 WireChanger WireChanger
copy z:\_WPLabs\_Installers\WireChanger\Html_forms.exe z:\_WPLabs\_Installers\WireNote\Sms\smssend.exe
copy z:\_WPLabs\_Installers\WireChanger\Html_forms.exe z:\_WPLabs\_Installers\WJazikator\Data\transl.exe
copy z:\_WPLabs\_Installers\WireChanger\WCRemind.cml z:\_WPLabs\_Installers\WireKeys\Plugins\WCRemind.cml 

call createOne.cmd WireKeys 3.7.1 WireKeys WireKeys
call createOne.cmd WireNote 3.5.3 WireNote WireNote

rem call createOne.cmd WJazikator 1.1 WJazikator WJazikator
rem call createOne.cmd PasteExtension 1.1 PasteExtension PasteExtension
rem call createOne.cmd ScreenArt 1.0 ScreenArt ScreenArt
rem call createOne.cmd ScreenCannon 1.0 ScreenCannon ScreenCannon
rem call createOne.cmd CloneEliminator 1.0 CloneEliminator CloneEliminator
rem call createOne.cmd CapsLord 1.0 CapsLord CapsLord
rem call createOne.cmd KaleidosWallpaper 1.0 wpt-kaleidoswallpaper KaleidosWallpaper

copy *.nfo z:\_WPLabs\_Wwwroot\download\*.nfo

