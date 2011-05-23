unit verify_data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  db_service, ADODB, DB, IniFiles,
  DBTables,
  StrUtils,
  RegExpr,
  StdCtrls, ComCtrls, Dialogs; //, Dialogs;

type
  TErrorInfo = class(TObject)
    number_record: integer;
    error_code: integer;
  end;

type
  TRegistrationData = class(TObject)
    id_file: integer;
    id_city: integer;
    id_firm: integer;
  end;

type
  TWarningInfo = class(TObject)
    number_record: integer;
    field_name: string;
    db_value: string;
    code: integer;
  end;

type
  TAboutFile = record
    name: string;
    size: integer;
    file_date_create: Extended;
    file_date_operate: Extended;
  end;

type
  TFormMain = class(TForm)
    DTPReportDate: TDateTimePicker;
    Label1: TLabel;
    CBCities: TComboBox;
    Label2: TLabel;
    BInputOpen: TButton;
    ODInputData: TOpenDialog;
    protocol: TMemo;
    Label3: TLabel;
    LBWarnings: TListBox;
    BStats: TButton;
    BLoad: TButton;
    LBInputFiles: TListBox;
    Label5: TLabel;
    CBErrors: TComboBox;
    Label6: TLabel;
    CBTemplateRules: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    CBTemplateCity: TComboBox;
    Label9: TLabel;
    CBTemplateStreet: TComboBox;
    BNewAddresses: TButton;
    BCheckData: TButton;
    BCheckBB: TButton;
    BAdaptCodeERC: TButton;
    BSearchFiles: TButton;
    BSave: TButton;
    BAnalyze: TButton;
    GB: TGroupBox;
    SB: TScrollBox;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    CBPeriods: TComboBox;
    BClearUnnecessary: TButton;
    BTempDataDelete: TButton;
    CBShortControl: TCheckBox;
    BForLoad: TButton;
    ADOConnectionMain: TADOConnection;
    BLoadingState: TButton;
    LActivePeriod: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DTPReportDateChange(Sender: TObject);
    procedure BInputOpenClick(Sender: TObject);
    procedure LBWarningsDblClick(Sender: TObject);
    procedure CBErrorsSelect(Sender: TObject);
    procedure BStatsClick(Sender: TObject);
    procedure CBTemplateRulesSelect(Sender: TObject);
    procedure CBTemplateStreetSelect(Sender: TObject);
    procedure CBTemplateCitySelect(Sender: TObject);
    procedure BNewAddressesClick(Sender: TObject);
    procedure BCheckDataClick(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
    procedure BCheckBBClick(Sender: TObject);
    procedure BAdaptCodeERCClick(Sender: TObject);
    procedure BSearchFilesClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BAnalyzeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BClearUnnecessaryClick(Sender: TObject);
    procedure BTempDataDeleteClick(Sender: TObject);
    procedure BForLoadClick(Sender: TObject);
    procedure BLoadingStateClick(Sender: TObject);
  private
    ADO_sp: TADOStoredProc;
    ADO_ds: TADODataSet;
    ADO_q: TADOQuery;
    return_code: integer;
    input_file_stats: TAboutFile;
    QInputData: TADOQuery;
    input_records: integer;
    added_records: integer;
    number_wrong_records: integer;
    number_warning_records: integer;
    firm_code_list: TStringList;
    warning: TWarningInfo;
    warning_records: TStringList;
    selected_error_code: integer;
    error_codes: string;
    periods :TStringList;
    is_empty: boolean;
    procedure Init;
//    procedure SaveResult;
    procedure show_record_by_num(n: integer);
    procedure CheckData;
    procedure save_wrong_records;
    procedure buttons_state_change(val: boolean);
  public
    { Public declarations }
    report_date_params: TReportDateOptions;
    procedure update_warnings;
    procedure to_protocol(s: string);
  end;

var
  FormMain: TFormMain;
  Settings: TIniFile;
  connection_string: string;
  log_in: string;
  pw: string;
  mode: integer;
  format_date: string = 'mm.dd.yyyy';
  format_date_time: string = 'mm.dd.yyyy h:n:s';
  current_record_num: integer;
  loading_params: TLoadingParams;
  is_problem : boolean = false;
  is_update_statistics: integer = 0;

implementation
uses
  view_info, ErrorAnalyzer, login, loading, LoadState;
{$R *.dfm}

procedure TFormMain.BAdaptCodeERCClick(Sender: TObject);
begin
  buttons_state_change(false);
  to_protocol('Начат подбор кодов ЕРЦ.');
  with ADO_sp do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_autofillingErcCode_byAddress;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_File', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@id_city', ftinteger, pdInput, 10, loading_params.main_city_id);
    Parameters.CreateParameter('@id_period', ftinteger, pdInput, 10,
      TReportDateOptions(periods.Objects[CBPeriods.ItemIndex]).id);
    ExecProc;
    to_protocol('Подобрано кодов: '+
      IntToStr(Parameters.ParamByName('@result_value').Value));
  end;
  to_protocol('Окончен подбор кодов ЕРЦ.');
  buttons_state_change(true);
end;

procedure TFormMain.BAnalyzeClick(Sender: TObject);
var
  getRes: Boolean;
begin
  getRes := false; //true;
  with ADO_sp do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_setBOCorrectRecord;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_File', ftinteger, pdInput, 10,
      loading_params.reg_record_id);
    Parameters.CreateParameter('@getResult', ftBoolean, pdInput, 10, getRes);
    ExecProc;
    Close;
  end;

//  if not FormMain.Visible then
//    FormMain.show;
  FormErrorAnalyzer.Show;
end;

procedure TFormMain.BCheckBBClick(Sender: TObject);
//var
//  i: integer;
{
function convert_bb(bb, picture: string): string;
begin
  while pos('-0', bb)>0 do
    bb := AnsiReplaceStr(bb, '-0','-');
  result := bb
end;
}
begin
//  with ADO_q do begin
//    SQL.Clear;
//    sql.add(
//      'if exists '+
//      '(select * from dbo.sysobjects '+
//      'where id = object_id(N''[dbo].[bankbook_mapping]'') '+
//      'and OBJECTPROPERTY(id, N''IsUserTable'') = 1) '+
//      'truncate table [dbo].[bankbook_mapping] ');
//    ExecSQL;
//    Close;
//
//    SQL.Clear;
//    sql.add('SELECT abcount FROM utilityfiles_bo WHERE id_file='+
//      IntToStr(loading_params.reg_record_id)+
//      ' AND record_number in '+
//      '(SELECT record_number FROM file_errors WHERE id_file='+
//      IntToStr(loading_params.reg_record_id)+
//      ' AND id_error=101)');
//    open;
//    first;
//    qq := TADOQuery.Create(self);
//    qq.ConnectionString := connection_string;
//    protocol.Lines.Add(TimeToStr(now)+'; Начато преобразование счетов.');
//    for I := 0 to RecordCount - 1 do begin
//      qq.SQL.Clear;
//      qq.SQL.Add('INSERT INTO bankbook_mapping VALUES('+
//        IntToStr(loading_params.reg_record_id)+', '''+
//        FieldByName('abcount').AsString+''', '''+
//        convert_bb(FieldByName('abcount').AsString, '')+''', '+
//        IntToStr(loading_params.firm_id)+', '+
//        IntToStr(loading_params.firm_id)+')');
//      qq.ExecSQL;
//      next;
//    end;
//    qq.Close;
//    qq.Free;
//    protocol.Lines.Add(TimeToStr(now)+'; Окончено преобразование счетов.');
//  end;
//
//  protocol.Lines.Add(TimeToStr(now)+'; Начат контоль счетов.');
//  with ADO_sp do begin
//    ProcedureName := 'up_addBankbooksByMappingFile;1';
//    Parameters.Clear;
//    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
//    Parameters.CreateParameter('@file_id', ftinteger, pdInput, 10, loading_params.reg_record_id);
//    ExecProc;
//    Close;
//  end;
//  protocol.Lines.Add(TimeToStr(now)+'; Окончен контоль счетов.');

