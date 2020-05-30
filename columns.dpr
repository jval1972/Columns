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
//    Project File
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr / jvalavanis@gmail.com
//  Site  : https://sourceforge.net/projects/columns-for-windows/
//------------------------------------------------------------------------------

program columns;

uses
  FastMM4 in 'FastMM4.pas',
  FastMM4Messages in 'FastMM4Messages.pas',
  Forms,
  frm_main in 'frm_main.pas' {ColumnsForm},
  frm_settings in 'frm_settings.pas' {SettingsForm},
  frm_hiscores in 'frm_hiscores.pas' {HiScoresForm},
  frm_splash in 'frm_splash.pas' {SplashForm},
  cl_engine in 'cl_engine.pas',
  cl_defs in 'cl_defs.pas',
  cl_colorpickerbutton in 'cl_colorpickerbutton.pas',
  cl_crtconsole in 'cl_crtconsole.pas',
  cl_utils in 'cl_utils.pas',
  frm_aboutframe in 'frm_aboutframe.pas' {AboutFrame: TFrame},
  frm_about in 'frm_about.pas' {AboutForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Columns';
  SplashForm := TSplashForm.Create(nil);
  SplashForm.Update;
  Application.CreateForm(TColumnsForm, ColumnsForm);
  Application.Run;
end.
