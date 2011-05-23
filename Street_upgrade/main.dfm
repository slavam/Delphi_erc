object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #1055#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072' '#1091#1083#1080#1094
  ClientHeight = 102
  ClientWidth = 736
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
  object Label1: TLabel
    Left = 8
    Top = 5
    Width = 95
    Height = 13
    Caption = #1053#1072#1089#1077#1083#1077#1085#1085#1099#1081' '#1087#1091#1085#1082#1090
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 31
    Height = 13
    Caption = #1059#1083#1080#1094#1072
  end
  object Label3: TLabel
    Left = 359
    Top = 51
    Width = 20
    Height = 13
    Caption = #1044#1086#1084
    Visible = False
  end
  object Label4: TLabel
    Left = 448
    Top = 51
    Width = 49
    Height = 13
    Caption = #1050#1074#1072#1088#1090#1080#1088#1072
    Visible = False
  end
  object Label5: TLabel
    Left = 361
    Top = 5
    Width = 85
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1075#1086#1088#1086#1076#1086#1074
  end
  object Label6: TLabel
    Left = 537
    Top = 5
    Width = 67
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1091#1083#1080#1094
  end
  object BStart: TButton
    Left = 615
    Top = 69
    Width = 113
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1080#1079' '#1089#1087#1080#1089#1082#1072
    TabOrder = 0
    OnClick = BStartClick
  end
  object CBCity: TComboBox
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBCity'
    OnSelect = CBCitySelect
  end
  object CBStreet: TComboBox
    Left = 8
    Top = 70
    Width = 337
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'ComboBox1'
    OnSelect = CBStreetSelect
  end
  object BStreetCreate: TButton
    Left = 534
    Top = 69
    Width = 75
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100
    TabOrder = 3
    OnClick = BStreetCreateClick
  end
  object CBHome: TComboBox
    Left = 359
    Top = 70
    Width = 82
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'ComboBox1'
    Visible = False
    OnSelect = CBHomeSelect
  end
  object CBRoom: TComboBox
    Left = 448
    Top = 70
    Width = 73
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'ComboBox1'
    Visible = False
  end
  object CBCityTemplate: TComboBox
    Left = 359
    Top = 24
    Width = 162
    Height = 21
    ItemHeight = 13
    TabOrder = 6
    Text = 'CBCity'
    OnSelect = CBCitySelect
  end
  object CBStreetTemplate: TComboBox
    Left = 535
    Top = 24
    Width = 193
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'CBCity'
    OnSelect = CBCitySelect
  end
end
