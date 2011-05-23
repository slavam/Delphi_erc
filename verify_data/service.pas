unit service;

interface
uses
  SysUtils, DB,
  Classes,
  ADODB;

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
  TAddressParams = record
    city_id: integer;
    local_city_id: integer;
    city_name: string;
    city_type: string;
    street_code: integer;
    local_street_code: integer;
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
  TDebtOptions = class(TObject) //record
    id_bankbook_utility: integer;
    period_id: integer;
    period_description: string;
    period_state: integer;
    address_id: integer;
    debt_date: Extended;
    debt_total: real;
    month_sum: real;
    normal_sum: real;
    month_count: integer;
    last_count: integer;
  end;

type
  TTarifParams = record
    id_bankbook_utility: integer;
    period_id: integer;
    period_begin_id: integer;
    watercharge: real;
    wc_change_date: Extended;
    tarif: real;
    real_tarif: real;
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
    id_bankbook_utility: integer;
//    bankbook_id: integer;
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


type
  TRoomOptions = record
    bankbook_id: integer;
    id_period: integer;
    id_period_begin: integer;
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
  TBankbookParams = class(TObject)
    id: integer;
    id_human: integer;
    id_bankbook_utilities: integer;
    code_firm: integer;
    code_utility: integer;
    bank_book: string;
    full_name: string;
    code_erc: integer;
  end;

type
  TERCCodeOwnerParams = class(TObject)
    id: integer;
    erc_code: integer;
    id_city: integer;
    id_room: integer;
    fullName: string;
  end;

type
  TLoadingParams = record
    report_date: Extended;
    main_city_id: integer;
    reg_record_id: integer;
    firm_id: integer;
    rules_template_id: integer;
    city_template_id: integer;
    street_template_id: integer;
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
  TRule = record
    result_field_name: string;
    default_value: string;
    input_field_name: string;
  end;

function get_file_size(file_name: string):integer;
function isCode(q: TADOQuery; tableName: string; fieldName: string; value: string): boolean;
function get_report_date_params(var report_date_params: TReportDateOptions;
  sp: TADOStoredProc; ds: TADODataSet; current_city_id: integer;
  report_date: Extended):Boolean;
function get_rules_by_firm_code(var rules: array of TRule; var total_rules: integer; q: TADOQuery; firm_code: integer): boolean;
function get_template_id_by_code_firm(q: TADOQuery; firm_id: integer): integer;
function get_firm_name_by_firm_id(q: TADOQuery; firm_id:integer): string;
function get_service_name_by_service_id(q: TADOQuery; service_id:integer): string;
function get_address_params_by_bankbook(var address_params: TAddressParams; q: TADOQuery;
  code_firm, code_utility, bank_book: string):boolean;
function get_address_by_id_room_location(var address_params: TAddressParams;
  q: TADOQuery; id_room_location: integer): boolean;
function get_debt_options_by_bankbook(var debt_params: TDebtOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; {code_utility: string;} id_bankbook_utility: integer): Boolean;
function get_room_options_by_bankbook(var room_attributes: TRoomOptions;
  ADOQDictionary: TADOQuery; report_date_id: string; bankbook_id: integer): Boolean;
function get_payer_options_by_bankbook(var payer_params: TPayerOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; bankbook_id: integer): Boolean;
procedure get_all_bankbook_by_code_firm(var TempList: TStringList; q: TADOQuery;
  code_firm: integer; bankbook: string);
procedure get_periods_by_city(var l: TStringList; q: TADOQuery; code_city: integer);
var
  ownership: array[0..5] of string = ('нет информации', 'государственная',
    'ведомственная', 'приватизированная', 'кооперативная', 'частная');
  type_heat: array[0..4] of string = ('нет информации', 'отопление обрезано',
    'автономное отопление', 'центральное отопление', 'отопление отсутствует');
function get_privilege_options_by_bankbook(var privilege_params: TPrivilege; ADOQDictionary: TADOQuery;
  report_date_id: string; id_bankbook_utility: integer): Boolean;
procedure get_all_bankbook_by_human_id(var TempList: TStringList; q: TADOQuery;
  id: integer); // code_utility: integer);
