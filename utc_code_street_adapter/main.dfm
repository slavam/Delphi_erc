object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 202
  ClientWidth = 445
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
    Top = 13
    Width = 67
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1091#1083#1080#1094
  end
  object CBStreetTemplate: TComboBox
    Left = 81
    Top = 10
    Width = 260
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'CBStreetTemplate'
  end
  object BLoad: TButton
    Left = 362
    Top = 8
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 1
    OnClick = BLoadClick
  end
end
