object FormBankbook: TFormBankbook
  Left = 0
  Top = 0
  Caption = 'FormBankbook'
  ClientHeight = 484
  ClientWidth = 410
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
    Width = 68
    Height = 13
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077
  end
  object Label2: TLabel
    Left = 8
    Top = 153
    Width = 35
    Height = 13
    Caption = #1059#1089#1083#1091#1075#1072
  end
  object Label3: TLabel
    Left = 8
    Top = 298
    Width = 25
    Height = 13
    Caption = #1057#1095#1077#1090
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 27
    Width = 393
    Height = 89
    DataSource = DSFirm
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    OnEnter = DBGrid1Enter
    Columns = <
      item
        Expanded = False
        FieldName = 'code'
        Title.Caption = #1050#1086#1076
        Width = 38
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 320
        Visible = True
      end>
  end
  object DBGrid2: TDBGrid
    Left = 8
    Top = 172
    Width = 393
    Height = 89
    DataSource = DSUtility
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnEnter = DBGrid2Enter
    Columns = <
      item
        Expanded = False
        Title.Caption = #1050#1086#1076
        Width = 33
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        Width = 323
        Visible = True
      end>
  end
  object DBNUtility: TDBNavigator
    Left = 8
    Top = 267
    Width = 104
    Height = 25
    DataSource = DSUtility
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 2
    OnClick = DBNUtilityClick
  end
  object DBGrid3: TDBGrid
    Left = 8
    Top = 317
    Width = 393
    Height = 94
    DataSource = DSBankbook
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = DBGrid3DblClick
    Columns = <
      item
        Expanded = False
        Title.Caption = #1050#1086#1076' '#1092#1080#1088#1084#1099
        Width = 62
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1050#1086#1076' '#1091#1089#1083#1091#1075#1080
        Width = 82
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1057#1095#1077#1090
        Width = 212
        Visible = True
      end>
  end
  object DBNFirm: TDBNavigator
    Left = 8
    Top = 122
    Width = 104
    Height = 25
    DataSource = DSFirm
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 4
    OnClick = DBNFirmClick
  end
  object DBNBankbook: TDBNavigator
    Left = 8
    Top = 417
    Width = 104
    Height = 25
    DataSource = DSBankbook
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 5
    OnClick = DBNBankbookClick
  end
  object ADOQbankbook: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER_TEST;Data Source=S-050-ERC-' +
      'TEST'
    Parameters = <>
    Left = 312
    Top = 264
  end
  object DSBankbook: TDataSource
    DataSet = ADOQbankbook
    Left = 344
    Top = 264
  end
  object ADOQutility: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER_TEST;Data Source=S-050-ERC-' +
      'TEST'
    Parameters = <>
    Left = 296
    Top = 128
  end
  object DSUtility: TDataSource
    DataSet = ADOQutility
    Left = 328
    Top = 128
  end
  object ADOTFirms: TADOTable
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER_TEST;Data Source=S-050-ERC-' +
      'TEST'
    CursorType = ctStatic
    Filter = 'is_active=1'
    Filtered = True
    TableName = 'firms'
    Left = 304
    Top = 8
    object ADOTFirmscode: TIntegerField
      FieldName = 'code'
    end
    object ADOTFirmsname: TStringField
      FieldName = 'name'
      Size = 40
    end
    object ADOTFirmsid_type: TIntegerField
      FieldName = 'id_type'
    end
  end
  object DSFirm: TDataSource
    DataSet = ADOTFirms
    Left = 336
    Top = 8
  end
end
