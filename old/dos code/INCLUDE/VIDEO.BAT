@echo off
wasm -3p -d1 -fo=obj\videoa.obj -mf video\videoa.asm
wpp386 -fpi87 -fp3 /mf /ot /d2 /bt=dos4g /fo=obj\video.obj video\video.cpp

del xavier.lib
del xavierp.lib


wlib -b Xavier.lib -+audiowcf.lib -+obj\dataf.obj -+obj\mouse.obj -+obj\pcx.obj
wlib -b xavier.lib  -+obj\video.obj -+obj\vesa.obj -+obj\videoa.obj -+obj\vesaa.obj
wlib -b Xavierp.lib -+audiowcf.lib -+obj\datafp.obj -+obj\mousep.obj -+obj\pcxp.obj
wlib -b Xavierp.lib -+obj\videop.obj  -+obj\vesap.obj -+obj\videoap.obj  -+obj\vesaap.obj


