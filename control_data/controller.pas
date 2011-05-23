unit controller;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ComCtrls, ADODB,
  StrUtils, IniFiles, Math,
  DB_service;

type
  TAddresIdBankbookId = class(TObject)
    number_record: integer;
    addr_id: integer;
    bb_id: integer;
  end;

type
  TWarningInfo = class(TObject)
    number_record: integer;
    field_name: string;
    db_value: string;
  end;

type
  TAboutFile = record
    name: string;
    size: integer;
    file_date_create: Extended;
    file_date_operate: Extended;
  end;

type
  TFormControl = class(TForm)
    BInputOpen: TButton;
    ODInputData: TOpenDialog;
    protocol: TMemo;
    LTotalRecords: TLabel;
    BExit: TButton;
    DTPReportDate: TDateTimePicker;
    Label1: TLabel;
    ADOQuery1: TADOQuery;
    ADOQDictionary: TADOQuery;
    ADOStoredProc1: TADOStoredProc;
    ADODSWork: TADODataSet;
    CBCities: TComboBox;
    Label2: TLabel;
    ADOTResult: TADOTable;
    ADOTResultid_file: TIntegerField;
    ADOTResultcode_firme: TIntegerField;
    ADOTResultabcount: TStringField;
    ADOTResultdate_d: TDateTimeField;
    ADOTResultcode_plat: TIntegerField;
    ADOTResultfio: TStringField;
    ADOTResultfio_vlad: TStringField;
    ADOTResultcode_c: TIntegerField;
    ADOTResultcode_s: TIntegerField;
    ADOTResultn_house: TIntegerField;
    ADOTResultf_house: TIntegerField;
    ADOTResulta_house: TStringField;
    ADOTResultd_house: TIntegerField;
    ADOTResultn_room: TIntegerField;
    ADOTResulta_room: TStringField;
    ADOTResultnum_room: TIntegerField;
    ADOTResultetaj: TIntegerField;
    ADOTResultphone: TStringField;
    ADOTResultdata_priv: TDateTimeField;
    ADOTResultform_prop: TIntegerField;
    ADOTResultob_pl: TFloatField;
    ADOTResultot_pl: TFloatField;
    ADOTResultpl_isp: TFloatField;
    ADOTResultpribor: TIntegerField;
    ADOTResultdata_pribor: TDateTimeField;
    ADOTResultboiler: TSmallintField;
    ADOTResultkolon: TIntegerField;
    ADOTResultwatercharge: TFloatField;
    ADOTResultdate_wc: TDateTimeField;
    ADOTResulttype_heat: TSmallintField;
    ADOTResultdate_th: TDateTimeField;
    ADOTResultsumm_month: TFloatField;
    ADOTResultsumm_isp: TFloatField;
    ADOTResulttarif: TFloatField;
    ADOTResulttarif_f: TFloatField;
    ADOTResultmonth_count: TIntegerField;
    ADOTResultend_count: TIntegerField;
    ADOTResultsumm_dolg: TFloatField;
    ADOTResultkol_zar: TIntegerField;
    ADOTResultsumm_01122006: TFloatField;
    ADOTResultdate_dog: TDateTimeField;
    ADOTResultnum_dog: TStringField;
    ADOTResultsum_dolg_dog: TFloatField;
    ADOTResultsubs: TFloatField;
    ADOTResultdate_subs: TDateTimeField;
    ADOTResultcode_lg1: TIntegerField;
    ADOTResultcount_tn_lg1: TIntegerField;
    ADOTResultkat_lg1: TIntegerField;
    ADOTResultdate_lg1: TDateTimeField;
    ADOTResultdoc_lg_vid1: TStringField;
    ADOTResultdoc_lg_num1: TStringField;
    ADOTResultdoc_lg_v1: TStringField;
    ADOTResultdoc_lg_d1: TDateTimeField;
    ADOTResultrate_lg1: TFloatField;
    PBprocess: TProgressBar;
    Label3: TLabel;
    Label4: TLabel;
    ADOTResultrecord_number: TIntegerField;
    LBWarnings: TListBox;
    BLoad: TButton;
    BCheckAbsentees: TButton;
    ChBFullNameWarn: TCheckBox;
    BWarningSave: TButton;
    LStatusFile: TLabel;
    procedure BInputOpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure DTPReportDateChange(Sender: TObject);
    procedure CBCitiesChange(Sender: TObject);
    procedure LBWarningsDblClick(Sender: TObject);
    procedure BCheckAbsenteesClick(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
    procedure ChBFullNameWarnClick(Sender: TObject);
    procedure BWarningSaveClick(Sender: TObject);
  private
    { Private declarations }
    loaded, for_loading, totalRecords: integer;
    inputFileName: string;
    numberRecord: integer;
    errorCode: integer;
    isWarning: boolean;
    totalWarnings: integer;
    room_attributes: TRoomOptions;
    tariff_params: TTariffOptions;
    debt_params: TDebtOptions;
    payer_params: TPayerOptions;
    privilege_params: TPrivilege;
    id_cities: array [0..100] of integer;
    rules: array [0..60] of TRule;
    total_rules: integer;
    return_code: integer;
    added_records: integer;
    number_wrong_records: integer;
    address_id: integer;
    occupants: string;
    input_file_stats: TAboutFile;
    errors: array [0..100] of string;
    reg_record_id: integer;
    main_ids: TStringList;
    buffer_size: integer;
    buffered_file_name: string;
    buffered_data_state: integer;
    procedure SaveResult;
    procedure get_buffer_state;
    procedure update_buffer_state;
  public
    { Public declarations }
    report_date: Extended;
    selected_record_num: integer;
    current_firm_code: integer;
    current_city_id: integer;
    warning_records: TStringList;
    warning: TWarningInfo;
    bank_book_id: integer;
    report_date_params: TReportDateOptions;
    QInputData: TADOQuery;
  end;

var
  FormControl: TFormControl;
  consumptionRate : TRateWater=[0, 50, 60, 80, 85, 90, 105, 115];
  Settings: TIniFile;
  connection_string: string;
  format_date: string = 'mm.dd.yyyy';

implementation

uses
  DataView, Absentees;

{$R *.dfm}

type
  TErrorInfo = record
    number_record: integer;
    error_code: integer;
  end;

var
  wrong_records: array [0..100000] of TErrorInfo;
  bb_absent: integer;
  address_absent: integer;
  full_name_diff: integer;

procedure TFormControl.BInputOpenClick(Sender: TObject);
var
  vf: file;
  i: integer;
  start_time: Extended;
  this_record, total_msec, avr_msec: integer;
  existed_file_size: integer;
  test_field_name: string;
  fio: string;
  main_id: TAddresIdBankbookId;

function get_field_name(result_field_name: string):string;
var
  i:integer;
begin
  for I := 0 to total_rules - 1 do
    if rules[i].result_field_name = result_field_name then begin
      result := rules[i].input_field_name;
      exit;
    end;
  result := result_field_name;
end;

procedure saveError(field_name, field_value: string);
begin
  wrong_records[number_wrong_records].number_record := i+1;
  wrong_records[number_wrong_records].error_code := errorCode;
  inc(number_wrong_records);
  protocol.Lines.Add('Запись '+IntToStr(i+1)+'; поле "'+field_name+
    '"; значение "'+field_value+'"; описание "'+errors[errorCode]+'"');
end;

function get_input_file_name_only(fileName: string): string;
begin
  result := ExtractFileName(fileName);
  result := copy(result, 1, pos('.', result)-1);
end;

function correct_input_file_name(fileName: string): Boolean;
begin
  result := true;
  if pos('bo', ANSIlowercase(fileName)) <> 1 then
    result := false
  else begin
    current_firm_code := StrToInt(copy(fileName, 3, 4));
    if not isCode(ADOQDictionary, 'firms', 'code', copy(fileName, 3, 4)) then begin
      result := false;
    end;
  end;
end;

function is_input_field_for(result_field_name: string): Boolean;
var
  i:integer;
begin
  result := false;
  for I := 0 to total_rules - 1 do
    if (rules[i].result_field_name = result_field_name) then begin
      if (rules[i].input_field_name <> '') then
        result := true
      else
        result := false;
      exit;
    end;
end;

function get_default_value_for(result_field_name: string): string;
var
  i:integer;
begin
  result := '';
  for I := 0 to total_rules - 1 do
    if (rules[i].result_field_name = result_field_name) then begin
      result := rules[i].default_value;
      exit;
    end;
end;

procedure saveWarning(result_field_name: string; base_field_value: string);
begin
  isWarning := true;
  warning := TWarningInfo.Create;
  warning.number_record := i+1;
  warning.field_name := result_field_name;
  warning.db_value := base_field_value;
  LBWarnings.Hint := 'В записи '+IntToStr(i+1)+
    ' значение поля '+get_field_name(result_field_name)+'="'+
    QInputData.FieldByName(get_field_name(result_field_name)).AsString+
    '" не совпадает со значением в базе "'+base_field_value+'";';
  warning_records.AddObject(LBWarnings.Hint, warning);
  LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
end;

procedure prepare_result_table;
begin
  ADOTResult.Active := false;
  with ADOQDictionary do begin
    SQL.Clear;
    sql.add(
      'if exists '+
      '(select * from dbo.sysobjects '+
      'where id = object_id(N''[dbo].[utilityfiles_bo]'') '+
      'and OBJECTPROPERTY(id, N''IsUserTable'') = 1) '+
      'truncate table [dbo].[utilityfiles_bo] ');
    ExecSQL;
    Close;
  end;
  ADOTResult.Active := true;
end;

procedure get_input_file_stats(file_name: string);
var
  FileHandle: Integer;
begin
  input_file_stats.name := ExtractFileName(file_name);
  input_file_stats.size := get_file_size(file_name);
  FileHandle:= FileOpen(ODInputData.FileName, 0);
//  sleep(1000);
  input_file_stats.file_date_operate := now;
  if FileHandle = -1 then
    input_file_stats.file_date_create := now
  else
    input_file_stats.file_date_create := FileDateToDateTime(FileGetDate(FileHandle));
  FileClose(FileHandle);
end;

function was_registred(input_file_name: string; var size: integer): boolean;
begin
  result := false;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM file_registrations WHERE file_name = '''+input_file_name+'''');
    Open;
    if Recordset.RecordCount > 0 then begin
      result := true;
      size := FieldByName('file_size').AsInteger;
    end;
    Close;
  end;
end;

function registre_input_file:integer;
begin
  result := 0;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('INSERT INTO file_registrations '+
      '(file_name, file_size, file_date, date_reg, id_type, id_status) VALUES '+
      '('''+input_file_stats.name+''', '+IntToStr(input_file_stats.size)+
      ', '''+FormatDateTime(format_date,input_file_stats.file_date_create)+''', '''+
      FormatDateTime(format_date,now)+''', 6, 0)');
    ExecSQL;
    Close;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 id FROM file_registrations WHERE id_type = 6 AND file_name = '''+
      input_file_stats.name+''' ORDER BY id DESC'); //date_reg DESC');
    Open;
    first;
    result := Fields[0].AsInteger;
    Close;
  end;
end;

begin
  return_code := 0;
  if ODInputData.Execute then begin
    get_input_file_stats(ODInputData.FileName);
    if was_registred(input_file_stats.name, existed_file_size) then begin
      return_code := 1; // file was processed error
      if existed_file_size <> input_file_stats.size then
        ShowMessage('Файла "'+input_file_stats.name+'" ('+
          IntToStr(input_file_stats.size)+')уже был обработан, но его размер был '+
          IntToStr(existed_file_size))
      else
        ShowMessage('Файла "'+input_file_stats.name+'" уже был обработан');
{$IFNDEF DEBUG}
      exit;
{$ENDIF}
    end;
    reg_record_id := registre_input_file();
    inputFileName:= ChangeFileExt(ODInputData.FileName, '.dbf');
    AssignFile(Vf, ODInputData.FileName);
    Rename(Vf, inputFileName);
    inputFileName := get_input_file_name_only(inputFileName);
    if not correct_input_file_name(inputFileName) then begin
      return_code := 2; // file name error
      ShowMessage('Ошибка в имени входного файла "'+inputFileName+'"');
      exit;
    end;
  end else begin
    exit;
  end;
  warning_records.Clear;
  protocol.Clear;
  LBWarnings.Clear;
  protocol.Lines.Add(TimeToStr(now)+'; Начало обработки файла '+input_file_stats.name+
    '; отчетная дата '+DateToStr(report_date)+
    '; организация '+IntToStr(current_firm_code)+';');
  total_rules := 0;
  if not get_rules_by_firm_code(rules, total_rules, ADOQDictionary, current_firm_code) then begin
    ShowMessage('Нет правил преобразования данных для организации '+ IntToStr(current_firm_code));
    exit;
  end;
  protocol.Lines.Add(TimeToStr(now)+'; Найдены правила преобразования;');
  QInputData.SQL.Clear;
  QInputData.SQL.Add('select * from  openrowset (''MSDASQL'', '+
    '''DRIVER={Microsoft dBase Driver (*.dbf)};DBQ=\\Postserv\centr\about_payers'','+
    '''select * from '+inputFileName+''')');
  QInputData.Open;

  totalRecords := QInputData.RecordCount;
  QInputData.First;
  prepare_result_table;
  totalWarnings := 0;
  ADOTResult.Edit;
  total_msec := 0;
  added_records := 0;
  number_wrong_records := 0;
  bb_absent := 0;
  address_absent := 0;
  full_name_diff := 0;
  protocol.Lines.Add(TimeToStr(now)+'; Начат перебор записей; Всего '+IntToStr(totalRecords)+';');
  if totalRecords = 0 then
    return_code := 6; // table is empty
  BLoad.Enabled := false;
  BCheckAbsentees.Enabled := false;
  main_ids.Clear;
  for I := 0 to totalRecords - 1 do begin
    Application.ProcessMessages;
    LTotalRecords.Caption :=
      'Всего записей: '+intToStr(totalRecords)+'/'+Inttostr(i+1);
    try // hack!!!
      PBprocess.Position := PBprocess.Max * (i+1) div totalRecords;
    Except
      exit;
    end;
    errorCode := 0;
    ADOTResultid_file.Value := reg_record_id;
    main_id := TAddresIdBankbookId.Create;
    main_id.number_record := i+1;
    isWarning := false;
    start_time := now;
//1 CODE_FIRME required
    test_field_name := get_field_name('code_firme');
    if current_firm_code <> QInputData.FieldByName(test_field_name).AsInteger then begin
      errorCode := 1;
      saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
      QInputData.Next;
      Continue;
    end;
    ADOTResultcode_firme.Value := current_firm_code;

//3 DATE_D required
    test_field_name := get_field_name('date_d');
    if QInputData.FieldByName(test_field_name).AsDateTime > report_date then begin
      errorCode := 2;
      saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
      QInputData.Next;
      Continue;
    end;
    ADOTResultdate_d.Value := QInputData.FieldByName(get_field_name('date_d')).AsDateTime;

//4 CODE_PLAT required
    test_field_name := get_field_name('code_plat');
    if not isCode(ADOQDictionary, 'utilities', 'code', QInputData.FieldByName(test_field_name).AsString) then begin
      errorCode := 3;
      saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
      QInputData.Next;
      Continue;
    end;
    ADOTResultcode_plat.Value := QInputData.FieldByName(get_field_name('code_plat')).AsInteger;

//2 ABCOUNT required
    bank_book_id := -1;
    ADOTResultabcount.Value := trim(QInputData.FieldByName(get_field_name('abcount')).AsString);
    if not get_bank_book_id(bank_book_id, ADOStoredProc1, current_firm_code,
      ADOTResultcode_plat.Value, ADOTResultabcount.Value) then begin
      isWarning := true;
      warning := TWarningInfo.Create;
      warning.number_record := i+1;
      warning.field_name := 'abcount';
      warning.db_value := '';
      LBWarnings.Hint := 'В записи '+IntToStr(i+1)+
        ' лицевой счет '+ADOTResultabcount.Value+' не найден в базе;';
      inc(bb_absent);
      warning_records.AddObject(LBWarnings.Hint, warning);
      LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
    end;
    main_id.bb_id := bank_book_id;

//7 CODE_C required
    test_field_name := get_field_name('code_c');
//    if not isCode(ADOQDictionary, 'cities', 'id', QInputData.FieldByName(test_field_name).AsString) then begin
    if not is_city(ADOQDictionary, QInputData.FieldByName(test_field_name).AsString, current_city_id) then begin
      errorCode := 4;
      saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
      QInputData.Next;
      Continue;
    end;
    ADOTResultcode_c.Value := QInputData.FieldByName(get_field_name('code_c')).AsInteger;

//8 CODE_S required
    test_field_name := get_field_name('code_s');
    if not isCode(ADOQDictionary, 'streets', 'code_s', QInputData.FieldByName(test_field_name).AsString) then begin
      errorCode := 5;
      saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
      QInputData.Next;
      Continue;
    end;
    ADOTResultcode_s.Value := QInputData.FieldByName(get_field_name('code_s')).AsInteger;


//9 N_HOUSE required
    if trim(QInputData.FieldByName(get_field_name('n_house')).AsString)='' then
      ADOTResultn_house.Value := 0
    else
      ADOTResultn_house.Value := QInputData.FieldByName(get_field_name('n_house')).AsInteger;

//10 F_HOUSE required
    if trim(QInputData.FieldByName(get_field_name('f_house')).AsString)='' then
      ADOTResultf_house.Value := 0
    else
      ADOTResultf_house.Value := QInputData.FieldByName(get_field_name('f_house')).AsInteger;

//11 A_HOUSE required
    ADOTResulta_house.Value := QInputData.FieldByName(get_field_name('a_house')).AsString;

//12 D_HOUSE required
    if trim(QInputData.FieldByName(get_field_name('d_house')).AsString)='' then
      ADOTResultd_house.Value := 0
    else
      ADOTResultd_house.Value := QInputData.FieldByName(get_field_name('d_house')).AsInteger;

//13 N_ROOM required
    if trim(QInputData.FieldByName(get_field_name('n_room')).AsString)='' then
      ADOTResultn_room.Value := 0
    else
      ADOTResultn_room.Value := QInputData.FieldByName(get_field_name('n_room')).AsInteger;

//14 A_ROOM required
    ADOTResulta_room.Value := QInputData.FieldByName(get_field_name('a_room')).AsString;

// ADDRESS required
    address_id := -1;
    if not address_exists(ADOQDictionary, IntToStr(ADOTResultn_house.Value),
      IntToStr(ADOTResultf_house.Value), IntToStr(ADOTResultd_house.Value),
      ADOTResulta_house.Value, IntToStr(ADOTResultn_room.Value), ADOTResulta_room.Value,
      IntToStr(ADOTResultcode_c.Value), IntToStr(ADOTResultcode_s.Value), address_id) then begin
      isWarning := true;
      LBWarnings.Hint := 'В записи '+IntToStr(i+1)+
        ' в базе не найден адрес: код города='+IntToStr(ADOTResultcode_c.Value)+
        '; код улицы='+IntToStr(ADOTResultcode_s.Value)+
        '; дом='+IntToStr(ADOTResultn_house.Value)+' '+
        IntToStr(ADOTResultf_house.Value)+' '+
        ADOTResulta_house.Value+' '+
        IntToStr(ADOTResultd_house.Value)+
        '; квартира='+IntToStr(ADOTResultn_room.Value)+' '+
        ADOTResulta_room.Value+';';
      warning := TWarningInfo.Create;
      warning.number_record := i+1;
      warning.field_name := 'n_house';
      warning.db_value := '';
      inc(address_absent);
      LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
      warning_records.AddObject(LBWarnings.Hint, warning);
    end;
    main_id.addr_id := address_id;
//    main_ids.AddObject(IntToStr(i+1), main_id);
{
    if (address_id <> -1) and (bank_book_id > 0) and
      (address_id <> get_address_id_by_bank_book_id(ADOQDictionary, bank_book_id)) then begin
      isWarning := true;
      LBWarnings.Hint := 'В записи '+IntToStr(i+1)+
        ' для счета '+ADOTResultabcount.Value+' в базе имеется другой адрес;';
      warning := TWarningInfo.Create;
      warning.number_record := i+1;
      warning.field_name := 'n_house';
      warning.db_value :=
        IntToStr(get_address_id_by_bank_book_id(ADOQDictionary, bank_book_id));
      warning_records.AddObject(LBWarnings.Hint, warning);
      LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
    end;
}
//5 FIO
    fio := ANSIUpperCase(trim(QInputData.FieldByName(get_field_name('fio')).AsString));
    fio := AnsiReplaceStr(fio, chr(39), ''); // chr(39) = '
    fio := AnsiReplaceStr(fio, '\', '');
    fio := AnsiReplaceStr(fio, '?', '');
    fio := AnsiReplaceStr(fio, '%', '');
    fio := AnsiReplaceStr(fio, '*', '');
    fio := AnsiReplaceStr(fio, ',', ' ');
    fio := AnsiReplaceStr(fio, '.', ' ');
    fio := trim(AnsiReplaceStr(fio, '  ', ' '));
    ADOTResultfio.Value := fio;
    occupants := '';
    if (ADOTResultfio.Value = '') and (bank_book_id > 0) then begin
      isWarning := true;
      LBWarnings.Hint := 'В записи '+IntToStr(i+1)+
        ' фамилия, имя, отчество плательщика не заполнены;';
      warning := TWarningInfo.Create;
      warning.number_record := i+1;
      warning.field_name := 'fio';
      warning.db_value :=
        get_fullname_by_bankbook_id(ADOQDictionary, bank_book_id);
      warning_records.AddObject(LBWarnings.Hint, warning);
      inc(full_name_diff);
      if ChBFullNameWarn.Checked then
        LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
    end else if not full_name_exists(ADOStoredProc1, ADODSWork,
      current_firm_code, ADOTResultcode_plat.Value,
      ADOTResultabcount.Value, ADOTResultfio.Value, address_id, occupants) then begin
      isWarning := true;
      if occupants = '' then
        LBWarnings.hint := 'В записи '+IntToStr(i+1)+
        ' плательщик '+ADOTResultfio.Value+
        ' не найден в базе для счета '+ADOTResultabcount.Value+';'
      else begin
        LBWarnings.hint := 'В записи '+IntToStr(i+1)+
        ' Pos='+IntToStr(get_position_mismatch(ADOTResultfio.Value, occupants))+';'+
        ' плательщик '+ADOTResultfio.Value+
        ' не найден в базе; для счета '+ADOTResultabcount.Value+' найден '+occupants;
      end;
      warning := TWarningInfo.Create;
      warning.number_record := i+1;
      warning.field_name := 'fio';
      warning.db_value := trim(occupants);
      warning_records.AddObject(LBWarnings.Hint, warning);
      inc(full_name_diff);
      if ChBFullNameWarn.Checked then
        LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
    end;

//6 FIO_VLAD
    if is_input_field_for('fio_vlad') then begin
      ADOTResultfio_vlad.Value := ANSIUpperCase(trim(QInputData.FieldByName(get_field_name('fio_vlad')).AsString));
      if (ADOTResultfio.Value = '') and (ADOTResultfio_vlad.Value = '') then begin
        isWarning := true;
        LBWarnings.hint := 'В записи '+IntToStr(i+1)+
          ' фамилия, имя, отчество плательщика и владельца не заполнены;';
        warning := TWarningInfo.Create;
        warning.number_record := i+1;
        warning.field_name := 'fio_vlad';
        warning.db_value := '';
        warning_records.AddObject(LBWarnings.Hint, warning);
        LBWarnings.Items.AddObject(LBWarnings.Hint, warning);
      end;
    end else begin
      ADOTResultfio_vlad.Value := get_default_value_for('fio_vlad');
    end;

//15 NUM_ROOM required
    if is_input_field_for('num_room') then begin
      test_field_name := get_field_name('num_room');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultnum_room.Value := 0
      else
        ADOTResultnum_room.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResultnum_room.Value < 0) or (ADOTResultnum_room.Value > 2) then begin
        errorCode := 6;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultnum_room.Value <> room_attributes.number_rooms) then
          saveWarning('num_room', IntToStr(room_attributes.number_rooms));
    end else begin
      ADOTResultnum_room.Value := StrToInt(get_default_value_for('num_room'));
    end;

