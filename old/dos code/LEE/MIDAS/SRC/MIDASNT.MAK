#*      midasnt.mak
#*
#* Make script for MIDAS Sound System Windows NT library
#*
#* $Id: midasnt.mak,v 1.14 1997/01/16 18:41:59 pekangas Exp $
#*
#* Copyright 1996,1997 Housemarque Inc.
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*

# Note! use "nmake -f midasnt.mak VISUALC=1" to compile for Visual C!

# Compilers and options:

!ifdef VISUALC
CC = cl
CCOPTS =  -c -W3 -WX -YX -Zp1 -MT -nologo -O2 -Ot -G5 -D__VC32__ -DDEBUG \
        -DNOTIMER -D__NT__
ASM = tasm
ASMOPTS = -UT310 -p -m9 -zi -d__VC32__ -dDEBUG
!else
CC = wcc386
CCOPTS = -w3 -we -oneatx -5r -bt=nt -mf -d__WC32__ -dDEBUG -dNOTIMER -D__NT__
#CCOPTS = -w3 -d2 -we -5r -bt=nt -mf -fh -fhq -d__WC32__ -dDEBUG -dNOTIMER -D__NT__
ASM = tasm
ASMOPTS = -UT310 -p -m9 -zi -d__WC32__ -dDEBUG
!endif

LIBNAME = midasnt.lib

!ifdef VISUALC
LIBCMDS = midasnt.vcl
LIBCMD = lib /OUT:$(LIBNAME) /DEBUGTYPE:CV @$(LIBCMDS)
!else
LIBCMDS = midasnt.
LIBCMD = wlib -c -n $(LIBNAME) @$(LIBCMDS)
!endif


# These definitions ensure that the includes work OK:
O = obj

# Macros for MIDAS includes:
!include mincs.mak

$(LIBNAME) : midas.obj dsm.obj dsmmix.obj mmem.obj errors.obj \
        mutils.obj winwave.obj postproc.obj mglobals.obj \
        gmplayer.obj gmpcmds.obj file.obj rawf_nt.obj loadmod.obj \
        loadxm.obj loads3m.obj vu.obj dsmnsnd.obj mpoll.obj midasfx.obj \
        midasstr.obj midasdll.obj
        $(LIBCMD)

# Default rules:
.c.obj :
        $(CC) $< $(CCOPTS)

.asm.obj :
        $(ASM) $< $(ASMOPTS)


# Dependencies for MIDAS files:
!include mcdeps.mak
!include madeps.mak


#* $Log: midasnt.mak,v $
#* Revision 1.14  1997/01/16 18:41:59  pekangas
#* Changed copyright messages to Housemarque
#*
#* Revision 1.13  1996/12/07 21:42:30  pekangas
#* Now defines __NT__ on compiler command lines
#*
#* Revision 1.12  1996/09/25 18:37:10  pekangas
#* Added midasdll
#*
#* Revision 1.11  1996/09/22 23:02:32  pekangas
#* Added midasfx and midasstr modules
#*
#* Revision 1.10  1996/09/02 20:19:16  pekangas
#* Added -MT flag for Visual C
#*
#* Revision 1.9  1996/09/01 15:40:28  pekangas
#* Added -we flag to Watcom C
#*
#* Revision 1.8  1996/08/13 20:47:42  pekangas
#* Changed rawfile.obj to rawf_nt.obj
#*
#* Revision 1.7  1996/08/06 20:35:10  pekangas
#* Added mpoll.obj and changed the compiler flags to full optimization
#*
#* Revision 1.6  1996/07/29 19:33:29  pekangas
#* Added dsmnsnd.obj, some cleanup
#*
#* Revision 1.5  1996/07/16 20:21:21  pekangas
#* Added support for Visual C
#*
#* Revision 1.4  1996/05/24 21:25:42  pekangas
#* Separated assembler and C dependency information files
#*
#* Revision 1.3  1996/05/24 18:59:37  pekangas
#* Changed to use mdeps.mak and mincs.mak
#*
#* Revision 1.2  1996/05/23 20:51:27  pekangas
#* Added debug information to assembler modules also
#*
#* Revision 1.1  1996/05/22 20:49:33  pekangas
#* Initial revision
#*