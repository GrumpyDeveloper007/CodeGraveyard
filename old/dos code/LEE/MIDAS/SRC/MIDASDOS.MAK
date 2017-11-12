#*      midasdos.mak
#*
#* Make script for MIDAS Sound System DOS library
#*
#* $Id: midasdos.mak,v 1.3 1997/01/16 18:41:59 pekangas Exp $
#*
#* Copyright 1996,1997 Housemarque Inc.
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*


CC = wcc386
CCOPTS = -w3 -zdp -zu -oneatx -s -bt=dos -d__WC32__ #-dNOTIMER
ASM = tasm
ASMOPTS = -UT310 -p -m9 -d__WC32__
#ASMOPTS = -UT310 -p -ml -m9 -zi -d__WC32__ -dDEBUG

LIBNAME = midasdos.lib
LIBCMDS = midasdos.

LIBCMD = wlib -c -n $(LIBNAME) @$(LIBCMDS)


# These definitions ensure that the includes work OK:
O = obj

# Macros for MIDAS includes:
!include mincs.mak


$(LIBNAME) : midas.obj dsm.obj dsmmix.obj mmem.obj errors.obj \
        mutils.obj dma.obj mixsd.obj postproc.obj pas.obj mglobals.obj \
        sb.obj gmplayer.obj gmpcmds.obj file.obj rawfile.obj loadmod.obj \
        wss.obj dostimer.obj vgatext.obj gus.obj loadxm.obj loads3m.obj \
        vu.obj nosound.obj mconfig.obj gusdac.obj dpmi.obj midasdll.obj \
        midasfx.obj
        $(LIBCMD)


# Default rules:
.c.obj :
        $(CC) $[* $(CCOPTS)

.asm.obj :
        $(ASM) $[* $(ASMOPTS)


# Dependencies for MIDAS files:
!include mcdeps.mak
!include madeps.mak



#* $Log: midasdos.mak,v $
#* Revision 1.3  1997/01/16 18:41:59  pekangas
#* Changed copyright messages to Housemarque
#*
#* Revision 1.2  1996/09/25 18:36:07  pekangas
#* Added midasdll.obj and midasfx.obj
#*
#* Revision 1.1  1996/06/06 20:34:16  pekangas
#* Initial revision
#*
#* Revision 1.2  1996/05/30 22:38:46  pekangas
#* no changes?
#*
#* Revision 1.1  1996/05/22 20:49:33  pekangas
#* Initial revision
#*