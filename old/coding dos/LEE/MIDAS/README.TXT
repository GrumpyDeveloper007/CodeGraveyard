        MIDAS Sound System v0.6.1, release notes
        ----------------------------------------

A Sahara Surfers production.

Copyright 1996, 1997 Housemarque Inc.

Written by Petteri Kangaslampi and Jarno Paananen
(a.k.a. Alfred & Guru / S2)

This file is part of the MIDAS Sound System, and may only be used,
modified and distributed under the terms of the MIDAS Sound System
license, LICENSE.TXT. By continuing to use, modify or distribute this
file you indicate that you have read the license and understand and
accept it fully.



1. Introduction and news
------------------------

This file accompanies the release of MIDAS Sound System v0.6.1. This
release just fixes a few bugs since 0.6.0, and contains no new
functionality. If you are developing software with MIDAS 0.6.0, we
suggest that you upgrade, although no fatal bugs have been found.
Delphi support has now been fixed, as well as some example program
make scripts.



2. Brief introduction to MIDAS
------------------------------

So what is MIDAS Sound System anyway?

In brief, MIDAS is a multichannel digital sound and music system,
capable of playing an unlimited number of channels of digital sound on
all supported platforms. It can play music modules, individual samples,
and digital audio streams, in any combination.

MIDAS supports the following module formats:
        - 4-channel Protracker modules plus 1-32-channel variants (.MOD)
        - 1-32 -channel Scream Tracker 3 modules (.S3M)
        - 2-32 -channel FastTracker 2 modules (.XM)

Under Win32 and Linux, MIDAS plays sound through the system sound API,
so all cards that have drivers installed are supported. Under DOS,
MIDAS supports the following sound cards:
        - Creative Labs Sound Blaster series (1.0, 1.5, 2.0, Pro, 16)
        - Media Vision Pro Audio Spectrum series (regular, Plus, 16)
        - Windows Sound System and compatible sound cards
        - Gravis Ultrasound (regular, max, PnP)

This release of MIDAS can be used for free for free programs, and full
source code is included. Licenses for commercial purposes are also
available, contact "midas@housemarque.fi" for details.



3. What's New?
--------------

Since the old 16-bit MIDAS 0.40a release, MIDAS has been rewritten
almost completely. A few hightlights of the changes include:
        - MIDAS now supports 32-bit environments. 16-bit support is
          removed.
        - MIDAS now plays FastTracker 2 (XM) modules
        - All individual Module Players are removed, a single Generic
          Module Player takes care of all module playback
        - MIDAS has been ported to Win32 and Linux
        - A new DLL API is available, with documentation

Fixes since MIDAS 0.6.0 include:
        - Fixed FastTracker 2 Sample Offset command
        - Fixed some crashes with S3Ms that contain invalid commands
        - Fixed Delphi interface unit



4. Supported platforms
----------------------

MIDAS supports the following platforms and compilers:
        - 32-bit MS-DOS under DOS/4GW, with Watcom C/C++
        - Windows NT/95 with Watcom C/C++
        - Windows NT/95 with Visual C/C++
        - Windows NT/95 with Borland Delphi
        - Linux with GNU C/C++

In addition, under Win32 MIDAS can be used with any programming
environment that supports DLLs. Direct examples are provided only for
Watcom and Visual C and Borland Delphi though.

Under Linux background and stream playing needs a pthreads compatible
package, preferably the LinuxThreads-package available at:

ftp://ftp.inria.fr/INRIA/Projects/cristal/Xavier.Leroy/linuxthreads.tar.gz



5. Using MIDAS
--------------

Before trying to use MIDAS, make sure you read all documentation
available in the "doc" directory. Most of the documents are included in
three formats: LaTeX (*.tex), Postscript (*.ps) and HTML (separate
directories). Postscript is recommended for printing and HTML for
reading on the computer, if you do not have a HTML browser available
you can read the LaTeX source directly. Unfortunately the documentation
is incomplete, but the information there is should be very useful.

After at least browsing through the documentation, you should check of
the examples in the "samples" directory. The directory "samples/api"
should be especially useful, as it contains several small programs that
demonstrate the new MIDAS API. DOS programmer's should also check
"samples/dos". "samples/midpnt" contains the source code for MIDAS
Module Player for Windows NT, a slightly bigger and more complex
program.

Some of the examples might require a bit tweaking, depending your
target system. In particular, you may need to edit a few lines at the
beginning of the Makefiles in the directories. However, the code itself
should compile cleanly on all supported platforms.

