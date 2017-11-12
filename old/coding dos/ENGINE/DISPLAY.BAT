wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\Display.obj cpp\Display.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\Display.obj cpp\Display.cpp
wlib -b ..\3dodir\lib\3DEngine.lib -+obj\Display.obj
wlib -b ..\3dodir\pmlib\3DEngine.lib -+pmobj\Display.obj
