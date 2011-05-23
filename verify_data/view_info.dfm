object FormViewInfo: TFormViewInfo
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1074#1093#1086#1076#1085#1099#1093' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 417
  ClientWidth = 438
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
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 25
    Height = 13
    Caption = #1055#1086#1083#1103
  end
  object LNumRecord: TLabel
    Left = 295
    Top = 389
    Width = 45
    Height = 13
    Caption = #1047#1072#1087#1080#1089#1100' - '
    Visible = False
  end
  object LError: TLabel
    Left = 8
    Top = 8
    Width = 29
    Height = 13
    Caption = 'LError'
  end
  object Label8: TLabel
    Left = 295
    Top = 303
    Width = 103
    Height = 13
    Caption = #1057#1095#1077#1090#1072' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
    Visible = False
  end
  object Label2: TLabel
    Left = 295
    Top = 241
    Width = 42
    Height = 13
    Caption = #1046#1080#1083#1100#1094#1099
    Visible = False
  end
  object Label4: TLabel
    Left = 295
    Top = 72
    Width = 31
    Height = 13
    Caption = #1043#1086#1088#1086#1076
    Visible = False
  end
  object Label5: TLabel
    Left = 300
    Top = 118
    Width = 31
    Height = 13
    Caption = #1059#1083#1080#1094#1072
    Visible = False
  end
  object Label6: TLabel
    Left = 295
    Top = 164
    Width = 20
    Height = 13
    Caption = #1044#1086#1084
    Visible = False
  end
  object Label7: TLabel
    Left = 369
    Top = 164
    Width = 49
    Height = 13
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072
    Visible = False
  end
  object Label3: TLabel
    Left = 8
    Top = 338
    Width = 48
    Height = 13
    Caption = #1047#1085#1072#1095#1077#1085#1080#1077
  end
  object BSave: TButton
    Left = 8
    Top = 384
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 0
    OnClick = BSaveClick
  end
  object EValue: TEdit
    Left = 8
    Top = 357
    Width = 273
    Height = 21
    TabOrder = 1
    Text = 'EValue'
  end
  object LBBankbooks: TListBox
    Left = 295
    Top = 322
    Width = 135
    Height = 47
    ItemHeight = 13
    TabOrder = 2
    Visible = False
    OnDblClick = LBBankbooksDblClick
  end
  object LBOccupants: TListBox
    Left = 295
    Top = 272
    Width = 135
    Height = 25
    ItemHeight = 13
    TabOrder = 3
    Visible = False
    OnClick = LBOccupantsClick
  end
  object CBCity: TComboBox
    Left = 295
    Top = 91
    Width = 145
    Height = 21
    ItemHeight = 0
    TabOrder = 4
    Text = 'CBCity'
    Visible = False
    OnSelect = CBCitySelect
  end
  object CBStreet: TComboBox
    Left = 300
    Top = 137
    Width = 130
    Height = 21
    ItemHeight = 0
    TabOrder = 5
    Text = 'CBStreet'
    Visible = False
    OnSelect = CBStreetSelect
  end
  object CBHome: TComboBox
    Left = 295
    Top = 183
    Width = 68
    Height = 21
    ItemHeight = 0
    TabOrder = 6
    Text = 'CBHome'
    Visible = False
    OnSelect = CBHomeSelect
  end
  object CBRoom: TComboBox
    Left = 369
    Top = 183
    Width = 65
    Height = 21
    ItemHeight = 0
    TabOrder = 7
    Text = 'CBRoom'
    Visible = False
    OnSelect = CBRoomSelect
  end
  object BSubstituteAddress: TButton
    Left = 295
    Top = 210
    Width = 135
    Height = 25
    Caption = #1055#1086#1076#1089#1090#1072#1074#1080#1090#1100' '#1072#1076#1088#1077#1089
    Enabled = False
    TabOrder = 8
    Visible = False
    OnClick = BSubstituteAddressClick
  end
  object LBFields: TListBox
    Left = 8
    Top = 46
    Width = 273
    Height = 286
    ItemHeight = 13
    TabOrder = 9
    OnClick = LBFieldsClick
  end
end
