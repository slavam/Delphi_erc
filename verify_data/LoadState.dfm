object FormLoadingState: TFormLoadingState
  Left = 0
  Top = 0
  Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1075#1088#1091#1079#1082#1080
  ClientHeight = 307
  ClientWidth = 706
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGLoadindState: TDBGrid
    Left = 8
    Top = 8
    Width = 690
    Height = 272
    DataSource = DataSource
    ReadOnly = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = DBGLoadindStateDrawColumnCell
  end
  object DataSource: TDataSource
    DataSet = ADODataSet
    Left = 24
    Top = 280
  end
  object ADODataSet: TADODataSet
    ConnectionString = 
      'Provider=SQLNCLI10.1;Integrated Security="";Persist Security Inf' +
      'o=False;User ID=slava;Initial Catalog="";Data Source=S-050-35;In' +
      'itial File Name="";Server SPN=""'
    Parameters = <>
    Left = 64
    Top = 280
  end
end
