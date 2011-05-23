unit ViewInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  db_service, ADODB,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormInfo = class(TForm)
    LCodeERC: TLabel;
    LFullName: TLabel;
    LBankbook: TLabel;
    LAddress: TLabel;
    LFirm: TLabel;
    LService: TLabel;
    BSwitch: TButton;
    DTPReportDate: TDateTimePicker;
    BShowFullInfo: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BSwitchClick(Sender: TObject);
    procedure BShowFullInfoClick(Sender: TObject);
    procedure DTPReportDateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    is_short_view: boolean;
    report_date_params: TReportDateOptions;
    report_date: Extended;
  public
    current_owner_erc_code: TERCCodeOwnerParams;
    bankbook_params:TBankbookParams;
  end;

var
  FormInfo: TFormInfo;

implementation
uses
  mainCRUD, FullInfo;
var
  q: TADOQuery;
  sp: TADOStoredProc;
  ds: TADODataSet;

{$R *.dfm}

procedure TFormInfo.BSwitchClick(Sender: TObject);
begin
  if is_short_view then begin
    BSwitch.Caption := 'Скрыть <<';
    DTPReportDate.Show;
    BShowFullInfo.Show;
  end else begin
    BSwitch.Caption := 'Ещё >>';
    DTPReportDate.Hide;
    BShowFullInfo.Hide;
  end;
  is_short_view := not is_short_view;
end;

procedure TFormInfo.BShowFullInfoClick(Sender: TObject);
begin
  if FormFullInfo.Visible then
    FormFullInfo.Close;
  FormFullInfo.current_owner_erc_code := current_owner_erc_code;
  FormFullInfo.bankbook_params := bankbook_params;
  FormFullInfo.current_period_id := report_date_params.id;
  FormFullInfo.Show;
end;

procedure TFormInfo.DTPReportDateChange(Sender: TObject);
begin
  report_date_params.id := -1;
  report_date := DTPReportDate.Date;
  get_report_date_params(report_date_params, sp, ds,
    current_owner_erc_code.id_city, report_date);
  BShowFullInfo.Enabled := report_date_params.id > 0;
end;

procedure TFormInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (FormFullInfo <> nil) and FormFullInfo.Visible then
    FormFullInfo.Close;
end;

procedure TFormInfo.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  sp := TADOStoredProc.Create(self);
  sp.ConnectionString := connection_string;
  ds := TADODataSet.Create(self);
  ds.ConnectionString := connection_string;
  is_short_view := true;
  report_date_params := TReportDateOptions.Create;
end;

procedure TFormInfo.FormShow(Sender: TObject);
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
    IntToStr(bankbook_params.code_utility), bankbook_params.bank_book);

  LAddress.Caption := 'Адрес: '+ address_params.city_type+' '
    + address_params.city_name;
  LAddress.Caption := LAddress.Caption+', '+address_params.street_type+
    ' '+address_params.street_name+', ';
  LAddress.Caption := LAddress.Caption+'дом '+InttoStr(address_params.n_house);
  if address_params.f_house <> 0 then
    LAddress.Caption := LAddress.Caption+'-'+IntToStr(address_params.f_house);
  LAddress.Caption := LAddress.Caption+trim(address_params.a_house);
  if address_params.d_house <> 0 then
    LAddress.Caption := LAddress.Caption+'/'+Inttostr(address_params.d_house);
  if address_params.n_room <> 0 then
    LAddress.Caption := LAddress.Caption+', кв. '+ IntToStr(address_params.n_room)+
      trim(address_params.a_room);

  DTPReportDateChange(Sender);
end;

end.
