unit comparing_data;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB,
  verify_data,
  Dialogs, Grids, StdCtrls;

type
  TFormComparingDate = class(TForm)
    SGComparingData: TStringGrid;
    LBPeriod: TListBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure LBPeriodClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    q, qq: TADOQuery;
    periods: TStringList;
    current_period_id: integer;
    procedure FillCol(i, period_id, firm_id, utility_id: integer; bankbook: string);
  public
    { Public declarations }
    procedure UpdateContent(ei: TErrorInfo);
  end;

var
  FormComparingDate: TFormComparingDate;

implementation

uses
  ErrorAnalyzer,
  db_service,
  DB;
{$R *.dfm}

procedure TFormComparingDate.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  qq := TADOQuery.Create(self);
  SGComparingData.DefaultColWidth := 200;
  SGComparingData.ColWidths[0] := 100;
  SGComparingData.Cells[0, 0] := 'Поля';
  SGComparingData.Cells[1, 0] := 'Текущие';
  SGComparingData.Cells[2, 0] := 'Активные';
  SGComparingData.Cells[3, 0] := 'История';
  periods := TStringList.Create;
end;

procedure TFormComparingDate.FormShow(Sender: TObject);
begin
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  qq.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  get_periods_by_city(periods, q, loading_params.main_city_id);
  if periods.Count>0 then begin
    LBPeriod.Items := periods;
    LBPeriod.ItemIndex := 1;
    if LBPeriod.Items.count>0 then
      LBPeriodClick(self);
  end;
end;

procedure TFormComparingDate.LBPeriodClick(Sender: TObject);
begin
  current_period_id := TReportDateOptions(periods.Objects[LBPeriod.ItemIndex]).id;
  if FormErrorAnalyzer.LBErrors.Items.count>0 then
    UpdateContent(TErrorInfo(FormErrorAnalyzer.LBErrors.Items.Objects[FormErrorAnalyzer.LBErrors.ItemIndex]));
end;

procedure TFormComparingDate.UpdateContent(ei: TErrorInfo);
var
  i: integer;
  active_peiod_id: integer;
begin
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM utilityfiles_bo WHERE id_file='+
      IntToStr(loading_params.reg_record_id)+
      ' AND record_number='+IntToStr(TErrorInfo(ei).number_record));
      //FormErrorAnalyzer.current_record_number));
    open;
    SGComparingData.RowCount := FieldCount+1;
    for I := 0 to FieldCount - 1 do begin
      SGComparingData.Cells[0, i+1] := FieldDefList[i].Name;
      SGComparingData.Cells[1, i+1] := Fields[i].AsString;
    end;
    active_peiod_id :=
      get_active_period_by_city_id(qq, loading_params.main_city_id);
    case TErrorInfo(ei).error_code of
      102, 107, 108: begin  // Адрес не найден в базе
        FillCol(2, active_peiod_id, FieldByName('code_firme').AsInteger,
          FieldByName('code_plat').AsInteger, FieldByName('abcount').AsString);
        FillCol(3, current_period_id, FieldByName('code_firme').AsInteger,
          FieldByName('code_plat').AsInteger, FieldByName('abcount').AsString);
      end;
    end;
  end;
end;

procedure TFormComparingDate.FillCol(i, period_id, firm_id, utility_id: integer;
  bankbook: string);
var
//  debt_params: TDebtOptions;
  payer_params: TPayerOptions;
  room_params: TRoomOptions;
  privilege_params: TPrivilege;
//  tarif_params: TTarifParams;
  addr_params: TAddressParams;

function index_by_name(s: string): integer;
var
  i: integer;
begin
  i := 1;
  while (s<>SGComparingData.Cells[0, i]) and (i<SGComparingData.RowCount) do inc(i);
  result := i;
