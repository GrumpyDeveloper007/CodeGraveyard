wasm -3p -fo=pmobj\textplot.obj -mf asm\textplot.asm
wcl386 /mf /ot -fpi87 -fp3 /l=pmodew /fe=demo.exe cpp\main.cpp ..\XavStuff\pmlib\Xavier.lib pmobj\*.obj pict\main.obj
pmwlite /c4 demo.exe
