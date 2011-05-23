object PayerInfoForm: TPayerInfoForm
  Left = 0
  Top = 0
  Caption = #1044#1072#1085#1085#1099#1077' '#1089#1095#1077#1090#1072
  ClientHeight = 668
  ClientWidth = 436
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
    Top = 84
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
    Top = 46
    Width = 70
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
  end
  object LService: TLabel
    Left = 8
    Top = 65
    Width = 99
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072':'
  end
  object Lperiod: TLabel
    Left = 8
    Top = 153
    Width = 38
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object GBSubsidy: TGroupBox
    Left = 8
    Top = 214
    Width = 418
    Height = 448
    TabOrder = 1
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
    object LPrivelege1Code: TLabel
      Left = 8
      Top = 58
      Width = 79
      Height = 13
      Caption = #1055#1077#1088#1074#1072#1103' '#1083#1100#1075#1086#1090#1072':'
    end
    object LPrivelege1Users: TLabel
      Left = 16
      Top = 77
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivilege1Date: TLabel
      Left = 16
      Top = 96
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege1Percent: TLabel
      Left = 16
      Top = 115
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
    object Label2: TLabel
      Left = 8
      Top = 134
      Width = 78
      Height = 13
      Caption = #1042#1090#1086#1088#1072#1103' '#1083#1100#1075#1086#1090#1072':'
    end
    object LPrivelege2Users: TLabel
      Left = 16
      Top = 153
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivilege2Date: TLabel
      Left = 16
      Top = 172
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege2Percent: TLabel
      Left = 16
      Top = 191
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
    object Label6: TLabel
      Left = 8
      Top = 210
      Width = 78
      Height = 13
      Caption = #1058#1088#1077#1090#1100#1103' '#1083#1100#1075#1086#1090#1072':'
    end
    object LPrivelege3Users: TLabel
      Left = 16
      Top = 229
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivilege3Date: TLabel
      Left = 16
      Top = 248
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege3Percent: TLabel
      Left = 16
      Top = 267
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
    object Label10: TLabel
      Left = 8
      Top = 286
      Width = 97
      Height = 13
      Caption = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1083#1100#1075#1086#1090#1072':'
    end
    object LPrivelege4Users: TLabel
      Left = 16
      Top = 305
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivilege4Date: TLabel
      Left = 16
      Top = 324
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege4Percent: TLabel
      Left = 16
      Top = 343
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
    object Label14: TLabel
      Left = 8
      Top = 362
      Width = 73
      Height = 13
      Caption = #1055#1103#1090#1072#1103' '#1083#1100#1075#1086#1090#1072':'
    end
    object LPrivelege5Users: TLabel
      Left = 16
      Top = 381
      Width = 236
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1095#1077#1083#1086#1074#1077#1082', '#1087#1086#1083#1100#1079#1091#1102#1097#1080#1093#1089#1103' '#1083#1100#1075#1086#1090#1086#1081':'
    end
    object LPrivilege5Date: TLabel
      Left = 16
      Top = 400
      Width = 196
      Height = 13
      Caption = #1044#1072#1090#1072' '#1087#1088#1077#1076#1086#1089#1090#1072#1074#1083#1077#1085#1080#1103'/'#1089#1085#1103#1090#1080#1103' '#1083#1100#1075#1086#1090#1099':'
    end
    object LPrivilege5Percent: TLabel
      Left = 16
      Top = 419
      Width = 145
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1083#1100#1075#1086#1090#1099' '#1074' '#1087#1088#1086#1094#1077#1085#1090#1072#1093':'
    end
  end
  object GBPayer: TGroupBox
    Left = 8
    Top = 214
    Width = 418
    Height = 97
    TabOrder = 2
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
  object GBDebt: TGroupBox
    Left = 8
    Top = 214
    Width = 418
    Height = 204
    TabOrder = 3
    object LDateDebt: TLabel
      Left = 11
      Top = 12
      Width = 51
      Height = 13
      Caption = 'LDateDebt'
    end
    object LExes: TLabel
      Left = 11
      Top = 31
      Width = 28
      Height = 13
      Caption = 'LExes'
    end
    object LProfit: TLabel
      Left = 11
      Top = 50
      Width = 31
      Height = 13
      Caption = 'LProfit'
    end
    object LRecount: TLabel
      Left = 11
      Top = 69
      Width = 45
      Height = 13
      Caption = 'LRecount'
    end
    object LPayment: TLabel
      Left = 11
      Top = 88
      Width = 47
      Height = 13
      Caption = 'LPayment'
    end
    object LDebtNext: TLabel
      Left = 11
      Top = 107
      Width = 51
      Height = 13
      Caption = 'LDebtNext'
    end
    object Label3: TLabel
      Left = 3
      Top = 126
      Width = 206
      Height = 13
      Caption = #1055#1086#1089#1083#1077#1076#1085#1080#1077' '#1079#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1077' '#1087#1086#1082#1072#1079#1072#1085#1080#1103
    end
    object LCounter1: TLabel
      Left = 11
      Top = 145
      Width = 50
      Height = 13
      Caption = 'LCounter1'
    end
    object LCounter2: TLabel
      Left = 11
      Top = 164
      Width = 50
      Height = 13
      Caption = 'LCounter2'
    end
    object LCounter3: TLabel
      Left = 11
      Top = 183
      Width = 50
      Height = 13
      Caption = 'LCounter3'
    end
  end
  object GBHome: TGroupBox
    Left = 8
    Top = 214
    Width = 418
    Height = 291
    TabOrder = 5
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
      Top = 210
      Width = 81
      Height = 13
      Caption = #1045#1089#1090#1100' '#1083#1080' '#1073#1086#1081#1083#1077#1088':'
    end
    object LWaterHeater: TLabel
      Left = 8
      Top = 229
      Width = 87
      Height = 13
      Caption = #1045#1089#1090#1100' '#1083#1080' '#1082#1086#1083#1086#1085#1082#1072':'
    end
    object LHeatType: TLabel
      Left = 8
      Top = 248
      Width = 79
      Height = 13
      Caption = #1058#1080#1087' '#1086#1090#1086#1087#1083#1077#1085#1080#1103':'
    end
    object LChangeHeatDate: TLabel
      Left = 8
      Top = 267
      Width = 170
      Height = 13
      Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1090#1080#1087#1072' '#1086#1090#1086#1087#1083#1077#1085#1080#1103':'
    end
    object LCounterType: TLabel
      Left = 8
      Top = 191
      Width = 100
      Height = 13
      Caption = #1058#1080#1087' '#1087#1088#1080#1073#1086#1088#1072' '#1091#1095#1077#1090#1072':'
    end
  end
  object CBPeriod: TComboBox
    Left = 8
    Top = 172
    Width = 418
    Height = 21
    ItemHeight = 0
    TabOrder = 0
    Text = 'CBPeriod'
    OnSelect = CBPeriodSelect
  end
  object TSPartInfo: TTabSet
    Left = 8
    Top = 199
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
  object ADOQ: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 392
    Top = 15
  end
end
