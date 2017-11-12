unit gplmain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  Tgplform = class(TForm)
    LoadButton: TButton;
    OpenDialog: TOpenDialog;
    PlayButton: TButton;
    StopButton: TButton;
    PosTrack: TTrackBar;
    UpdateTimer: TTimer;
    procedure LoadButtonClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure PosTrackChange(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  gplform: Tgplform;

procedure MIDASerror;

implementation

uses midasdll;

var
   module : MIDASmodule;
   playing : boolean;

procedure MIDASerror;
var
   message : PChar;
begin
     message := MIDASgetErrorMessage(MIDASgetLastError);
     Application.MessageBox(message, 'MIDAS error', MB_OK or MB_ICONSTOP);
     MIDASclose;
     halt;
end;

{$R *.DFM}

procedure Tgplform.LoadButtonClick(Sender: TObject);
var
  cfilename : array[0..256] of char;
  info : MIDASmoduleInfo;
  captxt : string[64];
begin
  if OpenDialog.Execute then
  begin
    StrPCopy(cfilename, OpenDialog.FileName);
    if module <> NIL then begin
      if not MIDASstopModule(module) then
        midasError;
      if not MIDASfreeModule(module) then
        midasError;
      module := NIL;
    end;

    module := MIDASloadModule(cfilename);
    if module = NIL then begin
      Application.MessageBox(MIDASgetErrorMessage(MIDASgetLastError),
        'Module loading error', MB_OK or MB_ICONSTOP);
      exit;
    end;

    if not MIDASplayModule(module, 0) then
      MIDASerror;
    playing := true;

    if not MIDASgetModuleInfo(module, @info) then
      MIDASerror;

    captxt := info.songName;
    gplform.Caption := captxt;

    PosTrack.Enabled := true;
    PosTrack.Min := 0;
    PosTrack.Max := info.songLength - 1;    
  end;
end;

procedure Tgplform.PlayButtonClick(Sender: TObject);
begin
  if (not playing) and (module <> NIL) then
  begin
    if not MIDASplayModule(module, 0) then
      MIDASerror;
    playing := true;
    PosTrack.Enabled := true;
  end;
end;



procedure Tgplform.StopButtonClick(Sender: TObject);
begin
    if (playing) and (module <> NIL) then
    begin
        if not MIDASstopModule(module) then
            MIDASerror;
        playing := false;
        PosTrack.Enabled := false;
    end;
end;


procedure Tgplform.PosTrackChange(Sender: TObject);
begin
    if playing then
    begin
        if not MIDASsetPosition(PosTrack.Position) then
            MIDASerror;
    end;
end;

procedure Tgplform.UpdateTimerTimer(Sender: TObject);
var
    state : MIDASplayStatus;
begin
    if playing then
    begin
        if not MIDASgetPlayStatus(@state) then
            MIDASerror;
        if state.position <> PosTrack.position then
            PosTrack.position := state.position;
    end;
end;


begin
  module := NIL;
  playing := false;
end.