end;
begin
  SGComparingData.Cells[i, 1] := 'N/A';
  SGComparingData.Cells[i, 2] := 'N/A';
  SGComparingData.Cells[i, index_by_name('code_firme')] :=
    IntToStr(firm_id);
  SGComparingData.Cells[i, index_by_name('code_plat')] :=
    IntToStr(utility_id);
  SGComparingData.Cells[i, index_by_name('abcount')] :=
    bankbook;

  get_addr_params_by_firm_bankbook(addr_params, qq,
    IntToStr(firm_id), bankbook);
  SGComparingData.Cells[i, index_by_name('code_c')] :=
    intToStr(addr_params.local_city_id)+'-'+addr_params.city_name;
  SGComparingData.Cells[i, index_by_name('code_s')] :=
    intToStr(addr_params.local_street_code)+'-'+addr_params.street_name;
  SGComparingData.Cells[i, index_by_name('n_house')] :=
    intToStr(addr_params.n_house);
  SGComparingData.Cells[i, index_by_name('f_house')] :=
    intToStr(addr_params.f_house);
  SGComparingData.Cells[i, index_by_name('a_house')] :=
    addr_params.a_house;
  SGComparingData.Cells[i, index_by_name('d_house')] :=
    intToStr(addr_params.d_house);
  SGComparingData.Cells[i, index_by_name('n_room')] :=
    intToStr(addr_params.n_room);
  SGComparingData.Cells[i, index_by_name('a_room')] :=
    addr_params.a_room;

//  get_debt_options_by_firm_utility_bankbook(debt_params, qq, period_id,
//    IntToStr(firm_id), IntToStr(utility_id), bankbook);
//  SGComparingData.Cells[i, index_by_name('sum_month')] :=
//    FloatToStr(debt_params.month_sum);
//  SGComparingData.Cells[i, index_by_name('sum_isp')] :=
//    FloatToStr(debt_params.normal_sum);
//  SGComparingData.Cells[i, index_by_name('end_count')] :=
//    IntToStr(debt_params.last_count);
//  SGComparingData.Cells[i, index_by_name('month_count')] :=
//    IntToStr(debt_params.month_count);
//  SGComparingData.Cells[i, index_by_name('date_dolg')] :=
//    DateToStr(debt_params.debt_date);
//  SGComparingData.Cells[i, index_by_name('sum_dolg')] :=
//    FloatToStr(debt_params.debt_total);
//
//  get_tarif_options_by_firm_utility_bankbook(tarif_params, qq, period_id,
//    IntToStr(firm_id), IntToStr(utility_id), bankbook);
//  SGComparingData.Cells[i, index_by_name('watercharge')] :=
//    FloatToStr(tarif_params.watercharge);
//  SGComparingData.Cells[i, index_by_name('date_wc')] :=
//    DateToStr(tarif_params.wc_change_date);
//  SGComparingData.Cells[i, index_by_name('tarif')] :=
//    FloatToStr(tarif_params.tarif);
//  SGComparingData.Cells[i, index_by_name('tarif_f')] :=
//    FloatToStr(tarif_params.real_tarif);
//
//  get_privelege_options_by_firm_utility_bankbook(privilege_params, qq, period_id,
//    IntToStr(firm_id), IntToStr(utility_id), bankbook);

  SGComparingData.Cells[i, index_by_name('sum_01122006')] :=
    Floattostr(privilege_params.sum_01122006);
  SGComparingData.Cells[i, index_by_name('date_dog')] :=
    DateToStr(privilege_params.pact_date);
//  SGComparingData.Cells[i, index_by_name('num_dog')] :=
//    privilege_params.pact_number;
//  SGComparingData.Cells[i, index_by_name('sum_dolg_dog')] :=
//    Floattostr(privilege_params.debt_sum_restruct);
//  SGComparingData.Cells[i, index_by_name('subs')] :=
//    Floattostr(privilege_params.subsidy);
//  SGComparingData.Cells[i, index_by_name('date_subs')] :=
//    DateToStr(privilege_params.subsidy_date);
  SGComparingData.Cells[i, index_by_name('code_lg1')] :=
    Inttostr(privilege_params.privilege1_code);
  SGComparingData.Cells[i, index_by_name('count_tn_lg1')] :=
    Inttostr(privilege_params.privilege1_users);
