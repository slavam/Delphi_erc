object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1059#1083#1080#1094#1099
  ClientHeight = 426
  ClientWidth = 655
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
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 31
    Height = 13
    Caption = #1043#1086#1088#1086#1076
  end
  object Label1: TLabel
    Left = 248
    Top = 216
    Width = 66
    Height = 13
    Caption = #1054#1088#1075#1072#1085#1080#1079#1072#1094#1080#1103
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 33
    Height = 13
    Caption = #1059#1083#1080#1094#1099
  end
  object LLinkedTo: TLabel
    Left = 329
    Top = 403
    Width = 3
    Height = 13
  end
  object DBGridERC: TDBGrid
    Left = 8
    Top = 73
    Width = 639
    Height = 137
    DataSource = DSStreets
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        Title.Caption = #1050#1086#1076' '#1091#1083#1080#1094#1099
        Width = 58
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1058#1080#1087' '#1091#1083#1080#1094#1099
        Width = 59
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1083#1080#1094#1099
        Width = 241
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1083#1080#1094#1099' 2'
        Width = 242
        Visible = True
      end>
  end
  object CBCity: TComboBox
    Left = 8
    Top = 27
    Width = 169
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBCity'
    OnSelect = CBCitySelect
  end
  object CBFirm: TComboBox
    Left = 248
    Top = 235
    Width = 169
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 2
    Text = #1059#1082#1088#1058#1077#1083#1077#1050#1086#1084
    Items.Strings = (
      #1059#1082#1088#1058#1077#1083#1077#1050#1086#1084)
  end
  object DBNERCStreet: TDBNavigator
    Left = 8
    Top = 216
    Width = 100
    Height = 25
    DataSource = DSStreets
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 3
    OnClick = DBNERCStreetClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 262
    Width = 234
    Height = 123
    TabOrder = 4
    object LCodeStreet: TLabel
      Left = 48
      Top = 8
      Width = 24
      Height = 13
      Caption = #1050#1086#1076':'
    end
    object Label3: TLabel
      Left = 48
      Top = 35
      Width = 22
      Height = 13
      Caption = #1058#1080#1087':'
    end
    object LEName: TLabeledEdit
      Left = 74
      Top = 54
      Width = 145
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      LabelPosition = lpLeft
      TabOrder = 0
    end
    object LEName2: TLabeledEdit
      Left = 74
      Top = 81
      Width = 145
      Height = 21
      EditLabel.Width = 61
      EditLabel.Height = 13
      EditLabel.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 2:'
      LabelPosition = lpLeft
      TabOrder = 1
    end
    object CBType: TComboBox
      Left = 76
      Top = 27
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'CBType'
    end
  end
  object DBGridUTC: TDBGrid
    Left = 248
    Top = 262
    Width = 399
    Height = 123
    DataSource = DSUTCStreets
    ReadOnly = True
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        Title.Caption = #1050#1086#1076' '#1091#1083#1080#1094#1099
        Width = 75
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1058#1080#1087' '#1091#1083#1080#1094#1099
        Width = 58
        Visible = True
      end
      item
        Expanded = False
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1083#1080#1094#1099
        Width = 233
        Visible = True
      end>
  end
  object DBNUTCStreet: TDBNavigator
    Left = 547
    Top = 391
    Width = 100
    Height = 25
    DataSource = DSUTCStreets
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 6
    OnClick = DBNUTCStreetClick
  end
  object BSave: TButton
    Left = 8
    Top = 391
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 7
    OnClick = BSaveClick
  end
  object BAdd: TButton
    Left = 248
    Top = 391
    Width = 75
    Height = 25
    Caption = #1055#1088#1080#1074#1103#1079#1072#1090#1100
    TabOrder = 8
    OnClick = BAddClick
  end
  object BSplit: TButton
    Left = 167
    Top = 391
    Width = 75
    Height = 25
    Caption = #1056#1072#1079#1076#1077#1083#1080#1090#1100
    Enabled = False
    TabOrder = 9
    OnClick = BSplitClick
  end
  object DSStreets: TDataSource
    DataSet = QStreets
    Left = 448
    Top = 24
  end
  object QStreets: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER_TEST;Data Source=S-050-ERC-' +
      'TEST'
    Parameters = <>
    Left = 416
    Top = 24
  end
  object QUTCStreets: TQuery
    DatabaseName = 'ERC_DATA'
    Left = 512
    Top = 232
  end
  object DSUTCStreets: TDataSource
    DataSet = QUTCStreets
    Left = 544
    Top = 232
  end
end
