unit PayerInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  db_service, ADODB,
  Dialogs, StdCtrls, ComCtrls, Tabs, DB;

type
  TPayerInfoForm = class(TForm)
    LCodeERC: TLabel;
    LFullName: TLabel;
    LBankbook: TLabel;
    LAddress: TLabel;
    LFirm: TLabel;
    LService: TLabel;
    ADOQ: TADOQuery;
    Lperiod: TLabel;
    CBPeriod: TComboBox;
    GBSubsidy: TGroupBox;
    LSum01122006: TLabel;
    LPactDate: TLabel;
    LPrivelege1Code: TLabel;
    LPrivelege1Users: TLabel;
    LPrivilege1Date: TLabel;
    LPrivilege1Percent: TLabel;
    Label2: TLabel;
    LPrivelege2Users: TLabel;
    LPrivilege2Date: TLabel;
    LPrivilege2Percent: TLabel;
    Label6: TLabel;
    LPrivelege3Users: TLabel;
    LPrivilege3Date: TLabel;
    LPrivilege3Percent: TLabel;
    Label10: TLabel;
    LPrivelege4Users: TLabel;
    LPrivilege4Date: TLabel;
    LPrivilege4Percent: TLabel;
    Label14: TLabel;
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

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TSPartInfoClick(Sender: TObject);
    procedure CBPeriodSelect(Sender: TObject);
  private
    report_date_params: TReportDateOptions;
    current_period_id: integer;
    period_list : TStringList;
    procedure update_payer_data;
  public
    current_owner_erc_code: TERCCodeOwnerParams;
    bankbook_params:TBankbookParams;
  end;

var
  PayerInfoForm: TPayerInfoForm;

implementation
uses
  verify_data;
var
  q: TADOQuery;
  sp: TADOStoredProc;
  ds: TADODataSet;

{$R *.dfm}


procedure TPayerInfoForm.CBPeriodSelect(Sender: TObject);
begin
  current_period_id := TReportDateOptions(period_list.Objects[CBPeriod.ItemIndex]).id;
  update_payer_data;
end;

procedure TPayerInfoForm.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  sp := TADOStoredProc.Create(self);
  ds := TADODataSet.Create(self);
  report_date_params := TReportDateOptions.Create;
  period_list := TStringList.Create;
end;

procedure TPayerInfoForm.FormShow(Sender: TObject);
var
  address_params: TAddressParams;
begin
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  sp.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  ds.Connection := FormMain.ADOConnectionMain;//String := connection_string;

  LCodeERC.Caption :=
    '��� ���: ' + Inttostr(current_owner_erc_code.erc_code);
  LFullName.Caption := '���: '+ current_owner_erc_code.fullName;
  LBankbook.Caption := '������� ����: '+ bankbook_params.bank_book;
  LFirm.Caption := '�����������: '+
    IntToStr(bankbook_params.code_firm)+'; '+
    get_firm_name_by_firm_id(q, bankbook_params.code_firm);
  LService.Caption := '�������� �������: '+
    get_service_name_by_service_id(q, bankbook_params.code_utility);
  get_address_params_by_bankbook(address_params, q, Inttostr(bankbook_params.code_firm),
//    IntToStr(bankbook_params.code_utility),
    bankbook_params.bank_book);

  LAddress.Caption := '�����: '+ address_params.city_type+' '
    + address_params.city_name;
  LAddress.Caption := LAddress.Caption+', '+address_params.street_type+
    ' '+address_params.street_name+', ';
  LAddress.Caption := LAddress.Caption+'��� '+InttoStr(address_params.n_house);
  if address_params.f_house <> 0 then
    LAddress.Caption := LAddress.Caption+'-'+IntToStr(address_params.f_house);
  LAddress.Caption := LAddress.Caption+trim(address_params.a_house);
  if address_params.d_house <> 0 then
    LAddress.Caption := LAddress.Caption+'/'+Inttostr(address_params.d_house);
  if address_params.n_room <> 0 then
    LAddress.Caption := LAddress.Caption+', ��. '+ IntToStr(address_params.n_room)+
      trim(address_params.a_room);

  get_periods_by_bankbook(period_list, q, bankbook_params.id);
  CBPeriod.Clear;
  if period_list.Count=0 then begin
//    TSPartInfo.Hide;
//    CBPeriod.Hide;
//    Lperiod.Hide;
//    GBHome.Hide;
//    GBSubsidy.Hide;
//    GBPayer.Hide;
//    GBDebt.Hide;
    exit;
  end else begin
//    TSPartInfo.Visible := true;
//    CBPeriod.Visible := true;
//    Lperiod.Visible := true;
//    GBHome.Visible := true;
//    GBSubsidy.Visible := true;
//    GBPayer.Visible := true;
//    GBDebt.Visible := true;
  end;
  CBPeriod.Items := period_list;
  CBPeriod.ItemIndex := 0;
  current_period_id := TReportDateOptions(period_list.objects[CBPeriod.ItemIndex]).id;
  update_payer_data;
end;

procedure TPayerInfoForm.TSPartInfoClick(Sender: TObject);
begin
  GBDebt.Visible := TSPartInfo.TabIndex = 0;
  GBPayer.Visible := TSPartInfo.TabIndex = 1;
  GBHome.Visible := TSPartInfo.TabIndex = 2;
  GBSubsidy.Visible := TSPartInfo.TabIndex = 3;
end;

procedure TPayerInfoForm.update_payer_data;
var
  debt_params: TDebtOptions;
  payer_params: TPayerOptions;
  room_attributes: TRoomOptions;
  privilege_params: TPrivilege;
  s: string;

function get_1_from_3(value: integer):string;
begin
  if value = 0 then
    result := '��� ����������'
  else if value = 1 then
    Result := '��'
  else
    Result := '���';