end;


procedure TFormMain.BCheckDataClick(Sender: TObject);
begin
  if Application.MessageBox('Очистить заполненные на предыдущем шаге поля?',
       PChar(caption), MB_YESNO+MB_ICONQUESTION) = IDYES then
    is_empty := true
  else
    is_empty := false;

  CheckData;
  BStatsClick(Sender);
end;

procedure TFormMain.BInputOpenClick(Sender: TObject);
var
  i: integer;
  vf: file;
  ext: string;
  file_name: string;
//  RegExp: TRegExpr;

function registre_input_file:integer;
begin
  with ADO_q do begin
    SQL.Clear;
    SQL.Add('INSERT INTO file_registrations '+
      '(file_name, file_size, file_date, date_reg, id_city, code_firm, id_type, id_status) VALUES '+
      '('''+input_file_stats.name+''', '+IntToStr(input_file_stats.size)+
      ', '''+FormatDateTime(format_date_time,input_file_stats.file_date_create)+''', '''+
      FormatDateTime(format_date_time,now)+''', '+IntToStr(loading_params.main_city_id)+', '+
      IntToStr(loading_params.firm_id)+', 6, 0)');
    ExecSQL;
    SQL.Clear;
    SQL.Add('SELECT TOP 1 id FROM file_registrations WHERE id_type = 6 AND file_name = '''+
      input_file_stats.name+''' ORDER BY id DESC');
    Open;
    result := Fields[0].AsInteger;
  end;
end;

procedure check_old_data(fn: string; firm_id: integer);
var
  s: string;
begin
  with ADO_q do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    SQL.Clear;
    SQL.Add('SELECT * FROM file_registrations '+
     ' WHERE id_type=6 AND code_firm='+IntToStr(firm_id));
//     ' WHERE file_name LIKE '''+copy(fn, 1, pos('.', fn))+'%''');
    open;
    if not eof then begin
      s := 'Удалить из буфера загруженные ранее данные из файла '+PChar(fn)+'?';
      if Application.MessageBox(PChar(s),
        PChar(caption), MB_YESNO+MB_ICONQUESTION) = IDYES then
        while not eof do begin
          with ADO_sp do begin
            CursorLocation := clUseServer;
            CursorType := ctOpenForwardOnly;
            ProcedureName := 'up_deleteFileInfo;1';
            Parameters.Clear;
            Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
            Parameters.CreateParameter('@file_id', ftinteger, pdInput, 10,
              ADO_q.FieldByName('id').AsInteger);
            ExecProc;
            Close;
          end;
          to_protocol('Удалены записи файла '+
            ADO_q.FieldByName('file_name').AsString+' за '+
            ADO_q.FieldByName('date_reg').AsString+';');
          next;
        end;
    end;
  end;
end;

//=============================================================================
begin
  is_empty := true;
  return_code := 0;
  protocol.Clear;
  protocol.Lines.Clear;
  protocol.update;
  LBWarnings.Clear;
  check_old_data(input_file_stats.name, loading_params.firm_id);
  loading_params.reg_record_id := registre_input_file();
  to_protocol('Начало обработки файла(ов) по организации '+
    IntToStr(loading_params.firm_id)+
    '; отчетная дата '+DateToStr(loading_params.report_date)+';');
  update_templates_by_firm(ado_q, loading_params);
  added_records := 0;
  number_wrong_records := 0;
  number_warning_records := 0;
  warning_records.Clear;
  for I := 0 to LBInputFiles.Count - 1 do begin
    to_protocol('Чтение данных из файла '+
      LBInputFiles.Items[i]+';');
    file_name := ExtractFilePath(ODInputData.FileName)+LBInputFiles.Items[i];
    ext := ExtractFileExt(LBInputFiles.Items[i]);
    LBInputFiles.Items[i] := ChangeFileExt(LBInputFiles.Items[i], '.dbf');
    AssignFile(Vf, file_name);
    file_name := ChangeFileExt(file_name, '.dbf');
    Rename(Vf, file_name);
    with ADO_sp do begin
      CursorLocation := clUseServer;
      CursorType := ctOpenForwardOnly;
      ProcedureName := 'up_loadFileByTemplate;1';
      Parameters.Clear;
      Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
      Parameters.CreateParameter('@file_id', ftinteger, pdInput, 10, loading_params.reg_record_id);
      Parameters.CreateParameter('@id_template', ftinteger, pdInput, 10, loading_params.rules_template_id);
      Parameters.CreateParameter('@file_path', ftstring, pdInput, 100, ExtractFilePath(ODInputData.FileName));
      Parameters.CreateParameter('@file_name', ftstring, pdInput, 20, LBInputFiles.Items[i]);
      ExecProc;
      Close;
    end;
    file_name := ChangeFileExt(file_name, ext);
    LBInputFiles.Items[i] := ChangeFileExt(LBInputFiles.Items[i], ext);
    Rename(Vf, file_name);
//    CloseFile(vf);
  end;

  input_records := get_record_count(ADO_q, loading_params.reg_record_id);

  to_protocol('Принято записей '+
    IntToStr(input_records)+';');
  CheckData;
//  BStats.Enabled := true; //loading_params.reg_record_id >0;
//  BAdaptCodeERC.Enabled := True;
//  BNewAddresses.Enabled := true;
//  BCheckData.Enabled := true;
//  BAnalyze.Enabled := true;
//  BSave.Enabled := true;
//  BCheckBB.Enabled := true;
  BStatsClick(Sender);
end;

procedure TFormMain.BLoadClick(Sender: TObject);
begin
  FormLoading.ShowModal;
end;

procedure TFormMain.CheckData;
begin
  BStats.Enabled := false;
  BCheckData.Enabled := false;
  buttons_state_change(false);
  Application.ProcessMessages;
  to_protocol('Начата подготовка входных данных к контролю.');
  ADO_sp.CommandTimeout := 10000;
  with ADO_sp do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_preauditUtilityFiles_bo;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@id_city_template', ftinteger, pdInput, 10, loading_params.city_template_id);
    Parameters.CreateParameter('@id_street_template', ftinteger, pdInput, 10, loading_params.street_template_id);
    Parameters.CreateParameter('@is_code_firmKIS', ftBoolean, pdInput, 10, true); //false);
    Parameters.CreateParameter('@is_preauditfieldempty', ftBoolean, pdInput, 10, is_empty);
    ExecProc;
    Close;
  end;
  to_protocol('Закончена подготовка входных данных к контролю.');
  to_protocol('Начат контроль данных.');

  ADO_sp.CommandTimeout := 10000;
  with ADO_sp do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_verifyUtlityFiles_bo;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@is_short_control', ftBoolean, pdInput, 10, CBShortControl.Checked); //false);
    ExecProc;
    Close;
  end;
  to_protocol('Окончен контроль данных.');

  LBWarnings.Clear;

  input_records := get_record_count(ADO_q, loading_params.reg_record_id);
