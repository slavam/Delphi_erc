unit FullInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB_service,
  controller,
  Dialogs, StdCtrls, DB, ADODB, Tabs;

type
  TFormFullInfo = class(TForm)
    LCodeERC: TLabel;
    LFullName: TLabel;
    LBankbook: TLabel;
    ADOQ: TADOQuery;
    LAddress: TLabel;
    LFirm: TLabel;
    LService: TLabel;
    GBDebt: TGroupBox;
    LMonthSum: TLabel;
    LNormalSum: TLabel;
    LMonthCount: TLabel;
    LLastCount: TLabel;
    LDebtTotal: TLabel;
    GBPayer: TGroupBox;
    LFullnamePayer: TLabel;
    LOwnerFullname: TLabel;
    LPhone: TLabel;
    LResidentNumber: TLabel;
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
    GBSubsidy: TGroupBox;
    LSum01122006: TLabel;
    LPactDate: TLabel;
    LPactNumber: TLabel;
    LSumRestruct: TLabel;
    LSubsidy: TLabel;
    LSubsidyDate: TLabel;
    LPrivelege1Code: TLabel;
    TSPartInfo: TTabSet;
    LPrivelege1Users: TLabel;
    LPrivelege1Category: TLabel;
    LPrivilege1Date: TLabel;
    LPrivilege1Doc: TLabel;
    LPrivilege1DocNumber: TLabel;
    LPrivilege1Who: TLabel;
    LPrivilege1DocDate: TLabel;
    LPrivilege1Percent: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TSPartInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    current_owner_erc_code: TERCCodeOwnerParams;
    current_period_id: integer;
    bankbook_params:TBankbookParams;
  end;

var
  FormFullInfo: TFormFullInfo;

implementation
uses
  DataView;
{$R *.dfm}

procedure TFormFullInfo.FormCreate(Sender: TObject);
begin
  current_owner_erc_code := TERCCodeOwnerParams.Create;
  ADOQ.ConnectionString := connection_string;
end;

procedure TFormFullInfo.FormDestroy(Sender: TObject);
begin
  current_owner_erc_code.Free;
end;

