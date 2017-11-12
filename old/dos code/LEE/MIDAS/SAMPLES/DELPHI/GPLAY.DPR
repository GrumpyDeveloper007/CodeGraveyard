program gplay;

uses
  Forms,
  gplmain in 'gplmain.pas' {gplform},
  midasdll in '\midas\include\midasdll.pas';

{$R *.RES}

begin
  MIDASstartup;
  if not MIDASsetOption(MIDAS_OPTION_MIXBUFLEN, 200) then
    MIDASerror;
  if not MIDASinit then
    MIDASerror;
  if not MIDASstartBackgroundPlay(0) then
    MIDASerror;

  Application.Initialize;
  Application.CreateForm(Tgplform, gplform);
  Application.Run;

  if not MIDASstopBackgroundPlay then
    MIDASerror;
  if not MIDASclose then
    MIDASerror;
end.
