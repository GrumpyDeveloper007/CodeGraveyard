{*      miniplay.pas
 *
 * A minimal Delphi console module player example
 *
 * Compile to a console application and link with midasdll unit
 *
 * Copyright 1996,1997 Housemarque Inc
 *
 * This file is part of the MIDAS Sound System, and may only be
 * used, modified and distributed under the terms of the MIDAS
 * Sound System license, LICENSE.TXT. By continuing to use,
 * modify or distribute this file you indicate that you have
 * read the license and understand and accept it fully.
*}

uses
    midasdll, sysutils;


procedure MIDASerror;
begin
    WriteLn('MIDAS error: ', MIDASgetErrorMessage(MIDASgetLastError));
    MIDASclose;
    halt;
end;


var
    module : MIDASmodule;

BEGIN
    MIDASstartup;
    if not MIDASinit then
        MIDASerror;
    if not MIDASstartBackgroundPlay(0) then
        MIDASerror;

    module := MIDASloadModule('..\data\templsun.xm');
    if module = NIL then
        MIDASerror;

    if not MIDASplayModule(module, 0) then
        MIDASerror;

    WriteLn('Playing - press enter');
    ReadLn;

    if not MIDASstopModule(module) then
        MIDASerror;
    if not MIDASfreeModule(module) then
        MIDASerror;
    if not MIDASstopBackgroundPlay then
        MIDASerror;
    if not MIDASclose then
        MIDASerror;
END.