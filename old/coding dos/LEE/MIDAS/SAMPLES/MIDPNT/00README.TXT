	MIDAS Module Player for Windows NT

This directory contains the source code for MidpNT. It's very messy
at the moment, but should be usable as an example on using MIDAS in
a slightly bigger program. You could also use this as a basis for
hacking together the module player of your choise.

To compile:
	Watcom: wmake -u
	Visual C: nmake VISUALC=1	

Also, make sure that mds06rc1.dll is somewhere in your path
(or just copy it here)