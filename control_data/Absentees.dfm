object FormAbsentees: TFormAbsentees
  Left = 0
  Top = 0
  Caption = 'Absentees'
  ClientHeight = 293
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 156
    Height = 13
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1076#1072#1090#1091' '#1076#1083#1103' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
  end
  object LVerdict: TLabel
    Left = 8
    Top = 64
    Width = 3
    Height = 13
  end
  object CBCompareDate: TComboBox
    Left = 8
    Top = 27
    Width = 241
    Height = 21
    ItemHeight = 0
    TabOrder = 0
    Text = 'CBCompareDate'
  end
  object BCompare: TButton
    Left = 264
    Top = 25
    Width = 75
    Height = 25
    Caption = #1057#1088#1072#1074#1085#1080#1090#1100
    TabOrder = 1
    OnClick = BCompareClick
  end
  object BShow: TButton
    Left = 8
    Top = 83
    Width = 75
    Height = 25
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100
    TabOrder = 2
    OnClick = BShowClick
  end
  object LBAbsentees: TListBox
    Left = 8
    Top = 120
    Width = 410
    Height = 97
    ItemHeight = 13
    TabOrder = 3
    OnDblClick = LBAbsenteesDblClick
  end
  object ADOQ: TADOQuery
    Parameters = <>
    Left = 392
    Top = 24
  end
end
