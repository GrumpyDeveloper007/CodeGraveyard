rem video.bat
wasm -3p -d1 -fo=obj\videoa.obj -mf video\video.asm
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\video.obj video\video.cpp
wasm -3p -fo=obj\videoap.obj -mf video\video.asm
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\videop.obj video\video.cpp
rem wlib -b Xavier.lib -+obj\videoa.obj
rem wlib -b Xavier.lib -+obj\video.obj
rem wlib -b Xavierp.lib -+obj\videoap.obj
rem wlib -b Xavierp.lib -+obj\videop.obj

rem vesa.bat
wasm -3p -d1 -fo=obj\vesaa.obj -mf vesa\vesa.asm
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\vesa.obj vesa\vesa.cpp
wasm -3p -fo=obj\vesaap.obj -mf vesa\vesa.asm
pause
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\vesap.obj vesa\vesa.cpp
rem wlib -b Xavier.lib -+obj\vesaa.obj
rem wlib -b Xavier.lib -+obj\vesa.obj
rem wlib -b Xavierp.lib -+obj\vesaap.obj
rem wlib -b Xavierp.lib -+obj\vesap.obj


rem pcx.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\pcx.obj other\pcx.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\pcxp.obj other\pcx.cpp
rem wlib -b Xavier.lib -+obj\pcx.obj
rem wlib -b Xavierp.lib -+obj\pcxp.obj

rem mouse.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\mouse.obj other\mouse.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\mousep.obj other\mouse.cpp
rem wlib -b Xavier.lib -+obj\mouse.obj
rem wlib -b Xavierp.lib -+obj\mousep.obj

rem datafile.bat
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\dataf.obj other\datafile.cpp
wpp386 -fpi87 -fp3 /mf /ot /bt=pmodew /fo=obj\datafp.obj other\datafile.cpp
rem wlib -b Xavier.lib -+obj\dataf.obj
rem wlib -b Xavierp.lib -+obj\datafp.obj

rem joinlibs.bat
rem wlib -b Xavier.lib -+audiowcf.lib
rem wlib -b Xavierp.lib -+audiowcf.lib

rem join all obj
wlib -b Xavier.lib -+audiowcf.lib -+obj\dataf.obj -+obj\mouse.obj -+obj\pcx.obj
wlib -b Xavier.lib obj\video.obj obj\videoa.obj -+obj\vesa.obj -+obj\vesaa.obj
wlib -b Xavierp.lib -+audiowcf.lib -+obj\datafp.obj -+obj\mousep.obj -+obj\pcxp.obj
wlib -b Xavierp.lib obj\videop.obj obj\videoap.obj -+obj\vesap.obj -+obj\vesaap.obj


