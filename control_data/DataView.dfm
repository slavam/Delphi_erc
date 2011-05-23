object FormPreview: TFormPreview
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1081
  ClientHeight = 356
  ClientWidth = 595
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
  object LTitle: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103' '
  end
  object LFieldName: TLabel
    Left = 66
    Top = 66
    Width = 66
    Height = 16
    Caption = 'LFieldName'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object LAddress: TLabel
    Left = 8
    Top = 48
    Width = 31
    Height = 13
    Caption = #1040#1076#1088#1077#1089
  end
  object Label1: TLabel
    Left = 8
    Top = 68
    Width = 47
    Height = 13
    Caption = #1056#1077#1082#1074#1080#1079#1080#1090
  end
  object Label2: TLabel
    Left = 8
    Top = 88
    Width = 81
    Height = 13
    Caption = #1053#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
  end
  object Label3: TLabel
    Left = 8
    Top = 138
    Width = 83
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1074' '#1073#1072#1079#1077
  end
  object LOccupants: TLabel
    Left = 8
    Top = 248
    Width = 99
    Height = 13
    Caption = #1046#1080#1083#1100#1094#1099' '#1087#1086' '#1072#1076#1088#1077#1089#1091' '
  end
  object LService: TLabel
    Left = 8
    Top = 28
    Width = 102
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072': '
  end
  object LPayers: TLabel
    Left = 8
    Top = 188
    Width = 120
    Height = 13
    Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082#1080' '#1087#1086' '#1089#1095#1077#1090#1091' '
  end
  object LBankbookOf: TLabel
    Left = 416
    Top = 188
    Width = 63
    Height = 13
    Caption = 'LBankbookOf'
  end
  object LDBValue: TLabel
    Left = 8
    Top = 168
    Width = 44
    Height = 13
    Caption = 'LDBValue'
  end
  object BChange: TButton
    Left = 184
    Top = 134
    Width = 25
    Height = 25
    Caption = '^'
    TabOrder = 0
    OnClick = BChangeClick
  end
  object BSaveNewValue: TButton
    Left = 400
    Top = 105
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 1
    OnClick = BSaveNewValueClick
  end
  object ENewValue: TEdit
    Left = 8
    Top = 107
    Width = 386
    Height = 21
    TabOrder = 2
  end
  object LBOccupants: TListBox
    Left = 8
    Top = 267
    Width = 386
    Height = 73
    ItemHeight = 13
    TabOrder = 3
    OnClick = LBOccupantsClick
  end
  object LBPayers: TListBox
    Left = 8
    Top = 207
    Width = 386
    Height = 33
    ItemHeight = 13
    TabOrder = 4
    OnClick = LBPayersClick
  end
  object LBBankbook: TListBox
    Left = 416
    Top = 207
    Width = 171
    Height = 133
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = LBBankbookDblClick
  end
  object CBStreet: TComboBox
    Left = 8
    Top = 165
    Width = 187
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = 'CBStreet'
    OnChange = CBStreetChange
  end
  object CBHome: TComboBox
    Left = 210
    Top = 165
    Width = 89
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'CBHome'
    OnChange = CBHomeChange
  end
  object CBRoom: TComboBox
    Left = 305
    Top = 165
    Width = 89
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'CBRoom'
  end
  object Button1: TButton
    Left = 512
    Top = 105
    Width = 75
    Height = 25
    Caption = #1048#1089#1082#1083#1102#1095#1080#1090#1100
    TabOrder = 9
    OnClick = Button1Click
  end
  object ADOQ: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 520
    Top = 6
  end
  object ADODSW: TADODataSet
    ConnectionString = 
      'Provider=SQLOLEDB.1;Persist Security Info=False;User ID=slava;In' +
      'itial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 552
    Top = 6
  end
  object ADOSP: TADOStoredProc
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 480
    Top = 6
  end
end
