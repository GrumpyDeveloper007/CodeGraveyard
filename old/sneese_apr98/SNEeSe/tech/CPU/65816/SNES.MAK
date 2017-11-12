ORIGIN		= Symantec C++
ORIGIN_VER	= Version 6.10
VERSION		= DEBUG

PROJ		= SNES
APPTYPE		= DOS EXE
PROJTYPE	= EXE

CC		= SC
MAKE		= MAKE
RC		= RCC
HC		= HC
ASM		= SC
DISASM		= OBJ2ASM
EXE2BIN		= EXE2BIN
LIBR		= IMPLIB
LNK		= LINK
CVPK		= CVPACK

DLLS		= 

HEADERS		= 

LIBS		= 

DEFFILE		= SNES.DEF

CFLAGS		=  -Jm -J -ms -C -3 -NC -c -w- -w6 -g 
HFLAGS		= $(CFLAGS) 
LFLAGS		=  /CO /LI 
MFLAGS		= MASTERPROJ=$(PROJ) 
RESFLAGS	=  
DEBUGGERFLAGS	=  -LOADSYMBOLS 
IMPLIBFLAGS	=  -IMPLIB -DLL 
CVPKFLAGS	=  
AFLAGS		= $(CFLAGS) 
HELPFLAGS	= 

MODEL		= S

PAR		= PROJS BATS OBJS

DEFINES		= 
RCDEFINES	= 
LIBDIRS		= 
INCLUDES	= -I. -Ic:\emulator\includes -Id:\sc\include\sys

OBJS		=  c:\emulator\bin\adrmode.OBJ  c:\emulator\bin\adrsmode.OBJ  c:\emulator\bin\cart.OBJ  \
		 c:\emulator\bin\cpu.OBJ  c:\emulator\bin\instr.OBJ  c:\emulator\bin\main.OBJ  c:\emulator\bin\memory.OBJ  \
		 c:\emulator\bin\opcodes.OBJ  c:\emulator\bin\utils.OBJ  c:\emulator\bin\vars.OBJ 

RCFILES		= 

RESFILES	= 

SYMS		= 

HELPFILES	= 

BATS		=  

.C.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.c

.CPP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cpp

.CXX.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cxx

.CP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cp

.H.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$*.sym $*.h

.HPP.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$*.sym $*.hpp

.HXX.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -o$*.sym $*.hxx

.C.EXP:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -e $*.c -l$*.lst

.CPP.EXP:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -e $*.cpp -l$*.lst

.CXX.EXP:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -e $*.cxx -l$*.lst

.CP.EXP:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -e $*.cp -l$*.lst

.ASM.EXP:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -e $*.asm -l$*.lst

.OBJ.COD:
	$(DISASM) $*.OBJ >$*.cod

.EXE.COD:
	$(DISASM) $*.EXE >$*.cod

.COM.COD:
	$(DISASM) $*.COM >$*.cod

.OBJ.EXE:
	$(LNK) $(LFLAGS) @$(PROJ).LNK

.EXE.COM:
	$(EXE2BIN) $*.EXE $*.COM

.DLL.LIB:
	$(LIBR) $*.LIB $*.DLL

.RTF.HLP:
	$(HC) $(HELPFLAGS) $*.HPJ

.ASM.OBJ:
	$(ASM) $(AFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.asm

.RC.RES: 
	$(RC) $(RCDEFINES) $(RESFLAGS) $(INCLUDES) $*.rc

.DLG.RES:
	echo \#include "windows.h" >$$$*.rc
	echo \#include "$*.h" >>$$$*.rc
	echo \#include "$*.dlg" >>$$$*.rc
	$(RC) $(RCDEFINES) $(RESFLAGS) $$$*.rc
	-del $*.res
	-ren $$$*.res $*.res



all:		$(PROJ).$(PROJTYPE) $(POSTLINK) done

$(PROJ).$(PROJTYPE):	$(PRECOMPILE) $(OBJS) $(RCFILES) $(RESFILES) $(HELPFILES) $(POSTCOMPILE) 
			$(LNK) $(LFLAGS) @$(PROJ).LNK
			$(CVPK) $$SCW$$.$(PROJTYPE) $(CVPKFLAGS)
			-del $(PROJ).$(PROJTYPE)
			-ren $$SCW$$.$(PROJTYPE) $(PROJ).$(PROJTYPE)
			-echo $(PROJ).$(PROJTYPE) built

done:
		-echo $(PROJ).$(PROJTYPE) done

buildall:	clean	all


clean:
		-del $(PROJ).$(PROJTYPE)
		-del c:\emulator\bin\SCPH.SYM
		-del c:\emulator\bin\adrmode.OBJ
		-del c:\emulator\bin\adrsmode.OBJ
		-del c:\emulator\bin\cart.OBJ
		-del c:\emulator\bin\cpu.OBJ
		-del c:\emulator\bin\instr.OBJ
		-del c:\emulator\bin\main.OBJ
		-del c:\emulator\bin\memory.OBJ
		-del c:\emulator\bin\opcodes.OBJ
		-del c:\emulator\bin\utils.OBJ
		-del c:\emulator\bin\vars.OBJ

cleanres:

res:		cleanres $(RCFILES) all


link:
		$(LNK) $(LFLAGS) @$(PROJ).LNK
		$(CVPK) $$SCW$$.$(PROJTYPE) $(CVPKFLAGS)
		-del $(PROJ).$(PROJTYPE)
		-ren $$SCW$$.$(PROJTYPE) $(PROJ).$(PROJTYPE)




include SNES.dep



c:\emulator\bin\adrmode.OBJ:	source\adrmode.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\adrmode.obj source\adrmode.c



c:\emulator\bin\adrsmode.OBJ:	source\adrsmode.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\adrsmode.obj source\adrsmode.c



c:\emulator\bin\cart.OBJ:	source\cart.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\cart.obj source\cart.c



c:\emulator\bin\cpu.OBJ:	source\cpu.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\cpu.obj source\cpu.c



c:\emulator\bin\instr.OBJ:	source\instr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\instr.obj source\instr.c



c:\emulator\bin\main.OBJ:	source\main.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\main.obj source\main.c



c:\emulator\bin\memory.OBJ:	source\memory.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\memory.obj source\memory.c



c:\emulator\bin\opcodes.OBJ:	source\opcodes.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\opcodes.obj source\opcodes.c



c:\emulator\bin\utils.OBJ:	source\utils.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\utils.obj source\utils.c



c:\emulator\bin\vars.OBJ:	source\vars.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -oc:\emulator\bin\vars.obj source\vars.c



