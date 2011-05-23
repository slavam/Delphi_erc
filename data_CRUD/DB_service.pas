unit DB_service;

interface
uses ADODB, DB,
  StrUtils,
  Classes,
  SysUtils;

type
  TRoomParams = class(TObject)
    id: integer;
    id_home: integer;
    n_room: integer;
    a_room: string;
  end;

type
  THomeParams = class(TObject)
    id: integer;
    id_street: integer;
    n_home: integer;
    f_home: integer;
    a_home: string;
    d_home: integer;
  end;

type
  TStreetParams = class(TObject)
    id: integer;
    id_city: integer;
    name: string;
    name2: string;
    id_type: integer;
  end;

type
  TERCCodeOwnerParams = class(TObject)
    id: integer;
    erc_code: integer;
    id_room: integer;
    fullName: string;
    id_city: integer;
  end;

type
//  TBankbookParams = record
  TBankbookParams = class(TObject)
    id: integer;
    id_human: integer;
    id_utility: integer;
    code_firm: integer;
    code_utility: integer;
    bank_book: string;
  end;

type
  TAddressParams = record
    city_id: integer;
    city_name: string;
    city_type: string;
    street_code: integer;
    street_name: string;
    street_type: string;
    n_house: integer;
    f_house: integer;
    a_house: string;
    d_house: integer;
    n_room: integer;
    a_room: string;
  end;
type
  TRule = record
    result_field_name: string;
    default_value: string;
    input_field_name: string;
  end;
type
  TRateWater = set of  0..115 ;

type
  TRoomOptions = record
    bankbook_id: integer;
    id_period: integer;
    number_rooms: integer;
    is_lift: boolean;
    date_privatization: Extended;
    form_property: integer;
    total_area: real;
    heat_area: real;
    quota_area: real;
    counter_state: integer;
    date_calc_device: Extended;
    boiler: integer;
    water_heater: integer;
    heat_type: integer;
    change_heat_date: Extended;
  end;
type
  TTariffOptions = record
    id_bankbook: integer;
    id_period: integer;
    id_period_begin: integer;
    watercharge: real;
    date_watercharge: Extended;
    tariff: real;
    tariff_real: real;
  end;

type
  TReportDateOptions = class(TObject)
    id: integer;
    id_city: integer;
    report_date: Extended;
    description: string;
    state: integer;
  end;

type
  TDebtOptions = record
    bankbook_id: integer;
    period_id: integer;
    address_id: integer;
    debt_date: Extended;
    debt_total: real;
    month_sum: real;
    normal_sum: real;
    month_count: integer;
    last_count: integer;
  end;

type
  TPayerOptions = record
    bankbook_id: integer;
    period_id: integer;
    period_begin_id: integer;
    full_name: string;
    owner_full_name: string;
    phone: string;
    resident_number: integer;
  end;

type
  TPrivilege = record
    bankbook_id: integer;
    period_id: integer;
    period_begin_id: integer;
    sum_01122006: real;
    pact_date: Extended;
    pact_number: string;
    debt_sum_restruct: real;
    subsidy: real;
    subsidy_date: Extended;
    privilege1_code: integer;
    privilege1_users: integer;
    privilege1_category: integer;
    privilege1_date: Extended;
    privilege1_doc: string;
    privilege1_doc_number: string;
    privilege1_doc_who: string;
    privilege1_doc_date: Extended;
    privilege1_percent: real;
  end;

function get_file_size(file_name: string):integer;
function isCode(ADOQDictionary: TADOQuery; tableName: string; fieldName: string; value: string): boolean;
function get_bank_book_id(var bank_book_id: integer; StoredProc: TADOStoredProc;
  code_firm, code_utility: integer; bank_book: string):boolean;
function full_name_exists(StoredProc: TADOStoredProc; ADODSWork: TADODataSet;
  code_firm, code_utility: integer; bank_book, full_name: string;
  address_id: integer; var occupants: string):boolean;
function get_report_date_params(var report_date_params: TReportDateOptions;
  StoredProc: TADOStoredProc; ADODSWork: TADODataSet; current_city_id: integer;
  report_date: Extended):Boolean;
function address_exists(ADOQDictionary: TADOQuery; n_house, f_house, d_house, a_house,
  n_room, a_room, code_city, code_street: string; var address_id: integer):boolean;
function get_full_address(ADOQ: TADOQuery; code_c, code_s, n_house, f_house, a_house, d_house,
  n_room, a_room: string): string;
