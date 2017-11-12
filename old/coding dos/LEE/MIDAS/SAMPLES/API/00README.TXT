Examples on using the MIDAS DLL API. 

Compile:

	Watcom C, DOS: wmake -u DOS=1
	Watcom C, Win32: wmake -u 
	Visual C, Win32: wmake -u VISUALC=1

At this moment this doesn't compile under Linux, although the same
API would be available. Fixing to work with Linux should be trivial
- just change the program to use some curses function for reading the
keyboard instead of getch().


Petteri
