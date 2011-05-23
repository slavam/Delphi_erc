unit ShortInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  db_service, ADODB,
  Dialogs, StdCtrls, ComCtrls, Tabs, DB;

type
  TShortInfoForm = class(TForm)
    LCodeERC: TLabel;
    LFullName: TLabel;
    LBankbook: TLabel;
    LAddress: TLabel;
    LFirm: TLabel;
    LService: TLabel;
    ADOQ: TADOQuery;
    Label1: TLabel;
    CBPeriod: TComboBox;
    GBSubsidy: TGroupBox;
    LSum01122006: TLabel;
    LPactDate: TLabel;
    LPrivelege1: TLabel;
    LPrivelege1Users: TLabel;
    LPrivilege1Date: TLabel;
    LPrivilege1Percent: TLabel;
    LPrivelege2: TLabel;
    LPrivelege2Users: TLabel;
    LPrivilege2Date: TLabel;
    LPrivilege2Percent: TLabel;
    LPrivelege3: TLabel;
    LPrivelege3Users: TLabel;
    LPrivilege3Date: TLabel;
    LPrivilege3Percent: TLabel;
    LPrivelege4: TLabel;
    LPrivelege4Users: TLabel;
    LPrivilege4Date: TLabel;
    LPrivilege4Percent: TLabel;
    LPrivelege5: TLabel;
    LPrivelege5Users: TLabel;
    LPrivilege5Date: TLabel;
    LPrivilege5Percent: TLabel;
    TSPartInfo: TTabSet;
    GBPayer: TGroupBox;
    LFullnamePayer: TLabel;
    LOwnerFullname: TLabel;
    LPhone: TLabel;
    LResidentNumber: TLabel;
    GBDebt: TGroupBox;
    GBHome: TGroupBox;
    LIsLift: TLabel;
    LOneRoom: TLabel;
    LDatePrivatization: TLabel;
    LFormProperty: TLabel;
    LTotalArea: TLabel;
    LHeatArea: TLabel;
    LQuotaArea: TLabel;
    LCalcDevice: TLabel;
    LDateCalcDevice: TLabel;
    LBoiler: TLabel;
    LWaterHeater: TLabel;
    LHeatType: TLabel;
    LChangeHeatDate: TLabel;
    LDateDebt: TLabel;
    LExes: TLabel;
    LProfit: TLabel;
    LRecount: TLabel;
    LPayment: TLabel;
    LDebtNext: TLabel;
    Label3: TLabel;
    LCounter1: TLabel;
    LCounter2: TLabel;
    LCounter3: TLabel;
    LCounterType: TLabel;
    GBTariff: TGroupBox;
    LWatercharge: TLabel;
    LDateChangeWC: TLabel;
    LTariff: TLabel;
    LTariffF: TLabel;
    GBPayment: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lll: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    LBPayment: TListBox;
    LTotal_curr: TLabel;
    Ldate_payment: TLabel;
    LWhere: TLabel;
    LSum: TLabel;
    Lperiod_start: TLabel;
    Lperiod_end: TLabel;
    Lfilial: TLabel;
    LStation: TLabel;
    Label6: TLabel;
    Lfile_out: TLabel;
    Label11: TLabel;
    Lcount_start: TLabel;
    Lfile_in: TLabel;
    Label12: TLabel;
    Lcount_end: TLabel;
    Label13: TLabel;
    Ldate_send: TLabel;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TSPartInfoClick(Sender: TObject);
    procedure CBPeriodSelect(Sender: TObject);
    procedure LBPaymentClick(Sender: TObject);
  private
    report_date_params: TReportDateOptions;
    current_period_id: integer;
    date, date0: string; //Extended;
    payment_list : TStringList;
    procedure update_payer_data;
  public
    current_owner_erc_code: TERCCodeOwnerParams;
    bankbook_params:TBankbookParams;
  end;

var
  ShortInfoForm: TShortInfoForm;

implementation
uses
  viewer;
var
  q: TADOQuery;
  sp: TADOStoredProc;
  ds: TADODataSet;

{$R *.dfm}