//16 ETAJ
    if is_input_field_for('etaj') then begin
      test_field_name := get_field_name('etaj');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultetaj.Value := 0
      else
        ADOTResultetaj.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResultetaj.Value < 0) or (ADOTResultetaj.Value > 1) then begin
        errorCode := 7;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultetaj.Value <> ord(room_attributes.is_lift)) then
          saveWarning('etaj', BoolToStr(room_attributes.is_lift));
    end else
      ADOTResultetaj.Value := StrToInt(get_default_value_for('etaj'));

//17 PHONE
    if is_input_field_for('phone') then
      ADOTResultphone.Value := QInputData.FieldByName(get_field_name('phone')).AsString
    else
      ADOTResultphone.Value := get_default_value_for('phone');

//18 DATA_PRIV
    if is_input_field_for('data_priv') then begin
      test_field_name := get_field_name('data_priv');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultdata_priv.Value := StrToDate(get_default_value_for('data_priv'))
      else
        ADOTResultdata_priv.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdata_priv.Value > report_date then begin
        errorCode := 8;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdata_priv.Value <> room_attributes.date_privatization) then
          saveWarning('data_priv', FormatDateTime(format_date,room_attributes.date_privatization));
    end else
      ADOTResultdata_priv.Value := StrToDate(get_default_value_for('data_priv'));

