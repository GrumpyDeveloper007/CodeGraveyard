#*      midasdll.mak
#*
#* Make script for MIDAS Sound System Win32 DLL
#*
#* $Id: midasdll.mak,v 1.3 1997/01/16 19:43:33 pekangas Exp $
#*
#* Copyright 1996,1997 Housemarque Inc.
#*
#* This file is part of the MIDAS Sound System, and may only be
#* used, modified and distributed under the terms of the MIDAS
#* Sound System license, LICENSE.TXT. By continuing to use,
#* modify or distribute this file you indicate that you have
#* read the license and understand and accept it fully.
#*

MIDASDIR = .
MIDASINCS = $(MIDASDIR)
MIDASLIB = $(MIDASDIR)\midasnt.lib

!ifndef DLLNAME
DLLFILE = midas.dll
LIBFILE = midasdll.lib
!else
DLLFILE = $(DLLNAME).dll
LIBFILE = $(DLLNAME).lib
!endif




!ifdef VISUALC

CC = cl
CFLAGS =  -c -W3 -WX -YX -Zp1 -MT -nologo -O2 -Ot -G5 -D__VC32__ -DDEBUG \
        -DNOTIMER -DDLL_EXPORT -D__NT__

!else

CC = wcc386
CFLAGS = -w3 -we -oneatx -5r -bt=nt -mf -bd -i$(MIDASINCS) -d__WC32__ \
        -dDEBUG -dNOTIMER -dDLL_EXPORT

!endif


all :           $(DLLFILE) $(LIBFILE)

!ifdef VISUALC

$(LIBFILE) $(DLLFILE) :         midasdll.obj $(MIDASLIB)
        link /dll /debug /debugtype:cv /out:$(DLLFILE) /implib:$(LIBFILE) \
                /machine:x86 midasdll.obj $(MIDASLIB) winmm.lib

!else

$(LIBFILE) :    $(DLLFILE)
        wlib $(LIBFILE) +-$(DLLFILE)

$(DLLFILE) :    midasdll.obj $(MIDASLIB)
        wlink system nt dll option caseexact option map name $(DLLFILE) \
                file midasdll library $(MIDASLIB)

!endif

midasdll.obj :          midasdll.c midasdll.h
        $(CC) $(CFLAGS) midasdll.c
