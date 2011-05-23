object FormControl: TFormControl
  Left = 0
  Top = 0
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = #1050#1086#1085#1090#1088#1086#1083#1100' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080' '#1086' '#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072#1093
  ClientHeight = 443
  ClientWidth = 706
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
  object LTotalRecords: TLabel
    Left = 8
    Top = 360
    Width = 3
    Height = 13
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 78
    Height = 13
    Caption = #1054#1090#1095#1077#1090#1085#1072#1103' '#1076#1072#1090#1072
  end
  object Label2: TLabel
    Left = 216
    Top = 8
    Width = 37
    Height = 13
    Caption = #1043#1086#1088#1086#1076#1072
  end
  object Label3: TLabel
    Left = 8
    Top = 64
    Width = 149
    Height = 13
    Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1082#1086#1085#1090#1088#1086#1083#1103
  end
  object Label4: TLabel
    Left = 8
    Top = 184
    Width = 89
    Height = 13
    Caption = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103
  end
  object LStatusFile: TLabel
    Left = 192
    Top = 422
    Width = 52
    Height = 13
    Caption = 'LStatusFile'
  end
  object BInputOpen: TButton
    Left = 400
    Top = 23
    Width = 95
    Height = 25
    Caption = #1042#1093#1086#1076#1085#1086#1081' '#1084#1072#1089#1089#1080#1074
    Enabled = False
    TabOrder = 0
    OnClick = BInputOpenClick
  end
  object protocol: TMemo
    Left = 8
    Top = 80
    Width = 689
    Height = 89
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object BExit: TButton
    Left = 602
    Top = 410
    Width = 95
    Height = 25
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 2
    OnClick = BExitClick
  end
  object DTPReportDate: TDateTimePicker
    Left = 8
    Top = 27
    Width = 153
    Height = 21
    Date = 40067.508555520840000000
    Time = 40067.508555520840000000
    TabOrder = 3
    OnChange = DTPReportDateChange
  end
  object CBCities: TComboBox
    Left = 214
    Top = 27
    Width = 153
    Height = 21
    ItemHeight = 13
    TabOrder = 4
    Text = 'CBCities'
    OnChange = CBCitiesChange
  end
  object PBprocess: TProgressBar
    Left = 8
    Top = 379
    Width = 689
    Height = 16
    TabOrder = 5
  end
  object LBWarnings: TListBox
    Left = 8
    Top = 203
    Width = 689
    Height = 141
    ItemHeight = 13
    TabOrder = 6
    OnDblClick = LBWarningsDblClick
  end
  object BLoad: TButton
    Left = 111
    Top = 410
    Width = 75
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    TabOrder = 7
    OnClick = BLoadClick
  end
  object BCheckAbsentees: TButton
    Left = 8
    Top = 410
    Width = 97
    Height = 25
    Caption = #1054#1090#1089#1091#1090#1089#1090#1074#1091#1102#1097#1080#1077
    Enabled = False
    TabOrder = 8
    OnClick = BCheckAbsenteesClick
  end
  object ChBFullNameWarn: TCheckBox
    Left = 360
    Top = 183
    Width = 313
    Height = 17
    Caption = #1055#1088#1077#1076#1091#1087#1088#1077#1078#1076#1077#1085#1080#1103' '#1086' '#1085#1077#1089#1086#1074#1087#1072#1076#1077#1085#1080#1080' '#1092#1072#1084#1080#1083#1080#1080' '#1074#1082#1083'/'#1074#1099#1082#1083
    TabOrder = 9
    OnClick = ChBFullNameWarnClick
  end
  object BWarningSave: TButton
    Left = 622
    Top = 349
    Width = 75
    Height = 25
    Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    TabOrder = 10
    OnClick = BWarningSaveClick
  end
  object ODInputData: TOpenDialog
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1076#1083#1103' '#1082#1086#1085#1090#1088#1086#1083#1103
    Left = 368
    Top = 24
  end
  object ADOQuery1: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT COUNT(*) FROM file_types')
    Left = 560
    Top = 40
  end
  object ADOQDictionary: TADOQuery
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 592
    Top = 40
  end
  object ADOStoredProc1: TADOStoredProc
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    CursorType = ctStatic
    Parameters = <>
    Left = 592
    Top = 8
  end
  object ADODSWork: TADODataSet
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    Parameters = <>
    Left = 560
    Top = 8
  end
  object ADOTResult: TADOTable
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User' +
      ' ID=slava;Initial Catalog=ERC_CENTER;Data Source=S-050-ERC-TEST'
    CursorType = ctStatic
    TableName = 'utilityfiles_bo'
    Left = 624
    Top = 8
    object ADOTResultid_file: TIntegerField
      FieldName = 'id_file'
    end
    object ADOTResultcode_firme: TIntegerField
      FieldName = 'code_firme'
    end
    object ADOTResultabcount: TStringField
      FieldName = 'abcount'
    end
    object ADOTResultdate_d: TDateTimeField
      FieldName = 'date_d'
    end
    object ADOTResultcode_plat: TIntegerField
      FieldName = 'code_plat'
    end
    object ADOTResultfio: TStringField
      FieldName = 'fio'
      Size = 37
    end
    object ADOTResultfio_vlad: TStringField
      FieldName = 'fio_vlad'
      Size = 37
    end
    object ADOTResultcode_c: TIntegerField
      FieldName = 'code_c'
    end
    object ADOTResultcode_s: TIntegerField
      FieldName = 'code_s'
    end
    object ADOTResultn_house: TIntegerField
      FieldName = 'n_house'
    end
    object ADOTResultf_house: TIntegerField
      FieldName = 'f_house'
    end
    object ADOTResulta_house: TStringField
      FieldName = 'a_house'
      Size = 2
    end
    object ADOTResultd_house: TIntegerField
      FieldName = 'd_house'
    end
    object ADOTResultn_room: TIntegerField
      FieldName = 'n_room'
    end
    object ADOTResulta_room: TStringField
      FieldName = 'a_room'
      Size = 2
    end
    object ADOTResultnum_room: TIntegerField
      FieldName = 'num_room'
    end
    object ADOTResultetaj: TIntegerField
      FieldName = 'etaj'
    end
    object ADOTResultphone: TStringField
      FieldName = 'phone'
      Size = 40
    end
    object ADOTResultdata_priv: TDateTimeField
      FieldName = 'data_priv'
    end
    object ADOTResultform_prop: TIntegerField
      FieldName = 'form_prop'
    end
    object ADOTResultob_pl: TFloatField
      FieldName = 'ob_pl'
    end
    object ADOTResultot_pl: TFloatField
      FieldName = 'ot_pl'
    end
    object ADOTResultpl_isp: TFloatField
      FieldName = 'pl_isp'
    end
    object ADOTResultpribor: TIntegerField
      FieldName = 'pribor'
    end
    object ADOTResultdata_pribor: TDateTimeField
      FieldName = 'data_pribor'
    end
    object ADOTResultboiler: TSmallintField
      FieldName = 'boiler'
    end
    object ADOTResultkolon: TIntegerField
      FieldName = 'kolon'
    end
    object ADOTResultwatercharge: TFloatField
      FieldName = 'watercharge'
    end
    object ADOTResultdate_wc: TDateTimeField
      FieldName = 'date_wc'
    end
    object ADOTResulttype_heat: TSmallintField
      FieldName = 'type_heat'
    end
    object ADOTResultdate_th: TDateTimeField
      FieldName = 'date_th'
    end
    object ADOTResultsumm_month: TFloatField
      FieldName = 'summ_month'
    end
    object ADOTResultsumm_isp: TFloatField
      FieldName = 'summ_isp'
    end
    object ADOTResulttarif: TFloatField
      FieldName = 'tarif'
    end
    object ADOTResulttarif_f: TFloatField
      FieldName = 'tarif_f'
    end
    object ADOTResultmonth_count: TIntegerField
      FieldName = 'month_count'
    end
    object ADOTResultend_count: TIntegerField
      FieldName = 'end_count'
    end
    object ADOTResultsumm_dolg: TFloatField
      FieldName = 'summ_dolg'
    end
    object ADOTResultkol_zar: TIntegerField
      FieldName = 'kol_zar'
    end
    object ADOTResultsumm_01122006: TFloatField
      FieldName = 'summ_01122006'
    end
    object ADOTResultdate_dog: TDateTimeField
      FieldName = 'date_dog'
    end
    object ADOTResultnum_dog: TStringField
      FieldName = 'num_dog'
      Size = 25
    end
    object ADOTResultsum_dolg_dog: TFloatField
      FieldName = 'sum_dolg_dog'
    end
    object ADOTResultsubs: TFloatField
      FieldName = 'subs'
    end
    object ADOTResultdate_subs: TDateTimeField
      FieldName = 'date_subs'
    end
    object ADOTResultcode_lg1: TIntegerField
      FieldName = 'code_lg1'
    end
    object ADOTResultcount_tn_lg1: TIntegerField
      FieldName = 'count_tn_lg1'
    end
    object ADOTResultkat_lg1: TIntegerField
      FieldName = 'kat_lg1'
    end
    object ADOTResultdate_lg1: TDateTimeField
      FieldName = 'date_lg1'
    end
    object ADOTResultdoc_lg_vid1: TStringField
      FieldName = 'doc_lg_vid1'
      Size = 15
    end
    object ADOTResultdoc_lg_num1: TStringField
      FieldName = 'doc_lg_num1'
      Size = 25
    end
    object ADOTResultdoc_lg_v1: TStringField
      FieldName = 'doc_lg_v1'
      Size = 25
    end
    object ADOTResultdoc_lg_d1: TDateTimeField
      FieldName = 'doc_lg_d1'
    end
    object ADOTResultrate_lg1: TFloatField
      FieldName = 'rate_lg1'
    end
    object ADOTResultrecord_number: TIntegerField
      FieldName = 'record_number'
    end
  end
end
