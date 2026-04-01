unit MainForm;

{$mode objfpc}{$H+}

interface

uses
  Clipbrd, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, Buttons, PairSplitter, ExtCtrls;

type

  { TFormMain }

  TFormMain = class(TForm)
    BtnGenerate: TButton;
    BtnCopy: TButton;
    BtnExport: TButton;
    BtnHide: TButton;
    BtnClose: TButton;
    BtnHistory: TButton;
    BtnAbout: TButton;
    ChkUpper: TCheckBox;
    ChkLower: TCheckBox;
    ChkNumbers: TCheckBox;
    ChkSymbols: TCheckBox;
    LabelTitel: TLabel;
    LabelTitel1: TLabel;
    LblLength: TLabel;
    MemoHistory: TMemo;
    MemoResult: TMemo;
    SaveDialog1: TSaveDialog;
    Shape1: TShape;
    TimerResize: TTimer;
    TrackBarLength: TTrackBar;
    procedure BtnAboutClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnGenerateClick(Sender: TObject);
    procedure BtnHistoryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TimerResizeTimer(Sender: TObject);
    procedure TrackBarLengthChange(Sender: TObject);
  private
    procedure AddToLog(const Password: string);
    procedure ToggleSize;

    function ShuffleString(const S: string): string;
    function GenerateUniquePassword(const Charset: string; Len: Integer): string;
    function BuildCharset: string;
  public

  end;

var
  FormMain: TFormMain;
  LogFolder: string;
  LogFile: string;
  TargetWidth: integer;
  StepSize: Integer = 10;
implementation
uses UnitAbout;
{$R *.lfm}

{ TFormMain }
function TFormMain.ShuffleString(const S: string): string;
var
  i, j: Integer;
  temp: Char;
begin
  Result := S;
  for i := Length(Result) downto 2 do
  begin
    j := Random(i) + 1;
    temp := Result[i];
    Result[i] := Result[j];
    Result[j] := temp;
  end;
end;

function TFormMain.GenerateUniquePassword(const Charset: string; Len: Integer): string;
var
  shuffled: string;
begin
  if Len > Length(Charset) then
    raise Exception.Create('Length exceeds unique characters available');

  shuffled := ShuffleString(Charset);
  Result := Copy(shuffled, 1, Len);
end;
function TFormMain.BuildCharset: string;
begin
  Result := '';

  if ChkUpper.Checked then
    Result += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  if ChkLower.Checked then
    Result += 'abcdefghijklmnopqrstuvwxyz';

  if ChkNumbers.Checked then
    Result += '0123456789';

  if ChkSymbols.Checked then
    Result += '!@#$%^&*()-_=+[]{}<>?';

  // 🔥 AUTO FIX: if nothing selected → default charset
  if Result = '' then
    Result := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

end;

procedure TFormMain.AddToLog(const Password: string);
var
  line: string;
begin
  line := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) + #9 + Password;

  MemoHistory.Lines.Add(line);
  MemoHistory.Lines.SaveToFile(LogFile); // simple & safe
end;
procedure TFormMain.ToggleSize;
begin
  if Width = 724 then
    TargetWidth := 318
  else
    TargetWidth := 724;

  TimerResize.Enabled := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FormMain.Width:=318;
  LblLength.Caption := Format('%d', [TrackBarLength.Position]);
  //LblLength.Caption := 'Length: ' + IntToStr(TrackBarLength.Position);
  MemoHistory.Clear;
  MemoResult.Clear;
  Randomize;

  // Use safe system folder
  LogFolder := ExtractFilePath(ParamStr(0)) + 'logs' + DirectorySeparator;

  if not DirectoryExists(LogFolder) then
    CreateDir(LogFolder);

  LogFile := LogFolder + FormatDateTime('yyyy-mm-dd', Date) + '.txt';

  // Create file if not exists
  if not FileExists(LogFile) then
  begin
    MemoHistory.Lines.Add('DateTime         '#9'Password');
    MemoHistory.Lines.Add('--------------------------------');
    MemoHistory.Lines.SaveToFile(LogFile);
  end
  else
  begin
    MemoHistory.Lines.LoadFromFile(LogFile);
  end;
end;

procedure TFormMain.TimerResizeTimer(Sender: TObject);
var
  NewWidth: Integer;
begin
  if Width < TargetWidth then
    NewWidth := Width + StepSize
  else
    NewWidth := Width - StepSize;

  // Stop condition
  if Abs(TargetWidth - Width) <= StepSize then
  begin
    Width := TargetWidth;
    TimerResize.Enabled := False;
  end
  else
    Width := NewWidth;

  // 🔥 Keep centered while animating
  Left := (Screen.Width div 2) - (Width div 2);
end;

procedure TFormMain.TrackBarLengthChange(Sender: TObject);
begin
  LblLength.Caption :=IntToStr(TrackBarLength.Position);

end;


procedure TFormMain.BtnGenerateClick(Sender: TObject);
var
  charset, password: string;
  len: Integer;
begin
  len := TrackBarLength.Position;

  try
    charset := BuildCharset;

    if charset = '' then
    begin
      ShowMessage('Select at least one character type');
      Exit;
    end;

    if len > Length(charset) then
    begin
      ShowMessage('Length too big for unique characters');
      Exit;
    end;

    password := GenerateUniquePassword(charset, len);

    MemoResult.Text := password;

    // 🔥 Auto copy
    Clipboard.AsText := password;

    // 🔥 Log
    AddToLog(password);

  except
    on E: Exception do
      ShowMessage(E.Message);
  end;
end;


procedure TFormMain.BtnHistoryClick(Sender: TObject);

begin
  if Width = 724 then
    TargetWidth := 318
  else
    TargetWidth := 724;

  TimerResize.Enabled := True;
end;

procedure TFormMain.BtnCopyClick(Sender: TObject);
begin
    Clipboard.AsText := MemoResult.Text;
    ShowMessage('Password copied!');
end;

procedure TFormMain.BtnCloseClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormMain.BtnAboutClick(Sender: TObject);
begin
  FormAbout := TFormAbout.Create(nil);
  try
    FormAbout.ShowModal;
  finally
    FormAbout.Free;
  end;
end;

procedure TFormMain.BtnExportClick(Sender: TObject);
begin
  begin
  SaveDialog1.FileName := 'PasswordHistory_' + FormatDateTime('yyyy-mm-dd', Date);

  if SaveDialog1.Execute then
    MemoHistory.Lines.SaveToFile(SaveDialog1.FileName);
end;

end;

end.