//19 FORM_PROP
    if is_input_field_for('form_prop') then begin
      test_field_name := get_field_name('form_prop');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultform_prop.Value := 0
      else
        ADOTResultform_prop.Value := QInputData.FieldByName(get_field_name('form_prop')).AsInteger;
      if (ADOTResultform_prop.Value < 0) or (ADOTResultform_prop.Value > 5) then begin
        errorCode := 9;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultform_prop.Value <> room_attributes.form_property) then
          saveWarning('form_prop', IntToStr(room_attributes.form_property));
    end else
      ADOTResultform_prop.Value := StrToInt(get_default_value_for('form_prop'));

//20 OB_PL
    if is_input_field_for('ob_pl') then begin
      test_field_name := get_field_name('ob_pl');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultob_pl.Value := StrToFloat(get_default_value_for('ob_pl'))
      else
        ADOTResultob_pl.Value := QInputData.FieldByName(test_field_name).AsFloat;
      if (ADOTResultob_pl.Value < 0.0) then begin
        errorCode := 10;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultob_pl.Value <> room_attributes.total_area) then
          saveWarning('ob_pl', FloatToStr(room_attributes.total_area));
    end else
      ADOTResultob_pl.Value := StrToFloat(get_default_value_for('ob_pl'));

//21 OT_PL
    if is_input_field_for('ot_pl') then begin
      test_field_name := get_field_name('ot_pl');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultot_pl.Value := StrToFloat(get_default_value_for('ot_pl'))
      else
        ADOTResultot_pl.Value := QInputData.FieldByName(test_field_name).AsFloat;
      if (ADOTResultot_pl.Value < 0.0) or
        (ADOTResultot_pl.Value > ADOTResultob_pl.Value) then begin
        errorCode := 11;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultot_pl.Value <> room_attributes.heat_area) then
          saveWarning('ot_pl', FloatToStr(room_attributes.heat_area));
    end else
      ADOTResultot_pl.Value := StrToFloat(get_default_value_for('ot_pl'));

