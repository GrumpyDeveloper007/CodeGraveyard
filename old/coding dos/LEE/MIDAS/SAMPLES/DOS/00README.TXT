DOS samples
-----------

This directory contains the MS-DOS examples. "demo.c" is an example on
how to use MIDAS in demos, and "miniplay.c" is a minimal DOS module
player.

Note that there are some differences in "demo.c" compared to MIDAS
pre-release versions:

        - The music synchronization callbacks (effect W in XMs and S3Ms)
        work now, check ..\data\templsun.xm.

        - There is some new code to handle the new timer - demo will
        complain loudly if it's unable to get proper screen sync
        (usually this happens when running under Win95)

        - The demo is modified for Assembly'96 competition rules - the
        setup only appears if neither GUS or SB is detected. To show
        config always, comment "#define ASM96" from the beginning.
        Note! If you don't show the config menu always, you must be
        sure to include proper credits elsewhere!

More examples are hopefully coming to v0.6.0 release.


Petteri