procedure TFormFullInfo.FormShow(Sender: TObject);
var
  address_params: TAddressParams;
  debt_params: TDebtOptions;
  payer_params: TPayerOptions;
  room_attributes: TRoomOptions;
  privilege_params: TPrivilege;
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
  LCodeERC.Caption :=
    'Код ЕРЦ: ' + Inttostr(current_owner_erc_code.erc_code);
  LFullName.Caption := 'ФИО: '+ current_owner_erc_code.fullName;

  LBankbook.Caption := 'Лицевой счет: '+ bankbook_params.bank_book;
  LFirm.Caption := 'Организация: '+
    IntToStr(bankbook_params.code_firm)+'; '+
    get_firm_name_by_firm_id(ADOQ, bankbook_params.code_firm);
  LService.Caption := 'Название платежа: '+
    get_service_name_by_service_id(ADOQ, bankbook_params.code_utility);

  get_address_params_by_bankbook(address_params, ADOQ,
    Inttostr(bankbook_params.code_firm),
    IntToStr(bankbook_params.code_utility), bankbook_params.bank_book);
  LAddress.Caption := 'Адрес: город '+ address_params.city_name;
  if (pos(' пер.', address_params.street_name) > 0) or
    (pos(' пр.', address_params.street_name) > 0) then
      LAddress.Caption := LAddress.Caption +address_params.street_name+', '
  else
    LAddress.Caption := LAddress.Caption+', ул. '+address_params.street_name+', ';
  LAddress.Caption := LAddress.Caption+'дом '+InttoStr(address_params.n_house);
  if address_params.f_house <> 0 then
    LAddress.Caption := LAddress.Caption+'-'+IntToStr(address_params.f_house);
  LAddress.Caption := LAddress.Caption+trim(address_params.a_house);
  if address_params.d_house <> 0 then
    LAddress.Caption := LAddress.Caption+'/'+Inttostr(address_params.d_house);
  if address_params.n_room <> 0 then
    LAddress.Caption := LAddress.Caption+', кв. '+ IntToStr(address_params.n_room)+
      trim(address_params.a_room);

  get_debt_options_by_bankbook(debt_params, ADOQ, IntToStr(current_period_id), bankbook_params.id);
  LMonthSum.Caption := 'Ежемесячное начисление: '+FloatToStr(debt_params.month_sum);
  LNormalSum.Caption := 'Начисление в пределах установленных норм потребления: '+
    FloatToStr(debt_params.normal_sum);
  LMonthCount.Caption := 'Фактическое использование услуги за предыдущий месяц: '+
    Inttostr(debt_params.month_count);
  LLastCount.Caption := 'Последнее оплаченное показание счетчика: '+
    IntToStr(debt_params.last_count);
  LDebtTotal.Caption := 'Задолженность за услугу с учетом льгот: '+
    FloatToStr(debt_params.debt_total);

  get_payer_options_by_bankbook(payer_params, ADOQ, IntToStr(current_period_id), bankbook_params.id);
  LFullnamePayer.Caption := 'ФИО: '+payer_params.full_name;
  LOwnerFullname.Caption := 'ФИО владельца жилья: '+payer_params.owner_full_name;
  LPhone.Caption := 'Телефон: '+payer_params.phone;
  LResidentNumber.Caption := 'Количество зарегистрированных человек: '+
    IntToStr(payer_params.resident_number);

  get_room_options_by_bankbook(room_attributes, ADOQ,
    IntToStr(current_period_id), bankbook_params.id);
  LOneRoom.Caption := 'Однокомнатная квартира: '+
    get_1_from_3(room_attributes.number_rooms);
  if room_attributes.is_lift then
    s := 'ДА'
  else
    s := 'НЕТ';
  LIsLift.Caption := 'Есть ли оплата лифта в расчете квартплаты: '+s;
  LDatePrivatization.Caption := 'Дата приватизации: '+
    DateToStr(room_attributes.date_privatization);
  LFormProperty.Caption := 'Форма собственности: '+
    ownership[room_attributes.form_property];
  LTotalArea.Caption := 'Общая площадь: '+FloatToStr(room_attributes.total_area);
  LHeatArea.Caption := 'Отапливаемая площадь: '+
    FloatToStr(room_attributes.heat_area);
  LQuotaArea.Caption := 'Площадь в пределах норм использования: '+
    FloatToStr(room_attributes.quota_area);
  LCalcDevice.Caption := 'Есть ли прибор учета: '+
    get_1_from_3(room_attributes.counter_state);
  LDateCalcDevice.Caption := 'Дата установки/снятия прибора учета: '+
    DateToStr(room_attributes.date_calc_device);
  LBoiler.Caption := 'Есть ли бойлер: '+get_1_from_3(room_attributes.boiler);
  LWaterHeater.Caption := 'Есть ли колонка: '+
    get_1_from_3(room_attributes.water_heater);
  LHeatType.Caption := 'Тип отопления: '+type_heat[room_attributes.heat_type];
  LChangeHeatDate.Caption := 'Дата изменения типа отопления: '+
    DateToStr(room_attributes.change_heat_date);

  get_privilege_options_by_bankbook(privilege_params, ADOQ,
    IntToStr(current_period_id), bankbook_params.id);
  LSum01122006.Caption := 'Сумма долга на 01.12.2006: '+
    FloatToStr(privilege_params.sum_01122006);
  LPactDate.Caption := 'Дата договора на реструктуризацию долга: '+
    DateToStr(privilege_params.pact_date);
  LPactNumber.Caption := 'Номер договора на реструктуризацию долга: '+
    privilege_params.pact_number;
  LSumRestruct.Caption := 'Сумма реструктурируемой задолженности по договору: '+
    FloatToStr(privilege_params.debt_sum_restruct);
  LSubsidy.Caption := 'Сумма субсидии: '+ FloatToStr(privilege_params.subsidy);
  LSubsidyDate.Caption := 'Дата начисления субсидии: '+
    DateToStr(privilege_params.subsidy_date);
  LPrivelege1Code.Caption := 'Код первой льготы: '+
    IntToStr(privilege_params.privilege1_code);
  LPrivelege1Users.Caption := 'Количество человек, пользующихся льготой: '+
    IntToStr(privilege_params.privilege1_users);
  LPrivelege1Category.Caption := 'Категория льготы: '+
    IntToStr(privilege_params.privilege1_category);
  LPrivilege1Date.Caption := 'Дата предоставления/снятия льготы: '+
    DateToStr(privilege_params.privilege1_date);
  LPrivilege1Doc.Caption := 'Вид документа, дающего право на льготу: '+
    privilege_params.privilege1_doc;
  LPrivilege1DocNumber.Caption := 'Серия и номер документа, дающего право на льготу: '+
    privilege_params.privilege1_doc_number;
  LPrivilege1Who.Caption := 'Кем выдан документ, дающий право на льготу: '+
    privilege_params.privilege1_doc_who;
  LPrivilege1DocDate.Caption := 'Дата выдачи документа, дающего право на льготу: '+
    DateToStr(privilege_params.privilege1_doc_date);
  LPrivilege1Percent.Caption := 'Размер льготы в процентах: '+
    FloatToStr(privilege_params.privilege1_percent);
end;

procedure TFormFullInfo.TSPartInfoClick(Sender: TObject);
begin
  GBDebt.Visible := TSPartInfo.TabIndex = 0;
  GBPayer.Visible := TSPartInfo.TabIndex = 1;
  GBHome.Visible := TSPartInfo.TabIndex = 2;
  GBSubsidy.Visible := TSPartInfo.TabIndex = 3;

end;

end.
