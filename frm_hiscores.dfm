object HiScoresForm: THiScoresForm
  Left = 297
  Top = 190
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'High Scores'
  ClientHeight = 268
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020080000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000CCCCCCCCCCCCCCC000000000000000
    00CCCCCCCCCCCCCCC09000000000000000CCCCCCCCCCCCCCC099000000000000
    00CCCCCCCCCCCCCCC09990000000000000CCCCCCCCCCCCCCC099990000000000
    00CCCCCCCCCCCCCCC09999000000000000CCCCCCCCCCCCCCC099990000000000
    00CCCCCCCCCCCCCCC09999000000000000CCCCCCCCCCCCCCC099990000000000
    00CCCCCCCCCCCCCCC09999000000000000CCCCCCCCCCCCCCC099990000000000
    00CCCCCCCCCCCCCCC09999000000000000CCCCCCCCCCCCCCC099990000000000
    00CCCCCCCCCCCCCCC09999000000000000CCCCCCCCCCCCCCC099990000000000
    00000000000000000099990000000000000AAAAAAAAAAAAAAA09990000000000
    0000AAAAAAAAAAAAAAA099000000000000000AAAAAAAAAAAAAAA090000000000
    000000AAAAAAAAAAAAAAA0000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFFFFFFFFFFFFFFFFFFFFFFFFFF80003FFF80001FFF80000FFF800007FF800
    003FF800001FF800001FF800001FF800001FF800001FF800001FF800001FF800
    001FF800001FF800001FF800001FF800001FFC00001FFE00001FFF00001FFF80
    001FFFC0001FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CrtPanel1: TPanel
    Left = 0
    Top = 0
    Width = 322
    Height = 227
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    Caption = ' '
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 227
    Width = 322
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 1
    object Button1: TButton
      Left = 232
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 0
    end
  end
end