end;
begin
  debt_params := TDebtOptions.Create;
  get_debt_options_by_bankbook(debt_params, q, IntToStr(current_period_id),
    bankbook_params.id_utility);
  LDateDebt.Caption := '���� ��: '+DateToStr(debt_params.debt_date)+
  ' ����� '+FloatToStr(debt_params.sum_dolg1);
  LExes.Caption := '�������������� �����: '+FloatToStr(debt_params.month_count+
    debt_params.month_count2+ debt_params.month_count3);
  LProfit.Caption := '���������: '+FloatToStr(debt_params.sum_month);
  LRecount.Caption := '����������: '+FloatToStr(debt_params.sum_recalculation);
  LPayment.Caption := '������ (� ���������): '+FloatToStr(debt_params.sum_pay);
  LDebtNext.Caption := '���� �� ������ ���������� ������: '+
    FloatToStr(debt_params.sum_dolg);
  LCounter1.Caption := '������� 1: '+ FloatToStr(debt_params.end_count);
  LCounter2.Caption := '������� 2: '+ FloatToStr(debt_params.end_count2);
  LCounter3.Caption := '������� 3: '+ FloatToStr(debt_params.end_count3);

  get_payer_options_by_bankbook(payer_params, q, IntToStr(current_period_id),
    bankbook_params.id);
  LFullnamePayer.Caption := '���: '+payer_params.full_name;
  LOwnerFullname.Caption := '��� ��������� �����: '+payer_params.owner_full_name;
  LPhone.Caption := '�������: '+payer_params.phone;
  LResidentNumber.Caption := '���������� ������������������ �������: '+
    IntToStr(payer_params.resident_number);

  get_room_options_by_bankbook(room_attributes, q,
    IntToStr(current_period_id), bankbook_params.id);
  LOneRoom.Caption := '������������� ��������: '+
    get_1_from_3(room_attributes.number_rooms);
  if room_attributes.is_lift then
    s := '��'
  else
    s := '���';
  LIsLift.Caption := '���� �� ������ ����� � ������� ����������: '+s;
  LDatePrivatization.Caption := '���� ������������: '+
    DateToStr(room_attributes.date_privatization);
  LFormProperty.Caption := '����� �������������: '+
    ownership[room_attributes.form_property];
  LTotalArea.Caption := '����� �������: '+FloatToStr(room_attributes.total_area);
  LHeatArea.Caption := '������������ �������: '+
    FloatToStr(room_attributes.heat_area);
  LQuotaArea.Caption := '������� � �������� ���� �������������: '+
    FloatToStr(room_attributes.quota_area);
  LCalcDevice.Caption := '���� �� ������ �����: '+
    get_1_from_3(room_attributes.counter_state);
  LDateCalcDevice.Caption := '���� ���������/������ ������� �����: '+
    DateToStr(room_attributes.date_calc_device);
  LCounterType.Caption := '��� ������� �����: '+
    IntToStr(room_attributes.counter_type);
  LBoiler.Caption := '���� �� ������: '+get_1_from_3(room_attributes.boiler);
  LWaterHeater.Caption := '���� �� �������: '+
    get_1_from_3(room_attributes.water_heater);
  LHeatType.Caption := '��� ���������: '+type_heat[room_attributes.heat_type];
  LChangeHeatDate.Caption := '���� ��������� ���� ���������: '+
    DateToStr(room_attributes.change_heat_date);

  get_privilege_options_by_bankbook(privilege_params, q,
    IntToStr(current_period_id), bankbook_params.id_utility);
  LSum01122006.Caption := '����� ����� �� 01.12.2006: '+
    FloatToStr(privilege_params.sum_01122006);
  LPactDate.Caption := '���� �������� �� ���������������� �����: '+
    DateToStr(privilege_params.pact_date);
  LPrivelege1Users.Caption := '���������� �������, ������������ �������: '+
    IntToStr(privilege_params.privilege1_users);
  LPrivilege1Date.Caption := '���� ��������������/������ ������: '+
    DateToStr(privilege_params.privilege1_date);
  LPrivilege1Percent.Caption := '������ ������ � ���������: '+
    FloatToStr(privilege_params.privilege1_percent);
  LPrivelege2Users.Caption := '���������� �������, ������������ �������: '+
    IntToStr(privilege_params.privilege2_users);
  LPrivilege2Date.Caption := '���� ��������������/������ ������: '+
    DateToStr(privilege_params.privilege2_date);
  LPrivilege2Percent.Caption := '������ ������ � ���������: '+
    FloatToStr(privilege_params.privilege2_percent);
  LPrivelege3Users.Caption := '���������� �������, ������������ �������: '+
    IntToStr(privilege_params.privilege3_users);
  LPrivilege3Date.Caption := '���� ��������������/������ ������: '+
    DateToStr(privilege_params.privilege3_date);
  LPrivilege3Percent.Caption := '������ ������ � ���������: '+
    FloatToStr(privilege_params.privilege3_percent);
  LPrivelege4Users.Caption := '���������� �������, ������������ �������: '+
    IntToStr(privilege_params.privilege4_users);
  LPrivilege4Date.Caption := '���� ��������������/������ ������: '+
    DateToStr(privilege_params.privilege4_date);
  LPrivilege4Percent.Caption := '������ ������ � ���������: '+
    FloatToStr(privilege_params.privilege4_percent);
  LPrivelege5Users.Caption := '���������� �������, ������������ �������: '+
    IntToStr(privilege_params.privilege5_users);
  LPrivilege5Date.Caption := '���� ��������������/������ ������: '+
    DateToStr(privilege_params.privilege5_date);
  LPrivilege5Percent.Caption := '������ ������ � ���������: '+
    FloatToStr(privilege_params.privilege5_percent);
end;

end.
