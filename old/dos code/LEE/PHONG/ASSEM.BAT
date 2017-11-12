echo off
wasm -4p -d1 -fo=assem.obj -mf assem.asm
wasm -4 -fo=assemp.obj -mf assem.asm
wlib -b Elf.lib -+assem.obj
wlib -b ElfP.lib -+assemp.obj