//  BForLoad.Enabled := True;
    buttons_state_change(true);
  BCheckData.Enabled := true;
  BStats.Enabled := true;
//  BTempDataDelete.Enabled := true;
end;


procedure TFormMain.update_warnings;
var
  s:string;
  q: TADOQuery;
begin
  LBWarnings.Clear;
  q := TADOQuery.Create(self);
  q.Connection := ADOConnectionMain;


  with ADO_q do begin
//    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    SQL.Clear;
    if selected_error_code=0 then
      sql.add('SELECT bo.code_firme, '+
        'bo.date_dolg, '+
        'bo.code_plat, '+
        'bo.code_c, '+
        'bo.code_s, '+
        'bo.one_roomed_flat, '+
        'bo.lift, '+
        'bo.date_privatization, '+
        'bo.form_property, '+
        'bo.total_area, '+
        'bo.heat_area, '+
        'bo.quota_area, '+
        'bo.calc_device, '+
        'bo.date_calc_device, '+
        'bo.boiler, '+
        'bo.water_heater, '+
        'bo.watercharge, '+
        'bo.date_wc, '+
        'bo.type_heating, '+
        'bo.date_dog, '+
        'bo.date_lg1, '+
        'bo.n_house, '+
        'bo.f_house, '+
        'bo.d_house, '+
        'bo.a_house, '+
        'bo.n_room, '+
        'bo.a_room, '+
        'bo.abcount, '+
        'bo.record_number, '+
        'bo.id_file, '+
        ' e.description, fe.record_number, fe.id_error, fe.description field FROM file_errors fe'+
        ' JOIN errors e ON fe.id_error=e.code AND id_software=2 AND error_type <> 2'+
        ' JOIN utilityfiles_bo bo ON bo.record_number=fe.record_number and bo.id_file='+
        IntToStr(loading_params.reg_record_id)+
        ' WHERE fe.id_file='+
        IntToStr(loading_params.reg_record_id)+
        ' ORDER BY fe.record_number')
    else
      sql.add('SELECT bo.*, e.description, fe.record_number, fe.id_error, fe.description field FROM file_errors fe'+
        ' JOIN errors e ON fe.id_error=e.code AND id_software=2  AND error_type <>2 '+
        ' JOIN utilityfiles_bo bo ON bo.record_number=fe.record_number and bo.id_file='+
        IntToStr(loading_params.reg_record_id)+
        ' WHERE fe.id_file='+
        IntToStr(loading_params.reg_record_id)+' AND id_error='+
        Inttostr(selected_error_code)+
        ' ORDER BY fe.record_number');
    to_protocol('Начат выбор ошибок.');
    open;
    to_protocol('Окончен выбор ошибок.');
    LBWarnings.Items.Clear;
    while not EOF do begin
      warning := TWarningInfo.Create;
      warning.number_record := FieldByName('record_number').AsInteger;
      s := 'Запись № '+FieldByName('record_number').AsString+'; Ошибка № '+
        FieldByName('id_error').AsString+' - '+
        FieldByName('description').AsString+' '+FieldByName('field').AsString+ '; ';
      case FieldByName('id_error').AsInteger of
        1:  //Код организации отсутствует в справочнике ЕРЦ
          s := s + '"'+FieldByName('code_firme').AsString+'"';
        2: //Ошибка в отчетной дате
          s := s + '"'+FieldByName('date_dolg').AsString+'"';
        3: //Код платежа отсутствует в справочнике ЕРЦ
          s := s + '"'+FieldByName('code_plat').AsString+'"';
        4: //Код города отсутствует в справочнике ЕРЦ
          s := s + '"'+FieldByName('code_c').AsString+'"';
        5: //Код улицы отсутствует в справочнике ЕРЦ
          s := s + '"'+FieldByName('code_s').AsString+'"';
        6: //Недопустимое значение в поле Признак однокомнатной квартиры
          s := s + '"'+FieldByName('one_roomed_flat').AsString+'"';
        7: //Недопустимое значение в поле Наличие лифта в расчете квартплаты
          s := s + '"'+FieldByName('lift').AsString+'"';
        8: //Ошибка в дате приватизации
          s := s + '"'+FieldByName('date_privatization').AsString+'"';
        9: //Недопустимое значение в поле Форма собственности
          s := s + '"'+FieldByName('form_property').AsString+'"';
        10: //Недопустимое значение в поле Общая площадь жилья
          s := s + '"'+FieldByName('total_area').AsString+'"';
        11: //Недопустимое значение в поле Отапливаемая площадь жилья
          s := s + '"'+FieldByName('heat_area').AsString+'"';
        12: //Недопустимое значение в поле Площадь жилья в пределах норм использования
          s := s + '"'+FieldByName('quota_area').AsString+'"';
        13: //Недопустимое значение в поле Наличие прибора учета
          s := s + '"'+FieldByName('calc_device').AsString+'"';
        14: //Недопустимое значение в поле Дата установки/снятия прибора учета
          s := s + '"'+FieldByName('date_calc_device').AsString+'"';
        15: //Недопустимое значение в поле Наличие бойлера
          s := s + '"'+FieldByName('boiler').AsString+'"';
        16: //Недопустимое значение в поле Наличие колонки по проекту
          s := s + '"'+FieldByName('water_heater').AsString+'"';
        17: //Недопустимое значение в поле Норма потребления воды
          s := s + '"'+FieldByName('watercharge').AsString+'"';
        18: //Недопустимое значение в поле Дата изменения нормы потребления воды
          s := s + '"'+FieldByName('date_wc').AsString+'"';
        19: //Недопустимое значение в поле Тип отопления
          s := s + '"'+FieldByName('type_heating').AsString+'"';
        20: //Недопустимое значение в поле Дата изменения типа отопления
          s := s + '"'+FieldByName('type_heating').AsString+'"';
        21: //Недопустимое значение в поле Дата договора на реструктуризацию долга
          s := s + '"'+FieldByName('date_dog').AsString+'"';
        22: //Недопустимое значение в поле Дата предоставления/снятия 1-й льготы
          s := s + '"'+FieldByName('date_lg1').AsString+'"';
        102: begin//Адрес не найден в базе
          s := s + '"'+get_full_address(q, FieldByName('code_c_corr').AsString,
            FieldByName('code_s_corr').AsString,
            FieldByName('n_house').AsString,
            FieldByName('f_house').AsString,
            FieldByName('d_house').AsString,
            FieldByName('a_house').AsString,
            FieldByName('n_room').AsString,
            FieldByName('a_room').AsString)+'"';
        end;
        107: //Некорректный дом
          s := s + '"'+FieldByName('n_house').AsString+'-'+
            FieldByName('f_house').AsString+'/'+
            FieldByName('d_house').AsString+
            FieldByName('a_house').AsString+'"';
        108: //Некорректная квартира
          s := s + '"'+FieldByName('n_room').AsString+
            FieldByName('a_room').AsString+'"';
        109: //Код платежа не соответствует коду организации
          s := s + '"'+FieldByName('code_firme').AsString+'->'+
            FieldByName('code_plat').AsString+'"';
        101: //Лицевой счет не найден в базе
          s := s + '"'+FieldByName('abcount').AsString+'"';
      end;
      LBWarnings.Items.AddObject(s, warning);
      next;
    end;
    to_protocol('Создан список ошибок.');
    Close;
  end;
  q.Close;
  q.Free;
end;

