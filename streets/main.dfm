object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1091#1083#1080#1094
  ClientHeight = 479
  ClientWidth = 525
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
  object Label5: TLabel
    Left = 361
    Top = 5
    Width = 79
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1075#1086#1088#1086#1076#1072
  end
  object Label6: TLabel
    Left = 8
    Top = 348
    Width = 75
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1091#1083#1080#1094#1099
  end
  object Label2: TLabel
    Left = 8
    Top = 51
    Width = 33
    Height = 13
    Caption = #1059#1083#1080#1094#1099
  end
  object LID: TLabel
    Left = 89
    Top = 245
    Width = 15
    Height = 13
    Caption = 'ID:'
  end
  object Label4: TLabel
    Left = 8
    Top = 267
    Width = 22
    Height = 13
    Caption = #1058#1080#1087':'
  end
  object Label7: TLabel
    Left = 8
    Top = 294
    Width = 61
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1:'
  end
  object Label8: TLabel
    Left = 8
    Top = 321
    Width = 61
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 2:'
  end
  object Label9: TLabel
    Left = 8
    Top = 375
    Width = 42
    Height = 13
    Caption = 'Local ID:'
  end
  object Label10: TLabel
    Left = 8
    Top = 248
    Width = 15
    Height = 13
    Caption = 'ID:'
  end
  object Label11: TLabel
    Left = 8
    Top = 402
    Width = 52
    Height = 13
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
  end
  object Label12: TLabel
    Left = 8
    Top = 429
    Width = 22
    Height = 13
    Caption = #1058#1080#1087':'
  end
  object Label13: TLabel
    Left = 8
    Top = 456
    Width = 63
    Height = 13
    Caption = #1050#1086#1076' '#1075#1086#1088#1086#1076#1072':'
  end
  object CBCity: TComboBox
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'CBCity'
    OnSelect = CBCitySelect
  end
  object CBCityTemplate: TComboBox
    Left = 359
    Top = 24
    Width = 162
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'CBCity'
  end
  object CBStreetTemplate: TComboBox
    Left = 89
    Top = 345
    Width = 193
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnSelect = CBStreetTemplateSelect
  end
  object DBGStreets: TDBGrid
    Left = 8
    Top = 70
    Width = 513
    Height = 130
    DataSource = DSStreets
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = DBGStreetsCellClick
    Columns = <
      item
        Expanded = False
        Title.Caption = 'ID'
        Width = 37
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'short_type'
        Title.Caption = #1058#1080#1087
        Width = 35
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'name'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 1'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'name2'
        Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077' 2'
        Visible = True
      end
      item
        Expanded = False
        Visible = True
      end>
  end
  object DBNavigator1: TDBNavigator
    Left = 8
    Top = 206
    Width = 104
    Height = 25
    DataSource = DSStreets
    VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
    TabOrder = 4
    OnClick = DBNavigator1Click
  end
  object EName1: TEdit
    Left = 89
    Top = 291
    Width = 261
    Height = 21
    TabOrder = 5
    Text = 'EName1'
  end
  object EName2: TEdit
    Left = 89
    Top = 318
    Width = 261
    Height = 21
    TabOrder = 6
    Text = 'EName2'
  end
  object CBStreetType: TComboBox
    Left = 89
    Top = 264
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'CBStreetType'
  end
  object ELocalStreetId: TEdit
    Left = 89
    Top = 372
    Width = 80
    Height = 21
    TabOrder = 8
    Text = 'ELocalStreetId'
  end
  object ELocalStreetName: TEdit
    Left = 89
    Top = 399
    Width = 261
    Height = 21
    TabOrder = 9
    Text = 'ELocalStreetName'
  end
  object ECity: TEdit
    Left = 89
    Top = 453
    Width = 40
    Height = 21
    TabOrder = 10
    Text = 'ECity'
  end
  object EType: TEdit
    Left = 89
    Top = 426
    Width = 40
    Height = 21
    TabOrder = 11
    Text = 'EType'
  end
  object BUpdate: TButton
    Left = 136
    Top = 206
    Width = 75
    Height = 25
    Caption = #1048#1079#1084#1077#1085#1080#1090#1100
    TabOrder = 12
    OnClick = BUpdateClick
  end
  object BAdd: TButton
    Left = 217
    Top = 206
    Width = 75
    Height = 25
    Caption = #1044#1086#1073#1072#1074#1080#1090#1100
    TabOrder = 13
    OnClick = BAddClick
  end
  object BDelete: TButton
    Left = 298
    Top = 206
    Width = 75
    Height = 25
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 14
    OnClick = BDeleteClick
  end
  object BSave: TButton
    Left = 365
    Top = 451
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 15
    OnClick = BSaveClick
  end
  object BCancel: TButton
    Left = 446
    Top = 451
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1080#1090#1100
    TabOrder = 16
    OnClick = BCancelClick
  end
  object DSStreets: TDataSource
    DataSet = ADOQStreets
    Left = 448
    Top = 216
  end
  object ADOQStreets: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    Left = 480
    Top = 216
  end
end
