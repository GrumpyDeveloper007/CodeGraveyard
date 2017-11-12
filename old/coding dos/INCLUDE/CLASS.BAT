wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\class.obj cpp\class.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\class.obj cpp\class.cpp
wlib -b lib\Xavier.lib -+obj\class.obj
wlib -b pmlib\Xavier.lib -+pmobj\class.obj