function get_city_by_id(q: TADOQuery; id: Integer): string;
function get_street_by_id(q: TADOQuery; id_city, id_street: Integer): string;
procedure get_all_bankbook_by_code_firm_id_room(var TempList: TStringList; q: TADOQuery;
  code_firm, id_room_location: integer);
procedure get_all_bankbook_by_id_room(var TempList: TStringList; q: TADOQuery;
  id_room_location: integer);
procedure get_erc_code_owner_params_by_id_room(var l: TStringList; q: TADOQuery; id_room: integer);
procedure get_erc_code_owner_params_by_firm_and_bankbook(var l: TStringList;
  q: TADOQuery; firm: integer; bb: string);
procedure update_code_erc(q: TADOQuery; erc_code, number_record, file_id: integer);
procedure set_record_as_correct(q: TADOQuery; number_record, file_id: integer);
procedure set_record_as_incorrect(q: TADOQuery; number_record, file_id: integer);
procedure update_id_room_location(q: TADOQuery; id_room, number_record, file_id: integer);
function get_active_period_by_city_id(q: TADOQuery; city_id: integer): integer;
procedure get_debt_options_by_firm_utility_bankbook(var dp: TDebtOptions; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount: string);
procedure get_human_options_by_firm_bankbook(var hp: TPayerOptions; q: TADOQuery;
  period_id: integer; firm_id, abcount: string);
procedure get_room_options_by_firm_bankbook(var rp: TRoomOptions; q: TADOQuery;
  period_id: integer; firm_id, abcount: string);
procedure get_tarif_options_by_firm_utility_bankbook(var tp: TTarifParams; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount: string);
procedure get_addr_params_by_firm_bankbook(var address_params: TAddressParams;
  q: TADOQuery; code_firm, bank_book: string);
procedure get_privelege_options_by_firm_utility_bankbook(pp: TPrivilege; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount:string);
procedure get_debts_by_bankbook(var TempList: TStringList; q: TADOQuery;
  id_bankbook_utility: integer);
function get_new_erc_code(sp: TADOStoredProc; city_id:integer): string;
procedure get_street_list_by_city(var l: TStringList; q: TADOQuery; id: integer);
procedure get_street_id_list_by_city(var l: TStringList; q: TADOQuery; id: integer);
procedure get_room_list_by_home(var l: TStringList; q: TADOQuery; id: integer);
procedure get_home_list_by_street(var l: TStringList; q: TADOQuery; id: integer);

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

function isCode(q: TADOQuery; tableName: string; fieldName: string; value: string): boolean;
begin
  result := false;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT '+fieldName+' FROM '+tableName+' WHERE '+fieldName+' = '+ value);
    Open;
    if RecordCount > 0 then result := true;
    Close;
  end
end;

function get_report_date_params(var report_date_params: TReportDateOptions;
  sp: TADOStoredProc; ds: TADODataSet; current_city_id: integer;
  report_date: Extended):Boolean;
var
  i: integer;
begin
  result := false;
  with sp do begin
    ProcedureName := 'us_get_report_date_params;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_city', ftinteger, pdInput, 10, current_city_id);
    Parameters.CreateParameter('@report_date', ftDate, pdInput, 10, DateToStr(report_date));
    Open;
    if Recordset.RecordCount > 0 then begin
      ds.Recordset := Recordset;
      ds.First;
//      for i := 0 to ds.Recordset.RecordCount - 1 do begin
//        if ds.FieldByName('status').AsInteger = 2 then begin
          report_date_params.id := ds.FieldByName('id').AsInteger;
          report_date_params.id_city := ds.FieldByName('id_city').AsInteger;
          report_date_params.report_date := ds.FieldByName('date_b').AsDateTime;
          report_date_params.description := ds.FieldByName('description').AsString;
          report_date_params.state := ds.FieldByName('status').AsInteger;
          result := true;
          Close;
          exit;
//        end;
//        ds.Next;
//      end;
    end;
    Close;
  end;
end;

function get_rules_by_firm_code(var rules: array of TRule; var total_rules: integer;
  q: TADOQuery; firm_code: integer): boolean;
var
  i: integer;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM conversion_rules WHERE code_firm ='+
      IntToStr(firm_code));
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

