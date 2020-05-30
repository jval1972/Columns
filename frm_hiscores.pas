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
//    Hi-Scores Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr / jvalavanis@gmail.com
//  Site  : https://sourceforge.net/projects/columns-for-windows/
//------------------------------------------------------------------------------

unit frm_hiscores;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  cl_crtconsole, StdCtrls, ExtCtrls;

resourceString
  rsFormatScore1 = '%3d.';
  rsFormatScore2 = '%3d';
  rsFormatScore3 = '%7d';
  rsScoresTitle = '   #  Name              Level   Score';
  rsLine = ' -------------------------------------';

type
  THiScoresForm = class(TForm)
    CrtPanel1: TPanel;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Crt1: TCrtConsole;
  public
    { Public declarations }
  end;

implementation

uses
  frm_main;

{$R *.DFM}

procedure THiScoresForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  Color := clBlack;
  Crt1.ScreenSizeY := NUMHISCORES + 4;
  Crt1.Writeln(['']);
  Crt1.TextColor(clYellow);
  Crt1.Writeln([rsScoresTitle]);
  Crt1.Writeln([rsLine]);
  Crt1.TextColor(clWhite);
  for i := 1 to NUMHISCORES do
  begin
    Crt1.GoToXY(2, Crt1.WhereY);
    Crt1.Write([Format(rsFormatScore1, [i])]);
    Crt1.GoToXY(7, Crt1.WhereY);
    Crt1.Write([ColumnsForm.HiScores[i].Name]);
    Crt1.GoToXY(27, Crt1.WhereY);
    Crt1.Write([Format(rsFormatScore2, [ColumnsForm.HiScores[i].Level])]);
    Crt1.GoToXY(31, Crt1.WhereY);
    Crt1.Write([Format(rsFormatScore3, [ColumnsForm.HiScores[i].Score])]);
    Crt1.Writeln(['']);
  end;
end;

procedure THiScoresForm.FormCreate(Sender: TObject);
begin
  Crt1 := TCrtConsole.Create(nil);
  Crt1.Parent := CrtPanel1;
  Crt1.Align := alClient;
  Crt1.ScreenSizeX := 40;
  Crt1.ScreenSizeY := 11;
end;

procedure THiScoresForm.FormDestroy(Sender: TObject);
begin
  Crt1.Free;
end;

end.

