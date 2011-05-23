object FormViewPayer: TFormViewPayer
  Left = 0
  Top = 0
  Caption = #1044#1072#1085#1085#1099#1077' '#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072#1093
  ClientHeight = 668
  ClientWidth = 429
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 8
    Top = 173
    Width = 70
    Height = 13
    Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082#1080
  end
  object Label8: TLabel
    Left = 8
    Top = 277
    Width = 103
    Height = 13
    Caption = #1057#1095#1077#1090#1072' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
  end
  object Label14: TLabel
    Left = 8
    Top = 471
    Width = 143
    Height = 13
    Caption = #1054#1089#1090#1072#1083#1100#1085#1099#1077' '#1089#1095#1077#1090#1072' '#1087#1086' '#1072#1076#1088#1077#1089#1091
  end
  object Label16: TLabel
    Left = 204
    Top = 277
    Width = 38
    Height = 13
    Caption = #1055#1077#1088#1080#1086#1076
  end
  object PErrors: TPanel
    Left = 8
    Top = 20
    Width = 410
    Height = 640
    TabOrder = 4
    object Label9: TLabel
      Left = 8
      Top = 53
      Width = 34
      Height = 13
      Caption = #1060#1072#1081#1083#1099
    end
    object Label10: TLabel
      Left = 8
      Top = 7
      Width = 66
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1080
    end
    object Label17: TLabel
      Left = 8
      Top = 99
      Width = 40
      Height = 13
      Caption = #1054#1096#1080#1073#1082#1080
    end
    object CBFirmsForErrors: TComboBox
      Left = 8
      Top = 26
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnSelect = CBFirmsForErrorsSelect
    end
    object CBFiles: TComboBox
      Left = 8
      Top = 72
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'CBFiles'
      OnSelect = CBFilesSelect
    end
    object DBGrid3: TDBGrid
      Left = 8
      Top = 118
      Width = 392
      Height = 483
      DataSource = DSErrors
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGrid3DblClick
    end
    object DBNavigator1: TDBNavigator
      Left = 8
      Top = 607
      Width = 240
      Height = 25
      DataSource = DSErrors
      TabOrder = 3
    end
  end
  object PAddress: TPanel
    Left = 8
    Top = 20
    Width = 410
    Height = 149
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 7
      Width = 95
      Height = 13
      Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
    end
    object Label4: TLabel
      Left = 8
      Top = 49
      Width = 31
      Height = 13
      Caption = #1059#1083#1080#1094#1072
    end
    object Label6: TLabel
      Left = 8
      Top = 95
      Width = 20
      Height = 13
      Caption = #1044#1086#1084
    end
    object Label7: TLabel
      Left = 104
      Top = 95
      Width = 49
      Height = 13
      Caption = #1050#1074#1072#1088#1090#1080#1088#1072
    end
    object Label15: TLabel
      Left = 196
      Top = 95
      Width = 92
      Height = 13
      Caption = #1050#1086#1076' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
    end
    object CBCity: TComboBox
      Left = 8
      Top = 26
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnExit = CBCityExit
      OnKeyPress = CBCityKeyPress
      OnSelect = CBCitySelect
    end
    object CBStreet: TComboBox
      Left = 8
      Top = 68
      Width = 392
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 1
      Text = 'CBStreet'
      OnExit = CBStreetExit
      OnKeyPress = CBStreetKeyPress
      OnSelect = CBStreetSelect
    end
    object CBHome: TComboBox
      Left = 8
      Top = 114
      Width = 68
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 2
      Text = 'CBHome'
      OnExit = CBHomeExit
      OnKeyPress = CBHomeKeyPress
      OnSelect = CBHomeSelect
    end
    object CBRoom: TComboBox
      Left = 104
      Top = 114
      Width = 65
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 3
      Text = 'CBRoom'
      OnExit = CBRoomExit
      OnKeyPress = CBRoomKeyPress
      OnSelect = CBRoomSelect
    end
    object ECodeERC: TEdit
      Left = 198
      Top = 114
      Width = 90
      Height = 21
      TabOrder = 4
    end
    object BFindByCode: TButton
      Left = 304
      Top = 110
      Width = 96
      Height = 25
      Caption = #1048#1089#1082#1072#1090#1100' '#1087#1086' '#1082#1086#1076#1091
      TabOrder = 5
      OnClick = BFindByCodeClick
    end
  end
  object PFUBb: TPanel
    Left = 8
    Top = 20
    Width = 410
    Height = 149
    TabOrder = 9
    Visible = False
    object Label11: TLabel
      Left = 8
      Top = 7
      Width = 66
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    end
    object Label12: TLabel
      Left = 8
      Top = 49
      Width = 35
      Height = 13
      Caption = #1059#1089#1083#1091#1075#1072
    end
    object Label13: TLabel
      Left = 8
      Top = 95
      Width = 31
      Height = 13
      Caption = #1057#1095#1077#1090#1072
    end
    object CBFirmForFind: TComboBox
      Left = 8
      Top = 26
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'CBFirm'
      OnSelect = CBFirmForFindSelect
    end
    object CBUtility: TComboBox
      Left = 8
      Top = 68
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'CBUtility'
      OnSelect = CBUtilitySelect
    end
    object DBNBankbook: TDBNavigator
      Left = 8
      Top = 191
      Width = 104
      Height = 25
      DataSource = DSErrors
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      TabOrder = 2
    end
    object CBBankbooksByFirm: TComboBox
      Left = 8
      Top = 114
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'CBBankbooksByFirm'
      OnSelect = CBBankbooksByFirmSelect
    end
  end
  object LBOccupants: TListBox
    Left = 8
    Top = 192
    Width = 410
    Height = 71
    ItemHeight = 13
    TabOrder = 2
    OnClick = LBOccupantsClick
  end
  object LBBankbooks: TListBox
    Left = 8
    Top = 608
    Width = 410
    Height = 57
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -8
    Font.Name = 'Courier'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 3
    Visible = False
    OnClick = LBBankbooksClick
    OnDblClick = LBBankbooksDblClick
  end
  object TSMode: TTabSet
    Left = 8
    Top = 0
    Width = 410
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Style = tsModernTabs
    Tabs.Strings = (
      #1055#1086' '#1072#1076#1088#1077#1089#1091
      #1055#1086' '#1089#1095#1077#1090#1091
      #1054#1096#1080#1073#1082#1080)
    TabIndex = 0
    TabPosition = tpTop
    OnChange = TSModeChange
  end
  object LBOtherBankbooks: TListBox
    Left = 8
    Top = 490
    Width = 410
    Height = 167
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = LBOtherBankbooksDblClick
  end
  object BMoveBankbooks: TButton
    Left = 388
    Top = 459
    Width = 30
    Height = 25
    Caption = '++'
    Enabled = False
    TabOrder = 6
    OnClick = BMoveBankbooksClick
  end
  object BMoveBankbook: TButton
    Left = 352
    Top = 459
    Width = 30
    Height = 25
    Caption = '+'
    Enabled = False
    TabOrder = 7
    OnClick = BMoveBankbookClick
  end
  object CBperiod_bb: TComboBox
    Left = 248
    Top = 269
    Width = 170
    Height = 21
    Enabled = False
    ItemHeight = 13
    TabOrder = 10
    Text = 'CBperiod_bb'
    OnSelect = CBperiod_bbSelect
  end
  object BCreate: TButton
    Left = 271
    Top = 459
    Width = 75
    Height = 25
    Caption = #1054#1090#1076#1077#1083#1080#1090#1100
    Enabled = False
    TabOrder = 11
    OnClick = BCreateClick
  end
  object BChangeFullName: TButton
    Left = 190
    Top = 459
    Width = 75
    Height = 25
    Caption = #1057#1084#1077#1085#1080#1090#1100' '#1060#1048#1054
    Enabled = False
    TabOrder = 12
    OnClick = BChangeFullNameClick
  end
  object PDouble: TPanel
    Left = 18
    Top = 431
    Width = 400
    Height = 229
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 8
      Top = 7
      Width = 66
      Height = 13
      Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
    end
    object Label2: TLabel
      Left = 7
      Top = 53
      Width = 38
      Height = 13
      Caption = #1055#1077#1088#1080#1086#1076
    end
    object CBPeriod: TComboBox
      Left = 7
      Top = 72
      Width = 393
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'ComboBox1'
    end
    object MDoubles: TMemo
      Left = 8
      Top = 132
      Width = 377
      Height = 85
      ScrollBars = ssBoth
      TabOrder = 3
      WordWrap = False
    end
    object CBFirm: TComboBox
      Left = 8
      Top = 26
      Width = 392
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'CBFirmDubl'
      OnSelect = CBFirmSelect
    end
    object BSearch: TButton
      Left = 325
      Top = 101
      Width = 75
      Height = 25
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 2
      OnClick = BSearchClick
    end
  end
  object DBGBankbooks: TDBGrid
    Left = 8
    Top = 292
    Width = 413
    Height = 161
    DataSource = DS
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 13
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGBankbooksCellClick
    OnDblClick = DBGBankbooksDblClick
  end
  object ADOQErrors: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-35'
    Parameters = <>
    Left = 128
    Top = 128
  end
  object DSErrors: TDataSource
    DataSet = ADOQErrors
    Left = 160
    Top = 128
  end
  object DS: TDataSource
    DataSet = ADOQBankbooks
    Top = 384
  end
  object ADOQBankbooks: TADOQuery
    Parameters = <>
    Top = 408
  end
end
