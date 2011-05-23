object FormCRUD: TFormCRUD
  Left = 0
  Top = 0
  Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082#1080'/'#1089#1095#1077#1090#1072
  ClientHeight = 435
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 410
    Height = 388
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 31
      Height = 13
      Caption = #1043#1086#1088#1086#1076
    end
    object Label5: TLabel
      Left = 8
      Top = 54
      Width = 31
      Height = 13
      Caption = #1059#1083#1080#1094#1072
    end
    object Label6: TLabel
      Left = 8
      Top = 100
      Width = 20
      Height = 13
      Caption = #1044#1086#1084
    end
    object Label7: TLabel
      Left = 112
      Top = 100
      Width = 49
      Height = 13
      Caption = #1050#1074#1072#1088#1090#1080#1088#1072
    end
    object Label8: TLabel
      Left = 8
      Top = 267
      Width = 103
      Height = 13
      Caption = #1057#1095#1077#1090#1072' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
    end
    object Label1: TLabel
      Left = 8
      Top = 146
      Width = 70
      Height = 13
      Caption = #1055#1083#1072#1090#1077#1083#1100#1097#1080#1082#1080
    end
    object CBCity: TComboBox
      Left = 8
      Top = 27
      Width = 258
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'CBCity'
      OnSelect = CBCitySelect
    end
    object CBStreet: TComboBox
      Left = 8
      Top = 73
      Width = 258
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'CBStreet'
      OnSelect = CBStreetSelect
    end
    object CBHome: TComboBox
      Left = 8
      Top = 119
      Width = 68
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'CBHome'
      OnSelect = CBHomeSelect
    end
    object CBRoom: TComboBox
      Left = 112
      Top = 119
      Width = 65
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'CBRoom'
      OnSelect = CBRoomSelect
    end
    object LBOccupants: TListBox
      Left = 8
      Top = 165
      Width = 393
      Height = 65
      ItemHeight = 13
      TabOrder = 4
      OnClick = LBOccupantsClick
    end
    object BNewPayer: TButton
      Left = 8
      Top = 236
      Width = 137
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072
      TabOrder = 5
      OnClick = BNewPayerClick
    end
    object BAddBankbook: TButton
      Left = 8
      Top = 357
      Width = 104
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1095#1077#1090
      Enabled = False
      TabOrder = 6
      OnClick = BAddBankbookClick
    end
    object LBBankbooks: TListBox
      Left = 8
      Top = 286
      Width = 393
      Height = 65
      ItemHeight = 13
      TabOrder = 7
      OnDblClick = LBBankbooksDblClick
    end
    object LECodeERC: TLabeledEdit
      Left = 272
      Top = 27
      Width = 129
      Height = 21
      EditLabel.Width = 43
      EditLabel.Height = 13
      EditLabel.Caption = #1050#1086#1076' '#1045#1056#1062
      TabOrder = 8
    end
    object BSearch: TButton
      Left = 326
      Top = 71
      Width = 75
      Height = 25
      Caption = #1048#1089#1082#1072#1090#1100
      TabOrder = 9
      OnClick = BSearchClick
    end
  end
  object BShowBB: TButton
    Left = 8
    Top = 402
    Width = 112
    Height = 25
    Caption = #1060#1080#1088#1084#1072'/'#1091#1089#1083#1091#1075#1072'/'#1089#1095#1077#1090
    TabOrder = 1
    OnClick = BShowBBClick
  end
end
