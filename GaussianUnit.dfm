object GaussianForm: TGaussianForm
  Left = 173
  Top = 195
  Width = 283
  Height = 138
  Caption = 'GaussianForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBar1: TScrollBar
    Left = 24
    Top = 24
    Width = 225
    Height = 16
    Max = 10
    PageSize = 0
    TabOrder = 0
    OnScroll = ScrollBar1Scroll
  end
  object Button1: TButton
    Left = 40
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 144
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
