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
//    Main Game Functions
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr / jvalavanis@gmail.com
//  Site  : https://sourceforge.net/projects/columns-for-windows/
//------------------------------------------------------------------------------

unit cl_engine;

interface

{$R cl_sounds.res}

uses
  Windows, Messages, Classes, Controls, Graphics, SysUtils, MMSystem, Dialogs,
  ExtCtrls;

resourceString
  rsColumns = 'Columns';
  rsColumnsFileExtention = 'clm';
  rsColumnsFileFilter =
    'Columns Games (*.clm)|*.clm';
  rsCancelGame =
    'Cancel current game?';
  rsErrLoadFromStream =
    'Can not loading from stream.';

const
  MINROWS = 10;
  MAXROWS = 24;
  MINCOLUMNS = 4;
  MAXCOLUMNS = 12;
  STICKSIZE = 3;
  ColumnsSignature: array [0..19] of Char = 'Columns saved game'#10#13;

const
  MINLEVEL = 1;
  MAXLEVEL = 10;
  LEVELSPEED: array[MINLEVEL..MAXLEVEL] of integer = (
    1000, 800, 650, 525, 425, 350, 280, 225, 185, 150
  );

type
  TColumnsColor = (ccNone, ccSpecial, ccBlack, ccRed, ccGreen, ccYellow, ccBlue, ccSilver);

  TColumnsTable = array [1..MAXCOLUMNS, 1..MAXROWS] of TColumnsColor;

  TColumnsStick = class(TObject)
  public
    Bars: array[1..STICKSIZE] of TColumnsColor;
    constructor Create; virtual;
    procedure Suffle(IsHard: boolean);
    procedure Roll;
    procedure Clear;
    procedure LoadFromStream(s: TStream);
    procedure SaveToStream(s: TStream);
  end;

  TColumnsBoardSettings = class(TPersistent)
  private
    fBackGroundColor: TColor;
    fStartingLevel: byte;
    fNextLevelAfter: word; // Αριθμός πόντων για επόμενο επίπεδο
    fSoundOn: boolean;
    fRows: byte;
    fColumns: byte;
    fBoxSize: byte;
    fIsHard: boolean;
    fParent: TCustomControl;
    procedure SetBackGroundColor(Value: TColor);
    procedure SetStartingLevel(Value: byte);
    procedure SetNextLevelAfter(Value: word);
    procedure SetSoundOn(Value: boolean);
    procedure SetRows(Value: byte);
    procedure SetColumns(Value: byte);
    procedure SetBoxSize(Value: byte);
    procedure SetIsHard(Value: boolean);
  protected
  public
    constructor Create(AParent: TCustomControl); virtual;
    procedure Assign(Source: TPersistent); override;
    procedure AdjustParentSize;
    procedure LoadFromStream(s: TStream);
    procedure SaveToStream(s: TStream);
  published
    property BackGroundColor: TColor
      read fBackGroundColor write SetBackGroundColor default clWhite;
    property StartingLevel: byte
      read fStartingLevel write SetStartingLevel default 1;
    property NextLevelAfter: word
      read fNextLevelAfter write SetNextLevelAfter default 100;
    property Rows: byte
      read fRows write SetRows default 20;
    property Columns: byte
      read fColumns write SetColumns default 6;
    property SoundOn: boolean
      read fSoundOn write SetSoundOn default True;
    property BoxSize: byte
      read fBoxSize write SetBoxSize default 20;
    property IsHard: boolean
      read fIsHard write SetIsHard default False;
  end;

  TColumnsUpdateEvent =
    procedure(Sender: TObject; Score: LongWord; Level: byte) of object;

  TColumnsGameOverEvent = TColumnsUpdateEvent;

  TColumnsUpdateScoreEvent = TColumnsUpdateEvent;

  TColumnsBoard = class(TCustomControl)
  private
    Timer1: TTimer;
    fSettings: TColumnsBoardSettings;
    fCurrentLevel: byte;
    fCurrentScore: LongWord;
    fCurrentPos: TPoint;
    fTable: TColumnsTable;
    fStick: TColumnsStick;
    fSpeeding: boolean; // True αν έχουμε πατήσει το κάτω βέλος
    fGameOver: boolean;
    fOnGameOver: TColumnsGameOverEvent;
    fOnUpdateScore: TColumnsUpdateScoreEvent;
    fFileName: string;
    cacheBM: TBitmap;
    procedure SetSettings(Value: TColumnsBoardSettings);
    function IndexToRect(x, y: integer): TRect; overload;
    function IndexToRect(p: TPoint): TRect; overload;
    function StickIndexToRect(pos: integer): TRect;
    function StickIndexToPoint(pos: integer): TPoint;
  protected
    procedure WMEraseBkgnd(var Msg: TMessage); message wm_EraseBkgnd;
    procedure PaintStick(C: TCanvas);
    procedure Paint; override;
    procedure Step(Sender: TObject);
    function  Check: boolean;
    function  Merge: boolean;
    procedure CheckAndMerge;
    function  TableReduction: boolean;
    procedure PackTable;
    function GetSleepMsecs: integer;
    procedure NewStick(IsHard: boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure ArrowLeft;  // Πατήθηκε το αριστερό βέλος
    procedure ArrowRight; // Πατήθηκε το δεξί βέλος
    procedure ArrowUp;    // Πατήθηκε το πάνω βέλος
    procedure ArrowDown;  // Πατήθηκε το κάτω βέλος

    function  LoadGame: boolean;
    function  LoadFromFile(s: string): boolean;
    function  LoadFromStream(s: TStream): boolean;
    procedure SaveToFile(s: string);
    procedure SaveToStream(s: TStream);

    procedure AddPoints(p: LongWord);
    procedure Pause; overload;
    procedure Pause(flag: boolean); overload;
    procedure Resume;
    function  IsPaused: boolean;
    procedure Start;
    procedure ClearBoard;
    procedure SetupGame;
    procedure SaveGame;
    procedure SaveAs;

    property CurrentLevel: byte
      read fCurrentLevel write fCurrentLevel;
    property CurrentScore: LongWord
      read fCurrentScore write fCurrentScore;
    property GameOver: boolean
      read fGameOver;
  published
    property Settings: TColumnsBoardSettings
      read fSettings write SetSettings;
    property OnGameOver: TColumnsGameOverEvent
      read fOnGameOver write fOnGameOver;
    property OnUpdateScore: TColumnsUpdateScoreEvent
      read fOnUpdateScore write fOnUpdateScore;
    property Width;
    property Height;
    property Font;
    property Hint;
    property ParentShowHint;
    property Popupmenu;
    property ShowHint;
    property Align;
    property Visible;
    property TabStop;
  end;

function TColumnsColorToTColor(t: TColumnsColor): TColor;

implementation

uses
  cl_utils;
  
function TColumnsColorToTColor(t: TColumnsColor): TColor;
begin
  case t of
    ccBlack: Result := clBlack;
    ccRed: Result := clRed;
    ccGreen: Result := clGreen;
    ccYellow: Result := clYellow;
    ccBlue: Result := clBlue;
    ccSilver: Result := clSilver;
  else
    Result := clWhite;
  end;
end;

{ --- TColumnsBoardSettings --- }
constructor TColumnsBoardSettings.Create(AParent: TCustomControl);
begin
  Inherited Create;
  fParent := AParent;
  fBackGroundColor := clWhite;
  fStartingLevel := 1;
  fNextLevelAfter := 500;
  fSoundOn := True;
  fRows := 20;
  fColumns := 6;
  fBoxSize := 20;
  fIsHard := False;
end;

procedure TColumnsBoardSettings.Assign(Source: TPersistent);
begin
  if Source is TColumnsBoardSettings then
  begin
    fBackGroundColor := (Source as TColumnsBoardSettings).BackGroundColor;
    fStartingLevel := (Source as TColumnsBoardSettings).StartingLevel;
    fNextLevelAfter := (Source as TColumnsBoardSettings).NextLevelAfter;
    fSoundOn := (Source as TColumnsBoardSettings).SoundOn;
    fRows := (Source as TColumnsBoardSettings).Rows;
    fColumns := (Source as TColumnsBoardSettings).Columns;
    fBoxSize := (Source as TColumnsBoardSettings).BoxSize;
    fIsHard := (Source as TColumnsBoardSettings).IsHard;
    if not fSoundOn then
      PlaySound(nil, 0, 0);
    AdjustParentSize;
  end
  else if Source is TColumnsBoard then
    Assign((Source as TColumnsBoard).Settings)
  else
    raise Exception.Create('Invalid source assigned to TColumnsBoardSettings');
end;

procedure TColumnsBoardSettings.LoadFromStream(s: TStream);
begin
  s.Read(fBackGroundColor, SizeOf(fBackGroundColor));
  s.Read(fStartingLevel, SizeOf(fStartingLevel));
  s.Read(fNextLevelAfter, SizeOf(fNextLevelAfter));
  s.Read(fSoundOn, SizeOf(fSoundOn));
  s.Read(fRows, SizeOf(fRows));
  s.Read(fColumns, SizeOf(fColumns));
  s.Read(fBoxSize, SizeOf(fBoxSize));
  s.Read(fIsHard, SizeOf(fIsHard));
  if not fSoundOn then
    PlaySound(nil, 0, 0);
  AdjustParentSize;
end;

procedure TColumnsBoardSettings.SaveToStream(s: TStream);
begin
  s.Write(fBackGroundColor, SizeOf(fBackGroundColor));
  s.Write(fStartingLevel, SizeOf(fStartingLevel));
  s.Write(fNextLevelAfter, SizeOf(fNextLevelAfter));
  s.Write(fSoundOn, SizeOf(fSoundOn));
  s.Write(fRows, SizeOf(fRows));
  s.Write(fColumns, SizeOf(fColumns));
  s.Write(fBoxSize, SizeOf(fBoxSize));
  s.Write(fIsHard, SizeOf(fIsHard));
end;

procedure TColumnsBoardSettings.SetBackGroundColor(Value: TColor);
begin
  if fBackGroundColor <> Value then
  begin
    fBackGroundColor := Value;
    if Assigned(fParent) then InvalidateRect(fParent.Handle, nil, False);
  end
end;

procedure TColumnsBoardSettings.SetStartingLevel(Value: byte);
begin
  if Value in [1..10] then
  begin
    if fStartingLevel <> Value then
      fStartingLevel := Value;
  end
  else
    raise Exception.Create('Starting level must be in range [1..10]');
end;

procedure TColumnsBoardSettings.SetNextLevelAfter(Value: word);
begin
  if Value <> 0 then
    fNextLevelAfter := Value
  else
    raise Exception.Create('Points for next level must be <> 0');
end;

procedure TColumnsBoardSettings.SetSoundOn(Value: boolean);
begin
  if fSoundOn <> Value then
  begin
    fSoundOn := Value;
    if not fSoundOn then
      PlaySound(nil, 0, 0);
  end
end;

procedure TColumnsBoardSettings.SetRows(Value: byte);
begin
  if Value in [MINROWS..MAXROWS] then
  begin
    if fRows <> Value then
      fRows := Value;
  end
  else
    raise Exception.Create('Rows must be in [' + IntToStr(MINROWS) + '..' + IntToStr(MAXROWS) + ']');
end;

procedure TColumnsBoardSettings.SetColumns(Value: byte);
begin
  if Value in [MINCOLUMNS..MAXCOLUMNS] then
  begin
    if fColumns <> Value then
      fColumns := Value
  end
  else
    raise Exception.Create('Rows must be in [' + IntToStr(MINCOLUMNS) + '..' + IntToStr(MAXCOLUMNS) + ']');
end;

procedure TColumnsBoardSettings.SetBoxSize(Value: byte);
begin
  if Value <> fBoxSize then
  begin
    fBoxSize := Value;
    AdjustParentSize;
  end;
end;

procedure TColumnsBoardSettings.SetIsHard(Value: boolean);
begin
  if Value <> fIsHard then fIsHard := Value;

end;
procedure TColumnsBoardSettings.AdjustParentSize;
begin
  if Assigned(fParent) then
    fParent.SetBounds(fParent.Left, fParent.Top, fColumns * fBoxSize, fRows * fBoxSize);
end;

{ --- TColumnsStick --- }

constructor TColumnsStick.Create;
begin
  Inherited Create;
  Clear;
end;

procedure TColumnsStick.Clear;
var
  i: integer;
begin
  for i := 1 to STICKSIZE do
    Bars[i] := ccNone;
end;

procedure TColumnsStick.LoadFromStream(s: TStream);
begin
  s.Read(Bars, SizeOf(Bars));
end;

procedure TColumnsStick.SaveToStream(s: TStream);
begin
  s.Write(Bars, SizeOf(Bars));
end;

procedure TColumnsStick.Suffle(IsHard: boolean);
var
  i: integer;
begin
  // If game is hard we do not allow same colors in the stick
  if IsHard then
  begin
    Bars[1] := TColumnsColor(random(Ord(High(TColumnsColor)) - 1) + 2);
    repeat
      Bars[2] := TColumnsColor(random(Ord(High(TColumnsColor)) - 1) + 2);
    until Bars[2] <> Bars[1];
    repeat
      Bars[3] := TColumnsColor(random(Ord(High(TColumnsColor)) - 1) + 2);
    until (Bars[3] <> Bars[1]) and (Bars[3] <> Bars[2]);
  end
  else
  for i := 1 to STICKSIZE do
    Bars[i] := TColumnsColor(random(Ord(High(TColumnsColor)) - 1) + 2)
end;

procedure TColumnsStick.Roll;
var
  i: integer;
  tmp: array[1..STICKSIZE] of TColumnsColor;
begin
  tmp[STICKSIZE] := Bars[1];
  for i := 2 to STICKSIZE do
    tmp[i - 1] := Bars[i];
  for i := 1 to STICKSIZE do
    Bars[i] := tmp[i];
end;

{ --- TColumnsBoard --- }

constructor TColumnsBoard.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  randomize;
  cacheBM := TBitmap.Create;
  cacheBM.PixelFormat := pf24bit;
  fFileName := '';
  fSpeeding := False;
  fGameOver := False;
  fCurrentLevel := 1;
  fCurrentScore := 0;
  fCurrentPos := Point(0, 0);
  fSettings := TColumnsBoardSettings.Create(self);
  fStick := TColumnsStick.Create;
  Width := fSettings.fColumns * 20;
  Height := fSettings.fRows * 20;
  if not (csDesigning in ComponentState) then
  begin
    Timer1 := TTimer.Create(nil);
    Timer1.Interval := LEVELSPEED[MINLEVEL];
    Timer1.OnTimer := Step;
    Timer1.Enabled := False;
  end;
  SetupGame;
end;

destructor TColumnsBoard.Destroy;
begin
  if not (csDesigning in ComponentState) then
  begin
    Timer1.Enabled := False;
    Timer1.Free;
  end;
  fStick.Free;
  fSettings.Free;
  cacheBM.Free;
  Inherited;
end;

procedure TColumnsBoard.SetSettings(Value: TColumnsBoardSettings);
begin
  fSettings.Assign(Value);
end;

function TColumnsBoard.IndexToRect(x, y: integer): TRect;
begin
  SetRect(Result, fSettings.BoxSize * (x - 1),
                  fSettings.BoxSize * (y - 1),
                  fSettings.BoxSize * x,
                  fSettings.BoxSize * y);
end;

function TColumnsBoard.IndexToRect(p: TPoint): TRect;
begin
  Result := IndexToRect(p.X, p.Y);
end;

function TColumnsBoard.StickIndexToRect(pos: integer): TRect;
begin
  SetRect(Result, fSettings.BoxSize * (fCurrentPos.X - 1),
                  fSettings.BoxSize * (fCurrentPos.Y - pos - 1),
                  fSettings.BoxSize * fCurrentPos.X,
                  fSettings.BoxSize * (fCurrentPos.Y - pos));
end;

function TColumnsBoard.StickIndexToPoint(pos: integer): TPoint;
begin
  Result := Point(fCurrentPos.X, fCurrentPos.Y - pos + 1);
end;

procedure TColumnsBoard.AddPoints(p: LongWord);
begin
  inc(fCurrentScore, p);
  fCurrentLevel := MinI(fSettings.StartingLevel + (fCurrentScore div fSettings.NextLevelAfter), 10)
end;

procedure TColumnsBoard.Step(Sender: TObject);
begin
  if not fGameOver then
  begin
    Timer1.Interval := GetSleepMsecs;
    if fSpeeding then
    begin
      AddPoints(1); // One point for every fast step
      if Assigned(fOnUpdateScore) then
        fOnUpdateScore(Self, fCurrentScore, fCurrentLevel);
    end;
    CheckAndMerge;
    inc(fCurrentPos.Y);
    Invalidate;
  end;
end;

function TColumnsBoard.Check: boolean;
begin
  if fCurrentPos.Y = fSettings.Rows then
    Result := False
  else if fTable[fCurrentPos.X, fCurrentPos.Y + 1] <> ccNone then
  begin
    Result := False;
    if fCurrentPos.Y < 3 then
    begin
      fGameOver := True;
      fStick.Clear;
      Timer1.Enabled := False;
      if Assigned(fOnGameOver) then
        fOnGameOver(Self, fCurrentScore, fCurrentLevel);
      Pause;
      ClearBoard;
    end
  end
  else
    Result := True;
end;

function TColumnsBoard.Merge: boolean;
{ Merge fStick with fTable }
var
  i: integer;
  index: TPoint;
  flag: boolean;
begin
  Result := False;
  for i := 1 to STICKSIZE do
  begin
    index := StickIndexToPoint(i);
    fTable[Index.X, Index.Y] := fStick.Bars[i];
    fStick.Bars[i] := ccNone;
  end;
  repeat
    InvalidateRect(Handle, nil, False);
    UpdateWindow(Handle);
    Sleep(GetSleepMsecs);
    if Assigned(fOnUpdateScore) then
      fOnUpdateScore(Self, fCurrentScore, fCurrentLevel);
    flag := TableReduction;
    if flag then
      Result := True;
  until not flag or fGameOver;
end;

procedure TColumnsBoard.CheckAndMerge;
begin
  if not Check then
  begin
    if not Merge then
      if fSettings.SoundOn then
        PlaySound('COLUMNS_1', HInstance, SND_ASYNC or SND_RESOURCE);
    NewStick(fSettings.IsHard);
  end
end;

// Επιστρέφει True αν βρεθεί κάποια τριάδα.
function TColumnsBoard.TableReduction: boolean;
var
  i, j, k: integer;
  tmp: TColumnsTable;
begin
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      tmp[i, j] := ccNone;

  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      if fTable[i, j] <> ccNone then
      begin

        if not (i in [1, fSettings.Columns]) then
        begin
          if (fTable[i - 1, j] = fTable[i + 1, j]) and
             (fTable[i, j] = fTable[i + 1, j]) then
          begin
            tmp[i, j] := ccSpecial;
            tmp[i - 1, j] := ccSpecial;
            tmp[i + 1, j] := ccSpecial;
          end;
        end;

        if not (j in [1, fSettings.Rows]) then
        begin
          if (fTable[i, j - 1] = fTable[i, j + 1]) and
             (fTable[i, j] = fTable[i, j + 1]) then
          begin
            tmp[i, j] := ccSpecial;
            tmp[i, j - 1] := ccSpecial;
            tmp[i, j + 1] := ccSpecial;
          end;
        end;

        if not (i in [1, fSettings.Columns]) and
           not (j in [1, fSettings.Rows]) then
        begin
          if (fTable[i - 1, j - 1] = fTable[i + 1, j + 1]) and
             (fTable[i, j] = fTable[i + 1, j + 1]) then
          begin
            tmp[i, j] := ccSpecial;
            tmp[i - 1, j - 1] := ccSpecial;
            tmp[i + 1, j + 1] := ccSpecial;
          end;

          if (fTable[i + 1, j - 1] = fTable[i - 1, j + 1]) and
             (fTable[i, j] = fTable[i - 1, j + 1]) then
          begin
            tmp[i, j] := ccSpecial;
            tmp[i + 1, j - 1] := ccSpecial;
            tmp[i - 1, j + 1] := ccSpecial;
          end;
        end;

      end;

  Result := False;
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      if tmp[i, j] = ccSpecial then
      begin
        fTable[i, j] := ccNone;
        Result := True;
        AddPoints(10); // 10 βαθμοί για κάθε τετράγωνο
      end;


  if Result then
  begin
    if fSettings.SoundOn then
      PlaySound('COLUMNS_2', HInstance, SND_ASYNC or SND_RESOURCE);

    Sleep(GetSleepMsecs);
    for k := 1 to 2 do
    begin
      for i := 1 to fSettings.Columns do
        for j := 1 to fSettings.Rows do
          if tmp[i, j] = ccSpecial then
            InvertRect(Canvas.Handle, IndexToRect(i, j));
      Sleep(200);
      for i := 1 to fSettings.Columns do
        for j := 1 to fSettings.Rows do
          if tmp[i, j] = ccSpecial then
            InvertRect(Canvas.Handle, IndexToRect(i, j));
      Sleep(200);
    end;

    PackTable;
  end;

end;

procedure TColumnsBoard.PackTable;
var
  i, j, k: integer;
  tmp: TColumnsTable;
begin
  if fGameOver then
    Exit;
    
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      tmp[i, j] := ccNone;
  for i := 1 to fSettings.Columns do
  begin
    k := fSettings.Rows;
    for j := fSettings.Rows downto 1 do
    begin
      if fTable[i, j] <> ccNone then
      begin
        tmp[i, k] := fTable[i, j];
        dec(k);
      end;
    end;
  end;
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      fTable[i, j] := tmp[i, j];
end;

procedure TColumnsBoard.ArrowLeft;  // Πατήθηκε το αριστερό βέλος
var
  i: integer;
  CanDoIt: boolean;
  Index: TPoint;
begin
  if IsPaused and not fGameOver then
    Resume;
  if fCurrentPos.X > 1 then
  begin
    CanDoIt := True;
    for i := 1 to STICKSIZE do
      if i < fCurrentPos.Y then
      begin
        Index := StickIndexToPoint(i);
        CanDoIt := CanDoIt and (fTable[index.X - 1, index.Y] = ccNone);
      end;
    if CanDoIt then
    begin
      dec(fCurrentPos.X);
      Invalidate;
    end;
  end;
end;

procedure TColumnsBoard.ArrowRight; // Πατήθηκε το δεξί βέλος
var
  i: integer;
  CanDoIt: boolean;
  Index: TPoint;
begin
  if IsPaused and not fGameOver then
    Resume;
  if fCurrentPos.X < fSettings.Columns then
  begin
    CanDoIt := True;
    for i := 1 to STICKSIZE do
      if i < fCurrentPos.Y then
      begin
        Index := StickIndexToPoint(i);
        CanDoIt := CanDoIt and (fTable[index.X + 1, index.Y] = ccNone);
      end;
    if CanDoIt then
    begin
      inc(fCurrentPos.X);
      Invalidate;
    end;
  end;
end;

procedure TColumnsBoard.ArrowUp;    // Πατήθηκε το πάνω βέλος
begin
  if IsPaused and not fGameOver then
    Resume;
  if fSpeeding then
    fSpeeding := False
  else
  begin
    fStick.Roll;
    PaintStick(Canvas);
  end
end;

procedure TColumnsBoard.ArrowDown;  // Πατήθηκε το κάτω βέλος
begin
  if IsPaused and not fGameOver then
    Resume;
  if fSpeeding then
    fSpeeding := False
  else if not Timer1.Enabled then
    fSpeeding := True
  else
  begin
    Timer1.Enabled := False;
    fSpeeding := True;
    Timer1.Enabled := True;
  end;
end;

function TColumnsBoard.GetSleepMsecs: integer;
var
  alevel: integer;
begin
  if fSpeeding then
    Result := 50
  else
  begin
    alevel := fCurrentLevel;
    if alevel < MINLEVEL then
      alevel := MINLEVEL
    else if alevel > MAXLEVEL then
      alevel := MAXLEVEL;
    Result := LEVELSPEED[alevel];
  end;
end;

procedure TColumnsBoard.Pause;
begin
  Pause(not IsPaused);
end;

procedure TColumnsBoard.Pause(flag: boolean);
begin
  Timer1.Enabled := not flag;
end;

procedure TColumnsBoard.Resume;
begin
  Pause(False);
end;

function  TColumnsBoard.IsPaused: boolean;
begin
  Result := not Timer1.Enabled;
end;

procedure TColumnsBoard.Start;
begin
  if not IsPaused then
    Timer1.Enabled := False;
  SetupGame;
  Resume;
end;

procedure TColumnsBoard.WMEraseBkgnd(var Msg: TMessage);
begin
  Msg.Result := 1;
end;

procedure TColumnsBoard.PaintStick(C: TCanvas);
var
  i: integer;
  r: TRect;
begin
  for i := 1 to STICKSIZE do
    if fStick.Bars[i] <> ccNone then
    begin
      C.Brush.Color := TColumnsColorToTColor(fStick.Bars[i]);
      r := StickIndexToRect(i);
      C.FillRect(r);
    end;
end;

procedure TColumnsBoard.Paint;
var
  i, j: integer;
  r: TRect;
begin
  cacheBM.Width := Width;
  cacheBM.Height := Height;
  cacheBM.Canvas.Brush.Color := fSettings.BackGroundColor;
  cacheBM.Canvas.FillRect(Canvas.ClipRect);
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      if fTable[i, j] <> ccNone then
      begin
        cacheBM.Canvas.Brush.Color := TColumnsColorToTColor(fTable[i, j]);
        r := IndexToRect(i, j);
        cacheBM.Canvas.FillRect(r);
      end;
  PaintStick(cacheBM.Canvas);

  Canvas.CopyRect(Canvas.ClipRect, cacheBM.Canvas, Canvas.ClipRect);
end;

procedure TColumnsBoard.ClearBoard;
var
  i, j: integer;
begin
  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      fTable[i, j] := ccNone;
  fCurrentScore := 0;
  fCurrentLevel := fSettings.StartingLevel;
  if Assigned(fOnUpdateScore) then
    fOnUpdateScore(Self, fCurrentScore, fCurrentLevel);
end;

procedure TColumnsBoard.SetupGame;
begin
  ClearBoard;
  fGameOver := False;
  fFileName := '';
  NewStick(True);
end;

procedure TColumnsBoard.NewStick(IsHard: boolean);
begin
  if not fGameOver then
  begin
    fCurrentPos.X := random(fSettings.Columns) + 1;
    fCurrentPos.Y := 1;
    fStick.Suffle(IsHard);
    fSpeeding := False;
  end;
end;

function TColumnsBoard.LoadGame: boolean;
var
  OpenDialog1: TOpenDialog;
  flag: Boolean;
begin
  Result := False;
  flag := IsPaused;
  Pause(True);
  if fGameOver or
    (MessageBox(GetFocus, PChar(rsCancelGame), PChar(rsColumns),
     mb_YesNo or mb_IconQuestion) = id_Yes) then
  begin
    OpenDialog1 := TOpenDialog.Create(self);
    try
      OpenDialog1.Filter := rsColumnsFileFilter;
      OpenDialog1.DefaultExt := rsColumnsFileExtention;
      OpenDialog1.Options := OpenDialog1.Options +
        [ofPathMustExist, ofFileMustExist];
      if OpenDialog1.Execute then
        Result := LoadFromFile(OpenDialog1.FileName);
    finally
      OpenDialog1.Free;
    end;
  end;
  Pause(flag);
end;

function TColumnsBoard.LoadFromFile(s: string): boolean;
var
  f: TFileStream;
begin
  Result := False;
  f := TFileStream.Create(s, fmOpenRead);
  try
    if LoadFromStream(f) then
    begin
      Result := True;
      fFileName := s;
    end;
  finally
    f.Free;
  end;
end;

function TColumnsBoard.LoadFromStream(s: TStream): boolean;
var
  i, j: integer;
  Test: array [0..SizeOf(ColumnsSignature)] of Char;
begin
  if not IsPaused then
    Pause;
  Result := False;
  s.Read(Test, SizeOf(ColumnsSignature));
  if StrLComp(ColumnsSignature, Test, SizeOf(ColumnsSignature)) = 0 then
  begin
    try
      fSettings.LoadFromStream(s);
      s.Read(fCurrentScore, SizeOf(fCurrentScore));
      s.Read(fCurrentLevel, SizeOf(fCurrentLevel));
      s.Read(fGameOver, SizeOf(fGameOver));
      s.Read(fCurrentPos, SizeOf(fCurrentPos));
      fStick.LoadFromStream(s);

      for i := 1 to fSettings.Columns do
        for j := 1 to fSettings.Rows do
          s.Read(fTable[i, j], SizeOf(fTable[i, j]));

      InvalidateRect(Handle, nil, False);

      Result := True;
    finally
      if not Result then
        raise Exception.Create(rsErrLoadFromStream);
    end;
  end;
end;

procedure TColumnsBoard.SaveGame;
begin
  if fFileName = '' then
    SaveAs
  else
    SaveToFile(fFileName);
end;

procedure TColumnsBoard.SaveToFile(s: string);
var
  f: TFileStream;
begin
  f := TFileStream.Create(s, fmCreate);
  try
    SaveToStream(f);
  finally
    f.Free;
  end;
end;

procedure TColumnsBoard.SaveToStream(s: TStream);
var
  i, j: integer;
begin
  s.Write(ColumnsSignature, SizeOf(ColumnsSignature));
  fSettings.SaveToStream(s);
  s.Write(fCurrentScore, SizeOf(fCurrentScore));
  s.Write(fCurrentLevel, SizeOf(fCurrentLevel));
  s.Write(fGameOver, SizeOf(fGameOver));
  s.Write(fCurrentPos, SizeOf(fCurrentPos));
  fStick.SaveToStream(s);

  for i := 1 to fSettings.Columns do
    for j := 1 to fSettings.Rows do
      s.Write(fTable[i, j], SizeOf(fTable[i, j]));
end;

procedure TColumnsBoard.SaveAs;
var
  SaveDialog1: TSaveDialog;
  flag: boolean;
begin
  SaveDialog1 := TSaveDialog.Create(self);
  try
    flag := IsPaused;
    Pause(True);
    SaveDialog1.Filter := rsColumnsFileFilter;
    SaveDialog1.DefaultExt := rsColumnsFileExtention;
    SaveDialog1.Options := SaveDialog1.Options + [ofOverwritePrompt];
    if SaveDialog1.Execute then
    begin
      fFileName := SaveDialog1.FileName;
      SaveGame
    end;
    Pause(flag);
  finally
    SaveDialog1.Free;
  end;
end;

end.