//22 PL_ISP
    if is_input_field_for('pl_isp') then begin
      test_field_name := get_field_name('pl_isp');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultpl_isp.Value := StrToFloat(get_default_value_for('pl_isp'))
      else
        ADOTResultpl_isp.Value := QInputData.FieldByName(test_field_name).AsFloat;
      if (ADOTResultpl_isp.Value < 0.0) or
        (ADOTResultpl_isp.Value > ADOTResultob_pl.Value) then begin
        errorCode := 12;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultpl_isp.Value <> room_attributes.quota_area) then
          saveWarning('pl_isp', FloatToStr(room_attributes.quota_area));
    end else
      ADOTResultpl_isp.Value := StrToFloat(get_default_value_for('pl_isp'));

//23 PRIBOR
    if is_input_field_for('pribor') then begin
      test_field_name := get_field_name('pribor');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultpribor.Value := StrToInt(get_default_value_for('pribor'))
      else
        ADOTResultpribor.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResultpribor.Value < 0) or (ADOTResultpribor.Value > 2) then begin
        errorCode := 13;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultpribor.Value <> room_attributes.counter_state) then
          saveWarning('pribor', IntToStr(room_attributes.counter_state));
    end else
      ADOTResultpribor.Value := StrToInt(get_default_value_for('pribor'));

//24 DATA_PRIBOR
    if is_input_field_for('data_pribor') then begin
      test_field_name := get_field_name('data_pribor');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultdata_pribor.Value := StrToDate(get_default_value_for('data_pribor'))
      else
        ADOTResultdata_pribor.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdata_pribor.Value > report_date then begin
        errorCode := 14;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdata_pribor.Value <> room_attributes.date_calc_device) then
          saveWarning('data_pribor', FormatDateTime(format_date,room_attributes.date_calc_device));
    end else
      ADOTResultdata_pribor.Value := StrToDate(get_default_value_for('data_pribor'));

//25 BOILER
    if is_input_field_for('boiler') then begin
      test_field_name := get_field_name('boiler');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultboiler.Value := StrToInt(get_default_value_for('boiler'))
      else
        ADOTResultboiler.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResultboiler.Value < 0) or (ADOTResultboiler.Value > 2) then begin
        errorCode := 15;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultboiler.Value <> room_attributes.boiler) then
          saveWarning('boiler', IntToStr(room_attributes.boiler));
    end else
      ADOTResultboiler.Value := StrToInt(get_default_value_for('boiler'));

//26 KOLON
    if is_input_field_for('kolon') then begin
      test_field_name := get_field_name('kolon');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultkolon.Value := StrToInt(get_default_value_for('kolon'))
      else
        ADOTResultkolon.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResultkolon.Value < 0) or (ADOTResultkolon.Value > 2) then begin
        errorCode := 16;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultkolon.Value <> room_attributes.water_heater) then
          saveWarning('kolon', IntToStr(room_attributes.water_heater));
    end else
      ADOTResultkolon.Value := StrToInt(get_default_value_for('kolon'));

//27 WATERCHARGE
    if is_input_field_for('watercharge') then begin
      test_field_name := get_field_name('watercharge');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultwatercharge.Value := StrToFloat(get_default_value_for('watercharge'))
      else
        ADOTResultwatercharge.Value := QInputData.FieldByName(test_field_name).AsFloat;
      if not(round(ADOTResultwatercharge.Value) in  consumptionRate) then begin
        errorCode := 17;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and get_tariff_by_bankbook(tariff_params, ADOQDictionary,
        IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultwatercharge.Value <> tariff_params.watercharge) then
          saveWarning('watercharge', FloatToStr(tariff_params.watercharge));
    end else
      ADOTResultwatercharge.Value := StrToFloat(get_default_value_for('watercharge'));

//28 DATE_WC
    if is_input_field_for('date_wc') then begin
      test_field_name := get_field_name('date_wc');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultdate_wc.Value := StrToDate(get_default_value_for('date_wc'))
      else
        ADOTResultdate_wc.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdate_wc.Value > report_date then begin
        errorCode := 18;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and get_tariff_by_bankbook(tariff_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdate_wc.Value <> tariff_params.date_watercharge) then
          saveWarning('date_wc', FormatDateTime(format_date,tariff_params.date_watercharge));
    end else
      ADOTResultdate_wc.Value := StrToDate(get_default_value_for('date_wc'));

//29 TYPE_HEAT
    if is_input_field_for('type_heat') then begin
      test_field_name := get_field_name('type_heat');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResulttype_heat.Value := StrToInt(get_default_value_for('type_heat'))
      else
        ADOTResulttype_heat.Value := QInputData.FieldByName(test_field_name).AsInteger;
      if (ADOTResulttype_heat.Value < 0) or (ADOTResulttype_heat.Value > 4) then begin
        errorCode := 19;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResulttype_heat.Value <> room_attributes.heat_type) then
          saveWarning('type_heat', IntToStr(room_attributes.heat_type));
    end else
      ADOTResulttype_heat.Value := StrToInt(get_default_value_for('type_heat'));

//30 DATE_TH
    if is_input_field_for('date_th') then begin
      test_field_name := get_field_name('date_th');
      if trim(QInputData.FieldByName(test_field_name).AsString)='' then
        ADOTResultdate_th.Value := StrToDate(get_default_value_for('date_th'))
      else
        ADOTResultdate_th.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdate_th.Value > report_date then begin
        errorCode := 20;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_room_options_by_bankbook(room_attributes, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdate_th.Value <> room_attributes.change_heat_date) then
          saveWarning('date_th', FormatDateTime(format_date,room_attributes.change_heat_date));
    end else
      ADOTResultdate_th.Value := StrToDate(get_default_value_for('date_th'));

//31 SUMM_MONTH
    if is_input_field_for('summ_month') then begin
      if QInputData.FieldByName(get_field_name('summ_month')).AsString='' then
        ADOTResultsumm_month.Value := StrToFloat(get_default_value_for('summ_month'))
      else
        ADOTResultsumm_month.Value :=
          QInputData.FieldByName(get_field_name('summ_month')).AsFloat;
//      if (bank_book_id > 0) and
//        get_debt_options_by_bankbook(debt_params, ADOQDictionary,
//        IntToStr(report_date_params.id), bank_book_id) and
//        (ADOTResultsumm_month.Value <> debt_params.month_sum) then
//          saveWarning('summ_month', FloatToStr(debt_params.month_sum));
    end else
      ADOTResultsumm_month.Value := StrToFloat(get_default_value_for('summ_month'));

//32 SUMM_ISP
    if is_input_field_for('summ_isp') then begin
      if QInputData.FieldByName(get_field_name('summ_isp')).AsString='' then
        ADOTResultsumm_isp.Value := StrToFloat(get_default_value_for('summ_isp'))
      else
        ADOTResultsumm_isp.Value :=
          QInputData.FieldByName(get_field_name('summ_isp')).AsFloat;
      if (bank_book_id > 0) and
        get_debt_options_by_bankbook(debt_params, ADOQDictionary,
        IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultsumm_isp.Value <> debt_params.normal_sum) then
          saveWarning('summ_isp', FloatToStr(debt_params.normal_sum));
    end else
      ADOTResultsumm_isp.Value := StrToFloat(get_default_value_for('summ_isp'));

//33 TARIF
    if is_input_field_for('tarif') then begin
      if QInputData.FieldByName(get_field_name('tarif')).AsString='' then
        ADOTResulttarif.Value := StrToFloat(get_default_value_for('tarif'))
      else
        ADOTResulttarif.Value := QInputData.FieldByName(get_field_name('tarif')).AsFloat;
      if (bank_book_id > 0) and
        get_tariff_by_bankbook(tariff_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResulttarif.Value <> tariff_params.tariff) then
          saveWarning('tarif', FloatToStr(tariff_params.tariff));
    end else
      ADOTResulttarif.Value := StrToFloat(get_default_value_for('tarif'));

//34 TARIF_F
    if is_input_field_for('tarif_f') then begin
      if QInputData.FieldByName(get_field_name('tarif_f')).AsString='' then
        ADOTResulttarif_f.Value := StrToFloat(get_default_value_for('tarif_f'))
      else
        ADOTResulttarif_f.Value := QInputData.FieldByName(get_field_name('tarif_f')).AsFloat;
      if (bank_book_id > 0) and
        get_tariff_by_bankbook(tariff_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResulttarif_f.Value <> tariff_params.tariff) then
          saveWarning('tarif_f', FloatToStr(tariff_params.tariff_real));
    end else
      ADOTResulttarif_f.Value := StrToFloat(get_default_value_for('tarif_f'));

//35 MONTH_COUNT
    if is_input_field_for('month_count') and
      (QInputData.FieldByName(get_field_name('month_count')).AsString<>'') then
      ADOTResultmonth_count.Value := QInputData.FieldByName(get_field_name('month_count')).AsInteger
    else
      ADOTResultmonth_count.Value := StrToInt(get_default_value_for('month_count'));

