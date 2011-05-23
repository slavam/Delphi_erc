unit NewBankbook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, mainCRUD,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormNewBankbook = class(TForm)
    CBFirms: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    CBUtility: TComboBox;
    LEBankbook: TLabeledEdit;
    BCreate: TButton;
    BClose: TButton;
    procedure BCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBFirmsSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewBankbook: TFormNewBankbook;

implementation
uses
  DB_service;
var
  q: TADOQuery;
  current_code_firm: integer;
  code_firm: array[0..1000] of integer;
  code_utility: array[0..100] of integer;
{$R *.dfm}

procedure TFormNewBankbook.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormNewBankbook.BCreateClick(Sender: TObject);
var
  bankbook_id, id_human: integer;
  bankbook: string;
begin
  id_human := TERCCodeOwnerParams(FormCRUD.occupant_list.Objects[FormCRUD.LBOccupants.ItemIndex]).id;
  bankbook := trim(LEBankbook.Text);
  if get_bankbook_utilities_id(q, id_human, code_firm[CBFirms.ItemIndex], code_utility[CBUtility.ItemIndex], bankbook)=0 then begin
    bankbook_id := get_bankbook_id(q, id_human, code_firm[CBFirms.ItemIndex], bankbook);
    if bankbook_id=0 then
      with q do begin
        sql.Clear;
        sql.Add('INSERT INTO bankbooks VALUES ('+
          Inttostr(id_human)+', '+
          Inttostr(code_firm[CBFirms.ItemIndex])+', '''+
          bankbook+''')');
        ExecSQL;
        Close;
        bankbook_id := get_bankbook_id(q, id_human, code_firm[CBFirms.ItemIndex], bankbook);
        sql.Clear;
        sql.Add('INSERT INTO bankbook_utilities VALUES ('+
          IntToStr(bankbook_id)+', '+
          IntToStr(code_utility[CBUtility.ItemIndex])+')');
        ExecSQL;
        Close;
      end
    else
      with q do begin
        sql.Clear;
        sql.Add('INSERT INTO bankbook_utilities VALUES ('+
          IntToStr(bankbook_id)+', '+
          IntToStr(code_utility[CBUtility.ItemIndex])+')');
        ExecSQL;
        Close;
      end;
  end;
  Close;
end;

procedure TFormNewBankbook.CBFirmsSelect(Sender: TObject);
var
  i: integer;
begin
  CBUtility.Clear;
  q.SQL.Clear;
  q.SQL.Add('SELECT name, code FROM utilities WHERE code IN '+
    '(SELECT code_utility FROM firm_utilities WHERE code_firm = '+
    Inttostr(code_firm[CBFirms.ItemIndex])+')');
  q.Open;
  q.First;
  for I := 0 to q.RecordCount - 1 do begin
    CBUtility.Items.Add('('+q.FieldByName('code').AsString+') '+q.FieldByName('name').AsString);
    code_utility[i] := q.FieldByName('code').AsInteger;
    q.Next;
  end;
  q.Close;
  CBUtility.ItemIndex := 0;
end;

procedure TFormNewBankbook.FormCreate(Sender: TObject);
var
  i: integer;
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;

  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM active_firms_short_view');
  q.Open;
  q.First;
  for I := 0 to q.RecordCount - 1 do begin
    CBFirms.Items.Add('('+q.FieldByName('code').AsString+') '+q.FieldByName('name').AsString);
    code_firm[i] := q.FieldByName('code').AsInteger;
    q.Next;
  end;
  q.Close;
  CBFirms.ItemIndex := 0;
  current_code_firm := code_firm[0];
end;

procedure TFormNewBankbook.FormShow(Sender: TObject);
begin
  CBFirmsSelect(Sender);
end;

end.
