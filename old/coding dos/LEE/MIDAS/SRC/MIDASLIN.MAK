#*      midaslinux.mak
#*
#* Make script for MIDAS Sound System Linux version
#*
#* $Id: Makefile,v 1.18 1996/10/07 10:18:26 jpaana Exp $
#*
#* Copyright 1996 Petteri Kangaslampi and Jarno Paananen
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*


# Destination directory for midp executable
DEST = /usr/local/bin
LIBDEST = /usr/lib


CPP = gcc

# The safest options
#CPPOPTS = -O2 -fomit-frame-pointer -m486 -g -fpack-struct -Wall -D__LINUX__ --DDEBUG

# For Pentium optimizing gcc 2.7.2p
#CPPOPTS = -O6 -frisc -fomit-frame-pointer -mpentium -g -fpack-struct -fstrength-reduce -Wall -D__LINUX__ -DDEBUG

# For gcc 2.7.2.1 (or any "normal" gcc) with pthreads
CPPOPTS = -O6 -fomit-frame-pointer -m486 -fpack-struct -fstrength-reduce -Wall -D__LINUX__ -DDEBUG -shared -D_REENTRANT

# For gcc 2.7.2p with pthreads
#CPPOPTS = -O6 -frisc -fomit-frame-pointer -mpentium -bpentium-linux -V2.7.2p -fpack-struct -fstrength-reduce -Wall -D__LINUX__ -DDEBUG -shared -D_REENTRANT


ASM = gcc
ASMOPTS = $(CPPOPTS)
LINK = gcc -lncurses -lpthread -L. -o
LIB = ar
TOUCH = /usr/bin/touch

.SUFFIXES:
.SUFFIXES: .c .h .S .o .pic

OBJS = midas.o midasdll.o midasfx.o dsm.o dsmmix.o mmem.o errors.o mutils.o postproc.o mglobals.o \
       gmplayer.o gmpcmds.o file.o rawfile.o loadmod.o loadxm.o loads3m.o \
       mpoll.o oss.o midasstr.o
 
SHOBJS = midas.pic midasdll.pic midasfx.pic dsm.pic dsmmix.pic mmem.pic errors.pic mutils.pic \
       postproc.pic mglobals.pic gmplayer.pic gmpcmds.pic file.pic rawfile.pic loadmod.pic loadxm.pic loads3m.pic \
       mpoll.pic oss.pic midasstr.pic


all :         	libs

libs:		libmidas.a libmidas.so

%.o:			%.c
		$(CPP) $(CPPOPTS) -c $< -o $@

%.o:			%.S
		$(ASM) $(ASMOPTS) -c $< -o $@

%.pic:			%.c
		$(CPP) $(CPPOPTS) -fpic -c $< -o $@

%.pic:			%.S
		$(ASM) $(ASMOPTS) -fpic -c $< -o $@

libmidas.a:	$(OBJS)
		rm -f libmidas.a
		$(LIB) r libmidas.a $(OBJS)
		ranlib libmidas.a

libmidas.so: 	$(SHOBJS)
	        rm -f libmidas.so
		$(CPP) -shared -Wl,-soname,libmidas.so.0 -o libmidas.so.0.6 $(SHOBJS) 
		ln -sf libmidas.so.0.6 libmidas.so

convert:	dsmmix.wdisasm
		sed -e s/_// -e s/+// -e s/.bss/.lcomm/ -e s/repe/rep\;/ dsmmix.wdisasm > dsmmix.S
		sed -e s/_// -e s/+// -e s/.bss/.lcomm/ -e s/repe/rep\;/ postproc.wdisasm > postproc.S		


midas.o : 	midas.c midas.h

midasdll.o : 	midasdll.c midasdll.h midas.h

midasfx.o : 	midasfx.c midasfx.h midas.h

gmplayer.o : 	gmplayer.c lang.h mtypes.h errors.h sdevice.h gmplayer.h mmem.h

gmpcmds.o : 	gmpcmds.c lang.h mtypes.h errors.h sdevice.h gmplayer.h

loadmod.o : 	loadmod.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
		sdevice.h gmplayer.h mutils.h

loadxm.o : 	loadxm.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
		sdevice.h gmplayer.h mutils.h xm.h

loads3m.o : 	loads3m.c lang.h mtypes.h errors.h mglobals.h mmem.h file.h \
		sdevice.h gmplayer.h mutils.h

file.o : 	file.c lang.h mtypes.h errors.h mmem.h rawfile.h file.h

rawfile.o : 	rawfile.c lang.h mtypes.h errors.h mmem.h rawfile.h

dsm.o : 	dsm.c lang.h errors.h mmem.h dsm.h sdevice.h dsm.h mutils.h \
		mglobals.h

mmem.o : 	mmem.c lang.h errors.h mmem.h

errors.o : 	errors.c lang.h errors.h

mutils.o : 	mutils.c lang.h mutils.h

mpoll.o : 	mpoll.c mpoll.h lang.h midas.h

dsmmix.o : 	dsmmix.S

mixsd.o : 	mixsd.c lang.h mtypes.h errors.h mmem.h mixsd.h dma.h sdevice.h dsm.h

postproc.o : 	postproc.S

oss.o : 	oss.c sdevice.h lang.h mtypes.h errors.h mmem.h sdevice.h

mglobals.o : 	mglobals.c mglobals.h

midas.h : 	lang.h mtypes.h errors.h mglobals.h mmem.h file.h sdevice.h \
		gmplayer.h dsm.h mutils.h rawfile.h mpoll.h midasfx.h 


clean:
		rm -f *.o *.pic *~ midp libmidas.*

#* $Log: Makefile,v $
#* Revision 1.18  1996/10/07 10:18:26  jpaana
#* Fixed
#*
#* Revision 1.17  1996/09/28 09:00:44  jpaana
#* Added shared libraries (for ELF only, as usual) support
#*
#* Revision 1.16  1996/09/28 08:12:40  jpaana
#* Added midasdll.*
#*
#* Revision 1.15  1996/09/28 06:50:36  jpaana
#* Added midasfx.h and midasstr.h
#*
#* Revision 1.14  1996/09/21 17:18:01  jpaana
#* Added mpoll.c
#*
#* Revision 1.13  1996/09/21 16:49:26  jpaana
#* Changed uss to oss
#*
#* Revision 1.12  1996/09/15 09:24:40  jpaana
#* Still some tweaking with the options
#*
#* Revision 1.11  1996/09/14 16:27:17  jpaana
#* Commented the various compiler options
#*
#* Revision 1.10  1996/09/14 16:13:01  jpaana
#* readded pthreads
#*
#* Revision 1.9  1996/09/08 20:36:32  jpaana
#* And still
#*
#* Revision 1.8  1996/09/08 20:32:32  jpaana
#* Modified some compiler flags
#*
#* Revision 1.7  1996/08/03 13:16:59  jpaana
#* Added non-Pthread configuration
#*
#* Revision 1.6  1996/08/02 19:00:41  jpaana
#* Added libmidas.a
#*
#* Revision 1.5  1996/06/05 19:40:35  jpaana
#* Modified for pthreads
#*
#* Revision 1.4  1996/05/25 15:49:57  jpaana
#* Still fixed dependencies
#*
#* Revision 1.3  1996/05/24 20:40:12  jpaana
#* Fixed dependencies
#*
#* Revision 1.2  1996/05/24 16:19:39  jpaana
#* Fixed to actually work
#*
#* Revision 1.1  1996/05/24 14:37:07  jpaana
#* Initial revision
#*