procedure TFormMain.BStatsClick(Sender: TObject);
var
  q: TADOQuery;
  shifter: integer;
  total_records: integer;
begin
  to_protocol('СТАТИСТИКА');
  q := TADOQuery.Create(self);
  total_records := 0;
  with q do begin
    Connection := ADOConnectionMain;
    CursorLocation := clUseServer;
    SQL.Clear;
    SQL.Add('SELECT count(distinct record_number) count FROM file_errors '+
      ' WHERE id_file='+Inttostr(loading_params.reg_record_id)+
      ' AND id_error IN '+
        '(SELECT code FROM errors WHERE id_software=2 AND error_type <> 2 AND importance=2)');
    open;
    number_wrong_records := FieldByName('count').AsInteger;
    protocol.Lines.Add('Всего записей - '+InttoStr(input_records));
    if input_records>0 then
      protocol.Lines.Add('Ошибочных записей - '+
        FieldByName('count').AsString+' или в процентах '+
        FloatToStrF(FieldByName('count').AsInteger*100/input_records, ffFixed, 18, 2));

    SQL.Clear;
    SQL.Add('SELECT fe.id_error id_error, e.description description, '+
      'count(fe.id_error) count, e.importance importance FROM file_errors fe '+
      'JOIN errors e ON fe.id_error=e.code AND e.id_software=2 AND e.error_type <> 2'+
    ' WHERE id_file='+Inttostr(loading_params.reg_record_id)+
    ' GROUP BY fe.id_error, e.description,'+
    ' e.importance ORDER BY e.importance DESC');
    Open;
    shifter := 3;
    while not EOF do begin
      if FieldByName('importance').AsInteger<>shifter  then begin
        protocol.Lines.Add('----------------------------------------------');
        shifter := FieldByName('importance').AsInteger
      end;
      protocol.Lines.Add('Ошибка № '+
        FieldByName('id_error').AsString+' ('+FieldByName('description').AsString+') - '+
        FieldByName('count').AsString);
      next;
    end;
  end;
  q.Free;

  protocol.Lines.Add('============================================================');
  with ADO_sp do begin
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_getFileBOCompareStatistic;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@id_city', ftinteger, pdInput, 10, loading_params.main_city_id);
    Open;
    if not eof then begin
      ADO_ds.Recordset := Recordset;
      total_records := ADO_ds.FieldByName('count_bo').AsInteger;
      protocol.Lines.Add('Количество входных записей - '+
        ADO_ds.FieldByName('count_bo').AsString);
      protocol.Lines.Add('Количество записей в предыдущем месяце - '+
        ADO_ds.FieldByName('count_active').AsString);
      protocol.Lines.Add('Количество лицевых счетов - '+
        ADO_ds.FieldByName('count_bankbook_bo').AsString);
      protocol.Lines.Add('Количество лицевых счетов в предыдущем месяце - '+
        ADO_ds.FieldByName('count_bankbook_active').AsString);
      protocol.Lines.Add('Количество адресов - '+
        ADO_ds.FieldByName('count_adress_bo').AsString);
      protocol.Lines.Add('Количество адресов в предыдущем месяце - '+
        ADO_ds.FieldByName('count_adress_active').AsString);
    end;
    Close;
  end;

  with ADO_sp do begin
      CursorLocation := clUseServer;
      CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_setBOCorrectRecord;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@getResult', ftBoolean, pdInput, 10, 1);
    Open;
    if not eof then begin
      ADO_ds.Recordset := Recordset;
      protocol.Lines.Add('Будет загружено записей - '+
        ADO_ds.Fields[0].AsString);
      protocol.Lines.Add('Отвергнуто записей - '+
        IntToStr(total_records - ADO_ds.Fields[0].AsInteger));
    end;
    Close;
  end;

end;

procedure TFormMain.BTempDataDeleteClick(Sender: TObject);
begin
  to_protocol('Начато удаление данных о текущем файле;');
  with ADO_sp do begin
      CursorLocation := clUseServer;
      CursorType := ctOpenForwardOnly;
    ProcedureName := 'up_clearUnnecessary;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    ExecProc;
    Close;
  end;
  to_protocol('Окончено удаление данных о текущем файле.');
  BTempDataDelete.Enabled := false;
end;

procedure TFormMain.Button1Click(Sender: TObject);
var
  i: integer;
begin
  GB.Hide;
  error_codes := '';
  for I := ComponentCount-1 downto 0 do begin
    if (Components[i] is TCheckBox) and (TCheckBox(Components[i]).name <> 'CBShortControl') then begin
      if (TCheckBox(Components[i]).Checked) then
        error_codes := error_codes+IntToStr(TCheckBox(Components[i]).tag)+', ';
      Components[i].Free;
    end;
  end;
  if error_codes<>'' then begin
    error_codes := copy(error_codes, 1, length(error_codes)-2);
    error_codes := ' and fe.id_error in ('+error_codes+') ';
    save_wrong_records;
  end else begin
//    WrongRecordsTabl.Active := false;
//    WrongRecordsTabl.e ;
  end;
end;

procedure TFormMain.Button2Click(Sender: TObject);
var
  i: integer;
begin
  error_codes := '';
  GB.Hide;
  for I := ComponentCount-1 downto 0 do
    if Components[i] is TCheckBox then
      Components[i].Free;
//  WrongRecordsTabl.Active := false;
//  WrongRecordsTabl.;
end;

procedure TFormMain.BLoadingStateClick(Sender: TObject);
begin
  to_protocol('Начат сбор данных о загрузке;');
  with ADO_sp do begin
    CursorLocation := clUseClient; // UseServer;
    CursorType := ctDynamic; // ctOpenForwardOnly;
    ProcedureName := 'up_testingLoad;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_city', ftinteger, pdInput, 10, loading_params.main_city_id);
    Open; //only Open not ExecProc
    FormLoadingState.ADODataSet.Connection := ADOConnectionMain;
    FormLoadingState.DataSource.DataSet := FormLoadingState.ADODataSet;
    FormLoadingState.ADODataSet.Recordset := ADO_sp.RecordSet;
    Close;
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
  end;
  to_protocol('Окончен сбор данных о загрузке;');
  FormLoadingState.ShowModal;

end;

procedure TFormMain.BClearUnnecessaryClick(Sender: TObject);
begin
  to_protocol('Начато удаление "пустых" плательщиков;');
  with ADO_sp do begin
    ProcedureName := 'up_clearUnnecessary;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    ExecProc;
    Close;
    to_protocol('Удалено всего записей: '+
      IntToStr(Parameters.ParamByName('@result_value').Value));
  end;
  to_protocol('Окончено удаление.');
end;

procedure TFormMain.BForLoadClick(Sender: TObject);
begin
  update_reg_record(ADO_q, loading_params.reg_record_id, 9);
end;

procedure TFormMain.save_wrong_records;
var
  qq: TADOQuery;
  file_name: string;
  fio, fio1: string;
begin
  with ADO_q do begin
