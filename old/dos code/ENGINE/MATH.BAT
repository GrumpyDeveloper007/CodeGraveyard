wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\3dmath.obj cpp\3dmath.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\3dmath.obj cpp\3dmath.cpp
wlib -b ..\3dodir\lib\3DEngine.lib -+obj\3dmath.obj
wlib -b ..\3dodir\pmlib\3DEngine.lib -+pmobj\3dmath.obj
