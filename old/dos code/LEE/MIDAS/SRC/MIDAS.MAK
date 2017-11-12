#*      MIDAS.MAK
#*
#* Include file for all MIDAS Sound System make scripts. Defines compilation
#* rules for all standard MIDAS Sound System files.
#*
#* $Id: midas.mak,v 1.3 1997/01/16 18:41:59 pekangas Exp $
#*
#* Copyright 1996,1997 Housemarque Inc.
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*

midas.obj : midas.c midas.h
	$(CC) midas.c $(CCOPTS)

vgatext.obj : vgatext.asm lang.inc vgatext.inc
	$(ASM) vgatext.asm $(ASMOPTS)

gmplayer.obj : gmplayer.c lang.h mtypes.h errors.h sdevice.h gmplayer.h \
	mmem.h $(EMSH)
	$(CC) gmplayer.c $(CCOPTS)

gmpcmds.obj : gmpcmds.c lang.h mtypes.h errors.h sdevice.h gmplayer.h
	$(CC) gmpcmds.c $(CCOPTS) -w2

loadmod.obj : loadmod.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
	sdevice.h gmplayer.h mutils.h $(EMSH)
	$(CC) loadmod.c $(CCOPTS)

loadxm.obj : loadxm.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
	sdevice.h gmplayer.h mutils.h xm.h $(EMSH)
	$(CC) loadxm.c $(CCOPTS)

loads3m.obj : loads3m.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
	sdevice.h gmplayer.h mutils.h $(EMSH)
	$(CC) loads3m.c $(CCOPTS)

file.obj : file.c lang.h mtypes.h errors.h mmem.h rawfile.h file.h
	$(CC) file.c $(CCOPTS)

rawfile.obj : rawfile.c lang.h mtypes.h errors.h mmem.h rawfile.h
	$(CC) rawfile.c $(CCOPTS)

asmrfile.obj : asmrfile.asm lang.inc errors.inc rawfile.inc mmem.inc
	$(ASM) asmrfile.asm $(ASMOPTS)

dsm.obj : dsm.c lang.h errors.h mmem.h dsm.h sdevice.h dsm.h mutils.h \
	mglobals.h $(DPMIH) $(EMSH)
	$(CC) dsm.c $(CCOPTS)

mmem.obj : mmem.c lang.h errors.h mmem.h
	$(CC) mmem.c $(CCOPTS)

errors.obj : errors.c lang.h errors.h
	$(CC) errors.c $(CCOPTS)

mutils.obj : mutils.asm lang.inc mutils.inc
	$(ASM) mutils.asm $(ASMOPTS)

dsmmix.obj : dsmmix.asm lang.inc errors.inc sdevice.inc dsm.inc mglobals.inc \
	$(EMSINC)
	$(ASM) dsmmix.asm $(ASMOPTS)

dma.obj : dma.c lang.h mtypes.h errors.h mmem.h dma.h $(DPMIINC)
	$(CC) dma.c $(CCOPTS)

dpmi.obj : dpmi.asm lang.inc errors.inc dpmi.inc
	$(ASM) dpmi.asm $(ASMOPTS)

mixsd.obj : mixsd.c lang.h mtypes.h errors.h mmem.h mixsd.h dma.h sdevice.h \
	dsm.h
	$(CC) mixsd.c $(CCOPTS)

postproc.obj : postproc.asm lang.inc errors.inc dsm.inc
	$(ASM) postproc.asm $(ASMOPTS)

pas.obj : pas.asm pas.inc lang.inc errors.inc sdevice.inc dsm.inc \
	mixsd.inc $(DPMIINC)
	$(ASM) pas.asm $(ASMOPTS)

nosound.obj : nosound.c lang.h mtypes.h errors.h sdevice.h
        $(CC) nosound.c $(CCOPTS)

ems.obj : ems.asm lang.inc errors.inc ems.inc mmem.inc
	$(ASM) ems.asm $(ASMOPTS)

mglobals.obj : mglobals.c mglobals.h
	$(CC) mglobals.c $(CCOPTS)

sb.obj : sb.asm lang.inc errors.inc sdevice.inc dsm.inc dma.inc mixsd.inc \
	mutils.inc
	$(ASM) sb.asm $(ASMOPTS)

wss.obj : wss.asm lang.inc errors.inc sdevice.inc mixsd.inc dsm.inc
	$(ASM) wss.asm $(ASMOPTS)

gus.obj : gus.asm lang.inc errors.inc sdevice.inc
	$(ASM) gus.asm $(ASMOPTS)

gusdac.obj : gusdac.asm lang.inc errors.inc sdevice.inc
        $(ASM) gusdac.asm $(ASMOPTS)

timer.obj : timer.asm lang.inc mglobals.inc errors.inc timer.inc sdevice.inc \
	$(EMSINC)
	$(ASM) timer.asm $(ASMOPTS)

mconfig.obj : mconfig.c midas.h vgatext.h
        $(CC) mconfig.c $(CCOPTS)

vu.obj : vu.c lang.h mtypes.h errors.h mmem.h sdevice.h vu.h mutils.h
        $(CC) vu.c $(CCOPTS)

midas.h : lang.h mtypes.h errors.h mglobals.h mmem.h file.h sdevice.h \
	gmplayer.h timer.h dma.h dsm.h mutils.h $(EMSH)
	$(TOUCH) midas.h


#* $Log: midas.mak,v $
#* Revision 1.3  1997/01/16 18:41:59  pekangas
#* Changed copyright messages to Housemarque
#*
#* Revision 1.2  1996/05/30 22:38:46  pekangas
#* no changes?
#*
#* Revision 1.1  1996/05/22 20:49:33  pekangas
#* Initial revision
#*