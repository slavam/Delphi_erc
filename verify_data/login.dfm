object LoginDlg: TLoginDlg
  Left = 227
  Top = 108
  ActiveControl = ELogin
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 129
  ClientWidth = 298
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 201
    Height = 89
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 34
    Height = 13
    Caption = #1051#1086#1075#1080#1085':'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 41
    Height = 13
    Caption = #1055#1072#1088#1086#1083#1100':'
  end
  object LFileNum: TLabel
    Left = 8
    Top = 106
    Width = 136
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1092#1072#1081#1083#1072' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072':'
  end
  object OKBtn: TButton
    Left = 219
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 219
    Top = 39
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
    OnClick = CancelBtnClick
  end
  object ELogin: TEdit
    Left = 72
    Top = 21
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object EPassword: TEdit
    Left = 72
    Top = 61
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
  end
  object EFileNum: TEdit
    Left = 150
    Top = 103
    Width = 59
    Height = 21
    TabOrder = 2
  end
end
