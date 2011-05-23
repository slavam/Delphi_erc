object FormLoading: TFormLoading
  Left = 0
  Top = 0
  Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 269
  ClientWidth = 426
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
    Width = 147
    Height = 13
    Caption = #1057#1087#1080#1089#1086#1082' '#1092#1072#1081#1083#1086#1074' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080
  end
  object CLBReadyFiles: TCheckListBox
    Left = 8
    Top = 27
    Width = 410
    Height = 206
    ItemHeight = 13
    TabOrder = 0
    OnMouseUp = CLBReadyFilesMouseUp
  end
  object BLoad: TButton
    Left = 8
    Top = 239
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 1
    OnClick = BLoadClick
  end
  object BExit: TButton
    Left = 343
    Top = 239
    Width = 75
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = BExitClick
  end
end