//    CursorLocation := clUseServer;
//    CursorType := ctOpenForwardOnly;
    SQL.Clear;
    SQL.Add(
      'select fe.id_error, e.description error_desc, '+
      'fe.description field_desc, '+
      'u.id_file, u.record_number, u.code_firme, u.abcount, '+
      'u.date_dolg, u.code_plat, u.full_name, u.full_name_owner, '+
      'u.code_c, u.code_s, u.n_house, u.f_house, u.a_house, u.d_house, '+
      'u.n_room, u.a_room, u.one_roomed_flat, u.lift, u.phone, '+
      'u.date_privatization, u.form_property, u.total_area, u.heat_area, '+
      'u.quota_area, u.calc_device, u.date_calc_device, u.type_calc_device, '+
      'u.boiler, u.water_heater, '+
      'u.watercharge, u.date_wc, u.type_heating, u.date_heating, u.sum_dolg1, '+
      'u.sum_month, u.sum_norec, '+
      'u.sum_isp, u.sum_recalculation, '+
      'u.tarif, u.tarif_f, u.month_count, u.month_count2,  u.month_count3,'+
      'u.end_count, u.end_count2, u.end_count3, u.sum_pay, '+
      'u.sum_dolg, '+
      'u.resident_number, u.sum_01122006, u.date_dog, '+
      'u.code_lg1, u.count_tn_lg1, '+
      'u.date_lg1, '+
      'u.rate_lg1, '+
      'u.code_lg2, u.count_tn_lg2, '+
      'u.date_lg2, u.rate_lg2, '+
      'u.code_lg3, u.count_tn_lg3, '+
      'u.date_lg3, u.rate_lg3, '+
      'u.code_lg4, u.count_tn_lg4, '+
      'u.date_lg4, u.rate_lg4, '+
      'u.code_lg5, u.count_tn_lg5, '+
      'u.date_lg5, u.rate_lg5 '+

      'from utilityfiles_bo u '+
      'join file_errors fe on fe.record_number=u.record_number and fe.id_file='+
      IntToStr(loading_params.reg_record_id)+error_codes+
      ' join errors e on e.code=fe.id_error and id_software=2 AND error_type <>2 '+
      ' where u.id_file='+IntToStr(loading_params.reg_record_id)+error_codes);
    open;

//    ChDir('\\POSTSERV\centr\about_payers\');
//    file_name := 'errors_'+FieldByName('code_firme').AsString+'_'+FormatDateTime('yyyymmdd_hhnnss',now)+'.DBF';
    file_name := 'errors_'+IntToStr(loading_params.firm_id)+'_'+FormatDateTime('yyyymmdd_hhnnss',now)+'.DBF';

    CopyFile('\\POSTSERV\centr\about_payers\wrong_records_.DBF',
//      PAnsiCHar('c:\erc\'+file_name), false);
      PAnsiCHar(ExtractFilePath(Application.ExeName)+file_name), false);

    qq:= TADOQuery.Create(self);
    qq.ConnectionString :=
      'Provider=MSDASQL.1;DRIVER={Microsoft dBase Driver (*.dbf)};DriverId=277;fil=dBase IV;DBQ='+
        ExtractFilePath(Application.ExeName);
//      'Provider=MSDASQL.1;DRIVER={Microsoft dBase Driver (*.dbf)};DriverId=277;fil=dBase IV;DBQ=\\POSTSERV\centr\about_payers\';
    Cursor := crHourGlass;
