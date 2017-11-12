{*      midasdll.pas
 *
 * MIDAS DLL programming interface Delphi interface unit
 *
 * $Id: midasdll.h,v 1.1 1996/09/25 18:38:12 pekangas Exp $
 *
 * Copyright 1996,1997 Housemarque Inc
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*}

unit midasdll;


interface


uses wintypes;


const
    { enum MIDASoptions }
    MIDAS_OPTION_NONE = 0;
    MIDAS_OPTION_MIXRATE = 1;
    MIDAS_OPTION_OUTPUTMODE = 2;
    MIDAS_OPTION_MIXBUFLEN = 3;
    MIDAS_OPTION_MIXBUFBLOCKS = 4;

    { enum MIDASmodes }
    MIDAS_MODE_NONE = 0;
    MIDAS_MODE_MONO = 1;
    MIDAS_MODE_STEREO = 2;
    MIDAS_MODE_8BIT = 4;
    MIDAS_MODE_16BIT = 8;
    MIDAS_MODE_8BIT_MONO = MIDAS_MODE_8BIT or MIDAS_MODE_MONO;
    MIDAS_MODE_8BIT_STEREO = MIDAS_MODE_8BIT or MIDAS_MODE_STEREO;
    MIDAS_MODE_16BIT_MONO = MIDAS_MODE_16BIT or MIDAS_MODE_MONO;
    MIDAS_MODE_16BIT_STEREO = MIDAS_MODE_16BIT or MIDAS_MODE_STEREO;

    { enum MIDASsampleTypes }
    MIDAS_SAMPLE_NONE = 0;
    MIDAS_SAMPLE_8BIT_MONO = 1;
    MIDAS_SAMPLE_16BIT_MONO = 2;
    MIDAS_SAMPLE_8BIT_STEREO = 3;
    MIDAS_SAMPLE_16BIT_STEREO = 4;

    { enum MIDASloop }
    MIDAS_LOOP_NO = 0;
    MIDAS_LOOP_YES = 1;

    { enum MIDASpanning }
    MIDAS_PAN_LEFT = -64;
    MIDAS_PAN_MIDDLE = 0;
    MIDAS_PAN_RIGHT = 64;
    MIDAS_PAN_SURROUND = $80;

    { enum MIDASchannels }
    MIDAS_CHANNEL_AUTO = $FFFF;


type
    MIDASmoduleInfo = record
        songName : array[0..31] of char;
        songLength : integer;
        numPatterns : integer;
        numInstruments : integer;
        numChannels : integer;
    end;
    PMIDASmoduleInfo = ^MIDASmoduleInfo;

    MIDASinstrumentInfo = record
        instName : array[0..31] of char;
    end;
    PMIDASinstrumentInfo = ^MIDASinstrumentInfo;

    MIDASplayStatus = record
        position : dword;
        pattern : dword;
        row : dword;
        syncInfo : integer;
    end;
    PMIDASplayStatus = ^MIDASplayStatus;


    MIDASmodule = pointer;
    MIDASsample = DWORD;
    MIDASsamplePlayHandle = DWORD;
    MIDASstreamHandle = pointer;
    Pbyte = ^byte;



function MIDASgetLastError : integer; stdcall;
function MIDASgetErrorMessage(errorCode : integer) : PChar; stdcall;

function MIDASstartup : boolean; stdcall;
function MIDASinit : boolean; stdcall;
function MIDASsetOption(option, value : integer) : boolean; stdcall;
function MIDASclose : boolean; stdcall;
function MIDASopenChannels(numChannels : integer) : boolean; stdcall;
function MIDAScloseChannels : boolean; stdcall;
function MIDASstartBackgroundPlay(pollRate : dword) : boolean; stdcall;
function MIDASstopBackgroundPlay : boolean; stdcall;
function MIDASpoll : boolean; stdcall;
function MIDASgetVersionString : PChar; stdcall;

function MIDASloadModule(fileName : PChar) : MIDASmodule; stdcall;
function MIDASplayModule(module : MIDASmodule; numEffectChannels : integer) :
    boolean; stdcall;
