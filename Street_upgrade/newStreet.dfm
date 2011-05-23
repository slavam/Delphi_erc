object FormNewStreet: TFormNewStreet
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1072#1103' '#1091#1083#1080#1094#1072
  ClientHeight = 87
  ClientWidth = 456
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
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object Label2: TLabel
    Left = 224
    Top = 8
    Width = 18
    Height = 13
    Caption = #1058#1080#1087
  end
  object Label4: TLabel
    Left = 335
    Top = 8
    Width = 114
    Height = 13
    Caption = #1050#1086#1076' '#1091#1083#1080#1094#1099' '#1083#1086#1082#1072#1083#1100#1085#1099#1081
  end
  object CBType: TComboBox
    Left = 224
    Top = 27
    Width = 105
    Height = 21
    ItemHeight = 0
    TabOrder = 0
    Text = 'CBType'
    OnSelect = CBTypeSelect
  end
  object BCreate: TButton
    Left = 8
    Top = 54
    Width = 75
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 1
    OnClick = BCreateClick
  end
  object BExit: TButton
    Left = 373
    Top = 54
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = BExitClick
  end
  object EName: TEdit
    Left = 8
    Top = 27
    Width = 210
    Height = 21
    TabOrder = 3
    Text = 'EName'
  end
  object EStreetCodeLocal: TEdit
    Left = 334
    Top = 27
    Width = 114
    Height = 21
    TabOrder = 4
    Text = '1'
  end
end
