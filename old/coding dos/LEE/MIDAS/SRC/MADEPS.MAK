#*      madeps.mak
#*
#* Defines make dependencies for MIDAS Sound System assembelr files
#* Note! You need to include mincs.mak first!
#*
#* $Id: madeps.mak,v 1.3 1997/01/16 18:41:59 pekangas Exp $
#*
#* Copyright 1996,1997 Housemarque Inc.
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*


dpmi.$(O) :     dpmi.asm lang.inc errors.inc dpmi.inc

gus.$(O) :      gus.asm lang.inc errors.inc sdevice.inc mmem.inc \
                mglobals.inc mutils.inc

gusdac.$(O) :   gusdac.asm lang.inc errors.inc sdevice.inc mixsd.inc dsm.inc \
                dma.inc mutils.inc

mutils.$(O) :   mutils.asm lang.inc mutils.inc

pas.$(O) :      pas.asm pas.inc lang.inc errors.inc sdevice.inc dsm.inc \
                mixsd.inc dpmi.inc

postproc.$(O) : postproc.asm lang.inc

sb.$(O) :       sb.asm lang.inc errors.inc sdevice.inc dsm.inc dma.inc \
                mixsd.inc mutils.inc

timer.$(O) :    timer.asm lang.inc mglobals.inc errors.inc timer.inc \
                sdevice.inc

vgatext.$(O) :  vgatext.asm lang.inc vgatext.inc

wss.$(O) :      wss.asm lang.inc errors.inc sdevice.inc mixsd.inc dsm.inc

dsmmix.$(O) :   dsmmix.asm lang.inc errors.inc sdevice.inc dsm.inc \
                mglobals.inc


#* $Log: madeps.mak,v $
#* Revision 1.3  1997/01/16 18:41:59  pekangas
#* Changed copyright messages to Housemarque
#*
#* Revision 1.2  1996/07/29 19:31:27  pekangas
#* .
#*
#* Revision 1.1  1996/05/24 21:24:00  pekangas
#* Initial revision
#*
#* Revision 1.1  1996/05/24 19:04:50  pekangas
#* Initial revision
#*