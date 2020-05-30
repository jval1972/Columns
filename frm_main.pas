//------------------------------------------------------------------------------
//
//  Columns - A portable puzzle game for Windows
//
//  Copyright (C) 2018 by Jim Valavanis
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
// DESCRIPTION:
//    Main Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr / jvalavanis@gmail.com
//  Site  : https://sourceforge.net/projects/columns-for-windows/
//------------------------------------------------------------------------------

unit frm_main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ComCtrls, ToolWin, Menus, ImgList, ExtCtrls, AppEvnts, cl_crtconsole,
  cl_colorPickerButton, cl_engine;

resourceString
  rsAppVersion = 'Version 1.0';
  rsFormat = '%5d';
  rsGameIsPaused = '             Game is Paused';
  rsScore = '   Score: ';
  rsLevel = '   Level: ';
  rsHiScore = 'New Best Record! Please enter your name:';

const
  NUMHISCORES = 10;

type
  THiScoreInfo = packed record
    Score: LongWord;
    Level: Integer;
    Name: string[16];
  end;

  THiScores = array[1..NUMHISCORES + 1] of THiScoreInfo;

  TColumnsForm = class(TForm)
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    New1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Separator1: TMenuItem;
    Pause1: TMenuItem;
    Separator2: TMenuItem;
    Exit1: TMenuItem;
    Tools1: TMenuItem;
    Options1: TMenuItem;
    BestRecord1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ToolBar1: TToolBar;
    ToolSeparator1: TToolButton;
    ToolSeparator2: TToolButton;
    ToolSeparator3: TToolButton;
    New2: TSpeedButton;
    Load2: TSpeedButton;
    Save2: TSpeedButton;
    Bevel1: TBevel;
    StatusBar1: TStatusBar;
    ApplicationEvents1: TApplicationEvents;
    ColumnsPanel: TPanel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure PauseClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure LoadClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure Game1Click(Sender: TObject);
    procedure Columns1GameOver(Sender: TObject; Score: Cardinal;
      Level: Byte);
    procedure Columns1UpdateScore(Sender: TObject; Score: Cardinal;
      Level: Byte);
    procedure Options1Click(Sender: TObject);
    procedure CheckIfPausedThreadExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure BestRecord1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Columns1: TColumnsBoard;
    Crt1: TCrtConsole;
    playername: string;
    procedure SortHiScores;
    function  IsHiScore: boolean;
    procedure UpdateHiScores;
    procedure UpdateScore(Score: Cardinal; Level: Byte);
    procedure AdjustFormSize;
    procedure SaveRegistrySettings;
    procedure RestoreRegistrySettings;
    procedure ShowBestRecordsForm;
  public
    HiScores: THiScores;
    { Public declarations }
  end;

var
  ColumnsForm: TColumnsForm;

implementation

uses
  frm_settings, frm_hiscores, frm_about, cl_defs, cl_utils;

{$R *.DFM}

procedure TColumnsForm.FormCreate(Sender: TObject);
begin
  Crt1 := TCrtConsole.Create(nil);
  Crt1.Left := 12;
  Crt1.Top := 40;
  Crt1.Width := 320;
  Crt1.Height := 26;
  Crt1.Caption := 'Crt1';
  Crt1.Font.Charset := GREEK_CHARSET;
  Crt1.Font.Color := clSilver;
  Crt1.Font.Height := -13;
  Crt1.Font.Name := 'Courier';
  Crt1.Font.Pitch := fpFixed;
  Crt1.Font.Style := [fsBold];
  Crt1.ParentColor := False;
  Crt1.ParentFont := False;
  Crt1.ScreenSizeX := 40;
  Crt1.ScreenSizeY := 2;
  Crt1.Parent := Self;

  Columns1 := TColumnsBoard.Create(nil);
  Columns1.Parent := ColumnsPanel;
  Columns1.Left := 2;
  Columns1.Top := 2;
  Columns1.OnUpdateScore := Columns1UpdateScore;
  Columns1.OnGameOver := Columns1GameOver;

  Color := clBlack;

  playername := '';

  RestoreRegistrySettings;
  Caption := Application.Title;
  StatusBar1.Panels[0].Text := Application.Title + ' ' + rsAppVersion;
  if ParamCount = 1 then
    Columns1.LoadFromFile(ParamStr(1));

  AdjustFormSize;

  UpdateScore(Columns1.CurrentScore, Columns1.CurrentLevel);
end;

procedure TColumnsForm.About1Click(Sender: TObject);
var
  flag: boolean;
  f: TAboutForm;
begin
  flag := Columns1.IsPaused;
  if not flag then
    Columns1.Pause;

  f := TAboutForm.Create(nil);
  try
    f.ShowModal;
  finally
    f.Free;
  end;

  if not flag then
    Columns1.Resume;
end;

procedure TColumnsForm.NewClick(Sender: TObject);
begin
  UpdateHiScores;
  Columns1.Start;