function get_template_id_by_code_firm(q: TADOQuery; firm_id: integer): integer;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT id_template_bo FROM firms WHERE code='+IntToStr(firm_id));
    Open;
    First;
    if Fields[0].IsNull then
      result := 6
    else
      result := Fields[0].AsInteger;
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

function get_address_params_by_bankbook(var address_params: TAddressParams; q: TADOQuery;
  code_firm, code_utility, bank_book: string):boolean;
var
  key: string;
begin
  Result := false;
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM rooms WHERE id = '+
        '(SELECT id_room FROM humans WHERE id = '+
          '(SELECT id_human FROM bankbooks WHERE code_firm = '+code_firm+
          ' AND code_utility = '+code_utility+
          ' AND bank_book = '''+bank_book+'''))');
      Open;
      address_params.n_room := FieldByName('n_room').AsInteger;
      address_params.a_room := FieldByName('a_room').AsString;
      key := FieldByName('id_house').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM houses WHERE id ='+key);
      Open;
      address_params.n_house := FieldByName('n_house').AsInteger;
      address_params.f_house := FieldByName('f_house').AsInteger;
      address_params.a_house := FieldByName('a_house').AsString;
      address_params.d_house := FieldByName('d_house').AsInteger;
      key := FieldByName('id_street').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM streets WHERE id ='+key);
      Open;
//      address_params.street_code := FieldByName('code_s').AsInteger;
      address_params.street_name := FieldByName('name').AsString;
//      address_params.city_id := FieldByName('id_city').AsInteger;
      key := FieldByName('id_city').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM cities WHERE id ='+key);
      Open;
      address_params.city_name := FieldByName('name').AsString;
      close;
      Result := true;
    end;
  Except
  end;
end;

function get_address_by_id_room_location(var address_params: TAddressParams;
  q: TADOQuery; id_room_location: integer): boolean;
begin
  Result := false;
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT r.n_room, r.a_room, h.n_house, h.f_house, h.a_house, '+
        'h.d_house, sl.name, st.short_name street_t, c.name_rus, ct.short_name city_t'+
        ' FROM room_locations rl '+
        'JOIN rooms r ON rl.id_room=r.id '+
        'JOIN house_locations hl ON hl.id=rl.id_house_location '+
        'JOIN houses h ON h.id=hl.id_house '+
        'JOIN street_locations sl ON sl.id=hl.id_street_location '+
//        'JOIN streets s ON s.id=sl.id_street '+
//        'JOIN street_names sn ON sn.id=s.id_name '+
        'JOIN street_types st ON st.id=sl.id_type '+
        'JOIN cities c ON c.id=sl.id_city '+
        'JOIN city_types ct ON ct.id=c.id_type '+
        'WHERE rl.id ='+IntToStr(id_room_location));
      Open;
      address_params.n_room := FieldByName('n_room').AsInteger;
      address_params.a_room := FieldByName('a_room').AsString;
      address_params.n_house := FieldByName('n_house').AsInteger;
      address_params.f_house := FieldByName('f_house').AsInteger;
      address_params.a_house := FieldByName('a_house').AsString;
      address_params.d_house := FieldByName('d_house').AsInteger;
      address_params.street_type := FieldByName('street_t').AsString;
      address_params.street_name := FieldByName('name').AsString;
      address_params.city_type := FieldByName('city_t').AsString;
      address_params.city_name := FieldByName('name_rus').AsString;
      close;
      Result := true;
    end;
  Except
  end;
end;

function get_debt_options_by_bankbook(var debt_params: TDebtOptions; ADOQDictionary: TADOQuery;
  report_date_id: string; {code_utility: string;} id_bankbook_utility: integer): Boolean;
begin
  result := false;
  if debt_params.id_bankbook_utility = id_bankbook_utility then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
//    'SELECT * FROM bankbook_attributes_debts '+
//      'WHERE id_period ='+report_date_id+' AND id_bankbook_utility ='+
//      '(SELECT id FROM bankbook_utilities WHERE id_bankbook='
//      +IntToStr(bankbook_id)+' AND code_utility='+code_utility);
//    SQL.Add(
      'SELECT * FROM bankbook_attributes_debts WHERE id_period = '+
      report_date_id+' AND id_bankbook_utility = '+IntToStr(id_bankbook_utility));
    Open;
    if RecordCount > 0 then begin
      result := true;
//      debt_params.bankbook_id := FieldByName('id_bankbook').AsInteger;
      debt_params := TDebtOptions.Create;
      debt_params.id_bankbook_utility := id_bankbook_utility;
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

function get_privilege_options_by_bankbook(var privilege_params: TPrivilege; ADOQDictionary: TADOQuery;
  report_date_id: string; id_bankbook_utility: integer): Boolean;
begin
  result := false;
  if privilege_params.id_bankbook_utility = id_bankbook_utility then begin
    result := true;
    exit;
  end;
  with ADOQDictionary do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_lgots WHERE id_period = '+
      report_date_id+' AND id_bankbook_utility = '+ IntToStr(id_bankbook_utility));
    Open;
    if RecordCount > 0 then begin
      result := true;
      privilege_params.id_bankbook_utility := FieldByName('id_bankbook_utility').AsInteger;
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

procedure get_all_bankbook_by_human_id(var TempList: TStringList; q: TADOQuery;
  id: integer); // code_utility: integer);
var
  i: integer;
  bb_params: TBankbookParams;
begin
  with q do begin
    SQL.Clear;
    SQL.Add( //'SELECT bu.*, bb.* FROM bankbook_utilities bu WHERE bu.id_bankbook=
//    'SELECT * FROM bankbooks WHERE id_human = '+ IntToStr(id));
      'SELECT bb.*, bu.code_utility code_utility, bu.id id_bankbook_utilities FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bb.id=bu.id_bankbook '+
      'WHERE id_human ='+IntToStr(id));
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := id;
      bb_params.code_firm := FieldByName('code_firm').AsInteger;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.id_bankbook_utilities := FieldByName('id_bankbook_utilities').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      TempList.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;
    close;
  end;
end;

procedure get_all_bankbook_by_code_firm(var TempList: TStringList; q: TADOQuery;
  code_firm: integer; bankbook: string);
var
  i: integer;
  bb_params: TBankbookParams;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT bb.*, bu.id id_bankbook_utilities, bu.code_utility code_utility FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bb.id=bu.id_bankbook '+
      'WHERE code_firm='+Inttostr(code_firm)+' AND bank_book='''+bankbook+'''');
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := FieldByName('id_human').AsInteger;
      bb_params.code_firm := code_firm;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.id_bankbook_utilities := FieldByName('id_bankbook_utilities').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      TempList.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;
    close;
  end;
end;

procedure get_all_bankbook_by_code_firm_id_room(var TempList: TStringList; q: TADOQuery;
  code_firm, id_room_location: integer);
var
  i: integer;
  bb_params: TBankbookParams;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT bb.*, bu.id id_bankbook_utilities, bu.code_utility code_utility FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bb.id=bu.id_bankbook '+
      'WHERE code_firm='+Inttostr(code_firm)+
      ' AND id_human IN '+
        '(SELECT id FROM humans WHERE id_room_location='+
        Inttostr(id_room_location)+')');
    Open;
    TempList.Clear;
    First;
    for I := 0 to recordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := FieldByName('id_human').AsInteger;
      bb_params.code_firm := code_firm;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.id_bankbook_utilities := FieldByName('id_bankbook_utilities').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      TempList.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;
    close;
  end;
end;

procedure get_all_bankbook_by_id_room(var TempList: TStringList; q: TADOQuery;
  id_room_location: integer);
var
  i: integer;
  bb_params: TBankbookParams;
begin
  with q do begin
    SQL.Clear;
//    SQL.Add('SELECT bb.*, bu.id id_bankbook_utilities, bu.code_utility code_utility FROM bankbooks bb '+
//      'JOIN bankbook_utilities bu ON bb.id=bu.id_bankbook '+
//      'WHERE id_human IN '+
//        '(SELECT id FROM humans WHERE id_room_location='+
//        Inttostr(id_room_location)+')');
    SQL.Add('SELECT bb.*, bu.id id_bankbook_utilities, '+
      'bu.code_utility code_utility, h.full_name, h.code_erc '+
      ' FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bb.id=bu.id_bankbook '+
      'JOIN humans h ON h.id=bb.id_human and h.id_room_location='+
        Inttostr(id_room_location));
    Open;
    TempList.Clear;
    First;
    for I := 0 to recordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := FieldByName('id_human').AsInteger;
      bb_params.code_firm := FieldByName('code_firm').AsInteger;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.id_bankbook_utilities := FieldByName('id_bankbook_utilities').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      bb_params.full_name := FieldByName('full_name').AsString;
      bb_params.code_erc := FieldByName('code_erc').AsInteger;
      TempList.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;
    close;
  end;
end;


procedure get_periods_by_city(var l: TStringList; q: TADOQuery; code_city: integer);
var
  i: integer;
  rd_params: TReportDateOptions;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM periods WHERE id_city = '+ IntToStr(code_city)+
      ' ORDER BY date_b DESC');
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      rd_params := TReportDateOptions.Create;
      rd_params.id := FieldByName('id').AsInteger;
      rd_params.id_city := code_city;
      rd_params.report_date := FieldByName('date_b').AsDateTime;
      rd_params.description:= FieldByName('description').AsString;
      rd_params.state:= FieldByName('status').AsInteger;
      l.AddObject(FieldByName('date_b').AsString+'-'+
        FieldByName('status').AsString+'-'+
        FieldByName('description').AsString, rd_params);
      next;
    end;
  end;
end;

function get_city_by_id(q: TADOQuery; id: Integer): string;
begin
  Result := '';
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT name_rus, short_name FROM cities c '+
      'JOIN city_types ct ON ct.id=c.id_type '+
    ' WHERE c.id ='+IntToStr(id));
    Open;
    Result := FieldByName('short_name').AsString+' '+FieldByName('name_rus').AsString;
  end;
end;

function get_street_by_id(q: TADOQuery; id_city, id_street: Integer): string;
begin
  Result := '';
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT name, short_name FROM street_locations sl '+
      'JOIN street_types st ON st.id=sl.id_type '+
    ' WHERE sl.id ='+IntToStr(id_street)+' AND sl.id_city='+IntToStr(id_city));
    Open;
    Result := FieldByName('short_name').AsString+' '+FieldByName('name').AsString;
  end;
end;

procedure get_erc_code_owner_params_by_id_room(var l: TStringList; q: TADOQuery; id_room: integer);
var
  i:integer;
  payer_params: TERCCodeOwnerParams;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id_room_location='+Inttostr(id_room));
    Open;
    if recordcount>0 then begin
      First;
      for I := 0 to recordCount - 1 do begin
        payer_params := TERCCodeOwnerParams.Create;
        payer_params.id := FieldByName('id').AsInteger;
        payer_params.erc_code := FieldByName('code_erc').AsInteger;
        payer_params.id_room := FieldByName('id_room_location').AsInteger;
        payer_params.id_city := FieldByName('id_city').AsInteger;
        payer_params.fullName := FieldByName('full_name').AsString;
        l.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(payer_params));
        Next;
      end;
    end;
  end;
end;

procedure get_erc_code_owner_params_by_firm_and_bankbook(var l: TStringList;
  q: TADOQuery; firm: integer; bb: string);
var
  i:integer;
  payer_params: TERCCodeOwnerParams;
begin
  l.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id in '+
      '(SELECT id_human FROM bankbooks where code_firm='+
      Inttostr(firm)+' and bank_book='''+bb+''')');
    Open;
    if recordcount>0 then begin
      First;
      for I := 0 to recordCount - 1 do begin
        payer_params := TERCCodeOwnerParams.Create;
        payer_params.id := FieldByName('id').AsInteger;
        payer_params.erc_code := FieldByName('code_erc').AsInteger;
        payer_params.id_room := FieldByName('id_room_location').AsInteger;
        payer_params.id_city := FieldByName('id_city').AsInteger;
        payer_params.fullName := FieldByName('full_name').AsString;
        l.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(payer_params));
        Next;
      end;
    end;
  end;
end;

procedure update_code_erc(q: TADOQuery; erc_code, number_record, file_id: integer);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET code_erc='+
      IntToStr(erc_code)+' WHERE id_file='+
      IntToStr(file_id)+' AND record_number='+
      IntToStr(number_record));
    ExecSQL;
  end;
end;

procedure update_id_room_location(q: TADOQuery; id_room, number_record, file_id: integer);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET id_room_location='+
      IntToStr(id_room)+' WHERE id_file='+
      IntToStr(file_id)+' AND record_number='+
      IntToStr(number_record));
    ExecSQL;
  end;
end;

procedure set_record_as_correct(q: TADOQuery; number_record, file_id: integer);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET is_correct_record=1'+
      ' WHERE id_file='+IntToStr(file_id)+' AND record_number='+
      IntToStr(number_record));
    SQL.Add('DELETE FROM file_errors '+
      ' WHERE id_file='+IntToStr(file_id)+' AND record_number='+
      IntToStr(number_record));
    ExecSQL;
  end;
end;

procedure set_record_as_incorrect(q: TADOQuery; number_record, file_id: integer);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET is_correct_record=0'+
      ' WHERE id_file='+IntToStr(file_id)+' AND record_number='+
      IntToStr(number_record));
    ExecSQL;
  end;
end;

function get_active_period_by_city_id(q: TADOQuery; city_id: integer): integer;
begin
  Result := 0;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM periods WHERE status=1 AND id_city='+IntToStr(city_id));
    Open;
    first;
    Result := FieldByName('id').AsInteger;
  end;
end;

procedure get_debt_options_by_firm_utility_bankbook(var dp: TDebtOptions; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount: string);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbook_attributes_debts d '+
      'JOIN bankbook_utilities bu ON bu.id=d.id_bankbook_utility and bu.code_utility='+
      utility_id+
      ' join bankbooks bb on bb.id=bu.id_bankbook and bb.code_firm='+
      firm_id+' and bb.bank_book='+abcount+
    ' WHERE id_period='+Inttostr(period_id));
    open;
    if RecordCount > 0 then begin
      dp := TDebtOptions.Create;
      dp.id_bankbook_utility := FieldByName('id_bankbook_utility').AsInteger;
      dp.period_id := FieldByName('id_period').AsInteger;
      dp.address_id := FieldByName('id_room_location').AsInteger;
      dp.debt_date := FieldByName('date_dolg').AsDateTime;
      dp.debt_total := FieldByName('sum_dolg').AsFloat;
      dp.month_sum := FieldByName('sum_month').AsFloat;
      dp.normal_sum := FieldByName('sum_isp').AsFloat;
      dp.month_count := FieldByName('month_count').AsInteger;
      dp.last_count := FieldByName('end_count').AsInteger;
    end;
  end;
end;

procedure get_human_options_by_firm_bankbook(var hp: TPayerOptions; q: TADOQuery;
  period_id: integer; firm_id, abcount: string);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbook_attributes_humans h '+
      ' join bankbooks bb on bb.id=h.id_bankbook and bb.code_firm='+
      firm_id+' and bb.bank_book='+abcount+
    ' WHERE h.id_period='+Inttostr(period_id));
    open;
    if RecordCount > 0 then begin
      hp.bankbook_id := FieldByName('id_bankbook').AsInteger;
      hp.period_id := FieldByName('id_period').AsInteger;
      hp.period_begin_id := FieldByName('id_period_begin').AsInteger;
      hp.full_name := ANSIUpperCase(FieldByName('full_name').AsString);
      hp.owner_full_name := ANSIUpperCase(FieldByName('full_name_owner').AsString);
      hp.phone := FieldByName('phone').AsString;
      hp.resident_number := FieldByName('resident_number').AsInteger;
    end else begin
      hp.bankbook_id := 0;
      hp.period_id := period_id;
      hp.period_begin_id := 0;
      hp.full_name := ANSIUpperCase('НЕ НАЙДЕНЫ');
      hp.owner_full_name := ANSIUpperCase('НЕ НАЙДЕНЫ');
      hp.phone := 'НЕ НАЙДЕН';
      hp.resident_number := 0;
    end;
  end;
end;

procedure get_room_options_by_firm_bankbook(var rp: TRoomOptions; q: TADOQuery;
  period_id: integer; firm_id, abcount: string);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbook_attributes_rooms r '+
      ' join bankbooks bb on bb.id=r.id_bankbook and bb.code_firm='+
      firm_id+' and bb.bank_book='+abcount+
    ' WHERE r.id_period='+Inttostr(period_id));
    open;
    if RecordCount > 0 then begin
      rp.bankbook_id := FieldByName('id_bankbook').AsInteger;
      rp.id_period := FieldByName('id_period').AsInteger;
      rp.id_period_begin := FieldByName('id_period_begin').AsInteger;
      rp.number_rooms := FieldByName('one_roomed_flat').AsInteger;
      rp.is_lift := FieldByName('lift').AsBoolean;
      rp.date_privatization := FieldByName('date_privatization').AsDateTime;
      rp.form_property := FieldByName('form_property').AsInteger;
      rp.total_area := FieldByName('total_area').AsFloat;
      rp.heat_area := FieldByName('heat_area').AsFloat;
      rp.quota_area := FieldByName('quota_area').AsFloat;
      rp.counter_state := FieldByName('calc_device').AsInteger;
      rp.date_calc_device := FieldByName('date_calc_device').AsDateTime;
      rp.boiler := FieldByName('boiler').AsInteger;
      rp.water_heater := FieldByName('water_heater').AsInteger;
      rp.heat_type := FieldByName('type_heating').AsInteger;
      rp.change_heat_date := FieldByName('date_heating').AsDateTime;
    end else begin
    end;
  end;
end;

procedure get_tarif_options_by_firm_utility_bankbook(var tp: TTarifParams; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount: string);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbook_attributes_tarifs t '+
      'JOIN bankbook_utilities bu ON bu.id=t.id_bankbook_utility and bu.code_utility='+
      utility_id+
      ' join bankbooks bb on bb.id=bu.id_bankbook and bb.code_firm='+
      firm_id+' and bb.bank_book='+abcount+
    ' WHERE t.id_period='+Inttostr(period_id));
    open;
    if RecordCount > 0 then begin
      tp.id_bankbook_utility := FieldByName('id_bankbook_utility').AsInteger;
      tp.period_id := FieldByName('id_period').AsInteger;
      tp.period_begin_id := FieldByName('id_period_begin').AsInteger;
      tp.watercharge := FieldByName('watercharge').AsFloat;
      tp.wc_change_date := FieldByName('date_wc').AsDateTime;
      tp.tarif := FieldByName('tarif').AsFloat;
      tp.real_tarif := FieldByName('tarif_f').AsFloat;
    end;
  end;
end;

procedure get_addr_params_by_firm_bankbook(var address_params: TAddressParams;
  q: TADOQuery; code_firm, bank_book: string);
var
  key: string;
begin
  try
    with q do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM room_locations rl '+
        'JOIN rooms r ON r.id=rl.id_room '+
        ' WHERE rl.id = '+
        '(SELECT id_room_location FROM humans h WHERE h.id = '+
          '(SELECT id_human FROM bankbooks WHERE code_firm = '+code_firm+
          ' AND bank_book = '''+bank_book+'''))');
      Open;
      address_params.n_room := FieldByName('n_room').AsInteger;
      address_params.a_room := FieldByName('a_room').AsString;
      key := FieldByName('id_house_location').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM house_locations hl '+
        'JOIN houses h ON h.id=id_house '+
        ' WHERE hl.id ='+key);
      Open;
      address_params.n_house := FieldByName('n_house').AsInteger;
      address_params.f_house := FieldByName('f_house').AsInteger;
      address_params.a_house := FieldByName('a_house').AsString;
      address_params.d_house := FieldByName('d_house').AsInteger;
      key := FieldByName('id_street_location').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM street_locations sl '+
        'JOIN street_mappings sm ON sm.id_street_location=sl.id '+
        ' WHERE sl.id ='+key);
      Open;
      address_params.street_code := FieldByName('id').AsInteger;
      address_params.local_street_code := FieldByName('code_street_outer').AsInteger;
      address_params.street_name := FieldByName('name').AsString;
      address_params.city_id := FieldByName('id_city').AsInteger;
      key := FieldByName('id_city').AsString;
      SQL.Clear;
      SQL.Add('SELECT * FROM cities '+
        'JOIN city_mappings sm ON sm.id_city=id '+
        ' WHERE id ='+key);
      Open;
      address_params.city_name := FieldByName('name_rus').AsString;
      address_params.local_city_id := FieldByName('code_city_outer').AsInteger;
      close;
    end;
  Except
  end;
end;

procedure get_privelege_options_by_firm_utility_bankbook(pp: TPrivilege; q: TADOQuery;
  period_id: integer; firm_id, utility_id, abcount:string);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbook_attributes_lgots l '+
      'JOIN bankbook_utilities bu ON bu.id=l.id_bankbook_utility and bu.code_utility='+
      utility_id+
      ' join bankbooks bb on bb.id=bu.id_bankbook and bb.code_firm='+
      firm_id+' and bb.bank_book='+abcount+
    ' WHERE id_period='+Inttostr(period_id));
    Open;
    if RecordCount > 0 then begin
      with pp do begin
        id_bankbook_utility := FieldByName('id_bankbook_utility').AsInteger;
        period_id := FieldByName('id_period').AsInteger;
        period_begin_id := FieldByName('id_period_begin').AsInteger;
        sum_01122006 := FieldByName('sum_01122006').AsFloat;
        pact_date := FieldByName('date_dog').AsDateTime;
        pact_number := FieldByName('num_dog').AsString;
        debt_sum_restruct := FieldByName('sum_dolg_dog').AsFloat;
        subsidy := FieldByName('subs').AsFloat;
        subsidy_date := FieldByName('date_subs').AsDateTime;
        privilege1_code := FieldByName('code_lg1').AsInteger;
        privilege1_users := FieldByName('count_tn_lg1').AsInteger;
        privilege1_category := FieldByName('kat_lg1').AsInteger;
        privilege1_date := FieldByName('date_lg1').AsDateTime;
        privilege1_doc := FieldByName('doc_lg_vid1').AsString;
        privilege1_doc_number := FieldByName('doc_lg_num1').AsString;
        privilege1_doc_who := FieldByName('doc_lg_v1').AsString;
        privilege1_doc_date := FieldByName('doc_lg_d1').AsDateTime;
        privilege1_percent := FieldByName('rate_lg1').AsFloat;
      end;
    end;
    Close;
  end;
end;

procedure get_debts_by_bankbook(var TempList: TStringList; q: TADOQuery;
  id_bankbook_utility: integer);
var
  i: integer;
  debt_params: TDebtOptions;
begin
  with q do begin
    SQL.Clear;
    SQL.Add(
      'SELECT * FROM bankbook_attributes_debts '+
        'JOIN periods p ON p.id=id_period '+
        'WHERE id_bankbook_utility = '+
        IntToStr(id_bankbook_utility));
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      debt_params := TDebtOptions.Create;
      debt_params.id_bankbook_utility := id_bankbook_utility;
      debt_params.period_id := FieldByName('id_period').AsInteger;
      debt_params.period_description := FieldByName('description').AsString;
      debt_params.period_state := FieldByName('status').AsInteger;
      debt_params.address_id := FieldByName('id_room_location').AsInteger;
      debt_params.debt_date := FieldByName('date_dolg').AsDateTime;
      debt_params.debt_total := FieldByName('sum_dolg').AsFloat;
      debt_params.month_sum := FieldByName('sum_month').AsFloat;
      debt_params.normal_sum := FieldByName('sum_isp').AsFloat;
      debt_params.month_count := FieldByName('month_count').AsInteger;
      debt_params.last_count := FieldByName('end_count').AsInteger;
      TempList.AddObject(FieldByName('sum_dolg').AsString+'грн. на '+
        FieldByName('date_dolg').AsString+'-'+
        FieldByName('status').AsString+'-'+
        FieldByName('description').AsString, TObject(debt_params));
      next;
    end;
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

procedure get_street_id_list_by_city(var l: TStringList; q: TADOQuery; id: integer);
var
  i: integer;
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
      l.AddObject(FieldByName('name').AsString+' '+
        FieldByName('type').AsString, TObject(FieldByName('id').AsInteger));
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

//end;
//procedure create_new_bankbook_utility(q: TADOQuery;);
//begin
//
//end;
end.
