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
//    Settings Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr / jvalavanis@gmail.com
//  Site  : https://sourceforge.net/projects/columns-for-windows/
//------------------------------------------------------------------------------

unit frm_settings;

interface

uses
  Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ComCtrls, ExtCtrls, Dialogs, Spin, cl_colorpickerbutton;

resourceString
  rsStartingLevel = 'Starting Level: %d';

type
  TSettingsForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    OKBtn: TButton;
    CancelBtn: TButton;
    Panel3: TPanel;
    StaticText1: TStaticText;
    Panel4: TPanel;
    StaticText2: TStaticText;
    SpinEdit1: TSpinEdit;
    StaticText3: TStaticText;
    SpinEdit2: TSpinEdit;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    RadioGroup1: TRadioGroup;
    Panel6: TPanel;
    StaticText4: TStaticText;
    TrackBar1: TTrackBar;
    ColorDialog1: TColorDialog;
    CheckBox1: TCheckBox;
    ColorPanel1: TPanel;
    procedure ColorPickerButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ColorPickerButton1: TColorPickerButton;
  end;

implementation

uses
  frm_main;

{$R *.DFM}

procedure TSettingsForm.ColorPickerButton1Click(Sender: TObject);
begin
  ColorDialog1.Color := ColorPickerButton1.Color;
  if ColorDialog1.Execute then
    ColorPickerButton1.Color := ColorDialog1.Color;
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;

  ColorPickerButton1 := TColorPickerButton.Create(nil);
  ColorPickerButton1.Parent := ColorPanel1;
  ColorPickerButton1.Align := alClient;
  ColorPickerButton1.OnClick := ColorPickerButton1Click;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  StaticText4.Caption := Format(rsStartingLevel, [TrackBar1.Position]);
end;

procedure TSettingsForm.TrackBar1Change(Sender: TObject);
begin
  StaticText4.Caption := Format(rsStartingLevel, [TrackBar1.Position]);
end;

procedure TSettingsForm.FormDestroy(Sender: TObject);
begin
  ColorPickerButton1.Free;
end;

end.

