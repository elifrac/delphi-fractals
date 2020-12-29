object ExChangeForm: TExChangeForm
  Left = 308
  Top = 180
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Exchange R<-->G<-->B'
  ClientHeight = 179
  ClientWidth = 179
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
  object RadioGroup1: TRadioGroup
    Left = 9
    Top = 8
    Width = 161
    Height = 113
    Caption = 'Exchange Basic Colors'
    ItemIndex = 3
    Items.Strings = (
      'Red     <------>  Green'
      'Red     <------>  Blue'
      'Green  <------>  Blue'
      'Original')
    TabOrder = 0
    OnClick = RadioGroup1Click
  end
  object Button1: TButton
    Left = 17
    Top = 144
    Width = 57
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 97
    Top = 144
    Width = 65
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
