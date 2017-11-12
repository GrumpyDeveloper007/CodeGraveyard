wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\3doparse.obj cpp\3doparse.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\3doparse.obj cpp\3doparse.cpp
wlib -b lib\3DEngine.lib -+obj\3doparse.obj
wlib -b pmlib\3DEngine.lib -+pmobj\3doparse.obj
