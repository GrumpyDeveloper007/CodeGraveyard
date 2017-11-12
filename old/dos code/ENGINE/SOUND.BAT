wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\sound.obj cpp\sound.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\sound.obj cpp\sound.cpp
wlib -b ..\3dodir\lib\3DEngine.lib -+obj\sound.obj
wlib -b ..\3dodir\pmlib\3DEngine.lib -+pmobj\sound.obj