//36 END_COUNT
    if is_input_field_for('end_count') and
      (QInputData.FieldByName(get_field_name('end_count')).AsString<>'') then
      ADOTResultend_count.Value := QInputData.FieldByName(get_field_name('end_count')).AsInteger
    else
      ADOTResultend_count.Value := StrToInt(get_default_value_for('end_count'));

//37 SUMM_DOLG
    if is_input_field_for('summ_dolg') and
      (QInputData.FieldByName(get_field_name('summ_dolg')).AsString<>'') then
      ADOTResultsumm_dolg.Value := QInputData.FieldByName(get_field_name('summ_dolg')).AsFloat
    else
      ADOTResultsumm_dolg.Value := StrToFloat(get_default_value_for('summ_dolg'));

//38 KOL_ZAR
    if is_input_field_for('kol_zar') then begin
      if QInputData.FieldByName(get_field_name('kol_zar')).AsString='' then
        ADOTResultkol_zar.Value := StrToInt(get_default_value_for('kol_zar'))
      else
        ADOTResultkol_zar.Value := QInputData.FieldByName(get_field_name('kol_zar')).AsInteger;
      if (bank_book_id > 0) and
        get_payer_options_by_bankbook(payer_params, ADOQDictionary,
        IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultkol_zar.Value <> payer_params.resident_number) then
          saveWarning('kol_zar', IntToStr(payer_params.resident_number));
    end else
      ADOTResultkol_zar.Value := StrToInt(get_default_value_for('kol_zar'));

//39 SUMM_01122006
    if is_input_field_for('summ_01122006') then begin
      if QInputData.FieldByName(get_field_name('summ_01122006')).AsString='' then
        ADOTResultsumm_01122006.Value := StrToFloat(get_default_value_for('summ_01122006'))
      else
        ADOTResultsumm_01122006.Value := QInputData.FieldByName(get_field_name('summ_01122006')).AsFloat;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultsumm_01122006.Value <> privilege_params.sum_01122006) then
          saveWarning('summ_01122006', FloatToStr(privilege_params.sum_01122006));
    end else
      ADOTResultsumm_01122006.Value := StrToFloat(get_default_value_for('summ_01122006'));

//40 DATE_DOG
    if is_input_field_for('date_dog') then begin
      test_field_name := get_field_name('date_dog');
      if QInputData.FieldByName(test_field_name).AsString='' then
        ADOTResultdate_dog.Value := StrToDate(get_default_value_for('date_dog'))
      else
        ADOTResultdate_dog.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdate_dog.Value > report_date then begin
        errorCode := 21;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdate_dog.Value <> privilege_params.pact_date) then
          saveWarning('date_dog', FormatDateTime(format_date,privilege_params.pact_date));
    end else
      ADOTResultdate_dog.Value := StrToDate(get_default_value_for('date_dog'));

//41 NUM_DOG
    if is_input_field_for('num_dog') then begin
      ADOTResultnum_dog.Value := QInputData.FieldByName(get_field_name('num_dog')).AsString;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultnum_dog.Value <> privilege_params.pact_number) then
          saveWarning('num_dog', privilege_params.pact_number);
    end else
      ADOTResultnum_dog.Value := get_default_value_for('num_dog');

//42 SUMM_DOLG_DOG
    if is_input_field_for('sum_dolg_dog') then begin
      if QInputData.FieldByName(get_field_name('sum_dolg_dog')).AsString='' then
        ADOTResultsum_dolg_dog.Value := StrToFloat(get_default_value_for('sum_dolg_dog'))
      else
        ADOTResultsum_dolg_dog.Value := QInputData.FieldByName(get_field_name('sum_dolg_dog')).AsFloat;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultsum_dolg_dog.Value <> privilege_params.debt_sum_restruct) then
          saveWarning('sum_dolg_dog', FloatToStr(privilege_params.debt_sum_restruct));
    end else
      ADOTResultsum_dolg_dog.Value := StrToFloat(get_default_value_for('sum_dolg_dog'));

//43 SUBS
    if is_input_field_for('subs') then begin
      if QInputData.FieldByName(get_field_name('subs')).AsString='' then
        ADOTResultsubs.Value := StrToFloat(get_default_value_for('subs'))
      else
        ADOTResultsubs.Value := QInputData.FieldByName(get_field_name('subs')).AsFloat;
//      if (bank_book_id > 0) and
//        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
//          IntToStr(report_date_params.id), bank_book_id) and
//        (ADOTResultsubs.Value <> privilege_params.subsidy) then
//          saveWarning('subs', FloatToStr(privilege_params.subsidy));
    end else
      ADOTResultsubs.Value := StrToFloat(get_default_value_for('subs'));

//44 DATE_SUBS
    if is_input_field_for('date_subs') then begin
      if QInputData.FieldByName(get_field_name('date_subs')).AsString='' then
        ADOTResultdate_subs.Value := StrToDate(get_default_value_for('date_subs'))
      else
        ADOTResultdate_subs.Value := QInputData.FieldByName(get_field_name('date_subs')).AsDateTime;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdate_subs.Value <> privilege_params.subsidy_date) then
          saveWarning('date_subs', FormatDateTime(format_date,privilege_params.subsidy_date));
    end else
      ADOTResultdate_subs.Value := StrToDate(get_default_value_for('date_subs'));

//45 CODE_LG1
    if is_input_field_for('code_lg1') then begin
      if QInputData.FieldByName(get_field_name('code_lg1')).AsString='' then
        ADOTResultcode_lg1.Value := StrToInt(get_default_value_for('code_lg1'))
      else
        ADOTResultcode_lg1.Value := QInputData.FieldByName(get_field_name('code_lg1')).AsInteger;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultcode_lg1.Value <> privilege_params.privilege1_code) then
          saveWarning('code_lg1', IntToStr(privilege_params.privilege1_code));
    end else
      ADOTResultcode_lg1.Value := StrToInt(get_default_value_for('code_lg1'));

//46 COUNT_HN_LG1
    if is_input_field_for('count_tn_lg1') then begin
      if QInputData.FieldByName(get_field_name('count_tn_lg1')).AsString='' then
        ADOTResultcount_tn_lg1.Value := StrToInt(get_default_value_for('count_tn_lg1'))
      else
        ADOTResultcount_tn_lg1.Value := QInputData.FieldByName(get_field_name('count_tn_lg1')).AsInteger;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultcount_tn_lg1.Value <> privilege_params.privilege1_users) then
          saveWarning('count_tn_lg1', IntToStr(privilege_params.privilege1_users));
    end else
      ADOTResultcount_tn_lg1.Value := StrToInt(get_default_value_for('count_tn_lg1'));

//47 KAT_LG1
    if is_input_field_for('kat_lg1') then begin
      if QInputData.FieldByName(get_field_name('kat_lg1')).AsString='' then
        ADOTResultkat_lg1.Value := StrToInt(get_default_value_for('kat_lg1'))
      else
        ADOTResultkat_lg1.Value := QInputData.FieldByName(get_field_name('kat_lg1')).AsInteger;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultkat_lg1.Value <> privilege_params.privilege1_category) then
          saveWarning('kat_lg1', IntToStr(privilege_params.privilege1_category));
    end else
      ADOTResultkat_lg1.Value := StrToInt(get_default_value_for('kat_lg1'));

//48 DATE_LG1
    if is_input_field_for('date_lg1') then begin
      test_field_name := get_field_name('date_lg1');
      if QInputData.FieldByName(test_field_name).AsString='' then
        ADOTResultdate_lg1.Value := StrToDate(get_default_value_for('date_lg1'))
      else
        ADOTResultdate_lg1.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdate_lg1.Value > report_date then begin
        errorCode := 22;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdate_lg1.Value <> privilege_params.privilege1_date) then
          saveWarning('date_lg1', FormatDateTime(format_date,privilege_params.privilege1_date));
    end else
      ADOTResultdate_lg1.Value := StrToDate(get_default_value_for('date_lg1'));

//49 DOC_LG_VID1
    if is_input_field_for('doc_lg_vid1') then begin
      ADOTResultdoc_lg_vid1.Value := QInputData.FieldByName(get_field_name('doc_lg_vid1')).AsString;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdoc_lg_vid1.Value <> privilege_params.privilege1_doc) then
          saveWarning('doc_lg_vid1', privilege_params.privilege1_doc);
    end else
      ADOTResultdoc_lg_vid1.Value := get_default_value_for('doc_lg_vid1');

//50 DOC_LG_NUM1
    if is_input_field_for('doc_lg_num1') then begin
      ADOTResultdoc_lg_num1.Value := QInputData.FieldByName(get_field_name('doc_lg_num1')).AsString;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdoc_lg_num1.Value <> privilege_params.privilege1_doc_number) then
          saveWarning('doc_lg_num1', privilege_params.privilege1_doc_number);
    end else
      ADOTResultdoc_lg_num1.Value := get_default_value_for('doc_lg_num1');

//51 DOC_LG_V1
    if is_input_field_for('doc_lg_v1') then begin
      ADOTResultdoc_lg_v1.Value := QInputData.FieldByName(get_field_name('doc_lg_v1')).AsString;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdoc_lg_v1.Value <> privilege_params.privilege1_doc_who) then
          saveWarning('doc_lg_v1', privilege_params.privilege1_doc_who);
    end else
      ADOTResultdoc_lg_v1.Value := get_default_value_for('doc_lg_v1');

