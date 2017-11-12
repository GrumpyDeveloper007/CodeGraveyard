@echo off
rem video.bat
wasm -3p -d1 -fo=obj\videoa.obj -mf video\videoa.asm
wasm -3p -fo=obj\videoap.obj -mf video\videoa.asm
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\video.obj video\video.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\videop.obj video\video.cpp

rem vesa.bat
wasm -3p -d1 -fo=obj\vesaa.obj -mf vesa\vesaa.asm
wasm -3p -fo=obj\vesaap.obj -mf vesa\vesaa.asm
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\vesa.obj vesa\vesa.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\vesap.obj vesa\vesa.cpp


rem pcx.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\pcx.obj other\pcx.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\pcxp.obj other\pcx.cpp

rem mouse.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\mouse.obj other\mouse.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\mousep.obj other\mouse.cpp

rem datafile.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\dataf.obj other\datafile.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\datafp.obj other\datafile.cpp

rem joinlibs.bat

rem join all obj
wlib -b Xavier.lib -+audiowcf.lib -+obj\dataf.obj -+obj\mouse.obj -+obj\pcx.obj
wlib -b xavier.lib  -+obj\video.obj -+obj\vesa.obj -+obj\videoa.obj -+obj\vesaa.obj
wlib -b Xavierp.lib -+audiowcf.lib -+obj\datafp.obj -+obj\mousep.obj -+obj\pcxp.obj
wlib -b Xavierp.lib -+obj\videop.obj  -+obj\vesap.obj -+obj\videoap.obj  -+obj\vesaap.obj