function MIDASstopModule(module : MIDASmodule) : boolean ; stdcall;
function MIDASfreeModule(module : MIDASmodule) : boolean; stdcall;

function MIDASgetPlayStatus(status : PMIDASplayStatus) : boolean; stdcall;
function MIDASsetPosition(newPosition : integer) : boolean; stdcall;
function MIDASsetMusicVolume(volume : dword) : boolean; stdcall;
function MIDASgetModuleInfo(module : MIDASmodule; info : PMIDASmoduleInfo) :
    boolean; stdcall;
function MIDASgetInstrumentInfo(module : MIDASmodule; instNum : integer;
    info : PMIDASinstrumentInfo) : boolean; stdcall;

function MIDASloadRawSample(fileName : PChar; sampleType,
    loopSample : integer) : MIDASsample; stdcall;
function MIDASfreeSample(sample : MIDASsample) : boolean; stdcall;
function MIDASsetAutoEffectChannels(firstChannel, numChannels : dword) :
    boolean; stdcall;
function MIDASplaySample(sample : MIDASsample; channel : dword;
    priority : integer; rate, volume : dword; panning : integer) :
    MIDASsamplePlayHandle;
    stdcall;
function MIDASstopSample(sample : MIDASsamplePlayHandle) : boolean; stdcall;
function MIDASsetSampleRate(sample : MIDASsamplePlayHandle; rate : dword) :
    boolean; stdcall;
function MIDASsetSampleVolume(sample : MIDASsamplePlayHandle; volume : dword)
    : boolean; stdcall;
function MIDASsetSamplePanning(sample : MIDASsamplePlayHandle;
    panning : integer) : boolean; stdcall;
function MIDASsetSamplePriority(sample : MIDASsamplePlayHandle;
    priority : integer) : boolean; stdcall;

function MIDASplayStreamFile(channel : dword; fileName : PChar;
    sampleType : dword; sampleRate : dword; bufferLength : dword;
    loopStream : integer) : MIDASstreamHandle; stdcall;
function MIDASstopStream(stream : MIDASstreamHandle) : boolean; stdcall;

function MIDASplayStreamPolling(channel : dword; sampleType : dword;
    sampleRate : dword; bufferLength : dword) : MIDASstreamHandle; stdcall;
function MIDASfeedStreamData(stream : MIDASstreamHandle; data : Pbyte;
    numBytes : dword; feedAll : boolean) : dword; stdcall;

function MIDASsetStreamRate(stream : MIDASstreamHandle; rate : dword)
    : boolean; stdcall;
function MIDASsetStreamVolume(stream : MIDASstreamHandle; volume : dword)
    : boolean; stdcall;
function MIDASsetStreamPanning(stream : MIDASstreamHandle; panning : integer)
     : boolean; stdcall;


implementation



function MIDASgetLastError : integer;
    stdcall; external 'midas06.dll' name '_MIDASgetLastError@0';
function MIDASgetErrorMessage(errorCode : integer) : PChar;
    stdcall; external 'midas06.dll' name '_MIDASgetErrorMessage@4';

function MIDASstartup : boolean;
    stdcall; external 'midas06.dll' name '_MIDASstartup@0';
function MIDASinit : boolean;
    stdcall; external 'midas06.dll' name '_MIDASinit@0';
function MIDASsetOption(option, value : integer) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetOption@8';
function MIDASclose : boolean;
    stdcall; external 'midas06.dll' name '_MIDASclose@0';
function MIDASopenChannels(numChannels : integer) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASopenChannels@4';
function MIDAScloseChannels : boolean;
    stdcall; external 'midas06.dll' name '_MIDAScloseChannels@4';
function MIDASstartBackgroundPlay(pollRate : dword) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASstartBackgroundPlay@4';
function MIDASstopBackgroundPlay : boolean;
    stdcall; external 'midas06.dll' name '_MIDASstopBackgroundPlay@0';
function MIDASpoll : boolean;
    stdcall; external 'midas06.dll' name '_MIDASpoll@0';
