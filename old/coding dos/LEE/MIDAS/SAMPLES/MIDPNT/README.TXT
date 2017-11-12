        MIDAS Module Player for Windows NT, version 0.2.4
        --------------------------------------------------

MIDAS MODULE PLAYER IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. IN NO EVENT
WILL ANY OF THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY DAMAGES
CAUSED BY THE USE, OR INABILITY TO USE, OF MIDAS MODULE PLAYER.

MIDAS Module Player may freely be distributed as long as no money is
charged for it, and no attempt is made to restrict further copying,
distribution and using of MIDAS Module Player. If you have problems
with this, or do not understand this, contact us.



1. Foreword
-----------

Thank you for downloading MIDAS Module Player, and, above all, thank
you for reading the documentation. Although several versions of MidpNT
have already been released, it's far from finished, and the version
number reflects this.  The user interface is far from finished and
there is very little documentation, but the most important feature is
here: correct playback.

So what is MidpNT anyway? MidpNT is a free module player for Windows NT
and 95. It plays Protracker (MOD), Scream Tracker 3 (S3M) and
FastTracker 2 (XM) modules on all sound cards that Windows supports.

MidpNT might seem very unfinished and in general look like a music
system test program more than anything else - and that is exactly what
it is. The main intention of MidpNT is to test MIDAS Sound System and
give you an impression what it sounds like - that's why our emphasis is
on playback quality instead of the user interface. Moreover, MIDAS is
still very much under development, so all feedback you can give is
appreciated.


2. Using MidpNT
------------------

Using MidpNT is simple - just start it and you are on your way to play
music. You can use File/Open to select a module, or you can pass a
module file name in the command line. If you attempt to start a new
instance of MidpNT, the module file name will just be passed to the old
copy and it will take care of playing it. This allows you to just
associate MidpNT with all module extensions and use Explorer or File
Manager to select and play modules.

MidpNT now also accepts a command line option. Yes, that's right, a
single command line option. Pass MidpNT "-m" on the command line before
the module file name to start in minimal UI mode.


3. MidpNT User Interface
------------------------

The MidpNT user interface, although very spartan, should be pretty
straightforward and easy to use. The UI consists of one main window,
plus possibly several view windows. Views contain some information
about the song that is currently playing, and possibly some ways to
control the playback.

Note! The playlist feature isn't there.

[More information when I have time :)]


4. Configuring MidpNT
---------------------

MidpNT can be configured using the entries in the Options menu.
Preferences opens a dialog with generic user interface -related
preferences and Sound Options lets you change the sound output quality.
You can also save and restore the view window positions.

IMPORTANT! If you manage to screw MidpNT settings up so that it refuses
to start any more, edit the Registry from
HKEY_CURRENT_USER\Software\Sahara Surfers\MidpNT. You can also delete
the whole MidpNT key --- MidpNT will then start with default values.


5. Future
---------

There are already a couple of graphical module player projects based on
MIDAS going on, so be sure to check back every now and then.
Furthermore, I'll be slowly enhancing MidpNT as time goes on, but it's
mainly designed to be the kind of moduleplayer I myself and a few of my
close friends would like to use.

Anyway, new MIDAS-related module players will be announced at the
MidpNT home page, and there is a good chance that a major new player
will be released during the next couple of weeks or so - stay tuned!


6. Contact information
----------------------

Comments, bug reports and improvement ideas are always welcome, use one
of the following methods:

e-mail:         pekangas@sci.fi

phone:          +358-3-3172204 (note the new area code)

snail mail:     Petteri Kangaslampi
                Insinöörinkatu 60 A 49
                FIN-33720 Tampere
                Finland, Europe

The latest version of MidpNT is always available at
http://kalahari.ton.tut.fi/s2/midp.html, and more information about
MIDAS Sound System can be found at
http://kalahari.ton.tut.fi/s2/midas.html.

Note! When reporting bugs in MidpNT, please remember to include the
version information and build date displayed in the main window at
startup. (eg. "Version 0.1.5, built Sep 13 1996.")


7. Revisions
------------

0.2.4   - Linked with MIDAS 0.6.1, fixes a couple of bugs

0.2.3   - Added the icon. The icon was originally drawn by
          Han Solo of K/oS, and edited a bit by me. So all the ugly
          bits you can blame on myself :) The icon isn't really tested
          on 256-color or 16-color displays, let me know if it looks
          too bad.
        - Linked with MIDAS 0.6.0

0.2.2   - Rewrote archive support completely. Decompression target
          directory can now be set in the preferences. Now handles
          archives where the archive name isn't exactly the same as
          the module name.

0.2.1   - User Interface enhancements: decompression console is hidden,
          MidpNT now displays information in the window caption
        - Minimal UI mode
        - Linked with MIDAS 0.6.rc1

0.2.0   - Major internal reorganization, now uses the documented MIDAS
          DLL API exclusively
        - Several FT2 compatibility bugs fixed in MIDAS

0.1.7   - Linked with MIDAS 0.5.0 releas
        - Small bugfixes

0.1.6   - A new release with the release version of MIDAS 0.5.rc2

0.1.5   - Fixed various Scream Tracker 3 support problems, including
          bad panning and tempos
        - Fixed a potentially dangerous bug in MOD/S3M playback, which
          didn't surface under Windows NT/95 though

0.1.4   - Fixed several FastTracker 2 compatibility problems
        - Fixed some problems in loading invalid S3Ms (produced by ST3)
        - Other miscellaneous bugfixes in MIDAS Sound System code

0.1.3   - Fixed a bug in handling file names with spaces
        - Miscellaneous playback fixes
        - Added 3D-look attribute to Preferences-dialog
        - Changed some accelerator keys - song position is now changed
          with Ctrl-'.' and Ctrl-',', and Center Channels is Ctrl-E.
        - Accelerators now work even if a child window is active

0.1.2	- Fixed some bugs in module playback that were causing crashes

0.1.1   - Changed polling to use a thread instead of a multimedia timer
           - this uses much less CPU
        - Centering channels when there was no module playing crashed
          MidpNT, fixed

0.1.0   - Initial release in this format


[$Id: readme.txt,v 1.9 1997/02/19 10:08:52 pekangas Exp $]
