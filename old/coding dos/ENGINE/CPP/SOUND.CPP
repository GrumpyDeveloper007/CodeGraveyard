/*

 SOUND routines (NON LIBRARY) placed here (Seperated for faster compile!)

  Design & Code By Xavier / Phobia '97

  NB: Want to code this sort of shit? Well its simple, load up your C++
     compiler, bung some hardcore anthems in your CD player and pump up
     that volume. You`ll be surprised how quickly you can code this
     sort of thing, and how little you have to think. <MAYBE NOT!>

*/

#include <dos.h>
#include <conio.h>
#include <iostream.h>

#include "h\3dengine.h"

PAUDIOMODULE pModule;
unsigned long SEALStatus;
void (__interrupt __far *OldInterrupt)();
long ClockTicks,Counter;
AUDIOINFO info;
AUDIOCAPS caps;

void KillSEAL()
 {
 // Stop module and close voices
 if ((SEALStatus & 4)==4)        // Module playing
  {
  AStopModule();
  ACloseVoices();
  }
 
 if ((SEALStatus & 2)==2)        // Module loaded
  {
  // Release module file
  AFreeModuleFile(pModule);
  }

 if ((SEALStatus & 1)==1)       // SEAL Initialised
  {
  outp(0x43,0x34);
  outp(0x40,0);
  outp(0x40,0);

  _dos_setvect(0x08,OldInterrupt);

  // Close audio device
  ACloseAudio();
  }
 }

void __interrupt __far UpdateSEAL()
 {
 AUpdateAudio();

 ClockTicks+=Counter; // stuff the clock I dont need it anyway :-o
 if (ClockTicks>=0x10000)
  {
  ClockTicks-=0x10000;
  OldInterrupt();
  }
 else
  outp(0x20,0x20);
 }

void InitialiseSEAL()
 {
 // Initialize SEAL audio library

 SEALStatus=0;

 cout << "\n\nInitialising Audio Device - Implemented Using SEAL !!";

 AInitialize();

 // Open audio device

 info.nDeviceId = AUDIO_DEVICE_MAPPER;
 info.wFormat = AUDIO_FORMAT_16BITS | AUDIO_FORMAT_STEREO;
 info.nSampleRate = 44100;
 AOpenAudio(&info);

 // Display audio device information

 AGetAudioDevCaps(info.nDeviceId, &caps);

 cout << "\n\nUsing For Audio : " << caps.szProductName << " at ";
 if (info.wFormat&AUDIO_FORMAT_16BITS)
  cout << "16-bits ";
 else
  cout << "8-bits ";
 if (info.wFormat&AUDIO_FORMAT_STEREO)
  cout << "Stereo ";
 else
  cout << "Mono ";
 cout << info.nSampleRate << " Hz";

// Initialise Interrupt

 ClockTicks=0;
 Counter=(0x9000); //frequency;

 OldInterrupt=_dos_getvect(0x08);
 _dos_setvect(0x08,UpdateSEAL);

 // Set the PIT channel 0 frequency
 outp(0x43,0x34);
 outp(0x40,Counter%256);
 outp(0x40,Counter/256);

 SEALStatus|=1;
 }

void LoadModule(char *FileName)
 {
 // Load module file
 ALoadModuleFile(FileName, &pModule);
 SEALStatus|=2;
 }

void StartModule()
 {
 if ((SEALStatus&2)==2)       // Module loaded
  {
  // Open voices and play module
  AOpenVoices(pModule->nTracks);
  APlayModule(pModule);

  SEALStatus|=4;
  }
 }
