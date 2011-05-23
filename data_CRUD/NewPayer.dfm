object FormNewPayer: TFormNewPayer
  Left = 0
  Top = 0
  Caption = #1053#1086#1074#1099#1081' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082
  ClientHeight = 114
  ClientWidth = 426
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
  object LAddress: TLabel
    Left = 8
    Top = 8
    Width = 44
    Height = 13
    Caption = 'LAddress'
  end
  object BCreate: TButton
    Left = 8
    Top = 83
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 0
    OnClick = BCreateClick
  end
  object BCancel: TButton
    Left = 343
    Top = 83
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 1
    OnClick = BCancelClick
  end
  object LEFullName: TLabeledEdit
    Left = 8
    Top = 56
    Width = 410
    Height = 21
    EditLabel.Width = 195
    EditLabel.Height = 13
    EditLabel.Caption = #1060#1072#1084#1080#1083#1080#1103', '#1080#1084#1103', '#1086#1090#1095#1077#1089#1090#1074#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
    TabOrder = 2
  end
end
