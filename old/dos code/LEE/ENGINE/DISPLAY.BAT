wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\Display.obj cpp\Display.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\Display.obj cpp\Display.cpp
wlib -b lib\3DEngine.lib -+obj\Display.obj
wlib -b pmlib\3DEngine.lib -+pmobj\Display.obj