procedure TShortInfoForm.CBPeriodSelect(Sender: TObject);
begin
  current_period_id := TReportDateOptions(period_list.Objects[CBPeriod.ItemIndex]).id;
  date := DatetoStr(TReportDateOptions(period_list.Objects[CBPeriod.ItemIndex]).report_date);
  date0 := Datetostr(IncMonth(TReportDateOptions(period_list.Objects[CBPeriod.ItemIndex]).report_date, -1));
  update_payer_data;
end;

procedure TShortInfoForm.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  sp := TADOStoredProc.Create(self);
  sp.ConnectionString := connection_string;
  ds := TADODataSet.Create(self);
  ds.ConnectionString := connection_string;
  report_date_params := TReportDateOptions.Create;
  payment_list := TStringList.Create;
  TSPartInfo.TabIndex := 0;
end;

procedure TShortInfoForm.FormShow(Sender: TObject);
var
  address_params: TAddressParams;
begin
  LCodeERC.Caption :=
    'Код ЕРЦ: ' + Inttostr(current_owner_erc_code.erc_code);
  LFullName.Caption := 'ФИО: '+ current_owner_erc_code.fullName;
  LBankbook.Caption := 'Лицевой счет: '+ bankbook_params.bank_book;
  LFirm.Caption := 'Организация: '+
    IntToStr(bankbook_params.code_firm)+'; '+
    get_firm_name_by_firm_id(q, bankbook_params.code_firm);
  LService.Caption := 'Название платежа: '+
    get_service_name_by_service_id(q, bankbook_params.code_utility);
  get_address_params_by_bankbook(address_params, q, Inttostr(bankbook_params.code_firm),
//    IntToStr(bankbook_params.code_utility),
    bankbook_params.bank_book);

  if address_params.zip_code>0 then
    LAddress.Caption := 'Адрес: '+IntToStr(address_params.zip_code)+', '
  else
    LAddress.Caption := 'Адрес: ';
  LAddress.Caption := LAddress.Caption+address_params.city_type+' '
    + address_params.city_name;
  LAddress.Caption := LAddress.Caption+', '+address_params.street_type+
    ' '+address_params.street_name+', ';
  LAddress.Caption := LAddress.Caption+'дом '+InttoStr(address_params.n_house);
  if address_params.f_house <> 0 then
    LAddress.Caption := LAddress.Caption+'-'+IntToStr(address_params.f_house);
  if address_params.d_house <> 0 then
    LAddress.Caption := LAddress.Caption+'/'+Inttostr(address_params.d_house);
  if trim(address_params.a_house)>'' then
    LAddress.Caption := LAddress.Caption+'"'+trim(address_params.a_house)+'"';
  if address_params.n_room <> 0 then
    LAddress.Caption := LAddress.Caption+', кв. '+ IntToStr(address_params.n_room);
  if address_params.a_room>'' then
    LAddress.Caption := LAddress.Caption+'"'+trim(address_params.a_room)+'"';

//  get_periods_by_bankbook(period_list, q, bankbook_params.id);
  get_periods_by_bankbook_utility(period_list, q, bankbook_params.id_utility);
  CBPeriod.Clear;
  CBPeriod.Items := period_list;
  CBPeriod.ItemIndex := 0;
  CBPeriodSelect(Sender);
//  current_period_id := TReportDateOptions(period_list.objects[CBPeriod.ItemIndex]).id;
  update_payer_data;
end;

procedure TShortInfoForm.LBPaymentClick(Sender: TObject);
begin
  LTotal_curr.Caption := IntToStr(LBPayment.ItemIndex+1)+'/'+IntToStr(payment_list.Count);
  with TPaymentParams(LBPayment.Items.Objects[LBPayment.itemindex]) do begin
    Ldate_payment.Caption := DateToStr(payment_date);
    LWhere.Caption := ward_name;
    LSum.Caption := FloatToStrF(sum, ffFixed, 5, 2)+' грн.';
    Lperiod_start.Caption := DateToStr(period_begin);
    Lperiod_end.Caption := DateToStr(period_end);
    Lfilial.Caption := IntToStr(filial);
    LStation.Caption := IntToStr(station);
    Lfile_in.Caption := file_name_in;
    Lfile_out.Caption := file_name_out;
    Lcount_start.Caption := FloatToStrF(count_start, ffFixed, 5, 2);
    Lcount_end.Caption := FloatToStrF(count_end, ffFixed, 5, 2);
    Ldate_send.Caption := DateToStr(send_date);
  end;
