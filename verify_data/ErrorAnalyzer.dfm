object FormErrorAnalyzer: TFormErrorAnalyzer
  Left = 0
  Top = 0
  Caption = 'FormErrorAnalyzer'
  ClientHeight = 643
  ClientWidth = 513
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
    Top = 168
    Width = 47
    Height = 13
    Caption = #1050#1086#1076' '#1045#1056#1062':'
  end
  object LFullName: TLabel
    Left = 8
    Top = 282
    Width = 31
    Height = 13
    Caption = #1060#1048#1054': '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object LBankbook: TLabel
    Left = 8
    Top = 225
    Width = 76
    Height = 13
    Caption = #1051#1080#1094#1077#1074#1086#1081' '#1089#1095#1077#1090': '
  end
  object LAddress: TLabel
    Left = 8
    Top = 244
    Width = 38
    Height = 13
    Caption = #1040#1076#1088#1077#1089': '
  end
  object LFirm: TLabel
    Left = 8
    Top = 187
    Width = 70
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103':'
  end
  object LService: TLabel
    Left = 8
    Top = 206
    Width = 99
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072':'
  end
  object LDescription: TLabel
    Left = 8
    Top = 509
    Width = 53
    Height = 13
    Caption = #1044#1077#1081#1089#1090#1074#1080#1077':'
  end
  object Label1: TLabel
    Left = 8
    Top = 383
    Width = 31
    Height = 13
    Caption = #1057#1095#1077#1090#1072
  end
  object LPayers: TLabel
    Left = 192
    Top = 263
    Width = 106
    Height = 13
    Caption = #1050#1086#1076#1099' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1086#1074
    Visible = False
  end
  object LTotalErrors: TLabel
    Left = 308
    Top = 168
    Width = 44
    Height = 13
    Alignment = taRightJustify
    Caption = #1054#1096#1080#1073#1086#1082':'
  end
  object LNowErrors: TLabel
    Left = 352
    Top = 168
    Width = 52
    Height = 13
    Caption = '/'#1054#1089#1090#1072#1083#1086#1089#1100
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 40
    Height = 13
    Caption = #1054#1096#1080#1073#1082#1080
  end
  object LBErrors: TListBox
    Left = 8
    Top = 27
    Width = 497
    Height = 135
    ItemHeight = 13
    TabOrder = 0
    OnClick = LBErrorsClick
  end
  object MAction: TMemo
    Left = 8
    Top = 528
    Width = 497
    Height = 81
    Lines.Strings = (
      'MAction')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object BAction: TButton
    Left = 8
    Top = 615
    Width = 113
    Height = 25
    TabOrder = 2
    Visible = False
    OnClick = BActionClick
  end
  object BCompareData: TButton
    Left = 392
    Top = 615
    Width = 113
    Height = 25
    Caption = #1057#1088#1072#1074#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
    TabOrder = 3
    OnClick = BCompareDataClick
  end
  object LBErcCodeOwners: TListBox
    Left = 8
    Top = 301
    Width = 396
    Height = 76
    ItemHeight = 13
    TabOrder = 4
    OnClick = LBErcCodeOwnersClick
    OnDblClick = LBErcCodeOwnersDblClick
  end
  object LBAccounts: TListBox
    Left = 8
    Top = 402
    Width = 497
    Height = 101
    ItemHeight = 13
    TabOrder = 5
    OnDblClick = LBAccountsDblClick
  end
  object BSubstituteCode: TButton
    Left = 414
    Top = 301
    Width = 91
    Height = 25
    Caption = #1055#1086#1076#1089#1090#1072#1074#1080#1090#1100' '#1082#1086#1076
    Enabled = False
    TabOrder = 6
    OnClick = BSubstituteCodeClick
  end
  object BCreateCode: TButton
    Left = 416
    Top = 352
    Width = 89
    Height = 25
    Caption = #1057#1086#1079#1076#1072#1090#1100' '#1082#1086#1076
    Enabled = False
    TabOrder = 7
    OnClick = BCreateCodeClick
  end
end