//  SGComparingData.Cells[i, index_by_name('kat_lg1')] :=
//    Inttostr(privilege_params.privilege1_category);
  SGComparingData.Cells[i, index_by_name('date_lg1')] :=
    DateToStr(privilege_params.privilege1_date);
//  SGComparingData.Cells[i, index_by_name('doc_lg_vid1')] :=
//    privilege_params.privilege1_doc;
//  SGComparingData.Cells[i, index_by_name('doc_lg_num1')] :=
//    privilege_params.privilege1_doc_number;
//  SGComparingData.Cells[i, index_by_name('doc_lg_v1')] :=
//    privilege_params.privilege1_doc_who;
//  SGComparingData.Cells[i, index_by_name('doc_lg_d1')] :=
//    DateToStr(privilege_params.privilege1_doc_date);
  SGComparingData.Cells[i, index_by_name('rate_lg1')] :=
    Floattostr(privilege_params.privilege1_percent);

//  get_human_options_by_firm_bankbook(payer_params, qq, period_id,
//    IntToStr(firm_id), bankbook);
  SGComparingData.Cells[i, index_by_name('full_name')] :=
    payer_params.full_name;
  SGComparingData.Cells[i, index_by_name('full_name_owner')] :=
    payer_params.owner_full_name;
  SGComparingData.Cells[i, index_by_name('phone')] := payer_params.phone;
  SGComparingData.Cells[i, index_by_name('resident_number')] :=
    IntToStr(payer_params.resident_number);

//  get_room_options_by_firm_bankbook(room_params, qq, period_id,
//    IntToStr(firm_id), bankbook);
  SGComparingData.Cells[i, index_by_name('one_roomed_flat')] :=
    Inttostr(room_params.number_rooms);
  SGComparingData.Cells[i, index_by_name('lift')] :=
    BoolToStr(room_params.is_lift);
  SGComparingData.Cells[i, index_by_name('date_privatization')] :=
    DateToStr(room_params.date_privatization);
  SGComparingData.Cells[i, index_by_name('form_property')] :=
    IntToStr(room_params.form_property);
  SGComparingData.Cells[i, index_by_name('total_area')] :=
    FloatToStr(room_params.total_area);
  SGComparingData.Cells[i, index_by_name('heat_area')] :=
    FloatToStr(room_params.heat_area);
  SGComparingData.Cells[i, index_by_name('quota_area')] :=
    FloatToStr(room_params.quota_area);
  SGComparingData.Cells[i, index_by_name('calc_device')] :=
    IntToStr(room_params.counter_state);
  SGComparingData.Cells[i, index_by_name('date_calc_device')] :=
    DateToStr(room_params.date_calc_device);
  SGComparingData.Cells[i, index_by_name('boiler')] :=
    IntToStr(room_params.boiler);
  SGComparingData.Cells[i, index_by_name('water_heater')] :=
    IntToStr(room_params.water_heater);
  SGComparingData.Cells[i, index_by_name('type_heating')] :=
    IntToStr(room_params.heat_type);
  SGComparingData.Cells[i, index_by_name('date_heating')] :=
    DateToStr(room_params.change_heat_date);
end;

end.

(*
select * from humans h2 where h2.id_room_location in
(select id_room_location from humans h
join bankbooks bb on bb.id_human=h.id and code_firm=15 and bank_book='08142168')
--where h.id_room_location=
--(select id_human from bankbooks 
--where code_firm=15 and bank_book='08142168')
select * from humans where id in
(select id_human from bankbooks 
where code_firm=15 and bank_book='08142168')
*)