end;

procedure TShortInfoForm.TSPartInfoClick(Sender: TObject);
begin
  GBDebt.Visible := TSPartInfo.TabIndex = 0;
  GBPayer.Visible := TSPartInfo.TabIndex = 1;
  GBHome.Visible := TSPartInfo.TabIndex = 2;
  GBSubsidy.Visible := TSPartInfo.TabIndex = 3;
  GBTariff.Visible := TSPartInfo.TabIndex = 4;
  GBPayment.Visible := TSPartInfo.TabIndex = 5;
end;

procedure TShortInfoForm.update_payer_data;
var
  debt_params: TDebtOptions;
  payer_params: TPayerOptions;
  room_attributes: TRoomOptions;
  privilege_params: TPrivilege;
  tariff_params : TTariffOptions;
  s: string;

function get_1_from_3(value: integer):string;
begin
  if value = 0 then
    result := 'нет информации'
  else if value = 1 then
    Result := 'ДА'
  else
    Result := 'НЕТ';
end;
begin
  debt_params := TDebtOptions.Create;
  get_debt_options_by_bankbook(debt_params, q, IntToStr(current_period_id),
    bankbook_params.id_utility);
// 20110314  LI+Olya LDateDebt.Caption := 'Долг на отчетную дату '+ DateToStr(debt_params.debt_date) +//changes 20101217 date0+ //changes before 20101217 DateToStr(debt_params.debt_date)+
// date = date_dolg - 1 month and firs day
//  LDateDebt.Caption := 'Долг на '+ DateToStr(debt_params.debt_date) + // from sum_dolg1  //changes 20101217 date0+ //changes before 20101217 DateToStr(debt_params.debt_date)+
  LDateDebt.Caption := 'Долг на '+
    FormatDateTime('01.mm.yyyy',IncMonth(debt_params.debt_date,-1))+
    ' равен '+FloatToStr(debt_params.sum_dolg1);
  LExes.Caption := 'Использованный объем: '+FloatToStr(debt_params.month_count+
    debt_params.month_count2+ debt_params.month_count3);
  LProfit.Caption := 'Начислено: '+FloatToStr(debt_params.sum_month)+ ',';
  LRecount.Caption := 'в т.ч. перерасчет: '+FloatToStr(debt_params.sum_recalculation);
  LPayment.Caption := 'Оплата (с субсидией): '+FloatToStr(debt_params.sum_pay);
