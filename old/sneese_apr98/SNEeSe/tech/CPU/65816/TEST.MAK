ORIGIN		= Symantec C++
ORIGIN_VER	= Version 6.10
VERSION		= DEBUG

PROJ		= TEST
APPTYPE		= WINDOWS EXE
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

LIBS		= LIBW.LIB COMMDLG.LIB SHELL.LIB

DEFFILE		= TEST.DEF

CFLAGS		=  -Jm -ml -C -W1 -2 -c -g 
HFLAGS		= $(CFLAGS) 
LFLAGS		=  /CO /LI 
MFLAGS		= MASTERPROJ=$(PROJ) 
RESFLAGS	=  
DEBUGGERFLAGS	=  -LOADSYMBOLS 
IMPLIBFLAGS	=  -IMPLIB -DLL 
CVPKFLAGS	=  
AFLAGS		= $(CFLAGS) 
HELPFLAGS	= 

MODEL		= L

PAR		= PROJS BATS OBJS

DEFINES		= 
RCDEFINES	= 
LIBDIRS		= 
INCLUDES	= 

OBJS		=  ..\vs2m\source\ch12\vbuf.OBJ 

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
		-del SCPH.SYM
		-del ..\vs2m\source\ch12\vbuf.OBJ

cleanres:

res:		cleanres $(RCFILES) all


link:
		$(LNK) $(LFLAGS) @$(PROJ).LNK
		$(CVPK) $$SCW$$.$(PROJTYPE) $(CVPKFLAGS)
		-del $(PROJ).$(PROJTYPE)
		-ren $$SCW$$.$(PROJTYPE) $(PROJ).$(PROJTYPE)




include TEST.dep

