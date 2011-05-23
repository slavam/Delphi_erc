object FormInfo: TFormInfo
  Left = 0
  Top = 0
  Caption = #1044#1072#1085#1085#1099#1077' '#1089#1095#1077#1090#1072
  ClientHeight = 153
  ClientWidth = 436
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object LCodeERC: TLabel
    Left = 8
    Top = 8
    Width = 47
    Height = 13
    Caption = #1050#1086#1076' '#1045#1056#1062':'
  end
  object LFullName: TLabel
    Left = 8
    Top = 27
    Width = 30
    Height = 13
    Caption = #1060#1048#1054': '
  end
  object LBankbook: TLabel
    Left = 8
    Top = 46
    Width = 76
    Height = 13
    Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090': '
  end
  object LAddress: TLabel
    Left = 8
    Top = 103
    Width = 38
    Height = 13
    Caption = #1040#1076#1088#1077#1089': '
  end
  object LFirm: TLabel
    Left = 8
    Top = 65
    Width = 70
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
  end
  object LService: TLabel
    Left = 8
    Top = 84
    Width = 99
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072':'
  end
  object BSwitch: TButton
    Left = 8
    Top = 122
    Width = 75
    Height = 25
    Caption = #1045#1097#1077' >>'
    TabOrder = 0
    OnClick = BSwitchClick
  end
  object DTPReportDate: TDateTimePicker
    Left = 89
    Top = 124
    Width = 120
    Height = 21
    Date = 40126.701425000000000000
    Time = 40126.701425000000000000
    TabOrder = 1
    Visible = False
    OnChange = DTPReportDateChange
  end
  object BShowFullInfo: TButton
    Left = 215
    Top = 122
    Width = 75
    Height = 25
    Caption = #1042#1089#1077' '#1076#1072#1085#1085#1099#1077
    Enabled = False
    TabOrder = 2
    Visible = False
    OnClick = BShowFullInfoClick
  end
end
