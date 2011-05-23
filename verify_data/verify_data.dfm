object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #1055#1088#1080#1077#1084' '#1074#1093#1086#1076#1085#1099#1093' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 684
  ClientWidth = 865
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
    Width = 78
    Height = 13
    Caption = #1054#1090#1095#1077#1090#1085#1072#1103' '#1076#1072#1090#1072
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 37
    Height = 13
    Caption = #1043#1086#1088#1086#1076#1072
  end
  object Label3: TLabel
    Left = 708
    Top = 8
    Width = 149
    Height = 13
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1082#1086#1085#1090#1088#1086#1083#1103
  end
  object Label5: TLabel
    Left = 8
    Top = 246
    Width = 104
    Height = 13
    Caption = #1060#1072#1081#1083#1099' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080
  end
  object Label6: TLabel
    Left = 8
    Top = 422
    Width = 46
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076#1099
  end
  object Label7: TLabel
    Left = 8
    Top = 192
    Width = 101
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1087#1088#1072#1074#1080#1083
  end
  object Label8: TLabel
    Left = 8
    Top = 100
    Width = 107
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1075#1086#1088#1086#1076#1086#1074
  end
  object Label9: TLabel
    Left = 8
    Top = 146
    Width = 89
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1091#1083#1080#1094
  end
  object Label4: TLabel
    Left = 168
    Top = 246
    Width = 40
    Height = 13
    Caption = #1054#1096#1080#1073#1082#1080
  end
  object LActivePeriod: TLabel
    Left = 168
    Top = 8
    Width = 98
    Height = 13
    Caption = #1040#1082#1090#1080#1074#1085#1099#1081' '#1087#1077#1088#1080#1086#1076': '
  end
  object DTPReportDate: TDateTimePicker
    Left = 8
    Top = 27
    Width = 145
    Height = 21
    Date = 40155.685866053240000000
    Time = 40155.685866053240000000
    TabOrder = 0
    OnChange = DTPReportDateChange
  end
  object CBCities: TComboBox
    Left = 8
    Top = 73
    Width = 145
    Height = 21
    AutoComplete = False
    AutoDropDown = True
    AutoCloseUp = True
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBCities'
    OnSelect = DTPReportDateChange
  end
  object BInputOpen: TButton
    Left = 8
    Top = 391
    Width = 145
    Height = 25
    Caption = #1055#1088#1080#1085#1103#1090#1100' '#1074#1093#1086#1076#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
    Enabled = False
    TabOrder = 6
    OnClick = BInputOpenClick
  end
  object protocol: TMemo
    Left = 168
    Top = 27
    Width = 689
    Height = 205
    ScrollBars = ssVertical
    TabOrder = 17
  end
  object LBWarnings: TListBox
    Left = 168
    Top = 265
    Width = 689
    Height = 377
    ItemHeight = 13
    TabOrder = 9
    OnDblClick = LBWarningsDblClick
  end
  object BStats: TButton
    Left = 8
    Top = 478
    Width = 145
    Height = 25
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    Enabled = False
    TabOrder = 7
    OnClick = BStatsClick
  end
  object BLoad: TButton
    Left = 8
    Top = 648
    Width = 145
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 14
    OnClick = BLoadClick
  end
  object LBInputFiles: TListBox
    Left = 8
    Top = 265
    Width = 145
    Height = 64
    ItemHeight = 13
    TabOrder = 18
  end
  object CBErrors: TComboBox
    Left = 214
    Top = 238
    Width = 539
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'CBErrors'
    OnSelect = CBErrorsSelect
  end
  object CBTemplateRules: TComboBox
    Left = 8
    Top = 211
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'CBCities'
    OnSelect = CBTemplateRulesSelect
  end
  object CBTemplateCity: TComboBox
    Left = 8
    Top = 119
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'CBCities'
    OnSelect = CBTemplateCitySelect
  end
  object CBTemplateStreet: TComboBox
    Left = 8
    Top = 165
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'CBCities'
    OnSelect = CBTemplateStreetSelect
  end
  object BNewAddresses: TButton
    Left = 8
    Top = 540
    Width = 145
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1099#1077' '#1072#1076#1088#1077#1089#1072
    Enabled = False
    TabOrder = 11
    OnClick = BNewAddressesClick
  end
  object BCheckData: TButton
    Left = 8
    Top = 509
    Width = 145
    Height = 25
    Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1076#1072#1085#1085#1099#1093
    Enabled = False
    TabOrder = 19
    OnClick = BCheckDataClick
  end
  object BCheckBB: TButton
    Left = 473
    Top = 648
    Width = 145
    Height = 25
    Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1089#1095#1077#1090#1086#1074
    Enabled = False
    TabOrder = 20
    Visible = False
    OnClick = BCheckBBClick
  end
  object BAdaptCodeERC: TButton
    Left = 8
    Top = 571
    Width = 145
    Height = 25
    Caption = #1055#1086#1076#1086#1073#1088#1072#1090#1100' '#1082#1086#1076' '#1045#1056#1062
    Enabled = False
    TabOrder = 21
    OnClick = BAdaptCodeERCClick
  end
  object BSearchFiles: TButton
    Left = 8
    Top = 335
    Width = 145
    Height = 25
    Caption = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083#1099' '#1076#1083#1103' '#1074#1074#1086#1076#1072
    Enabled = False
    TabOrder = 5
    OnClick = BSearchFilesClick
  end
  object BSave: TButton
    Left = 168
    Top = 648
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    Enabled = False
    TabOrder = 12
    OnClick = BSaveClick
  end
  object BAnalyze: TButton
    Left = 8
    Top = 617
    Width = 145
    Height = 25
    Caption = #1040#1085#1072#1083#1080#1079' '#1086#1096#1080#1073#1086#1082
    Enabled = False
    TabOrder = 10
    OnClick = BAnalyzeClick
  end
  object GB: TGroupBox
    Left = 384
    Top = 286
    Width = 465
    Height = 339
    Caption = #1054#1096#1080#1073#1082#1080
    TabOrder = 22
    Visible = False
    object SB: TScrollBox
      Left = 2
      Top = 16
      Width = 461
      Height = 281
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 0
    end
    object Button1: TButton
      Left = 11
      Top = 303
      Width = 75
      Height = 25
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 379
      Top = 303
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object CBPeriods: TComboBox
    Left = 8
    Top = 441
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 23
  end
  object BClearUnnecessary: TButton
    Left = 782
    Top = 648
    Width = 75
    Height = 25
    Caption = #1063#1080#1089#1090#1082#1072
    TabOrder = 16
    OnClick = BClearUnnecessaryClick
  end
  object BTempDataDelete: TButton
    Left = 624
    Top = 648
    Width = 152
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1080#1077' '#1076#1072#1085#1085#1099#1077
    Enabled = False
    TabOrder = 15
    OnClick = BTempDataDeleteClick
  end
  object CBShortControl: TCheckBox
    Left = 8
    Top = 366
    Width = 145
    Height = 17
    Caption = #1069#1082#1089#1087#1088#1077#1089#1089'-'#1082#1086#1085#1090#1088#1086#1083#1100
    Checked = True
    State = cbChecked
    TabOrder = 24
  end
  object BForLoad: TButton
    Left = 249
    Top = 648
    Width = 75
    Height = 25
    Caption = #1050' '#1079#1072#1075#1088#1091#1079#1082#1077
    Enabled = False
    TabOrder = 13
    OnClick = BForLoadClick
  end
  object BLoadingState: TButton
    Left = 330
    Top = 648
    Width = 75
    Height = 25
    Caption = #1054' '#1079#1072#1075#1088#1091#1079#1082#1077
    TabOrder = 25
    OnClick = BLoadingStateClick
  end
  object ODInputData: TOpenDialog
    Left = 128
  end
  object ADOConnectionMain: TADOConnection
    CommandTimeout = 100
    ConnectionTimeout = 100
    CursorLocation = clUseServer
    LoginPrompt = False
    Left = 136
    Top = 232
  end
end