//52 DOC_LG_D1
    if is_input_field_for('doc_lg_d1') then begin
      test_field_name := get_field_name('doc_lg_d1');
      if QInputData.FieldByName(test_field_name).AsString='' then
        ADOTResultdoc_lg_d1.Value := StrToDate(get_default_value_for('doc_lg_d1'))
      else
        ADOTResultdoc_lg_d1.Value := QInputData.FieldByName(test_field_name).AsDateTime;
      if ADOTResultdoc_lg_d1.Value > report_date then begin
        errorCode := 23;
        saveError(test_field_name, QInputData.FieldByName(test_field_name).AsString);
        QInputData.Next;
        Continue;
      end;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultdoc_lg_d1.Value <> privilege_params.privilege1_doc_date) then
          saveWarning('doc_lg_d1', FormatDateTime(format_date,privilege_params.privilege1_doc_date));
    end else
      ADOTResultdoc_lg_d1.Value := StrToDate(get_default_value_for('doc_lg_d1'));

//53 RATE_LG1
    if is_input_field_for('rate_lg1') then begin
      if QInputData.FieldByName(get_field_name('rate_lg1')).AsString='' then
        ADOTResultrate_lg1.Value := StrToFloat(get_default_value_for('rate_lg1'))
      else
        ADOTResultrate_lg1.Value := QInputData.FieldByName(get_field_name('rate_lg1')).AsFloat;
      if (bank_book_id > 0) and
        get_privilege_options_by_bankbook(privilege_params, ADOQDictionary,
          IntToStr(report_date_params.id), bank_book_id) and
        (ADOTResultrate_lg1.Value <> privilege_params.privilege1_percent) then
          saveWarning('rate_lg1', FloatToStr(privilege_params.privilege1_percent));
    end else
      ADOTResultrate_lg1.Value := StrToFloat(get_default_value_for('rate_lg1'));

    if isWarning then inc(totalWarnings);
    if errorCode = 0 then begin
      try
        inc(added_records);
        ADOTResultrecord_number.Value := i+1; //added_records;
        ADOTResult.Append;
//        main_ids.AddObject(IntToStr(i+1), main_id);
//        main_ids.AddObject(IntToStr(added_records), main_id);
        main_ids.AddObject(IntToStr(main_id.number_record), main_id);
      except
        ShowMessage('Ошибка при сохранении записи');
      end;
    end;
(*
*)
// only debug !!!!!
//    this_record := DateTimeToTimeStamp(start_time-now).Time;
//    total_msec := total_msec+ this_record;
//    avr_msec := total_msec div (i+1);
//    protocol.Lines.Add(IntToStr(i+1)+'; this='+IntToStr(this_record)+'; avr='+IntToStr(avr_msec)+'; total='+IntToStr(total_msec));
    QInputData.Next;
  end;
//  QInputData.Close;
  protocol.Lines.Add(TimeToStr(now)+'; Закончен перебор записей; Всего '+IntToStr(totalRecords)+
    '; Корректных '+IntToStr(added_records)+
    '; Ошибочных '+IntToStr(number_wrong_records)+
    '; С предупреждениями '+IntToStr(totalWarnings));
  protocol.Lines.Add(' - не найден лицевой счет: '+IntToStr(bb_absent));
  protocol.Lines.Add(' - не найден адрес: '+IntToStr(address_absent));
  protocol.Lines.Add(' - ФИО отсутствует или нет совпадения: '+IntToStr(full_name_diff));


  AssignFile(Vf, ChangeFileExt(ODInputData.FileName, '.dbf'));
  Rename(Vf, ODInputData.FileName);
  SaveResult;
  BLoad.Enabled := true;
  BCheckAbsentees.Enabled := true;
end;

procedure TFormControl.BLoadClick(Sender: TObject);
var
  i: integer;
  q: TADOQuery;
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  with ADOQuery1 do begin
    SQL.Clear;
    sql.Add('delete from bankbook_attributes_debts where id_period='+
      IntToStr(report_date_params.id)+
      ' AND id_bankbook in (SELECT id FROM bankbooks AS b '+
      'JOIN utilityfiles_bo AS i ON i.abcount = b.bank_book '+
      'WHERE code_firm='+Inttostr(current_firm_code)+
      ' and i.id_file='+IntToStr(reg_record_id)+')');

    ExecSQL;
    Close;
    SQL.Clear;
    sql.Add('SELECT * FROM utilityfiles_bo WHERE id_file = '+IntToStr(reg_record_id));
    open;
    first;
    for_loading := RecordCount;
    loaded := 0;
    for I := 0 to RecordCount - 1 do begin
      Application.ProcessMessages;
      try
        PBprocess.Position := PBprocess.Max * (i+1) div for_loading;
      Except
        exit;
      end;