//    first;
    while not EOF do begin
      fio := AnsiReplaceStr(FieldByName('full_name').AsString, '''', '"');
      fio1 := AnsiReplaceStr(FieldByName('full_name_owner').AsString, '''', '"');
      qq.SQL.Clear;
      qq.SQL.Add('INSERT INTO '+file_name+' VALUES('+ //ExtractFilePath(ODInputData.FileName)
        FieldByName('id_error').AsString+', '''+
        FieldByName('error_desc').AsString+''', '''+
        FieldByName('field_desc').AsString+''', '+
        FieldByName('id_file').AsString+', '+
        FieldByName('record_number').AsString+', '+
        FieldByName('code_firme').AsString+', '''+
        FieldByName('abcount').AsString+''', '''+
        FieldByName('date_dolg').AsString+''', '+
        FieldByName('code_plat').AsString+', '''+
        fio+''', '''+
        fio1+''', '+
        FieldByName('code_c').AsString+', '+
        FieldByName('code_s').AsString+', '+
        FieldByName('n_house').AsString+', '+
        FieldByName('f_house').AsString+', '''+
        FieldByName('a_house').AsString+''', '+
        FieldByName('d_house').AsString+', '+
        FieldByName('n_room').AsString+', '''+
        FieldByName('a_room').AsString+''', '+
        FieldByName('one_roomed_flat').AsString+', '+
        FieldByName('lift').AsString+', '''+
        FieldByName('phone').AsString+''', '''+
        FieldByName('date_privatization').AsString+''', '+
        FieldByName('form_property').AsString+', '+
        FieldByName('total_area').AsString+', '+
        FieldByName('heat_area').AsString+', '+
        FieldByName('quota_area').AsString+', '+
        FieldByName('calc_device').AsString+', '''+
        FieldByName('date_calc_device').AsString+''', '+
        FieldByName('type_calc_device').AsString+', '+
        FieldByName('boiler').AsString+', '+
        FieldByName('water_heater').AsString+', '+
        FieldByName('watercharge').AsString+', '''+
        FieldByName('date_wc').AsString+''', '+
        FieldByName('type_heating').AsString+', '''+
        FieldByName('date_heating').AsString+''', '+
        FieldByName('sum_dolg1').AsString+', '+
        FieldByName('sum_month').AsString+', '+
        FieldByName('sum_norec').AsString+', '+
        FieldByName('sum_isp').AsString+', '+
        FieldByName('sum_recalculation').AsString+', '+
        FieldByName('tarif').AsString+', '+
        FieldByName('tarif_f').AsString+', '+
        FieldByName('month_count').AsString+', '+
        FieldByName('month_count2').AsString+', '+
        FieldByName('month_count3').AsString+', '+
        FieldByName('end_count').AsString+', '+
        FieldByName('end_count2').AsString+', '+
        FieldByName('end_count3').AsString+', '+
        FieldByName('sum_pay').AsString+', '+
        FieldByName('sum_dolg').AsString+', '+
        FieldByName('resident_number').AsString+', '+
        FieldByName('sum_01122006').AsString+', '''+
        FieldByName('date_dog').AsString+''', '+
        FieldByName('code_lg1').AsString+', '+
        FieldByName('count_tn_lg1').AsString+', '''+
        FieldByName('date_lg1').AsString+''', '+
        FieldByName('rate_lg1').AsString+', '+
        FieldByName('code_lg2').AsString+', '+
        FieldByName('count_tn_lg2').AsString+', '''+
        FieldByName('date_lg2').AsString+''', '+
        FieldByName('rate_lg2').AsString+', '+
        FieldByName('code_lg3').AsString+', '+
        FieldByName('count_tn_lg3').AsString+', '''+
        FieldByName('date_lg3').AsString+''', '+
        FieldByName('rate_lg3').AsString+', '+
        FieldByName('code_lg4').AsString+', '+
        FieldByName('count_tn_lg4').AsString+', '''+
        FieldByName('date_lg4').AsString+''', '+
        FieldByName('rate_lg4').AsString+', '+
        FieldByName('code_lg5').AsString+', '+
        FieldByName('count_tn_lg5').AsString+', '''+
        FieldByName('date_lg5').AsString+''', '+
        FieldByName('rate_lg5').AsString+')');
      qq.ExecSQL;
      next;
    end;
    qq.Close;
    qq.Free;
    Cursor := crDefault;
    ShowMessage('Ошибки сохранены.');
  end;
  ado_q.Close;
end;

procedure TFormMain.BSaveClick(Sender: TObject);
var
  I: Integer;
  cb: TCheckBox;
begin
  with ADO_q do begin
    SQL.Clear;
    SQL.Add('SELECT DISTINCT file_errors.id_error code, errors.description description '+
      'FROM file_errors INNER JOIN errors ON file_errors.id_error = errors.code '+
      'WHERE id_software=2 and error_type <> 2 and file_errors.id_file ='+IntToStr(loading_params.reg_record_id));
    Open;
    i := 0;
    while not EOF do begin
      cb:= TCheckBox.Create(self);
      cb.Name := 'cb_'+FieldByName('code').AsString;
      cb.Tag := FieldByName('code').AsInteger;
      cb.Parent := SB;
      cb.Left := 8;
      cb.Top := i*30+10;
      cb.Width := sb.Width-20;
      cb.Caption := FieldByName('description').AsString;
      cb.Checked := true;
      next;
      inc(i);
    end;
  end;
  GB.Show;
end;

procedure TFormMain.BSearchFilesClick(Sender: TObject);
var
  qq: TADOQuery;
  main_firm_code: integer;
  F: TSearchRec;
  i: integer;
  vf: file;
  ext: string;
//-----------------------------------------------------------------------------
procedure get_input_file_stats(file_name: string);
var
  FileHandle: Integer;
begin
  input_file_stats.name := ExtractFileName(file_name);
  input_file_stats.size := get_file_size(file_name);
  FileHandle:= FileOpen(ODInputData.FileName, 0);
  input_file_stats.file_date_operate := now;
  if FileHandle = -1 then
    input_file_stats.file_date_create := now
  else
    input_file_stats.file_date_create := FileDateToDateTime(FileGetDate(FileHandle));
  FileClose(FileHandle);
end;

function get_code_firm_from_filename(name: string): integer;
begin
  Result := StrToInt(copy(name, 3, 4));
end;

procedure get_all_codes_by_firm(var list: TStringList; code: integer);
var
  s: string;
begin
  with ADO_q do begin
    close;
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    SQL.Clear;
      SQL.Add('SELECT DISTINCT firms.code, codeKIS FROM dbo.firms '+
      'inner join firm_accounts on(firms.code = firm_accounts.code_firm) '+
      'inner join firm_utilities on(firm_accounts.code_firm = firm_utilities.code_firm and firm_accounts.id = firm_utilities.id_firm_account) '+
      ' WHERE firms.code='+IntToStr(code));
    Open;
    while not EOF do begin
      if FieldByName('codeKIS').AsInteger<10 then
        s := '000'+FieldByName('codeKIS').AsString
      else if FieldByName('codeKIS').AsInteger<100 then
        s := '00'+FieldByName('codeKIS').AsString
      else if FieldByName('codeKIS').AsInteger<1000 then
        s := '0'+FieldByName('codeKIS').AsString
      else
        s := FieldByName('codeKIS').AsString;
      list.Add(s);
      Next;
    end;
  end;
end;
{
function was_registred(input_file_name: string; var size: integer): boolean;
begin
  result := false;
  with ADO_q do begin
    SQL.Clear;
    // ?????? нужно ли проверить статус????
    SQL.Add('SELECT * FROM file_registrations WHERE file_name = '''+
      input_file_name+''' ORDER BY id DESC');
    Open;
    while not EOF do begin
      result := true;
      size := FieldByName('file_size').AsInteger;
    end;
    Close;
  end;
end;

function get_input_file_name_only(fileName: string): string;
begin
  result := ExtractFileName(fileName);
  result := copy(result, 1, pos('.', result)-1);
end;

function correct_input_file_name(fileName: string): Boolean;
begin
  result := false;
  if (pos('bo', ANSIlowercase(fileName)) = 1) and
    isCode(ADO_q, 'firms', 'code', copy(fileName, 3, 4)) then
    result := true;
end;
}
function isInputStructureCorrect(fn: string): boolean;
var
  s, ss: string;
  i: integer;
function isNameRight(field_name: string): boolean;
var
  i: integer;
begin
  i := 0;
  while (I < qq.fieldCount) and (qq.FieldDefList[i].name <> field_name) do
    inc(i);
  if I < qq.fieldCount then
    Result := true
  else
    Result := false;
end;

function is_name_in_template(name_from_file: string): boolean;
begin
  ADO_q.First;
  Result := false;
  while not ado_q.EOF do begin
    if ANSIUpperCase(name_from_file) = ANSIUpperCase(ADO_q.FieldByName('file_field_name').AsString) then begin
      Result := true;
      exit;
    end;
    ADO_q.next;
  end;
end;

begin
  ADO_q.SQL.Clear;
  ADO_q.SQL.Add('select * from file_template_rules where id_template='+
    IntToStr(loading_params.rules_template_id));
  ADO_q.Open;

  ext := ExtractFileExt(fn);
  AssignFile(Vf, fn);
  Rename(Vf, ChangeFileExt(fn, '.dbf'));

  qq:= TADOQuery.Create(self);
  qq.ConnectionString :=
    'Provider=MSDASQL.1;DRIVER={Microsoft dBase Driver (*.dbf)};DriverId=277;fil=dBase IV;DBQ='+
      ExtractFilePath(fn);
  qq.SQL.Clear;
  qq.SQL.Add('select top 1 * from '+ExtractFileName(ChangeFileExt(fn, '.dbf')));
  qq.Open;
  ss := '';
  for I := 0 to qq.fieldCount - 1 do begin
    if not is_name_in_template(qq.FieldDefList[i].name) then begin
      if ss = '' then
        ss := qq.FieldDefList[i].name
      else
        ss := ss + '; '+  qq.FieldDefList[i].name;
    end;
  end;
  if ss <> '' then
    ss := 'В шаблоне нет правил для поля(ей) :'+ss;

  s := '';
  Result := true;
  ADO_q.First;
  while not ado_q.EOF do begin
    if not isNameRight(ADO_q.FieldByName('file_field_name').AsString) then begin
      result := false;
      if s = '' then
        s := ADO_q.FieldByName('file_field_name').AsString
      else
        s := s + '; '+  ADO_q.FieldByName('file_field_name').AsString;
    end;

    ADO_q.next;
  end;

  Rename(Vf, ChangeFileExt(fn, ext));

  if s <> '' then
    s := 'Во входных данных нет поля(ей): '+ s;
  if (ss <> '') or (s <> '') then
    ShowMessage(ss+#10+#13+s);


  qq.Close;
  qq.Free;
end;
//============================================================================
begin
  if ODInputData.Execute then begin
//    BForLoad.Enabled := false;
    get_input_file_stats(ODInputData.FileName);
    main_firm_code := get_code_firm_from_filename(input_file_stats.name);
    BInputOpen.Enabled := false;
    LBInputFiles.Clear;
    firm_code_list.Clear;
    get_all_codes_by_firm(firm_code_list, main_firm_code);
    if firm_code_list.Count>0 then begin
      for I := 0 to firm_code_list.Count - 1 do begin

        if FindFirst('b?'+firm_code_list[i]+'*.*', faAnyFile, F)=0 then begin
          LBInputFiles.Items.Add(F.Name);
          if isInputStructureCorrect(ExtractFilePath(ODInputData.FileName)+f.Name) then
            while (FindNext(F) = 0) and
              isInputStructureCorrect(ExtractFilePath(ODInputData.FileName)+f.Name) do
                LBInputFiles.Items.Add(F.Name);
        end;

        FindClose(F);
      end;
      BInputOpen.Enabled := LBInputFiles.Count>0;
    end else begin
      ShowMessage('Организация с кодом '+IntToStr(main_firm_code)+
        ' не найдена.');
      exit;
    end;
//    registred_file_size := 0;
//    if was_registred(input_file_stats.name, registred_file_size) then begin
//      return_code := 1; // file was processed error
//      if registred_file_size <> input_file_stats.size then
//        ShowMessage('Файла "'+input_file_stats.name+'" ('+
//          IntToStr(input_file_stats.size)+') уже был обработан, но его размер был '+
//          IntToStr(registred_file_size))
//      else
//        ShowMessage('Файла "'+input_file_stats.name+'" уже был обработан');
//{$IFNDEF DEBUG}
//      exit;
//{$ENDIF}
//    end;
//    input_file_name := ChangeFileExt(ODInputData.FileName, '.dbf');
//    AssignFile(Vf, ODInputData.FileName);
//    Rename(Vf, input_file_name);
//    input_file_name := get_input_file_name_only(input_file_name);
//    if not correct_input_file_name(input_file_name) then begin
//      return_code := 2; // file name error
//      ShowMessage('Ошибка в имени входного файла "'+input_file_name+'"');
//      exit;
//    end;
    loading_params.firm_id := main_firm_code;
  end else begin
    exit;
  end;
end;

procedure TFormMain.BNewAddressesClick(Sender: TObject);
begin
  buttons_state_change(false);
  to_protocol('Начато создание новых адресов.');
  with ADO_sp do begin
    ProcedureName := 'up_addNewAdresesByFile;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@id_city', ftinteger, pdInput, 10, loading_params.main_city_id);
    ExecProc;
    Close;
  end;
  to_protocol('Окончено создание новых адресов.');
  buttons_state_change(true);
end;

procedure TFormMain.CBErrorsSelect(Sender: TObject);
begin
  selected_error_code := integer(CBErrors.Items.Objects[CBErrors.ItemIndex]);
  update_warnings;
end;

procedure TFormMain.CBTemplateCitySelect(Sender: TObject);
begin
  loading_params.city_template_id :=
    integer(CBTemplateCity.Items.Objects[CBTemplateCity.ItemIndex]);
end;

procedure TFormMain.CBTemplateRulesSelect(Sender: TObject);
begin
  loading_params.rules_template_id :=
    integer(CBTemplateRules.Items.Objects[CBTemplateRules.ItemIndex]);
end;

procedure TFormMain.CBTemplateStreetSelect(Sender: TObject);
begin
  loading_params.street_template_id :=
    integer(CBTemplateStreet.Items.Objects[CBTemplateStreet.ItemIndex]);
end;

procedure TFormMain.DTPReportDateChange(Sender: TObject);
var
  s: string;
begin
  loading_params.report_date := DTPReportDate.Date;
  loading_params.main_city_id :=
    integer(CBCities.Items.Objects[CBCities.ItemIndex]);
  s := active_period_name(ado_q, loading_params.main_city_id);
  if s>'' then
    LActivePeriod.Caption := 'Активный период: '+s
  else
    LActivePeriod.Caption := 'Активный период: отсутствует';
  BSearchFiles.Enabled := true;
  if not get_report_date_params(report_date_params,ADO_sp,
      loading_params.main_city_id, loading_params.report_date) then begin
    BSearchFiles.Enabled := false;
    if Sender is TComboBox then
      if MessageDlg(CBCities.Items[CBCities.ItemIndex]+
        ' не имеет неподтвержденного периода!'+#10+#13+'Создать?',
        mtWarning, [mbYes, mbCancel], 0) = mrYes then begin
          crate_unconfirmed_period(ado_q, loading_params.main_city_id,
            loading_params.report_date);
//            , s>'');
          DTPReportDateChange(Sender);
        end;
  end else begin
    if loading_params.main_city_id=1 then begin // Донецк
      CBTemplateCity.ItemIndex := 0;
      loading_params.city_template_id :=
        integer(CBTemplateCity.Items.Objects[CBTemplateCity.ItemIndex]);
      CBTemplatestreet.ItemIndex :=  //4;
        CBTemplatestreet.Items.IndexOfObject(TObject(4));  // Улицы KIS Донецк
      loading_params.street_template_id :=
        integer(CBTemplateStreet.Items.Objects[CBTemplateStreet.ItemIndex]);
    end else
      with ADO_q do begin
        SQL.Clear;
        sql.add('SELECT id_template FROM city_mappings '+
          ' WHERE (id_city = '+IntToStr(loading_params.main_city_id)+
          ') AND (id_template <> 0)');
        Open;
        CBTemplateCity.ItemIndex := 0;
        if not eof then begin
          CBTemplateCity.ItemIndex :=
            CBTemplateCity.Items.IndexOfObject(TObject(FieldByName('id_template').AsInteger));
          CBTemplateCitySelect(Sender);
        end;
      end;
    get_periods_by_city(periods, ADO_q, loading_params.main_city_id);
    CBPeriods.Items := periods;
    if periods.Count>1 then
      CBPeriods.ItemIndex := 1
    else
      CBPeriods.ItemIndex := 0;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  warning_records := TStringList.Create;
  firm_code_list:= TStringList.Create;
  periods := TStringList.Create;
  report_date_params := TReportDateOptions.Create;
  report_date_params.id := -1;
end;

procedure TFormMain.Init;
begin
  mode := 0;
  LoadKeyboardLayout( '00000409' , KLF_ACTIVATE ) ;
  selected_error_code:= 0;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Load_settings.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password='+pw+';Persist Security Info=True;User ID='+
    log_in+';Data Source='+
    Settings.ReadString('Main', 'DATASOURCE', 'S-050-ERC')+
    '; Initial Catalog='+
    Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
  Caption := Caption+' ('+
    Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER')+')';
  is_update_statistics := Settings.ReadInteger('Main', 'UPDATESTATS', 0);
  Settings.Free;
  ADOConnectionMain.ConnectionString := connection_string;
  try
    ADOConnectionMain.Open;
  Except
    ShowMessage('Ошибка авторизации');
    Application.Terminate;
  end;
  ADO_sp := TADOStoredProc.Create(self);
  ADO_sp.Connection := ADOConnectionMain;
  ADO_sp.CommandTimeout := 1200;
  ADO_ds := TADODataSet.Create(self);
  ADO_ds.Connection := ADOConnectionMain;
  ADO_q := TADOQuery.Create(self);
  ADO_q.Connection := ADOConnectionMain;
  ADO_q.CursorLocation := clUseServer;
  QInputData := TADOQuery.Create(self);
  QInputData.Connection := ADOConnectionMain;
//  ADODataSet.Connection := ADOConnectionMain;
//УСТАНАВЛИВАЕМ русский язык ввода
  LoadKeyboardLayout( '00000419' , KLF_ACTIVATE ) ;
  with ADO_q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM file_templates WHERE id_type=6 ORDER BY id');
    Open;
    if not EOF then begin
      while not EOF do begin
        CBTemplateRules.Items.AddObject(FieldByName('description').AsString,
          TObject(FieldByName('id').AsInteger));
        Next;
      end;
      CBTemplateRules.ItemIndex := 0;
      loading_params.rules_template_id :=
        integer(CBTemplateRules.Items.Objects[0]);
    end;

    SQL.Clear;
    SQL.Add('SELECT * FROM city_mapping_templates ORDER BY id');
    Open;
    if not eof then begin
      while not EOF do begin
        CBTemplateCity.Items.AddObject(FieldByName('description').AsString,
          TObject(FieldByName('id').AsInteger));
        Next;
      end;
      CBTemplateCity.ItemIndex := 0;
      loading_params.city_template_id :=
        integer(CBTemplateCity.Items.Objects[0]);
    end;

    SQL.Clear;
    SQL.Add('SELECT * FROM street_mapping_templates ORDER BY id');
    Open;
    if not EOF then begin
      while not EOF do begin
        CBTemplateStreet.Items.AddObject(FieldByName('description').AsString,
          TObject(FieldByName('id').AsInteger));
        Next;
      end;
      CBTemplateStreet.ItemIndex := 0;
      loading_params.street_template_id :=
        integer(CBTemplateStreet.Items.Objects[0]);
    end;
    Close;

    SQL.Clear;
    SQL.Add('SELECT c.id id, c.name_rus, ct.short_name FROM cities c '+
      ' JOIN city_types ct ON ct.id=c.id_type '+
      ' WHERE id_parent = c.id and c.id>0 ORDER BY name_rus');
//      ' WHERE id_type > 0 ORDER BY name_rus');
    Open;
    CBCities.Items.Clear;
    while not EOF do begin
      CBCities.Items.AddObject(FieldByName('name_rus').AsString+' '+
        FieldByName('short_name').AsString, TObject(FieldByName('id').AsInteger));
      Next;
    end;
    Close;

    SQL.Clear;
    SQL.Add('SELECT * FROM errors WHERE id_software = 2 AND error_type <>2 ORDER BY code');
    Open;
    CBErrors.Items.AddObject('Все ошибки', TObject(0));
    while not EOF do begin
      CBErrors.Items.AddObject(FieldByName('code').AsString+'; '+
        FieldByName('description').AsString,
        TObject(FieldByName('code').AsInteger));
      Next;
    end;
    Close;
    CBErrors.ItemIndex := 0;
  end;
  CBCities.ItemIndex := 0;
  DTPReportDate.Date := now;
  if analyze_file_number>0 then begin
    loading_params.reg_record_id := analyze_file_number;
    with ADO_q do begin
      SQL.Clear;
      SQL.Add('SELECT id_city FROM file_registrations WHERE id ='+IntToStr(analyze_file_number));
      Open;
      loading_params.main_city_id := FieldByName('id_city').AsInteger;
      Close;
    end;
    BAnalyzeClick(self);
  end;
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  Year, Month, Day: Word;
begin
  Init;
//  if is_problem then exit;
  DecodeDate(now, Year, Month, Day);
  DTPReportDate.DateTime := now-day+1;
end;

procedure TFormMain.show_record_by_num(n: integer);
begin
  current_record_num := n;
  if FormViewInfo.visible then
    FormViewInfo.FormShow(nil)
  else
    FormViewInfo.Show;
end;

procedure TFormMain.LBWarningsDblClick(Sender: TObject);
begin
  show_record_by_num(TWarningInfo(LBWarnings.Items.Objects[LBWarnings.itemindex]).number_record);
end;

procedure TFormMain.to_protocol(s: string);
begin
  protocol.Lines.Add(TimeToStr(now)+'; '+s);
  protocol.Invalidate;
//  Application.ProcessMessages;
end;

procedure TFormMain.buttons_state_change(val: boolean);
begin
  Application.ProcessMessages;
  BInputOpen.Enabled := val;
  BStats.Enabled := val;
  BLoad.Enabled := val;
  BNewAddresses.Enabled := val;
  BCheckData.Enabled := val;
  BSearchFiles.Enabled := val;
  BAdaptCodeERC.Enabled := val;
  BAnalyze.Enabled := val;
  BSave.Enabled := val;
  BForLoad.Enabled := val;
end;

(*
procedure TFormMain.SaveResult;
var
  f: TextFile;
  title_string, file_name: string;
  status_as_str: string;
  D: TDateTime;
  Hour, Min, Sec, MSec,
  Year, Month, Day: Word;
  i, y, number: integer;
//------------------------------------------------------------------------------
function get_two_char(value: word): string;
begin
  result := IntToStr(value);
  if value < 10 then result := '0'+IntToStr(value);
end;
//==============================================================================
begin
  D:= Now;
  DecodeDate(D, Year, Month, Day);
  y := Year mod 100;
  DecodeTime(D, Hour, Min, Sec, MSec);
  number := 1;
  file_name := 'po'+copy(input_file_name, 3, 4)+get_two_char(Day)+'.'+
    get_two_char(Month)+IntToStr(number);

  if return_code = 0 then
    if number_wrong_records = 0 then begin
      return_code := 0; // errors are absent
      status_as_str := '2';
    end else begin
      return_code := 50;  // errors exists
      status_as_str := '3';
    end
  else
    status_as_str := '3';
  title_string := input_file_name+get_two_char(Day)+'.'+get_two_char(Month)+
    '.'+get_two_char(y)+get_two_char(Hour)+':'+get_two_char(Min)+
    Format('%5d%2d',[input_records, return_code]);

  AssignFile(f, ExtractFilePath(Application.ExeName)+file_name);
  Rewrite(f);
  Writeln(f, title_string);
//  for I := 0 to number_wrong_records - 1 do
//    Writeln(f, Format('%6d%2d',[TErrorInfo(wrong_records.Objects[i]).number_record,
//      TErrorInfo(wrong_records.Objects[i]).error_code]));
  CloseFile(f);

  with ADO_q do begin
    SQL.Clear;
    SQL.Add('INSERT INTO file_registrations '+
      '(file_name, file_size, file_date, date_reg, id_type, id_status) VALUES '+
      '('''+file_name+''', '+
      IntToStr(get_file_size(ExtractFilePath(Application.ExeName)+
      file_name))+', '''+FormatDateTime(format_date_time,now)+''', '''+
      FormatDateTime(format_date_time,now)+''', 7, 0)');
    ExecSQL;
    Close;

    SQL.Clear;
    SQL.Add('UPDATE file_registrations SET id_status = '+status_as_str+
      ' WHERE id ='+IntToStr(loading_params.reg_record_id));
    ExecSQL;
    Close;

//    if return_code <> 0 then
//{$IFDEF DEBUG}
//      SQL.Clear;
//      SQL.Add('DELETE FROM file_errors WHERE id_file='+
//        IntToStr(loading_params.reg_record_id));
//      ExecSQL;
//{$ENDIF}
//      for I := 0 to number_wrong_records - 1 do begin
//        SQL.Clear;
//        SQL.Add('INSERT INTO file_errors '+
//        'VALUES ('+IntToStr(loading_params.reg_record_id)+', '+
//        IntToStr(TErrorInfo(wrong_records.Objects[i]).number_record)+
//        ', '+IntToStr(TErrorInfo(wrong_records.Objects[i]).error_code)+')');
//        ExecSQL;
//      end;
//    Close;
  end;

  protocol.Lines.Add(TimeToStr(now)+'; Код возврата '+ IntToStr(return_code));
  ShowMessage('Обработан файл '+input_file_stats.name+chr(10)+chr(13)+
    'Всего записей '+IntToStr(input_records)+';');
end;
*)

//    RegExp := TRegExpr.Create;
//    try
//      RegExp.Expression := '[0-9]+';
//      if RegExp.Exec(ODInputData.FileName) then
//        ShowMessage(RegExp.Match[0])
//      else
//        ShowMessage('Fail');
//    finally
//      RegExp.Free;
//    end;
//    get_all_files_by_firm();


end.
