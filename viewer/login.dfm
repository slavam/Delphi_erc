object LoginDlg: TLoginDlg
  Left = 227
  Top = 108
  ActiveControl = ELogin
  BorderStyle = bsDialog
  Caption = #1040#1074#1090#1086#1088#1080#1079#1072#1094#1080#1103
  ClientHeight = 106
  ClientWidth = 304
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
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
  object OKBtn: TButton
    Left = 219
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
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
    TabOrder = 3
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
end