// 20110314 LI+Olya date = date_dolg and firs day
//  LDebtNext.Caption := 'Долг на отчетную дату '+date
  LDebtNext.Caption := 'Долг на отчетную дату '+
    FormatDateTime('01.mm.yyyy',debt_params.debt_date)+': '+
    FloatToStr(debt_params.sum_dolg);
  LCounter1.Caption := 'Счетчик 1: '+ FloatToStr(debt_params.end_count);
  LCounter2.Caption := 'Счетчик 2: '+ FloatToStr(debt_params.end_count2);
  LCounter3.Caption := 'Счетчик 3: '+ FloatToStr(debt_params.end_count3);

  get_payer_options_by_bankbook(payer_params, q, IntToStr(current_period_id),
    bankbook_params.id);
  LFullnamePayer.Caption := 'ФИО: '+payer_params.full_name;
  LOwnerFullname.Caption := 'ФИО владельца жилья: '+payer_params.owner_full_name;
  LPhone.Caption := 'Телефон: '+payer_params.phone;
  LResidentNumber.Caption := 'Количество зарегистрированных человек: '+
    IntToStr(payer_params.resident_number);

  get_room_options_by_bankbook(room_attributes, q,
    IntToStr(current_period_id), bankbook_params.id);
  LOneRoom.Caption := 'Однокомнатная квартира: '+
    get_1_from_3(room_attributes.number_rooms);
  if room_attributes.is_lift then
    s := 'ДА'
  else
    s := 'НЕТ';
  LIsLift.Caption := 'Есть ли оплата лифта в расчете квартплаты: '+s;
  if room_attributes.date_privatization>1 then
    LDatePrivatization.Caption := 'Дата приватизации: '+
      DateToStr(room_attributes.date_privatization)
  else
    LDatePrivatization.Caption := 'Дата приватизации: ';
  LFormProperty.Caption := 'Форма собственности: '+
    ownership[room_attributes.form_property];
  LTotalArea.Caption := 'Общая площадь: '+FloatToStr(room_attributes.total_area);
  LHeatArea.Caption := 'Отапливаемая площадь: '+
    FloatToStr(room_attributes.heat_area);
  LQuotaArea.Caption := 'Площадь в пределах норм использования: '+
    FloatToStr(room_attributes.quota_area);
  LCalcDevice.Caption := 'Есть ли прибор учета: '+
    get_1_from_3(room_attributes.counter_state);
  if room_attributes.date_calc_device>1 then
    LDateCalcDevice.Caption := 'Дата установки/снятия прибора учета: '+
      DateToStr(room_attributes.date_calc_device)
  else
    LDateCalcDevice.Caption := 'Дата установки/снятия прибора учета: ';
  LCounterType.Caption := 'Тип прибора учета: '+
    IntToStr(room_attributes.counter_type);
  LBoiler.Caption := 'Есть ли бойлер: '+get_1_from_3(room_attributes.boiler);
  LWaterHeater.Caption := 'Есть ли колонка: '+
    get_1_from_3(room_attributes.water_heater);
  LHeatType.Caption := 'Тип отопления: '+type_heat[room_attributes.heat_type];
  if room_attributes.change_heat_date>1 then
    LChangeHeatDate.Caption := 'Дата изменения типа отопления: '+
      DateToStr(room_attributes.change_heat_date)
  else
    LChangeHeatDate.Caption := 'Дата изменения типа отопления: ';

  get_privilege_options_by_bankbook(privilege_params, q,
    IntToStr(current_period_id), bankbook_params.id_utility);
  LSum01122006.Caption := 'Сумма долга на 01.12.2006: '+
    FloatToStr(privilege_params.sum_01122006);
  if privilege_params.pact_date>1 then
    LPactDate.Caption := 'Дата договора на реструктуризацию долга: '+
      DateToStr(privilege_params.pact_date)
  else
    LPactDate.Caption := 'Дата договора на реструктуризацию долга: ';
  if (privilege_params.privilege1_users>0) or
    (privilege_params.privilege1_date>1) or
    (privilege_params.privilege1_percent>0) then begin
    LPrivelege1.Show;
    LPrivelege1Users.Caption := 'Количество человек, пользующихся льготой: '+
      IntToStr(privilege_params.privilege1_users);
    LPrivilege1Date.Caption := 'Дата предоставления/снятия льготы: '+
      DateToStr(privilege_params.privilege1_date);
    LPrivilege1Percent.Caption := 'Размер льготы в процентах: '+
      FloatToStr(privilege_params.privilege1_percent);
  end else begin
    LPrivelege1.Hide;
    LPrivelege1Users.Caption := '';
    LPrivilege1Date.Caption := '';
    LPrivilege1Percent.Caption := '';
  end;
  if (privilege_params.privilege2_users>0) or
    (privilege_params.privilege2_date>1) or
    (privilege_params.privilege2_percent>0) then begin
    LPrivelege2.Show;
    LPrivelege2Users.Caption := 'Количество человек, пользующихся льготой: '+
      IntToStr(privilege_params.privilege2_users);
    LPrivilege2Date.Caption := 'Дата предоставления/снятия льготы: '+
      DateToStr(privilege_params.privilege2_date);
    LPrivilege2Percent.Caption := 'Размер льготы в процентах: '+
      FloatToStr(privilege_params.privilege2_percent);
  end else begin
    LPrivelege2.Hide;
    LPrivelege2Users.Caption := '';
    LPrivilege2Date.Caption := '';
    LPrivilege2Percent.Caption := '';
  end;
  if (privilege_params.privilege3_users>0) or
    (privilege_params.privilege3_date>1) or
    (privilege_params.privilege3_percent>0) then begin
    LPrivelege3.Show;
    LPrivelege3Users.Caption := 'Количество человек, пользующихся льготой: '+
      IntToStr(privilege_params.privilege3_users);
    LPrivilege3Date.Caption := 'Дата предоставления/снятия льготы: '+
      DateToStr(privilege_params.privilege3_date);
    LPrivilege3Percent.Caption := 'Размер льготы в процентах: '+
      FloatToStr(privilege_params.privilege3_percent);
  end else begin
    LPrivelege3.Hide;
    LPrivelege3Users.Caption := '';
    LPrivilege3Date.Caption := '';
    LPrivilege3Percent.Caption := '';
  end;
  if (privilege_params.privilege4_users>0) or
    (privilege_params.privilege4_date>1) or
    (privilege_params.privilege4_percent>0) then begin
    LPrivelege4.Show;
    LPrivelege4Users.Caption := 'Количество человек, пользующихся льготой: '+
      IntToStr(privilege_params.privilege4_users);
    LPrivilege4Date.Caption := 'Дата предоставления/снятия льготы: '+
      DateToStr(privilege_params.privilege4_date);
    LPrivilege4Percent.Caption := 'Размер льготы в процентах: '+
      FloatToStr(privilege_params.privilege4_percent);
  end else begin
    LPrivelege4.Hide;
    LPrivelege4Users.Caption := '';
    LPrivilege4Date.Caption := '';
    LPrivilege4Percent.Caption := '';
  end;
  if (privilege_params.privilege5_users>0) or
    (privilege_params.privilege5_date>1) or
    (privilege_params.privilege5_percent>0) then begin
    LPrivelege5.Show;
    LPrivelege5Users.Caption := 'Количество человек, пользующихся льготой: '+
      IntToStr(privilege_params.privilege5_users);
    LPrivilege5Date.Caption := 'Дата предоставления/снятия льготы: '+
      DateToStr(privilege_params.privilege5_date);
    LPrivilege5Percent.Caption := 'Размер льготы в процентах: '+
      FloatToStr(privilege_params.privilege5_percent);
  end else begin
    LPrivelege5.Hide;
    LPrivelege5Users.Caption := '';
    LPrivilege5Date.Caption := '';
    LPrivilege5Percent.Caption := '';
  end;

  tariff_params := TTariffOptions.Create;
  get_tariff_options_by_bankbook(tariff_params, q,
    current_period_id, bankbook_params.id_utility);
  LWatercharge.Caption := 'Месячная норма потребления воды: '+
    FloatToStr(tariff_params.watercharge);
  if tariff_params.date_watercharge>1 then
    LDateChangeWC.Caption := 'Дата изменения нормы потребления воды: '+
      DateToStr(tariff_params.date_watercharge)
  else
    LDateChangeWC.Caption := 'Дата изменения нормы потребления воды: ';
  LTariff.Caption := 'Тариф в гривнах за единицу услуги: '+
    FloatToStr(tariff_params.tariff);
  LTariffF.Caption := 'Фактический тариф в гривнах за единицу услуги: ' +
    FloatToStr(tariff_params.tariff_real);

  payment_list.clear;
  get_payment_params(payment_list, sp, tariff_params.id_bankbook_utility);
  LBPayment.Items := payment_list;
  LBPayment.ItemIndex := 0;
  if payment_list.Count>0 then
    LBPaymentClick(self)
  else begin
    LTotal_curr.Caption := '0/0';
    Ldate_payment.Caption := '';
    LWhere.Caption := '';
    LSum.Caption := '';
    Lperiod_start.Caption := '';
    Lperiod_end.Caption := '';
    Lfilial.Caption := '';
    LStation.Caption := '';
    Lfile_in.Caption := '';
    Lfile_out.Caption := '';
    Lcount_start.Caption := '';
    Lcount_end.Caption := '';
    Ldate_send.Caption := '';
  end;

end;

end.