//заполянем bankbook_attributes_debts
      with TAddresIdBankbookId(main_ids.Objects[i]) do begin
        if bb_id < 1 then
          get_bank_book_id(bb_id,
            ADOStoredProc1, current_firm_code,
            FieldByName('code_plat').AsInteger,
            FieldByName('abcount').AsString);
        if addr_id < 1 then
          addr_id :=
            get_address_id_by_bank_book_id(ADOQDictionary, bank_book_id);
        if (bb_id < 1) or (addr_id < 1) then begin
          next;
          Continue;
        end;
        ADOQDictionary.SQL.Clear;
        ADOQDictionary.sql.Add('insert into bankbook_attributes_debts VALUES ('+
          IntToStr(bb_id)+', '+
          IntToStr(report_date_params.id)+', '''+
          FormatDateTime(format_date,FieldByName('date_d').AsDateTime)+''', '+
          FieldByName('summ_isp').AsString+', '+
          FieldByName('summ_dolg').AsString+', '+
          FieldByName('summ_month').AsString+', '+
          FieldByName('month_count').AsString+', '+
          FieldByName('end_count').AsString+', '+
          IntToStr(addr_id)+
          ')'
        );
//заполянем bankbook_attributes_humans
        q.SQL.Clear;
        q.sql.Add('select * from bankbook_attributes_humans where '+
          'id_bankbook='+IntToStr(bb_id)
        );
        q.Open;
        if q.RecordCount = 0 then
          ADOQDictionary.sql.Add('insert into bankbook_attributes_humans VALUES('+
            IntToStr(bb_id)+', '+
            IntToStr(report_date_params.id)+', '+
            IntToStr(report_date_params.id)+', '''+
            FieldByName('fio').AsString+''', '''+
            FieldByName('fio_vlad').AsString+''', '''+
            FieldByName('phone').AsString+''', '+
            FieldByName('kol_zar').AsString+')')
        else if (FieldByName('fio').AsString <> q.FieldByName('full_name').AsString) or
            (FieldByName('fio_vlad').AsString <> q.FieldByName('full_name_owner').AsString) or
            (FieldByName('phone').AsString <> q.FieldByName('phone').AsString) or
            (FieldByName('kol_zar').AsString <> q.FieldByName('resident_number').AsString)
          then
            ADOQDictionary.sql.Add('update bankbook_attributes_humans set '+
              ' id_period= '+IntToStr(report_date_params.id)+', '+
              ' id_period_begin='+IntToStr(report_date_params.id)+', '+
              ' full_name='''+FieldByName('fio').AsString+''', '+
              ' full_name_owner='''+FieldByName('fio_vlad').AsString+''', '+
              ' phone='''+FieldByName('phone').AsString+''', '+
              ' resident_number='+FieldByName('kol_zar').AsString+
              ' where id_bankbook='+
              IntToStr(bb_id)
            )
          else
            ADOQDictionary.sql.Add('update bankbook_attributes_humans'+
              ' set id_period= '+IntToStr(report_date_params.id)+
              ' where id_bankbook='+
              IntToStr(bb_id)
            );
        q.Close;

  //заполянем bankbook_attributes_lgots
        q.SQL.Clear;
        q.sql.Add('select * from bankbook_attributes_lgots where '+
          'id_bankbook='+IntToStr(bb_id)
        );
        q.Open;
        if q.RecordCount = 0 then //загружаем которых нет
          ADOQDictionary.sql.Add('insert into bankbook_attributes_lgots values('+
            IntToStr(bb_id)+', '+
            IntToStr(report_date_params.id)+', '+
            IntToStr(report_date_params.id)+', '+
            FieldByName('summ_01122006').AsString+', '''+
            FieldByName('date_dog').AsString+''', '''+
            FieldByName('num_dog').AsString+''', '+
            FieldByName('sum_dolg_dog').AsString+', '+
            FieldByName('subs').AsString+', '''+
            FieldByName('date_subs').AsString+''', '+
            FieldByName('code_lg1').AsString+', '+
            FieldByName('count_tn_lg1').AsString+', '+
            FieldByName('kat_lg1').AsString+', '''+
            FieldByName('date_lg1').AsString+''', '''+
            FieldByName('doc_lg_vid1').AsString+''', '''+
            FieldByName('doc_lg_num1').AsString+''', '''+
            FieldByName('doc_lg_v1').AsString+''', '''+
            FieldByName('doc_lg_d1').AsString+''', '+
            FieldByName('rate_lg1').AsString+')')
        else if (FieldByName('summ_01122006').AsString <> q.FieldByName('sum_01122006').AsString) or
            (FieldByName('date_dog').AsString <> q.FieldByName('date_dog').AsString) or
            (FieldByName('num_dog').AsString <> q.FieldByName('num_dog').AsString) or
            (FieldByName('sum_dolg_dog').AsString <> q.FieldByName('sum_dolg_dog').AsString) or
            (FieldByName('subs').AsString <> q.FieldByName('subs').AsString) or
            (FieldByName('date_subs').AsString <> q.FieldByName('date_subs').AsString) or
            (FieldByName('code_lg1').AsString <> q.FieldByName('code_lg1').AsString) or
            (FieldByName('count_tn_lg1').AsString <> q.FieldByName('count_tn_lg1').AsString) or
            (FieldByName('kat_lg1').AsString <> q.FieldByName('kat_lg1').AsString) or
            (FieldByName('date_lg1').AsString <> q.FieldByName('date_lg1').AsString) or
            (FieldByName('doc_lg_vid1').AsString <> q.FieldByName('doc_lg_vid1').AsString) or
            (FieldByName('doc_lg_num1').AsString <> q.FieldByName('doc_lg_num1').AsString) or
            (FieldByName('doc_lg_v1').AsString <> q.FieldByName('doc_lg_v1').AsString) or
            (FieldByName('doc_lg_d1').AsString <> q.FieldByName('doc_lg_d1').AsString) or
            (FieldByName('rate_lg1').AsString <> q.FieldByName('rate_lg1').AsString)
          then
            ADOQDictionary.sql.Add('update bankbook_attributes_lgots set '+
              ' id_period= '+IntToStr(report_date_params.id)+', '+
              ' id_period_begin='+IntToStr(report_date_params.id)+', '+
              ' sum_01122006='+FieldByName('summ_01122006').AsString+', '+
              ' date_dog='''+
              FormatDateTime(format_date,FieldByName('date_dog').AsDateTime)+''', '+
              ' num_dog='''+FieldByName('num_dog').AsString+''', '+
              ' sum_dolg_dog='+FieldByName('sum_dolg_dog').AsString+', '+
              ' subs='+FieldByName('subs').AsString+', '+
              ' date_subs='''+
              FormatDateTime(format_date,FieldByName('date_subs').AsDateTime)+''', '+
              ' code_lg1='+FieldByName('code_lg1').AsString+', '+
              ' count_tn_lg1='+FieldByName('count_tn_lg1').AsString+', '+
              ' kat_lg1='+FieldByName('kat_lg1').AsString+', '+
              ' date_lg1='''+
              FormatDateTime(format_date,FieldByName('date_lg1').AsDateTime)+''', '+
              ' doc_lg_vid1='''+FieldByName('doc_lg_vid1').AsString+''', '+
              ' doc_lg_num1='''+FieldByName('doc_lg_num1').AsString+''', '+
              ' doc_lg_v1='''+FieldByName('doc_lg_v1').AsString+''', '+
              ' doc_lg_d1='''+
              FormatDateTime(format_date,FieldByName('doc_lg_d1').AsDateTime)+''', '+
              ' rate_lg1='+FieldByName('rate_lg1').AsString+
              ' where id_bankbook='+
              IntToStr(bb_id)
            )
          else
            ADOQDictionary.sql.Add('update bankbook_attributes_lgots '+
              'set id_period='+IntToStr(report_date_params.id)+
              ' where id_bankbook='+
              IntToStr(bb_id)
            );
        q.Close;

  //заполянем bankbook_attributes_rooms
        q.SQL.Clear;
        q.sql.Add('select * from bankbook_attributes_rooms where '+
          'id_bankbook='+IntToStr(bb_id)
        );
        q.Open;
        if q.RecordCount = 0 then //загружаем которых нет
          ADOQDictionary.sql.Add('insert into bankbook_attributes_rooms values('+
            IntToStr(bb_id)+', '+
            IntToStr(report_date_params.id)+', '+
            IntToStr(report_date_params.id)+', '+
            FieldByName('num_room').AsString+', '+
            FieldByName('etaj').AsString+', '''+
            FieldByName('data_priv').AsString+''', '+
            FieldByName('form_prop').AsString+', '+
            FieldByName('ob_pl').AsString+', '+
            FieldByName('ot_pl').AsString+', '+
            FieldByName('pl_isp').AsString+', '+
            FieldByName('pribor').AsString+', '''+
            FieldByName('data_pribor').AsString+''', '+
            FieldByName('boiler').AsString+', '+
            FieldByName('kolon').AsString+', '+
            FieldByName('type_heat').AsString+', '''+
            FieldByName('date_th').AsString+''')')
        else if (FieldByName('num_room').AsString <> q.FieldByName('one_roomed_flat').AsString) or
            (FieldByName('etaj').AsString <> q.FieldByName('lift').AsString) or
            (FieldByName('data_priv').AsString <> q.FieldByName('date_privatization').AsString) or
            (FieldByName('form_prop').AsString <> q.FieldByName('form_property').AsString) or
            (FieldByName('ob_pl').AsString <> q.FieldByName('total_area').AsString) or
            (FieldByName('ot_pl').AsString <> q.FieldByName('heat_area').AsString) or
            (FieldByName('pl_isp').AsString <> q.FieldByName('quota_area').AsString) or
            (FieldByName('pribor').AsString <> q.FieldByName('calc_device').AsString) or
            (FieldByName('data_pribor').AsString <> q.FieldByName('date_calc_device').AsString) or
            (FieldByName('boiler').AsString <> q.FieldByName('boiler').AsString) or
            (FieldByName('kolon').AsString <> q.FieldByName('water_heater').AsString) or
            (FieldByName('type_heat').AsString <> q.FieldByName('type_heating').AsString) or
            (FieldByName('date_th').AsString <> q.FieldByName('date_heating').AsString)
          then
            ADOQDictionary.sql.Add('update bankbook_attributes_rooms set'+
              ' id_period= '+IntToStr(report_date_params.id)+', '+
              ' id_period_begin='+IntToStr(report_date_params.id)+', '+
              ' one_roomed_flat='+FieldByName('num_room').AsString+', '+
              ' lift='+FieldByName('etaj').AsString+', '+
              ' date_privatization='''+
              FormatDateTime(format_date,FieldByName('data_priv').AsDateTime)+''', '+
              ' form_property='+FieldByName('form_prop').AsString+', '+
              ' total_area='+FieldByName('ob_pl').AsString+', '+
              ' heat_area='+FieldByName('ot_pl').AsString+', '+
              ' quota_area='+FieldByName('pl_isp').AsString+', '+
              ' calc_device='+FieldByName('pribor').AsString+', '+
              ' date_calc_device='''+
              FormatDateTime(format_date,FieldByName('data_pribor').AsDateTime)+''', '+
              ' boiler='+FieldByName('boiler').AsString+', '+
              ' water_heater='+FieldByName('kolon').AsString+', '+
              ' type_heating='+FieldByName('type_heat').AsString+', '+
              ' date_heating='''+
              FormatDateTime(format_date,FieldByName('date_th').AsDateTime)+''''+
              ' where id_bankbook='+
              IntToStr(bb_id)
            )
          else
            ADOQDictionary.sql.Add('update bankbook_attributes_rooms '+
              'set id_period ='+IntToStr(report_date_params.id)+
              ' where id_bankbook='+
              IntToStr(bb_id)
            );
        q.Close;

  //заполянем bankbook_attributes_tarifs
        q.SQL.Clear;
        q.sql.Add('select * from bankbook_attributes_tarifs where '+
          'id_bankbook='+IntToStr(bb_id)
        );
        q.Open;
        if q.RecordCount = 0 then //загружаем которых нет
          ADOQDictionary.sql.Add('insert into bankbook_attributes_tarifs values('+
            IntToStr(bb_id)+', '+
            IntToStr(report_date_params.id)+', '+
            IntToStr(report_date_params.id)+', '+
            FieldByName('watercharge').AsString+', '''+
            FieldByName('date_wc').AsString+''', '+
            FieldByName('tarif').AsString+', '+
            FieldByName('tarif_f').AsString+')')
        else if (FieldByName('watercharge').AsString <> q.FieldByName('watercharge').AsString) or
            (FieldByName('date_wc').AsString <> q.FieldByName('date_wc').AsString) or
            (FieldByName('tarif').AsString <> q.FieldByName('tarif').AsString) or
            (FieldByName('tarif_f').AsString <> q.FieldByName('tarif_f').AsString)
          then
            ADOQDictionary.sql.Add('update bankbook_attributes_tarifs set'+
              ' id_period= '+IntToStr(report_date_params.id)+', '+
              ' id_period_begin='+IntToStr(report_date_params.id)+', '+
              ' watercharge='+FieldByName('watercharge').AsString+', '+
              ' date_wc='''+
              FormatDateTime(format_date,FieldByName('date_wc').AsDateTime)+''', '+
              ' tarif='+FieldByName('tarif').AsString+', '+
              ' tarif_f='+FieldByName('tarif_f').AsString+
              ' where id_bankbook='+IntToStr(bb_id)
            )
          else
            ADOQDictionary.sql.Add('update bankbook_attributes_tarifs '+
              'set id_period ='+IntToStr(report_date_params.id)+
              ' where id_bankbook='+IntToStr(bb_id)
            );

      end;
      q.Close;

      try
        ADOQDictionary.ExecSQL;
        inc(loaded);
        ADOQDictionary.Close;
      Except
        ShowMessage('Запрос="'+ADOQDictionary.sql.Text+'"');
      end;

      next;
      LTotalRecords.Caption := 'Всего записей: '+intToStr(RecordCount)+'/'+
        Inttostr(recno);
    end;
    ShowMessage('Количество загруженных записей = '+Inttostr(loaded));
    Close;
  end;
  q.free;
  update_buffer_state;
end;

procedure TFormControl.BWarningSaveClick(Sender: TObject);
begin
  LBWarnings.Items.SaveToFile(ChangeFileExt(ODInputData.FileName, '.txt'));
end;

procedure TFormControl.FormCreate(Sender: TObject);
var
  i: integer;
begin
  warning_records := TStringList.Create;
  main_ids := TStringList.Create;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Client.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=S-050-ERC; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER_TEST');
  Settings.Free;
  ADOQuery1.ConnectionString := connection_string;
  ADOQDictionary.ConnectionString := connection_string;
  ADOStoredProc1.ConnectionString := connection_string;
  ADODSWork.ConnectionString := connection_string;
  ADOTResult.ConnectionString := connection_string;
  QInputData := TADOQuery.Create(self);
  QInputData.ConnectionString := connection_string;
  totalRecords := 0;
  numberRecord := 0;
  errorCode := 0;
  report_date := now;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM cities ORDER BY name');
    Open;
    if RecordCount > 0 then begin
      First;
      for I := 0 to RecordCount - 1 do begin
        CBCities.Items.Add(FieldByName('name').AsString);
        id_cities[i] := FieldByName('id').AsInteger;
        Next;
      end;
    end;
    Close;

    SQL.Clear;
    SQL.Add('SELECT * FROM errors WHERE error_type=1 AND id_software = 2 ORDER BY code');
    Open;
    if RecordCount > 0 then begin
      First;
      for I := 0 to RecordCount - 1 do begin
        errors[FieldByName('code').AsInteger] := FieldByName('description').AsString;
        Next;
      end;
    end;
    Close;
  end;
  update_buffer_state;

  CBCities.ItemIndex := 0;
  current_city_id := id_cities[0];
  report_date_params := TReportDateOptions.Create;
  report_date_params.id := -1;
end;

procedure TFormControl.LBWarningsDblClick(Sender: TObject);
begin
//  TAddresIdBankbookId(main_ids.Objects[FieldByName('record_number').AsInteger-1]
//  main_ids. Objects[FieldByName('record_number').AsInteger-1]
  selected_record_num := TWarningInfo(LBWarnings.Items.Objects[LBWarnings.ItemIndex]).number_record;
//    main_ids.IndexOf(IntToStr(TWarningInfo(LBWarnings.Items.Objects[LBWarnings.ItemIndex]).number_record));
//  selected_record_num :=
//    TWarningInfo(LBWarnings.Items.Objects[LBWarnings.ItemIndex]).number_record;
  FormPreview.ShowModal;
end;

procedure TFormControl.CBCitiesChange(Sender: TObject);
begin
  report_date_params.id := -1;
  current_city_id := id_cities[CBCities.ItemIndex];
  if not get_report_date_params(report_date_params,ADOStoredProc1,ADODSWork,
    current_city_id, report_date) then
    ShowMessage('По городу '+CBCities.Items[CBCities.ItemIndex]+' в базе не найден отчетный период');
  BInputOpen.Enabled := report_date_params.id <> -1;
end;

procedure TFormControl.ChBFullNameWarnClick(Sender: TObject);
var
  i: integer;
begin
  LBWarnings.Clear;
  if ChBFullNameWarn.Checked then
    LBWarnings.Items := warning_records
  else
    for I := 0 to warning_records.Count - 1 do
      if TWarningInfo(warning_records.Objects[i]).field_name <> 'fio' then
        LBWarnings.Items.AddObject(warning_records.Strings[i], warning_records.Objects[i]);

end;

procedure TFormControl.DTPReportDateChange(Sender: TObject);
begin
  report_date_params.id := -1;
  report_date := DTPReportDate.Date;
  get_report_date_params(report_date_params,ADOStoredProc1,ADODSWork,
    current_city_id, report_date);
  BInputOpen.Enabled := report_date_params.id <> -1;
end;

procedure TFormControl.SaveResult;
var
  f: TextFile;
  title_string, file_name: string;
  status_as_str: string;
  D: TDateTime;
  Hour, Min, Sec, MSec,
  Year, Month, Day: Word;
  i, y, number: integer;
function get_two_char(value: word): string;
begin
  result := IntToStr(value);
  if value < 10 then result := '0'+IntToStr(value);
end;

begin
  D:= Now;
  DecodeDate(D, Year, Month, Day);
  y := Year mod 100;
  DecodeTime(D, Hour, Min, Sec, MSec);
  number := 1;
  file_name := 'po'+copy(inputFileName, 3, 4)+get_two_char(Day)+'.'+
    get_two_char(Month)+IntToStr(number);

  if return_code = 0 then
    if number_wrong_records = 0 then begin
      return_code := 0; // errors are absent
      status_as_str := '2';
    end else begin
      return_code := 50;  // errors exists
      status_as_str := '3';
    end else
      status_as_str := '3';
  title_string := inputFileName+get_two_char(Day)+'.'+get_two_char(Month)+
    '.'+get_two_char(y)+get_two_char(Hour)+':'+get_two_char(Min)+
    Format('%5d%2d',[totalRecords, return_code]);

  AssignFile(f, ExtractFilePath(Application.ExeName)+file_name);
  Rewrite(f);
  Writeln(f, title_string);
  for I := 0 to number_wrong_records - 1 do
    Writeln(f, Format('%4d%3d',[wrong_records[i].number_record, wrong_records[i].error_code]));
  CloseFile(f);

  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('INSERT INTO file_registrations '+
      '(file_name, file_size, file_date, date_reg, id_type, id_status) VALUES '+
      '('''+file_name+''', '+
      IntToStr(get_file_size(ExtractFilePath(Application.ExeName)+
      file_name))+', '''+FormatDateTime(format_date,now)+''', '''+
      FormatDateTime(format_date,now)+''', 7, 0)');
    ExecSQL;
    Close;

    SQL.Clear;
    SQL.Add('UPDATE file_registrations SET id_status = '+status_as_str+
      ' WHERE id ='+IntToStr(reg_record_id));
    ExecSQL;
    Close;

    if return_code <> 0 then
{$IFDEF DEBUG}
      SQL.Clear;
      SQL.Add('DELETE FROM file_errors WHERE id_file='+IntToStr(reg_record_id));
      ExecSQL;
{$ENDIF}
      for I := 0 to number_wrong_records - 1 do begin
        SQL.Clear;
        SQL.Add('INSERT INTO file_errors '+
        'VALUES ('+IntToStr(reg_record_id)+', '+
        IntToStr(wrong_records[i].number_record)+
        ', '+IntToStr(wrong_records[i].error_code)+')');
        ExecSQL;
      end;
    Close;
  end;

  protocol.Lines.Add(TimeToStr(now)+'; Код возврата '+ IntToStr(return_code));
  update_buffer_state;
  ShowMessage('Обработан файл '+input_file_stats.name+chr(10)+chr(13)+
    'Всего записей '+IntToStr(totalRecords)+';'+chr(10)+chr(13)+
    'Корректных '+IntToStr(added_records)+';'+chr(10)+chr(13)+
    'Ошибочных '+IntToStr(number_wrong_records)+';'+chr(10)+chr(13)+
    'С предупреждениями '+IntToStr(totalWarnings)+';');
end;

procedure TFormControl.BCheckAbsenteesClick(Sender: TObject);
begin
  FormAbsentees.ShowModal;
end;

procedure TFormControl.BExitClick(Sender: TObject);
begin
  if Application.MessageBox('Завершить работу?',
                            PChar(FormControl.caption),
                            MB_OKCANCEL+MB_ICONQUESTION) = IDOK then begin
    totalRecords := 0; // hack!!!
    for_loading := 0;
    Close;
  end;
end;

procedure TFormControl.get_buffer_state;
//var
//  file_id: string;
begin
  with ADOQDictionary do begin
    SQL.Clear;
    sql.add('select * from utilityfiles_bo');
//      'truncate table [dbo].[utilityfiles_bo] ');
    open;
    first;
    buffer_size := RecordCount;
    reg_record_id := FieldByName('id_file').AsInteger;
    SQL.Clear;
    SQL.Add('SELECT * FROM file_registrations WHERE id='+IntToStr(reg_record_id));
    Open;
    buffered_file_name := FieldByName('file_name').AsString;
    buffered_data_state := FieldByName('id_status').AsInteger;
    Close;
  end;
end;

procedure TFormControl.update_buffer_state;
begin
  get_buffer_state;
  BLoad.Enabled := false;
  if buffer_size > 0 then begin
    LStatusFile.Caption := 'В буфере '+IntToStr(buffer_size)+' записей файла '+
      buffered_file_name+' и статус '+IntToStr(buffered_data_state);
    BLoad.Enabled := true;
  end else
    LStatusFile.Caption := 'Буфер пуст';
end;
end.

