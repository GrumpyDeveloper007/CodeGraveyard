wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\texture.obj cpp\texture.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\texture.obj cpp\texture.cpp
wlib -b ..\3dodir\lib\3DEngine.lib -+obj\texture.obj
wlib -b ..\3dodir\pmlib\3DEngine.lib -+pmobj\texture.obj
