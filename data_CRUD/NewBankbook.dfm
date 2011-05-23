object FormNewBankbook: TFormNewBankbook
  Left = 0
  Top = 0
  Caption = 'FormNewBankbook'
  ClientHeight = 193
  ClientWidth = 346
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
    Width = 66
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
  end
  object Label2: TLabel
    Left = 8
    Top = 59
    Width = 35
    Height = 13
    Caption = #1059#1089#1083#1091#1075#1072
  end
  object CBFirms: TComboBox
    Left = 8
    Top = 32
    Width = 329
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'CBFirms'
    OnSelect = CBFirmsSelect
  end
  object CBUtility: TComboBox
    Left = 8
    Top = 78
    Width = 329
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBUtility'
  end
  object LEBankbook: TLabeledEdit
    Left = 8
    Top = 121
    Width = 161
    Height = 21
    EditLabel.Width = 25
    EditLabel.Height = 13
    EditLabel.Caption = #1057#1095#1077#1090
    TabOrder = 2
  end
  object BCreate: TButton
    Left = 8
    Top = 160
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 3
    OnClick = BCreateClick
  end
  object BClose: TButton
    Left = 262
    Top = 160
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 4
    OnClick = BCloseClick
  end
end
