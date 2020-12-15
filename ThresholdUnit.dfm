object ThresholdForm: TThresholdForm
  Left = 276
  Top = 157
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Elifrac Threshold'
  ClientHeight = 148
  ClientWidth = 175
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 25
    Height = 13
    Caption = 'LOW'
  end
  object Label2: TLabel
    Left = 104
    Top = 48
    Width = 27
    Height = 13
    Caption = 'HIGH'
  end
  object LowThreshold: TSpinEdit
    Left = 23
    Top = 64
    Width = 49
    Height = 22
    MaxLength = 3
    MaxValue = 255
    MinValue = 0
    TabOrder = 0
    Value = 0
    OnChange = HighThresholdChange
  end
  object HighThreshold: TSpinEdit
    Left = 103
    Top = 64
    Width = 49
    Height = 22
    MaxLength = 3
    MaxValue = 255
    MinValue = 0
    TabOrder = 1
    Value = 255
    OnChange = HighThresholdChange
  end
  object Button1: TButton
    Left = 27
    Top = 112
    Width = 49
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 91
    Top = 112
    Width = 57
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object ComboBox1: TComboBox
    Left = 15
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
    OnChange = ComboBox1Change
    Items.Strings = (
      'All Colors'
      'Red'
      'Green'
      'Blue')
  end
end
