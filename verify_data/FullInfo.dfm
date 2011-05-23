object FormFullInfo: TFormFullInfo
  Left = 0
  Top = 0
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
  ClientHeight = 550
  ClientWidth = 434
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
  object Label1: TLabel
    Left = 8
    Top = 122
    Width = 38
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object GBHome: TGroupBox
    Left = 8
    Top = 241
    Width = 418
    Height = 270
    TabOrder = 2
    Visible = False
    object LIsLift: TLabel
      Left = 8
      Top = 39
      Width = 268
      Height = 13
      Caption = #1054#1087#1083#1072#1090#1072' '#1083#1080#1092#1090#1072' '#1087#1088#1080#1089#1091#1090#1089#1090#1074#1091#1077#1090' '#1074' '#1088#1072#1089#1095#1077#1090#1077' '#1082#1074#1072#1088#1090#1087#1083#1072#1090#1099':'
    end
    object LOneRoom: TLabel
      Left = 8
      Top = 20
      Width = 136
      Height = 13
      Caption = #1054#1076#1085#1086#1082#1086#1084#1085#1072#1090#1085#1072#1103' '#1082#1074#1072#1088#1090#1080#1088#1072':'
    end
    object LDatePrivatization: TLabel
      Left = 8
      Top = 58
      Width = 107
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1080#1074#1072#1090#1080#1079#1072#1094#1080#1080': '
    end
    object LFormProperty: TLabel
      Left = 8
      Top = 77
      Width = 114
      Height = 13
      Caption = #1060#1086#1088#1084#1072' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1086#1089#1090#1080':'
    end
    object LTotalArea: TLabel
      Left = 8
      Top = 96
      Width = 88
      Height = 13
      Caption = #1054#1073#1097#1072#1103' '#1087#1083#1086#1097#1072#1076#1100':'
    end
    object LHeatArea: TLabel
      Left = 8
      Top = 115
      Width = 127
      Height = 13
      Caption = #1054#1090#1072#1087#1083#1080#1074#1072#1077#1084#1072#1103' '#1087#1083#1086#1097#1072#1076#1100':'
    end
    object LQuotaArea: TLabel
      Left = 8
      Top = 134
      Width = 218
      Height = 13
      Caption = #1055#1083#1086#1097#1072#1076#1100' '#1074' '#1087#1088#1077#1076#1077#1083#1072#1093' '#1085#1086#1088#1084' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1103':'
    end
    object LCalcDevice: TLabel
      Left = 8
      Top = 153
      Width = 114
      Height = 13
      Caption = #1045#1089#1090#1100' '#1083#1080' '#1087#1088#1080#1073#1086#1088' '#1091#1095#1077#1090#1072':'
    end
    object LDateCalcDevice: TLabel
      Left = 8
      Top = 172
      Width = 203
      Height = 13
      Caption = #1044#1072#1090#1072' '#1091#1089#1090#1072#1085#1086#1074#1082#1080'/'#1089#1085#1103#1090#1080#1103' '#1087#1088#1080#1073#1086#1088#1072' '#1091#1095#1077#1090#1072':'
    end
    object LBoiler: TLabel
      Left = 8
      Top = 191
      Width = 81
      Height = 13
      Caption = #1045#1089#1090#1100' '#1083#1080' '#1073#1086#1081#1083#1077#1088':'
    end
    object LWaterHeater: TLabel
      Left = 8
      Top = 210
      Width = 87
      Height = 13
      Caption = #1045#1089#1090#1100' '#1083#1080' '#1082#1086#1083#1086#1085#1082#1072':'
    end
    object LHeatType: TLabel
      Left = 8
      Top = 229
      Width = 79
      Height = 13
      Caption = #1058#1080#1087' '#1086#1090#1086#1087#1083#1077#1085#1080#1103':'
    end
    object LChangeHeatDate: TLabel
      Left = 8
      Top = 248
      Width = 170
      Height = 13
      Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1090#1080#1087#1072' '#1086#1090#1086#1087#1083#1077#1085#1080#1103':'
    end
  end
  object GBSubsidy: TGroupBox
    Left = 8
    Top = 241
    Width = 418
    Height = 304
    TabOrder = 3
    Visible = False
    object LSum01122006: TLabel
      Left = 8
      Top = 20
      Width = 142
      Height = 13
      Caption = #1057#1091#1084#1084#1072' '#1076#1086#1083#1075#1072' '#1085#1072' 01.12.2006:'
    end
    object LPactDate: TLabel
      Left = 8
      Top = 39
      Width = 229
      Height = 13
      Caption = #1044#1072#1090#1072' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1085#1072' '#1088#1077#1089#1090#1088#1091#1082#1090#1091#1088#1080#1079#1072#1094#1080#1102' '#1076#1086#1083#1075#1072':'
    end
    object LPactNumber: TLabel
      Left = 8
      Top = 58
      Width = 234
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1085#1072' '#1088#1077#1089#1090#1088#1091#1082#1090#1091#1088#1080#1079#1072#1094#1080#1102' '#1076#1086#1083#1075#1072':'
    end
    object LSumRestruct: TLabel
      Left = 8
      Top = 77
      Width = 287
      Height = 13
      Caption = #1057#1091#1084#1084#1072' '#1088#1077#1089#1090#1088#1091#1082#1090#1091#1088#1080#1088#1091#1077#1084#1086#1081' '#1079#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1091':'
    end
    object LSubsidy: TLabel
      Left = 8
      Top = 96
      Width = 81
      Height = 13
      Caption = #1057#1091#1084#1084#1072' '#1089#1091#1073#1089#1080#1076#1080#1080
    end
    object LSubsidyDate: TLabel
      Left = 8
      Top = 115
      Width = 142
      Height = 13
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1089#1091#1073#1089#1080#1076#1080#1080':'
    end
    object LPrivelege1Code: TLabel
      Left = 8
      Top = 134
      Width = 103
      Height = 13
      Caption = #1050#1086#1076' '#1087#1077#1088#1074#1086#1081' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivelege1Users: TLabel
      Left = 8
      Top = 153
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivelege1Category: TLabel
      Left = 8
      Top = 172
      Width = 98
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege1Date: TLabel
      Left = 8
      Top = 191
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege1Doc: TLabel
      Left = 8
      Top = 210
      Width = 222
      Height = 13
      Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072', '#1076#1072#1102#1097#1077#1075#1086' '#1087#1088#1072#1074#1086' '#1085#1072' '#1083#1100#1075#1086#1090#1091':'
    end
    object LPrivilege1DocNumber: TLabel
      Left = 8
      Top = 229
      Width = 276
      Height = 13
      Caption = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072', '#1076#1072#1102#1097#1077#1075#1086' '#1087#1088#1072#1074#1086' '#1085#1072' '#1083#1100#1075#1086#1090#1091':'
    end
    object LPrivilege1Who: TLabel
      Left = 8
      Top = 248
      Width = 247
      Height = 13
      Caption = #1050#1077#1084' '#1074#1099#1076#1072#1085' '#1076#1086#1082#1091#1084#1077#1085#1090', '#1076#1072#1102#1097#1080#1081' '#1087#1088#1072#1074#1086' '#1085#1072' '#1083#1100#1075#1086#1090#1091':'
    end
    object LPrivilege1DocDate: TLabel
      Left = 8
      Top = 267
      Width = 271
      Height = 13
      Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072', '#1076#1072#1102#1097#1077#1075#1086' '#1087#1088#1072#1074#1086' '#1085#1072' '#1083#1100#1075#1086#1090#1091':'
    end
    object LPrivilege1Percent: TLabel
      Left = 8
      Top = 286
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
  end
  object GBDebt: TGroupBox
    Left = 8
    Top = 241
    Width = 418
    Height = 116
    TabOrder = 0
    object LMonthSum: TLabel
      Left = 8
      Top = 20
      Width = 133
      Height = 13
      Caption = #1045#1078#1077#1084#1077#1089#1103#1095#1085#1086#1077' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077':'
    end
    object LNormalSum: TLabel
      Left = 8
      Top = 39
      Width = 303
      Height = 13
      Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1074' '#1087#1088#1077#1076#1077#1083#1072#1093' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1099#1093' '#1085#1086#1088#1084' '#1087#1086#1090#1088#1077#1073#1083#1077#1085#1080#1103':'
    end
    object LMonthCount: TLabel
      Left = 8
      Top = 58
      Width = 303
      Height = 13
      Caption = #1060#1072#1082#1090#1080#1095#1077#1089#1082#1086#1077' '#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1080#1077' '#1091#1089#1083#1091#1075#1080' '#1079#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1084#1077#1089#1103#1094':'
    end
    object LLastCount: TLabel
      Left = 8
      Top = 77
      Width = 228
      Height = 13
      Caption = #1055#1086#1089#1083#1077#1076#1085#1077#1077' '#1086#1087#1083#1072#1095#1077#1085#1085#1086#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1103' '#1089#1095#1077#1090#1095#1080#1082#1072':'
    end
    object LDebtTotal: TLabel
      Left = 8
      Top = 96
      Width = 214
      Height = 13
      Caption = #1047#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1100' '#1079#1072' '#1091#1089#1083#1091#1075#1091' '#1089' '#1091#1095#1077#1090#1086#1084' '#1083#1100#1075#1086#1090':'
    end
  end
  object GBPayer: TGroupBox
    Left = 8
    Top = 241
    Width = 418
    Height = 97
    TabOrder = 1
    Visible = False
    object LFullnamePayer: TLabel
      Left = 8
      Top = 20
      Width = 27
      Height = 13
      Caption = #1060#1048#1054':'
    end
    object LOwnerFullname: TLabel
      Left = 8
      Top = 39
      Width = 123
      Height = 13
      Caption = #1060#1048#1054' '#1074#1083#1072#1076#1077#1083#1100#1094#1072' '#1078#1080#1083#1100#1103': '
    end
    object LPhone: TLabel
      Left = 8
      Top = 58
      Width = 48
      Height = 13
      Caption = #1058#1077#1083#1077#1092#1086#1085':'
    end
    object LResidentNumber: TLabel
      Left = 8
      Top = 77
      Width = 219
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1088#1077#1075#1080#1089#1090#1088#1080#1088#1086#1074#1072#1085#1085#1099#1093' '#1095#1077#1083#1086#1074#1077#1082':'
    end
  end
  object TSPartInfo: TTabSet
    Left = 8
    Top = 226
    Width = 361
    Height = 21
    DitherBackground = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    SoftTop = True
    Tabs.Strings = (
      #1047#1072#1076#1086#1083#1078#1077#1085#1085#1086#1089#1090#1100
      #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082
      #1046#1080#1083#1100#1077
      #1057#1091#1073#1089#1080#1076#1080#1103'/'#1051#1100#1075#1086#1090#1099)
    TabIndex = 0
    TabPosition = tpTop
    OnClick = TSPartInfoClick
  end
  object LBPeriod: TListBox
    Left = 8
    Top = 141
    Width = 211
    Height = 79
    ItemHeight = 13
    TabOrder = 5
    OnClick = LBPeriodClick
  end
  object ADOQ: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 392
    Top = 8
  end
end