function MIDASgetVersionString : PChar;
    stdcall; external 'midas06.dll' name '_MIDASgetVersionString@0';

function MIDASloadModule(fileName : PChar) : MIDASmodule;
    stdcall; external 'midas06.dll' name '_MIDASloadModule@4';
function MIDASplayModule(module : MIDASmodule; numEffectChannels : integer) :
    boolean;
    stdcall; external 'midas06.dll' name '_MIDASplayModule@8';
function MIDASstopModule(module : MIDASmodule) : boolean ;
    stdcall; external 'midas06.dll' name '_MIDASstopModule@4';
function MIDASfreeModule(module : MIDASmodule) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASfreeModule@4';

function MIDASgetPlayStatus(status : PMIDASplayStatus) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASgetPlayStatus@4';
function MIDASsetPosition(newPosition : integer) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetPosition@4';
function MIDASsetMusicVolume(volume : dword) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetMusicVolume@4';
function MIDASgetModuleInfo(module : MIDASmodule; info : PMIDASmoduleInfo) :
    boolean;
    stdcall; external 'midas06.dll' name '_MIDASgetModuleInfo@8';
function MIDASgetInstrumentInfo(module : MIDASmodule; instNum : integer;
    info : PMIDASinstrumentInfo) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASgetInstrumentInfo@12';

function MIDASloadRawSample(fileName : PChar; sampleType,
    loopSample : integer) : MIDASsample;
    stdcall; external 'midas06.dll' name '_MIDASloadRawSample@12';
function MIDASfreeSample(sample : MIDASsample) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASfreeSample@4';
function MIDASsetAutoEffectChannels(firstChannel, numChannels : dword) :
    boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetAutoEffectChannels@8';
function MIDASplaySample(sample : midasSample; channel : dword;
    priority : integer; rate, volume : dword; panning : integer) :
    MIDASsamplePlayHandle;
    stdcall; external 'midas06.dll' name '_MIDASplaySample@24';
function MIDASstopSample(sample : MIDASsamplePlayHandle) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASstopSample@4';
function MIDASsetSampleRate(sample : MIDASsamplePlayHandle; rate : dword) :
    boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetSampleRate@8';
function MIDASsetSampleVolume(sample : MIDASsamplePlayHandle; volume : dword)
    : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetSampleVolume@8';
function MIDASsetSamplePanning(sample : MIDASsamplePlayHandle;
    panning : integer) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetSamplePanning@8';
function MIDASsetSamplePriority(sample : MIDASsamplePlayHandle;
    priority : integer) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetSamplePlayHandle@8';

function MIDASplayStreamFile(channel : dword; fileName : PChar;
    sampleType : dword; sampleRate : dword; bufferLength : dword;
    loopStream : integer) : MIDASstreamHandle;
    stdcall; external 'midas06.dll' name '_MIDASplayStreamFile@24';
function MIDASstopStream(stream : MIDASstreamHandle) : boolean;
    stdcall; external 'midas06.dll' name '_MIDASstopStream@4';

function MIDASplayStreamPolling(channel : dword; sampleType : dword;
    sampleRate : dword; bufferLength : dword) : MIDASstreamHandle;
    stdcall; external 'midas06.dll' name '_MIDASplayStreamPolling@16';
function MIDASfeedStreamData(stream : MIDASstreamHandle; data : Pbyte;
    numBytes : dword; feedAll : boolean) : dword;
    stdcall; external 'midas06.dll' name '_MIDASfeedStreamData@16';

function MIDASsetStreamRate(stream : MIDASstreamHandle; rate : dword)
    : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetStreamRate@4';
function MIDASsetStreamVolume(stream : MIDASstreamHandle; volume : dword)
    : boolean;
    stdcall; external 'midas06.dll' name '_MIDASsetStreamVolume@4';
function MIDASsetStreamPanning(stream : MIDASstreamHandle; panning : integer)
     : boolean;
     stdcall; external 'midas06.dll' name '_MIDASsetStreamPanning@4';

BEGIN
END.