end;

procedure TColumnsForm.PauseClick(Sender: TObject);
begin
  Columns1.Pause;
end;

procedure TColumnsForm.ExitClick(Sender: TObject);
begin
  Close;
end;

procedure TColumnsForm.ApplicationEvents1Hint(Sender: TObject);
begin
  if Application.Hint <> '' then
    StatusBar1.Panels[0].Text := Application.Hint
  else
    StatusBar1.Panels[0].Text := Application.Title + ' ' + rsAppVersion;
end;

procedure TColumnsForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = wm_KeyDown) then
  begin
    case Msg.wParam of
      VK_LEFT: Columns1.ArrowLeft;
      VK_RIGHT: Columns1.ArrowRight;
      VK_UP: Columns1.ArrowUp;
      VK_DOWN: Columns1.ArrowDown;
    else
    end;
  end;
end;

procedure TColumnsForm.LoadClick(Sender: TObject);
begin
  UpdateHiScores;
  Columns1.LoadGame;
  AdjustFormSize;
end;

procedure TColumnsForm.SaveClick(Sender: TObject);
begin
  Columns1.SaveGame;
end;

procedure TColumnsForm.SaveAsClick(Sender: TObject);
begin
  Columns1.SaveAs
end;

procedure TColumnsForm.Game1Click(Sender: TObject);
begin
  Pause1.Checked := Columns1.IsPaused;
end;

procedure TColumnsForm.Columns1GameOver(Sender: TObject; Score: Cardinal;
  Level: Byte);
begin
  ShowMessage('Game Over');
  UpdateHiScores;
end;

procedure TColumnsForm.UpdateScore(Score: Cardinal; Level: Byte);
begin
  if IsHiScore then
    Crt1.TextColor(clWhite)
  else
    Crt1.TextColor(clSilver);
  Crt1.GoToXY(1, 1);
  Crt1.Write([rsScore, Format(rsFormat,[Score])]);
  Crt1.ClrEol;
  Crt1.GoToXY(21, 1);
  Crt1.Write([rsLevel, Format(rsFormat,[Level])]);
  Crt1.ClrEol;
end;

procedure TColumnsForm.Columns1UpdateScore(Sender: TObject;
  Score: Cardinal; Level: Byte);
begin
  UpdateScore(Score, Level);
end;

procedure TColumnsForm.Options1Click(Sender: TObject);
var
  f: TSettingsForm;
  flag: boolean;
begin
  flag := Columns1.IsPaused;
  if not flag then
    Columns1.Pause;
  f := TSettingsForm.Create(nil);
  try
    f.RadioGroup1.ItemIndex := integer(Columns1.Settings.IsHard);
    f.TrackBar1.Position := Columns1.Settings.StartingLevel;
    f.ColorPickerButton1.Color := Color;
    f.SpinEdit1.MinValue := MINROWS;
    f.SpinEdit1.MaxValue := MAXROWS;
    f.SpinEdit1.Value := Columns1.Settings.Rows;
    f.SpinEdit2.MinValue := MINCOLUMNS;
    f.SpinEdit2.MaxValue := MAXCOLUMNS;
    f.SpinEdit2.Value := Columns1.Settings.Columns;
    f.CheckBox1.Checked := Columns1.Settings.SoundOn;

    f.ShowModal;

    if f.ModalResult = mrOK then
    begin
      Columns1.Settings.IsHard := boolean(f.RadioGroup1.ItemIndex);
      Columns1.Settings.StartingLevel := f.TrackBar1.Position;
      Color := f.ColorPickerButton1.Color;
      Columns1.Settings.SoundOn := f.CheckBox1.Checked;
      if (f.SpinEdit1.Value <> Columns1.Settings.Rows) or
         (f.SpinEdit2.Value <> Columns1.Settings.Columns) then
      begin
        Columns1.Settings.Rows := f.SpinEdit1.Value;
        Columns1.Settings.Columns := f.SpinEdit2.Value;
        flag := true;
        Columns1.SetupGame;
      end;
      AdjustFormSize;
    end;
  finally
    f.Free;
  end;
  if not flag then
    Columns1.Pause(false);
end;

procedure TColumnsForm.AdjustFormSize;
begin
  LockWindowUpdate(Handle);
  Columns1.Settings.AdjustParentSize;
  ColumnsPanel.Width := Columns1.Width + 4;
  ColumnsPanel.Height := Columns1.Height + 4;
  ClientWidth := MaxI(ColumnsPanel.Width + 2 * 110, 350);
  ClientHeight := MaxI(ColumnsPanel.Height + 100, 400);
  Crt1.Left := (ClientWidth - Crt1.Width) div 2;
  ColumnsPanel.Left := (ClientWidth - Columns1.Width) div 2;
  LockWindowUpdate(0);
end;

