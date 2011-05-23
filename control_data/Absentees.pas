unit Absentees;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB,
  Dialogs, StdCtrls, DB;

type
  TFormAbsentees = class(TForm)
    CBCompareDate: TComboBox;
    Label1: TLabel;
    BCompare: TButton;
    ADOQ: TADOQuery;
    LVerdict: TLabel;
    BShow: TButton;
    LBAbsentees: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BCompareClick(Sender: TObject);
    procedure BShowClick(Sender: TObject);
    procedure LBAbsenteesDblClick(Sender: TObject);
  private
    { Private declarations }
    absent_list, DateList: TStringList;
    absent_number: integer;
  public
    { Public declarations }
  end;

var
  FormAbsentees: TFormAbsentees;

implementation

uses
  controller,
  FullInfo,
  DB_service;
{$R *.dfm}

procedure TFormAbsentees.BCompareClick(Sender: TObject);
begin
  with ADOQ do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM bankbooks WHERE id in '+
      '(SELECT id_bankbook FROM bankbook_attributes_debts WHERE '+
      'id_period = '+
      IntToStr(TReportDateOptions(DateList.Objects[CBCompareDate.ItemIndex]).id)+
      ' AND id_bankbook in '+
        '(SELECT id FROM bankbooks WHERE code_firm = '+
        IntToStr(FormControl.current_firm_code)+ //'))');
        ')) AND bank_book NOT IN (SELECT abcount FROM utilityfiles_bo)');
    open;
    absent_number := RecordCount;
    close;
  end;
  BShow.Enabled := absent_number > 0;
  if absent_number = 0 then
    LVerdict.caption := 'Все счета предприятия на '+
      CBCompareDate.Items[CBCompareDate.itemindex]+' имеются во входном файле.'
  else
    LVerdict.caption := 'На '+CBCompareDate.Items[CBCompareDate.itemindex]+
      ' во входном файле не найдено записей - '+IntToStr(absent_number);

end;

procedure TFormAbsentees.BShowClick(Sender: TObject);
var
  i: integer;
  bb_params : TBankbookParams;

begin
  with ADOQ do begin
    first;
    absent_list.Clear;
    for I := 0 to RecordCount - 1 do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := FieldByName('id_human').AsInteger;
      bb_params.code_firm := FieldByName('code_firm').AsInteger;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      absent_list.AddObject(FieldByName('code_firm').AsString+'-'+
        FieldByName('code_utility').AsString+'-'+
        FieldByName('bank_book').AsString, TObject(bb_params));
      next;
    end;

  end;
  LBAbsentees.Items := absent_list;
end;

procedure TFormAbsentees.FormCreate(Sender: TObject);
begin
  DateList := TStringList.Create;
  absent_list := TStringList.Create;
  ADOQ.ConnectionString := connection_string;
  absent_number := 0;
end;

procedure TFormAbsentees.FormDestroy(Sender: TObject);
begin
  DateList.Free;
  absent_list.Free;
end;

procedure TFormAbsentees.FormShow(Sender: TObject);
begin
  get_report_date_list_by_city(DateList, ADOQ, FormControl.current_city_id);
  CBCompareDate.Items := DateList;
  CBCompareDate.ItemIndex := 0;
  BCompare.Enabled := CBCompareDate.Items.Count > 0;
end;

procedure TFormAbsentees.LBAbsenteesDblClick(Sender: TObject);
var
  l: TStringList;
begin
  FormFullInfo.current_period_id := FormControl.report_date_params.id;
  l := TStringList.Create;
  get_payers_by_bankbook_params(l, ADOQ,
    Inttostr(TBankbookParams(absent_list.Objects[LBAbsentees.ItemIndex]).code_firm),
    IntToStr(TBankbookParams(absent_list.Objects[LBAbsentees.ItemIndex]).code_utility),
    TBankbookParams(absent_list.Objects[LBAbsentees.ItemIndex]).bank_book);
  FormFullInfo.current_owner_erc_code := TERCCodeOwnerParams(l.Objects[0]);
  FormFullInfo.bankbook_params := TBankbookParams(absent_list.Objects[LBAbsentees.ItemIndex]);
  FormFullInfo.ShowModal;
  l.Free;
end;

end.