function get_city_by_id(ADOQ: TADOQuery; city_id:string): string;
function get_street_by_codes(ADOQ: TADOQuery; city_id, street_code:string): string;
function get_room_options_by_bankbook(var room_attributes: TRoomOptions;
  ADOQDictionary: TADOQuery; report_date_id: string; bankbook_id: integer): Boolean;
function get_tariff_by_bankbook(var tariff_params:TTariffOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
function get_debt_options_by_bankbook(var debt_params: TDebtOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
function get_payer_options_by_bankbook(var payer_params: TPayerOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
function get_privilege_options_by_bankbook(var privilege_params: TPrivilege; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
function get_rules_by_firm_code(var rules: array of TRule; var total_rules: integer; ADOQDictionary: TADOQuery; current_firm_code: integer): boolean;
function get_address_id_by_bank_book_id(ADOQDictionary: TADOQuery; bank_book_id: integer): integer;
function get_fullname_by_bankbook_id(ADOQDictionary: TADOQuery; bank_book_id: integer):string;
function get_address_params_by_bankbook(var address_params: TAddressParams; q: TADOQuery;
  code_firm, code_utility, bank_book: string):boolean;
function get_fullname_by_bankbook_params(sp: TADOStoredProc;
  code_firm, code_utility: integer; bank_book: string):string;
procedure get_occupants_by_address(var TempList: TStringList; q: TADOQuery;
  code_c, code_s, n_house, f_house, a_house, d_house,
  n_room, a_room: string);
//function get_bankbook_by_human_id(q: TADOQuery; id: integer):TBankbookParams;
function get_firm_name_by_firm_id(q: TADOQuery; firm_id:integer): string;
function get_service_name_by_service_id(q: TADOQuery; service_id:integer): string;
procedure get_payers_by_bankbook_params(var TempList: TStringList; q: TADOQuery;
code_firm, code_utility, bank_book: string);
function get_bankbook_by_codefirm_codeutility_bankbook(q: TADOQuery;
  code_firm, code_utility, bank_book: string):TBankbookParams;
procedure get_all_bankbook_by_human_id(var TempList: TStringList; q: TADOQuery;
  id: integer);
procedure get_report_date_list_by_city(var l: TStringList; q: TADOQuery; code_city: integer);
procedure get_street_list_by_city(var l: TStringList; q: TADOQuery; id: integer);
procedure get_home_list_by_street(var l: TStringList; q: TADOQuery; id: integer);
procedure get_room_list_by_home(var l: TStringList; q: TADOQuery; id: integer);
function new_erc_code(q: TADOQuery; city_id: integer): string;
function get_new_erc_code(sp: TADOStoredProc; city_id:integer): string;

function get_bankbook_id(q: TADOQuery; id_human, code_firm: integer; bankbook: string): integer;
function get_bankbook_utilities_id(q: TADOQuery; id_human, code_firm,
  code_utility: integer; bankbook: string): integer;

var
  ownership: array[0..5] of string = ('нет информации', 'государственная',
    'ведомственная', 'приватизированная', 'кооперативная', 'частная');
  type_heat: array[0..4] of string = ('нет информации', 'отопление обрезано',
    'автономное отопление', 'центральное отопление', 'отопление отсутствует');

implementation

function get_file_size(file_name: string):integer;
var
  ts:TSearchRec;
begin
  result := 0;
  if FindFirst(file_name, faAnyFile, ts)=0 then begin
    result := ts.FindData.nFileSizeHigh*4294967296+ts.FindData.nFileSizeLow;
    Findclose(ts);
  end;
end;

function isCode(ADOQDictionary: TADOQuery; tableName: string; fieldName: string; value: string): boolean;
begin
  result := false;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT '+fieldName+' FROM '+tableName+' WHERE '+fieldName+' = '+ value);
    Open;
    if RecordCount > 0 then result := true;
    Close;
  end
end;

function get_bank_book_id(var bank_book_id: integer; StoredProc: TADOStoredProc;
  code_firm, code_utility: integer; bank_book: string):boolean;
begin
  result := false;
  with StoredProc do begin
    ProcedureName := 'us_bankbook_exists;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_firm', ftinteger, pdInput, 10, code_firm);
    Parameters.CreateParameter('@code_utility', ftinteger, pdInput, 10, code_utility);
    Parameters.CreateParameter('@bank_book', ftstring, pdInput, 20, bank_book);
    Open; //only Open not ExecProc
    if Recordset.RecordCount > 0 then begin
      bank_book_id := Recordset.Fields[0].Value;
      result := true;
    end;
    Close;
  end;
end;

function full_name_exists(StoredProc: TADOStoredProc; ADODSWork: TADODataSet; code_firm, code_utility: integer;
  bank_book, full_name: string; address_id: integer; var occupants: string):boolean;
var
  i: Integer;
begin
  result := false;
  with StoredProc do begin
    ProcedureName := 'us_get_fullname_by_bankbook;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_firm', ftinteger, pdInput, 10, code_firm);
    Parameters.CreateParameter('@code_utility', ftinteger, pdInput, 10, code_utility);
    Parameters.CreateParameter('@bank_book', ftstring, pdInput, 20, bank_book);
    Open;
    if Recordset.RecordCount > 0 then begin
      ADODSWork.Recordset := StoredProc.Recordset;
      ADODSWork.First;
      for i := 0 to ADODSWork.Recordset.RecordCount - 1 do begin
        if ANSIUpperCase(AnsiReplaceStr(ADODSWork.FieldByName('full_name').AsString, chr(95), chr(73))) = full_name then begin
          result := true;
          occupants := '';
          Close;
          exit;
        end;
        occupants := occupants + ADODSWork.FieldByName('full_name').AsString+ ' ';
        ADODSWork.Next;
      end;
    end else if address_id <> -1 then begin
      close;
      ProcedureName := 'us_get_fullnames_by_address_id;1';
      Parameters.Clear;
      Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
      Parameters.CreateParameter('@address_id', ftinteger, pdInput, 10, address_id);
      Open;
      if Recordset.RecordCount > 0 then begin
        ADODSWork.Recordset := StoredProc.Recordset;
        ADODSWork.First;
        for i := 0 to ADODSWork.Recordset.RecordCount - 1 do begin
          occupants := occupants + ANSIUpperCase(ADODSWork.FieldByName('full_name').AsString)+ ' ';
          ADODSWork.Next;
        end;
      end;
    end;
    Close;
  end;
end;

function get_report_date_params(var report_date_params: TReportDateOptions;
  StoredProc: TADOStoredProc; ADODSWork: TADODataSet; current_city_id: integer;
  report_date: Extended):Boolean;
var
  i: integer;
begin
  result := false;
  with StoredProc do begin
    ProcedureName := 'us_get_report_date_params;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_city', ftinteger, pdInput, 10, current_city_id);
    Parameters.CreateParameter('@report_date', ftDate, pdInput, 10, DateToStr(report_date));
    Open;
    if Recordset.RecordCount > 0 then begin
      ADODSWork.Recordset := Recordset;
      ADODSWork.First;
      for i := 0 to ADODSWork.Recordset.RecordCount - 1 do begin
        if ADODSWork.FieldByName('status').AsInteger = 1 then begin
          report_date_params.id := ADODSWork.FieldByName('id').AsInteger;
          report_date_params.id_city := ADODSWork.FieldByName('id_city').AsInteger;
          report_date_params.report_date := ADODSWork.FieldByName('date_b').AsDateTime;
          report_date_params.description := ADODSWork.FieldByName('description').AsString;
          report_date_params.state := ADODSWork.FieldByName('status').AsInteger;
          result := true;
          Close;
          exit;
        end;
        ADODSWork.Next;
      end;
    end;
    Close;
  end;
end;

function address_exists(ADOQDictionary: TADOQuery; n_house, f_house, d_house, a_house,
  n_room, a_room, code_city, code_street: string; var address_id: integer):boolean;
var
  house1, house2, house3: string;
  room: string;
function init_number(s: string): string;
begin
  if trim(s) = '' then
    result := '0'
  else
    result := trim(s);
end;
begin
  result := false;
  house1 := init_number(n_house);
  house2 := init_number(f_house);
  house3 := init_number(d_house);
  room := init_number(n_room);
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM rooms WHERE n_room = '+room+' AND a_room = '''+a_room+
      ''' AND id_house in (SELECT id FROM houses WHERE n_house = '+house1+
      ' AND f_house = '+house2+' AND d_house = '+house3+' AND a_house = '''+a_house+
      ''' AND id_street in (SELECT id FROM streets WHERE id_city = '+code_city+
      ' AND code_s = '+code_street+'))');
    Open;
    if RecordCount > 0 then begin
      address_id := FieldByName('id').AsInteger;
      result := true;
    end;
    Close;
  end;
end;

function get_city_by_id(ADOQ: TADOQuery; city_id:string): string;
begin
  result := '';
  with ADOQ do begin
    SQL.Clear;
    SQL.Add('SELECT name FROM cities WHERE id = '+city_id);
    Open;
    if Recordset.RecordCount > 0 then
      result := FieldByName('name').AsString;
    Close;
  end;
end;

function get_street_by_codes(ADOQ: TADOQuery; city_id, street_code:string): string;
begin
  result := '';
  with ADOQ do begin
    SQL.Clear;
    SQL.Add('SELECT name FROM streets WHERE id_city = '+city_id+'AND code_s ='+street_code);
    Open;
    if Recordset.RecordCount > 0 then
      result := FieldByName('name').AsString;
    Close;
  end;
end;

function get_full_address(ADOQ: TADOQuery; code_c, code_s, n_house, f_house, a_house, d_house,
  n_room, a_room: string): string;
var
  s: string;
begin
  result := '';
  result := 'город '+ get_city_by_id(ADOQ, code_c)+', ';
  s := get_street_by_codes(ADOQ, code_c, code_s);
  if (pos(' пер.', s) > 0) or (pos(' пр.', s) > 0)
    or (pos(' пл.', s) > 0) or (pos(' б.', s) > 0) then
    result := result +s+', '
  else
    result := result +'ул. '+s+', ';
  Result := Result+'дом '+n_house;
  if f_house <> '0' then
    Result := Result+'-'+f_house;
  Result := Result+trim(a_house);
  if d_house <> '0' then
    Result := Result+'/'+f_house;
  if n_room <> '0' then
    Result := Result+', кв.'+ n_room+trim(a_room);
end;

function get_room_options_by_bankbook(var room_attributes: TRoomOptions;
  ADOQDictionary: TADOQuery; report_date_id: string; bankbook_id: integer): Boolean;
begin
  result := false;
  if room_attributes.bankbook_id = bankbook_id then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_rooms WHERE id_period = '+report_date_id+
      'AND id_bankbook = '+ IntToStr(bankbook_id));
    Open;
    if RecordCount > 0 then begin
      result := true;
      room_attributes.bankbook_id := bankbook_id;
      room_attributes.id_period := FieldByName('id_period').AsInteger;
      room_attributes.number_rooms := FieldByName('one_roomed_flat').AsInteger;
      room_attributes.is_lift := FieldByName('lift').AsBoolean;
      room_attributes.date_privatization := FieldByName('date_privatization').AsDateTime;
      room_attributes.form_property := FieldByName('form_property').AsInteger;
      room_attributes.total_area := FieldByName('total_area').AsFloat;
      room_attributes.heat_area := FieldByName('heat_area').AsFloat;
      room_attributes.quota_area := FieldByName('quota_area').AsFloat;
      room_attributes.counter_state := FieldByName('calc_device').AsInteger;
      room_attributes.date_calc_device:= FieldByName('date_calc_device').AsDateTime;
      room_attributes.boiler := FieldByName('boiler').AsInteger;
      room_attributes.water_heater:= FieldByName('water_heater').AsInteger;
      room_attributes.heat_type := FieldByName('type_heating').AsInteger;
      room_attributes.change_heat_date := FieldByName('date_heating').AsDateTime;
    end;
    Close;
  end;
end;

function get_tariff_by_bankbook(var tariff_params:TTariffOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
begin
  result := false;
  if tariff_params.id_bankbook = bankbook_id then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_tarifs WHERE id_period = '+report_date_id+
      ' AND id_bankbook = '+IntToStr(bankbook_id));
    Open;
    if RecordCount > 0 then begin
      tariff_params.id_bankbook := FieldByName('id_bankbook').AsInteger;
      tariff_params.id_period := FieldByName('id_period').AsInteger;
      tariff_params.id_period_begin := FieldByName('id_period_begin').AsInteger;
      tariff_params.watercharge := FieldByName('watercharge').AsFloat;
      tariff_params.date_watercharge := FieldByName('date_wc').AsDateTime;
      tariff_params.tariff := FieldByName('tarif').AsFloat;
      tariff_params.tariff_real := FieldByName('tarif_f').AsFloat;
      result := true;
    end;
    Close;
  end;
end;

function get_debt_options_by_bankbook(var debt_params: TDebtOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
begin
  result := false;
  if debt_params.bankbook_id = bankbook_id then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_debts WHERE id_period = '+
      report_date_id+' AND id_bankbook_utility = '+
      IntToStr(bankbook_id));
    Open;
    if RecordCount > 0 then begin
      result := true;
      debt_params.bankbook_id := FieldByName('id_bankbook_utility').AsInteger;
      debt_params.period_id := FieldByName('id_period').AsInteger;
      debt_params.address_id := FieldByName('id_room_location').AsInteger;
      debt_params.debt_date := FieldByName('date_dolg').AsDateTime;
      debt_params.debt_total := FieldByName('sum_dolg').AsFloat;
      debt_params.month_sum := FieldByName('sum_month').AsFloat;
      debt_params.normal_sum := FieldByName('sum_isp').AsFloat;
      debt_params.month_count := FieldByName('month_count').AsInteger;
      debt_params.last_count := FieldByName('end_count').AsInteger;
    end;
    Close;
  end;
end;

function get_payer_options_by_bankbook(var payer_params: TPayerOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
begin
  result := false;
  if payer_params.bankbook_id = bankbook_id then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_humans WHERE id_period = '+
      report_date_id+' AND id_bankbook = '+ IntToStr(bankbook_id));
    Open;
    if RecordCount > 0 then begin
      result := true;
      payer_params.bankbook_id := FieldByName('id_bankbook').AsInteger;
      payer_params.period_id := FieldByName('id_period').AsInteger;
      payer_params.period_begin_id := FieldByName('id_period_begin').AsInteger;
      payer_params.full_name := ANSIUpperCase(FieldByName('full_name').AsString);
      payer_params.owner_full_name := ANSIUpperCase(FieldByName('full_name_owner').AsString);
      payer_params.phone := FieldByName('phone').AsString;
      payer_params.resident_number := FieldByName('resident_number').AsInteger;
    end;
    Close;
  end;
end;

function get_privilege_options_by_bankbook(var privilege_params: TPrivilege; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
begin
  result := false;
  if privilege_params.bankbook_id = bankbook_id then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_lgots WHERE id_period = '+
      report_date_id+' AND id_bankbook_utility = '+ IntToStr(bankbook_id));
    Open;
    if RecordCount > 0 then begin
      result := true;
      privilege_params.bankbook_id := FieldByName('id_bankbook_utility').AsInteger;
      privilege_params.period_id := FieldByName('id_period').AsInteger;
      privilege_params.period_begin_id := FieldByName('id_period_begin').AsInteger;
      privilege_params.sum_01122006 := FieldByName('sum_01122006').AsFloat;
      privilege_params.pact_date := FieldByName('date_dog').AsDateTime;
      privilege_params.pact_number := FieldByName('num_dog').AsString;
      privilege_params.debt_sum_restruct := FieldByName('sum_dolg_dog').AsFloat;
      privilege_params.subsidy := FieldByName('subs').AsFloat;
      privilege_params.subsidy_date := FieldByName('date_subs').AsDateTime;
      privilege_params.privilege1_code := FieldByName('code_lg1').AsInteger;
      privilege_params.privilege1_users := FieldByName('count_tn_lg1').AsInteger;
      privilege_params.privilege1_category := FieldByName('kat_lg1').AsInteger;
      privilege_params.privilege1_date := FieldByName('date_lg1').AsDateTime;
      privilege_params.privilege1_doc := FieldByName('doc_lg_vid1').AsString;
      privilege_params.privilege1_doc_number := FieldByName('doc_lg_num1').AsString;
      privilege_params.privilege1_doc_who := FieldByName('doc_lg_v1').AsString;
      privilege_params.privilege1_doc_date := FieldByName('doc_lg_d1').AsDateTime;
      privilege_params.privilege1_percent := FieldByName('rate_lg1').AsFloat;
    end;
    Close;
  end;
end;

function get_rules_by_firm_code(var rules: array of TRule; var total_rules: integer; ADOQDictionary: TADOQuery; current_firm_code: integer): boolean;
var
  i: integer;
begin
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM conversion_rules WHERE code_firm ='+
      IntToStr(current_firm_code));
    Open;
    First;
    if RecordCount > 0 then begin
      total_rules := RecordCount;
      result := true;
      for I := 0 to RecordCount - 1 do begin
        rules[i].result_field_name := FieldByName('field_name').AsString;
        rules[i].input_field_name := FieldByName('input_field_name').AsString;
        rules[i].default_value := FieldByName('default_value').AsString;
        Next;
      end;
    end else begin
      result := false;
    end;
    Close;
  end;
end;

function get_address_id_by_bank_book_id(ADOQDictionary: TADOQuery; bank_book_id: integer): integer;
begin
  Result := 0;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT id_room FROM humans WHERE id = (SELECT id_human FROM bankbooks WHERE id = '+
      IntToStr(bank_book_id)+')');
    Open;
    First;
    if RecordCount > 0 then begin
      Result := FieldByName('id_room').AsInteger;
    end;
    Close;
  end;
end;

function get_fullname_by_bankbook_id(ADOQDictionary: TADOQuery; bank_book_id: integer):string;
begin
  Result := '';
  if bank_book_id = -1 then
    exit;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add('SELECT full_name FROM humans WHERE id = (SELECT id_human FROM bankbooks WHERE id = '+
      IntToStr(bank_book_id)+')');
    Open;
    First;
    if RecordCount > 0 then begin
      Result := FieldByName('full_name').AsString;
    end;
    Close;
  end;
end;

function get_address_params_by_bankbook(var address_params: TAddressParams; q: TADOQuery;
  code_firm, code_utility, bank_book: string):boolean;
var
  key: string;
begin
  Result := false;
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM room_locations rl '+
        'JOIN rooms r ON r.id=rl.id_room '+
        ' WHERE rl.id = '+
        '(SELECT id_room_location FROM humans WHERE id = '+
          '(SELECT id_human FROM bankbooks WHERE code_firm = '+code_firm+
//          ' AND code_utility = '+code_utility+
          ' AND bank_book = '''+bank_book+'''))');
      Open;
      address_params.n_room := FieldByName('n_room').AsInteger;
      address_params.a_room := FieldByName('a_room').AsString;
      key := FieldByName('id_house_location').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM house_locations hl '+
        ' JOIN houses h ON h.id=hl.id_house '+
        ' WHERE hl.id ='+key);
      Open;
      address_params.n_house := FieldByName('n_house').AsInteger;
      address_params.f_house := FieldByName('f_house').AsInteger;
      address_params.a_house := FieldByName('a_house').AsString;
      address_params.d_house := FieldByName('d_house').AsInteger;
      key := FieldByName('id_street_location').AsString;
      SQL.Clear;
      SQL.Add('SELECT sl.*, st.short_name type FROM street_locations sl '+
        ' JOIN street_types st ON st.id=sl.id_type '+
        ' WHERE sl.id ='+key);
      Open;
      address_params.street_type := FieldByName('type').AsString;
      address_params.street_name := FieldByName('name').AsString;
      address_params.city_id := FieldByName('id_city').AsInteger;
      key := FieldByName('id_city').AsString;
      SQL.Clear;
      SQL.Add('SELECT c.name_rus, ct.short_name type FROM cities c '+
        'JOIN city_types ct ON ct.id=c.id_type'+
        ' WHERE c.id ='+key);
      Open;
      address_params.city_name := FieldByName('name_rus').AsString;
      address_params.city_type := FieldByName('type').AsString;
      close;
      Result := true;
    end;
  Except
  end;
end;

function get_fullname_by_bankbook_params(sp: TADOStoredProc;
  code_firm, code_utility: integer; bank_book: string):string;
begin
  result := '';
  with sp do begin
    ProcedureName := 'us_get_fullname_by_bankbook;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_firm', ftinteger, pdInput, 10, code_firm);
    Parameters.CreateParameter('@code_utility', ftinteger, pdInput, 10, code_utility);
    Parameters.CreateParameter('@bank_book', ftstring, pdInput, 20, bank_book);
    Open;
    if Recordset.RecordCount > 0 then begin
      Result := ANSIUpperCase(AnsiReplaceStr(FieldByName('full_name').AsString, chr(95), chr(73)));
      Close;
    end;
  end;
end;

procedure get_occupants_by_address(var TempList: TStringList; q: TADOQuery;
  code_c, code_s, n_house, f_house, a_house, d_house,
  n_room, a_room: string);
var
  i: integer;
  occupant_params: TERCCodeOwnerParams;
begin
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM humans WHERE id_room = '+
          '(SELECT id FROM rooms WHERE n_room = '+n_room+' AND a_room = '''+a_room+
          ''' AND id_house = '+
          '(SELECT id FROM houses WHERE n_house ='+n_house+
          ' AND f_house = '+f_house+' AND a_house = '''+a_house+
          ''' AND d_house = '+d_house+' AND id_street = '+
          '(SELECT id FROM streets WHERE code_s='+code_s+' AND id_city='+code_c+')))');
      Open;
      First;
      for I := 0 to recordCount - 1 do begin
        occupant_params := TERCCodeOwnerParams.Create;
        occupant_params.id := FieldByName('id').AsInteger;
        occupant_params.erc_code := FieldByName('code_erc').AsInteger;
        occupant_params.id_room := FieldByName('id_room').AsInteger;
        occupant_params.fullName := FieldByName('full_name').AsString;
        TempList.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(occupant_params));
        Next;
      end;
      close;
    end;
    except
      TempList.Clear;
    end;
end;

procedure get_payers_by_bankbook_params(var TempList: TStringList; q: TADOQuery;
code_firm, code_utility, bank_book: string);
var
  i: integer;
  payer_params: TERCCodeOwnerParams;
begin
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM humans WHERE id in '+
        '(SELECT id_human FROM bankbooks bb '+
        'JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id '+
        ' AND bu.code_utility='+code_utility+
        ' WHERE code_firm = '+code_firm+
        ' AND bank_book ='''+bank_book+''')');
//      SQL.Add('SELECT * FROM humans WHERE id in '+
//          '(SELECT id_human FROM bankbooks WHERE code_firm = '+code_firm+
//          ' AND code_utility = '+code_utility+
//          ' AND bank_book = '''+bank_book+''')');
      Open;
      First;
      for I := 0 to recordCount - 1 do begin
        payer_params := TERCCodeOwnerParams.Create;
        payer_params.id := FieldByName('id').AsInteger;
        payer_params.erc_code := FieldByName('code_erc').AsInteger;
        payer_params.id_room := FieldByName('id_room_location').AsInteger;
        payer_params.fullName := FieldByName('full_name').AsString;
        TempList.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(payer_params));
        Next;
      end;
      close;
    end;
    except
      TempList.Clear;
    end;
end;

procedure get_all_bankbook_by_human_id(var TempList: TStringList; q: TADOQuery;
  id: integer);
var
  i: integer;
  bb_params: TBankbookParams;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT bb.*, bu.id id_utility, bu.code_utility '+
      'FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id'+
      ' WHERE id_human ='+ IntToStr(id));
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := id;
      bb_params.id_utility := FieldByName('id_utility').AsInteger;
      bb_params.code_firm := FieldByName('code_firm').AsInteger;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      TempList.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;
    close;
  end;
end;

//function get_bankbook_by_human_id(q: TADOQuery; id: integer):TBankbookParams;
//begin
//  with q do begin
//    SQL.Clear;
//    SQL.Add('SELECT * FROM bankbooks WHERE id_human = '+ IntToStr(id));
//    Open;
//    if Recordset.RecordCount > 0 then begin
//      Result.id := FieldByName('id').AsInteger;
//      Result.id_human := id;
//      Result.code_firm := FieldByName('code_firm').AsInteger;
//      Result.code_utility := FieldByName('code_utility').AsInteger;
//      Result.bank_book := FieldByName('bank_book').AsString;
//    end;
//  end;
//end;

function get_bankbook_by_codefirm_codeutility_bankbook(q: TADOQuery;
  code_firm, code_utility, bank_book: string):TBankbookParams;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbooks WHERE code_firm = '+code_firm+
          ' AND code_utility = '+code_utility+
          ' AND bank_book = '''+bank_book+'''');
    Open;
    if Recordset.RecordCount > 0 then begin
      Result.id := FieldByName('id').AsInteger;
      Result.id_human := FieldByName('id_human').AsInteger;
      Result.code_firm := FieldByName('code_firm').AsInteger;
      Result.code_utility := FieldByName('code_utility').AsInteger;
      Result.bank_book := FieldByName('bank_book').AsString;
    end;
    close;
  end;
end;

function get_firm_name_by_firm_id(q: TADOQuery; firm_id:integer): string;
begin
  Result := '';
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT name FROM firms WHERE code = '+ IntToStr(firm_id));
    Open;
    if Recordset.RecordCount > 0 then begin
      Result := FieldByName('name').AsString;
    end;
  end;
end;

function get_service_name_by_service_id(q: TADOQuery; service_id:integer): string;
begin
  Result := '';
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT name FROM utilities WHERE code = '+ IntToStr(service_id));
    Open;
    if Recordset.RecordCount > 0 then begin
      Result := FieldByName('name').AsString;
    end;
  end;
end;

procedure get_report_date_list_by_city(var l: TStringList; q: TADOQuery; code_city: integer);
var
  i: integer;
  rd_params: TReportDateOptions;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM periods WHERE status = 0 AND id_city = '+ IntToStr(code_city));
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      rd_params := TReportDateOptions.Create;
      rd_params.id := FieldByName('id').AsInteger;
      rd_params.id_city := code_city;
      rd_params.report_date := FieldByName('date_b').AsDateTime;
      rd_params.description:= FieldByName('description').AsString;
      rd_params.state:= FieldByName('status').AsInteger;
      l.AddObject(FieldByName('date_b').AsString, rd_params);
      next;
    end;
  end;
end;

procedure get_street_list_by_city(var l: TStringList; q: TADOQuery; id: integer);
var
  i: integer;
  s_params: TStreetParams;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT sl.*, st.short_name type FROM street_locations sl '+
      ' JOIN street_types st ON st.id=sl.id_type '+
      ' WHERE id_city = '+ IntToStr(id)+'ORDER BY name');
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      s_params := TStreetParams.Create;
      s_params.id := FieldByName('id').AsInteger;
      s_params.id_city := id;
      s_params.name:= FieldByName('name').AsString;
      s_params.name2:= FieldByName('second_name').AsString;
      s_params.id_type := FieldByName('id_type').AsInteger;
      l.AddObject(FieldByName('name').AsString+' '+
        FieldByName('type').AsString, s_params);
      next;
    end;
  end;
end;

procedure get_home_list_by_street(var l: TStringList; q: TADOQuery; id: integer);
var
  i: integer;
  h_params: THomeParams;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT h.n_house, h.f_house, h.d_house, h.a_house, hl.id, hl.id_street_location '+
      'FROM house_locations hl '+
      'JOIN houses h ON h.id=hl.id_house '+
      ' WHERE id_street_location = '+ IntToStr(id)+
      'ORDER BY h.n_house, h.f_house, h.d_house, h.a_house');
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      h_params := THomeParams.Create;
      h_params.id := FieldByName('id').AsInteger;
      h_params.id_street:= id;
      h_params.n_home := FieldByName('n_house').AsInteger;
      h_params.f_home := FieldByName('f_house').AsInteger;
      h_params.a_home := FieldByName('a_house').AsString;
      h_params.d_home := FieldByName('d_house').AsInteger;
      l.AddObject(FieldByName('n_house').AsString+
        trim(FieldByName('a_house').AsString)+'-'+
        FieldByName('f_house').AsString+'/'+
        FieldByName('d_house').AsString, h_params);
      next;
    end;
  end;
end;

procedure get_room_list_by_home(var l: TStringList; q: TADOQuery; id: integer);
var
  i: integer;
  r_params: TRoomParams;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT r.n_room, r.a_room, rl.id FROM room_locations rl '+
      'JOIN rooms r ON r.id=rl.id_room '+
      ' WHERE id_house_location = '+ IntToStr(id)+
      ' ORDER BY r.n_room, r.a_room');
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      r_params := TRoomParams.Create;
      r_params.id := FieldByName('id').AsInteger;
      r_params.id_home:= id;
      r_params.n_room := FieldByName('n_room').AsInteger;
      r_params.a_room:= FieldByName('a_room').AsString;
      l.AddObject(FieldByName('n_room').AsString+
        trim(FieldByName('a_room').AsString), r_params);
      next;
    end;
  end;
end;

function new_erc_code(q: TADOQuery; city_id: integer): string;
var
  last_code: integer;
begin
  with q do begin
    SQL.Clear;
    SQL.add('SELECT lastGenErcCode FROM cities WHERE id='+IntToStr(city_id));
    Open;
    last_code := FieldByName('lastGenErcCode').AsInteger;
    inc(last_code);
    SQL.Clear;
    SQL.add('SELECT code=dbo.CreateNewHumanCode('+IntToStr(city_id)+')');
    Open;
    Result := FieldByName('code').AsString;
    SQL.Clear;
    SQL.add('UPDATE cities SET lastGenErcCode='+
      Inttostr(last_code)+' WHERE id='+IntToStr(city_id));
    ExecSQL;
    Close;
  end;
end;

function get_new_erc_code(sp: TADOStoredProc; city_id:integer): string;
begin
  result := '';
  with sp do begin
    ProcedureName := 'up_getNewErcCode;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@iCodeCity', ftinteger, pdInput, 10, city_id);
    Parameters.CreateParameter('@result', ftinteger, pdInputOutput, 10, 0);
    ExecProc;
    result := IntToStr(Parameters.ParamByName('@result').Value);
    Close;
  end;
end;

function get_bankbook_id(q: TADOQuery; id_human, code_firm: integer; bankbook: string): integer;
begin
  Result := 0;
  with q do begin
    SQL.Clear;
    SQL.add('SELECT id FROM bankbooks WHERE id_human='+
      IntToStr(id_human)+' AND code_firm='+IntToStr(code_firm)+
      ' AND bank_book='''+bankbook+'''');
    Open;
    first;
    if recordcount>0 then begin
      Result := FieldByName('id').AsInteger;
    end;
    Close;
  end;
end;

function get_bankbook_utilities_id(q: TADOQuery; id_human, code_firm,
  code_utility: integer; bankbook: string): integer;
var
  bankbook_id: integer;
begin
  Result := 0;
  bankbook_id := get_bankbook_id(q, id_human, code_firm, bankbook);
  if bankbook_id>0 then
    with q do begin
      SQL.Clear;
      SQL.add('SELECT id FROM bankbook_utilities WHERE id_bankbook='+
        IntToStr(bankbook_id)+' AND code_utility='+IntToStr(code_utility));
      open;
      First;
      if recordcount>0 then
        Result := FieldByName('id').AsInteger;
    end;
end;
end.
