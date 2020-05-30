object SettingsForm: TSettingsForm
  Left = 634
  Top = 145
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 196
  ClientWidth = 212
  Color = clBtnFace
  ParentFont = True
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
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 212
    Height = 162
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    ParentColor = True
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 202
      Height = 152
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Game'
        ImageIndex = 1
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 194
          Height = 124
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          Caption = ' '
          TabOrder = 0
          object RadioGroup1: TRadioGroup
            Left = 5
            Top = 5
            Width = 184
            Height = 56
            Align = alTop
            Caption = ' Difficulty Settings '
            ItemIndex = 0
            Items.Strings = (
              'Easy'
              'Hard')
            TabOrder = 0
          end
          object Panel6: TPanel
            Left = 5
            Top = 61
            Width = 184
            Height = 62
            Align = alTop
            BevelOuter = bvNone
            Caption = ' '
            TabOrder = 1
            object StaticText4: TStaticText
              Left = 8
              Top = 6
              Width = 94
              Height = 17
              Caption = 'Starting Level: %d'
              TabOrder = 0
            end
            object TrackBar1: TTrackBar
              Left = 7
              Top = 26
              Width = 177
              Height = 29
              Hint = #913#955#955#940#950#949#953' '#964#959' '#949#960#943#960#949#948#959' '#948#965#963#954#959#955#943#945#962
              Min = 1
              Position = 1
              TabOrder = 1
              OnChange = TrackBar1Change
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'General'
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 194
          Height = 41
          Align = alTop
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 0
          object StaticText1: TStaticText
            Left = 16
            Top = 16
            Width = 92
            Height = 17
            Caption = 'Background Color:'
            TabOrder = 0
          end
          object ColorPanel1: TPanel
            Left = 121
            Top = 8
            Width = 41
            Height = 25
            BevelOuter = bvNone
            Caption = ' '
            Color = clBlack
            TabOrder = 1
          end
        end
        object Panel4: TPanel
          Left = 0
          Top = 41
          Width = 194
          Height = 83
          Align = alClient
          BevelOuter = bvNone
          Caption = ' '
          TabOrder = 1
          object StaticText2: TStaticText
            Left = 16
            Top = 24
            Width = 104
            Height = 17
            Caption = 'Number of Columns: '
            TabOrder = 0
          end
          object SpinEdit1: TSpinEdit
            Left = 120
            Top = 0
            Width = 48
            Height = 22
            EditorEnabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 1
            Value = 0
          end
          object StaticText3: TStaticText
            Left = 16
            Top = 0
            Width = 91
            Height = 17
            Caption = 'Number of Lines:  '
            TabOrder = 2
          end
          object SpinEdit2: TSpinEdit
            Left = 120
            Top = 24
            Width = 48
            Height = 22
            EditorEnabled = False
            MaxValue = 0
            MinValue = 0
            TabOrder = 3
            Value = 0
          end
          object CheckBox1: TCheckBox
            Left = 16
            Top = 56
            Width = 169
            Height = 17
            Caption = 'Sounds'
            TabOrder = 4
          end
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 162
    Width = 212
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object OKBtn: TButton
      Left = 51
      Top = 2
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object CancelBtn: TButton
      Left = 131
      Top = 2
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object ColorDialog1: TColorDialog
    Options = [cdFullOpen]
    Left = 160
    Top = 5
  end
end
