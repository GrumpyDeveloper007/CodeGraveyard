wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\world.obj cpp\world.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\world.obj cpp\world.cpp
wlib -b ..\3dodir\lib\3DEngine.lib -+obj\world.obj
wlib -b ..\3dodir\pmlib\3DEngine.lib -+pmobj\world.obj