When you are ready to use MIDAS in your own programs, it is probably
useful to use one of the examples as a model. Remember that you are
allowed to use MIDAS for free programs as is, but for commercial usage
you will need to negotiate a license with us. In addition, your program
HAS to include proper credits for MIDAS, either in the program itself
or its documentation. This is even a requirement in the MIDAS license,
and if you fail to include the credits you are breaking it.



6. Contact Information
----------------------

Comments? Bug reports? Want more information about MIDAS or MIDAS
licensing? Contact us! E-mail is naturally preferred.

For technical questions, contact Petteri Kangaslampi:

        E-Mail:         pekangas@sci.fi (preferred)
                        k153997@cs.tut.fi (slow, use as backup if scifi
                                fails)

        Snail mail: (please don't)
                        Petteri Kangaslampi
                        Insinoorinkatu 60 A 49
                        FIN-33720 Tampere
                        Finland
                        Europe

        Phone:          +358-3-3172204 (note the new area code)


Linux-specific questions should go to Jarno Paananen:

        E-Mail:         jpaana@iki.fi


For MIDAS licensing information:

        E-Mail:         midas@housemarque.fi


The latest version is always available at our WWW site:
"http://kalahari.ton.tut.fi/s2/midas.html". You can also find all MIDP
versions there plus all latest MIDAS related news.

In addition, there is a mailing list available. Send a mail to Petteri
and request that you are added. The list is mainly intended for
MIDAS-related announcements, but some discussion is possible as well.



7. Getting MIDAS
----------------

The best and fastest way to get MIDAS is the Internet. The latest MIDAS
version is always at "http://kalahari.ton.tut.fi/s2/midas.html". In
addition, you can find there the latest MIDAS news, MIDP releases, and
general information.

In addition, MIDAS is available at the following fine BBSes:

        Edge Of Delight
                Node 1: +32-2-3755651   Boca 28.8K (V34/VFAST)
                Node 2: +32-2-3758923   ZyXEL 19.2K (V32terbo)
                Node 3: +32-2-3721089   ISDN 64K (X75)
                Chaos Managers: Cobra, aCceSs & Fredy

        The Underworld BBS
                Node 1: +41-22-9600621  USR Courier V.34+, ISDN Analog
                Node 2: +41-22-9600622  USR Courier V.34+, ISDN Analog
                Node 3: +41-22-9600623  ZyXEL Elite 2864I 64kb ISDN,
                                                ISDN Digital
                Sysop: Synoptic

        WarmBoot BBS
                Node 1: +55-194-261993
                Sysop: Warmbooter

        South of Heaven BBS
                Node 1: +1-916-567-1090 (2x28.8k)
                Sysop: Pantera

        Psycho Beaver BBS
                Node 1: +972-9-8320175 (2x28.8k)
                Sysop: riff raff

        Apologies for any boards we forgot - email us with your current
        information and you are back on the list. I have to confess I
        haven't kept very good track on our distribution sites, and now
        deliberately left out everybody I haven't heard from in a year
        or so...



8. Acknowledgements
-------------------

There is no way we could have MIDAS what it is alone, and we feel we
really owe a big "thank you" to the following people:

        Otto Chrons: Thanks for the sound cards, programming
        information, plus optimization and debugging hints.

        Teemu Kalvas: Thanks for some serious beta-testing,
        optimization ideas (still unused, maybe some day), and just
        general helpfulness.

        Jarno Heikkinen: Thanks for your support and the GUS PnP
        code. Wonder if it actually works? :)

        Carlos Hasan: Thanks for all your XM playing information

        Francois Baligant: One of the most supportive people I know.
        Nice meeting you at Wired'96, hopefully we'll meet this year
        too.

        Mikko Karvonen and Janne Oksanen: Thanks for composing all that
        wicked music :)

        And everybody who has sent us feedback on MIDAS - too numerous
        to mention, and all extremely important. Keep it coming!


Plus some traditional hillos to our friends in the scene and beyond:

        #cokers - you know who you are

	Alik. Katainen J-P :)
        Kari-Pekka Koljonen
        Kraku
        Nemesis1
        Statix
        Unreal

        The whole Virtual Visions team
        Everybody in Parallax
        Our friends in Prime

        All nice, intelligent and friendly people on #coders (there are
        some, right?)

        Byterapers
        CNCD
        Complex
        Paranoids
        Virtual Dreams


And finally, thanks to all our friends, both real and virtual - thank
you for being who you are, for doing what you do, the way you do.



-- Petteri Kangaslampi & Jarno Paananen, 19 Feb 1997