procedure TColumnsForm.CheckIfPausedThreadExecute(Sender: TObject);
begin
  Crt1.GoToXY(1, 2);
  if Columns1.IsPaused then
  begin
    Crt1.TextColor(RGB(255, 255, 128));
    Crt1.Write([rsGameIsPaused]);
  end
  else
    Crt1.ClrEol;
end;

procedure TColumnsForm.SortHiScores;
var
  hsTmp: THiScoreInfo;

  procedure QuickSort(left, right: integer); register;
  var
    l, r: integer;
  begin
    if right > left then
    begin
      l := left;
      r := right;
      while l < r do
      begin
        while (HiScores[r].Score + HiScores[r].Level / MAXINT) <
              (HiScores[left].Score  + HiScores[left].Level / MAXINT) do
          dec(r);
        while ((HiScores[l].Score + HiScores[l].Level / MAXINT) >=
               (HiScores[left].Score + HiScores[left].Level / MAXINT)) and
              (l < r) do
          inc(l);
        if l < r then
        begin
          hsTmp := HiScores[l];
          HiScores[l] := HiScores[r];
          HiScores[r] := hsTmp;
        end;
      end;
      hsTmp := HiScores[left];
      HiScores[left] := HiScores[r];
      HiScores[r] := hsTmp;
      QuickSort(left, r - 1);
      QuickSort(r + 1, right)
    end
  end;

begin
  QuickSort(1, NUMHISCORES + 1);
end;

function TColumnsForm.IsHiScore: boolean;
begin
  SortHiScores;
  result := (Columns1.CurrentScore > HiScores[NUMHISCORES].Score) or
            ((Columns1.CurrentScore = HiScores[NUMHISCORES].Score) and
             (Columns1.CurrentLevel > HiScores[NUMHISCORES].Level));
end;

procedure TColumnsForm.UpdateHiScores;
begin
  if IsHiScore and (Columns1.CurrentScore * Columns1.CurrentLevel <> 0) then
  begin
    if not Columns1.IsPaused then
      Columns1.Pause(true);
    if InputQuery(Application.Title, rsHiScore, playername) then
    begin
      HiScores[NUMHISCORES + 1].Score := Columns1.CurrentScore;
      HiScores[NUMHISCORES + 1].Level := Columns1.CurrentLevel;
      HiScores[NUMHISCORES + 1].Name := playername;
      SortHiScores;
      ShowBestRecordsForm;
    end;
  end;
end;

procedure TColumnsForm.SaveRegistrySettings;
var
  fs: TFileStream;
begin
  cl_SaveSettingsToFile(ChangeFileExt(ParamStr(0), '.ini'));

  fs := TFileStream.Create(ChangeFileExt(ParamStr(0), '.hi'), fmCreate);
  try
    SortHiScores;
    fs.Write(HiScores, SizeOf(HiScores));
  finally
    fs.Free;
  end;
end;

procedure TColumnsForm.RestoreRegistrySettings;
var
  fs: TFileStream;
begin
  if cl_LoadSettingsFromFile(ChangeFileExt(ParamStr(0), '.ini')) then
  begin
    Columns1.Settings.IsHard := opt_gamehard;
    Columns1.Settings.StartingLevel := opt_startinglevel;
    Columns1.Settings.SoundOn := opt_sound;
    Color := opt_backgroundcolor;
    Columns1.Settings.Rows := opt_gamerows;
    Columns1.Settings.Columns := opt_gamecolumns;
    AdjustFormSize;
  end;

  ZeroMemory(@HiScores, SizeOf(HiScores));
  if FileExists(ChangeFileExt(ParamStr(0), '.hi')) then
  begin
    fs := TFileStream.Create(ChangeFileExt(ParamStr(0), '.hi'), fmOpenRead or fmShareDenyWrite);
    try
      fs.Read(HiScores, SizeOf(HiScores));
      SortHiScores;
    finally
      fs.Free;
    end;
  end;
end;

procedure TColumnsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  opt_gamehard := Columns1.Settings.IsHard;
  opt_startinglevel := Columns1.Settings.StartingLevel;
  opt_sound := Columns1.Settings.SoundOn;
  opt_backgroundcolor := Color;
  opt_gamerows := Columns1.Settings.Rows;
  opt_gamecolumns := Columns1.Settings.Columns;
  SaveRegistrySettings;
end;

procedure TColumnsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  UpdateHiScores;
end;

procedure TColumnsForm.BestRecord1Click(Sender: TObject);
var
  flag: boolean;
begin
  flag := Columns1.IsPaused;
  if not flag then
    Columns1.Pause;
  ShowBestRecordsForm;
  if not flag then
    Columns1.Resume;
end;

procedure TColumnsForm.ShowBestRecordsForm;
var
  f: THiScoresForm;
begin
  f := THiScoresForm.Create(self);
  try
    f.ShowModal;
  finally
    f.Free;
  end;
end;

procedure TColumnsForm.FormDestroy(Sender: TObject);
begin
  Columns1.Free;
  Crt1.Free;
end;

end.
