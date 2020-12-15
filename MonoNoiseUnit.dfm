object MonoNoiseForm: TMonoNoiseForm
  Left = 167
  Top = 189
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Elifrac Add Mono Noise'
  ClientHeight = 120
  ClientWidth = 288
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
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 17
    Height = 13
    Caption = 'Min'
  end
  object Label2: TLabel
    Left = 240
    Top = 16
    Width = 20
    Height = 13
    Caption = 'Max'
  end
  object ScrollBar1: TScrollBar
    Left = 24
    Top = 32
    Width = 241
    Height = 16
    LargeChange = 10
    Max = 1000
    PageSize = 0
    TabOrder = 0
    OnScroll = ScrollBar1Scroll
  end
  object Button1: TButton
    Left = 80
    Top = 80
    Width = 57
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 152
    Top = 80
    Width = 57
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
