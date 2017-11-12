wpp386 /mf /ot /d2 /bt=dos4g /fo=obj\ipx.obj cpp\ipx.cpp
wpp386 /mf /ot /bt=pmodew /fo=pmobj\ipx.obj cpp\ipx.cpp
wlib -b lib\Xavier.lib -+obj\ipx.obj
wlib -b pmlib\Xavier.lib -+pmobj\ipx.obj
                                 
