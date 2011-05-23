object FormComparingDate: TFormComparingDate
  Left = 0
  Top = 0
  Caption = #1044#1072#1085#1085#1099#1077' '#1074' '#1089#1088#1072#1074#1085#1077#1085#1080#1080
  ClientHeight = 488
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 519
    Top = 8
    Width = 38
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object SGComparingData: TStringGrid
    Left = 8
    Top = 112
    Width = 724
    Height = 370
    ColCount = 4
    TabOrder = 0
  end
  object LBPeriod: TListBox
    Left = 519
    Top = 27
    Width = 211
    Height = 79
    ItemHeight = 13
    TabOrder = 1
    OnClick = LBPeriodClick
  end
end
