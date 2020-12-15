object WaveForm: TWaveForm
  Left = 255
  Top = 186
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Elifrac Wave Effects'
  ClientHeight = 105
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sXdiv: TScrollBar
    Left = 15
    Top = 16
    Width = 249
    Height = 10
    LargeChange = 10
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 0
  end
  object sYdiv: TScrollBar
    Left = 15
    Top = 29
    Width = 249
    Height = 10
    LargeChange = 10
    Min = 1
    PageSize = 0
    Position = 1
    TabOrder = 1
  end
  object sRatio: TScrollBar
    Left = 15
    Top = 41
    Width = 249
    Height = 11
    LargeChange = 10
    PageSize = 0
    Position = 2
    TabOrder = 2
    OnChange = sRatioChange
  end
  object Button1: TButton
    Left = 70
    Top = 72
    Width = 49
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object Button2: TButton
    Left = 134
    Top = 72
    Width = 57
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end
