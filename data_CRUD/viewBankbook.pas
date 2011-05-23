unit viewBankbook;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DB, ADODB, ExtCtrls, DBCtrls, Grids, DBGrids, StdCtrls,
  Dialogs;

type
  TFormBankbook = class(TForm)
    Label1: TLabel;
    DBGrid1: TDBGrid;
    Label2: TLabel;
    DBGrid2: TDBGrid;
    DBNUtility: TDBNavigator;
    Label3: TLabel;
    DBGrid3: TDBGrid;
    ADOQbankbook: TADOQuery;
    DSBankbook: TDataSource;
    ADOQutility: TADOQuery;
    DSUtility: TDataSource;
    ADOTFirms: TADOTable;
    ADOTFirmscode: TIntegerField;
    ADOTFirmsname: TStringField;
    ADOTFirmsid_type: TIntegerField;
    DSFirm: TDataSource;
    DBNFirm: TDBNavigator;
    DBNBankbook: TDBNavigator;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid2Enter(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure DBNUtilityClick(Sender: TObject; Button: TNavigateBtn);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGrid1Enter(Sender: TObject);
    procedure DBNFirmClick(Sender: TObject; Button: TNavigateBtn);
    procedure DBNBankbookClick(Sender: TObject; Button: TNavigateBtn);
  private
  public
  end;

var
  FormBankbook: TFormBankbook;
  payer_list: TStringList;

implementation

uses DB_service,
  mainCRUD,
  FullInfo, ViewInfo;

{$R *.dfm}

procedure TFormBankbook.DBGrid1CellClick(Column: TColumn);
begin
  with ADOQutility do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT name, code FROM utilities WHERE code IN '+
    '(SELECT code_utility FROM firm_utilities WHERE code_firm = '+
    Inttostr(ADOTFirmscode.Value)+')');
    Open;
  end;
  DBGrid2.Columns[0].FieldName := 'code';
  DBGrid2.Columns[1].FieldName := 'name';
  DBGrid2Enter(nil);
end;

procedure TFormBankbook.DBGrid1Enter(Sender: TObject);
begin
  with ADOQutility do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT u.code, u.name FROM firm_utilities fu '+
      'JOIN utilities u ON u.code=fu.code_utility '+
      'WHERE code_firm ='+Inttostr(ADOTFirmscode.Value));
    Open;
  end;
  DBGrid2.Columns[0].FieldName := 'code';
  DBGrid2.Columns[1].FieldName := 'name';
  DBGrid2Enter(Sender);
end;

procedure TFormBankbook.DBGrid2Enter(Sender: TObject);
begin
  with ADOQbankbook do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT bb.code_firm, bu.id id_utility, bu.code_utility, bb.bank_book, bb.id, h.id_city '+
      'FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id '+
      'JOIN humans h ON h.id=bb.id_human '+
      'WHERE bb.code_firm='+Inttostr(ADOTFirmscode.Value)+
      ' AND code_utility='+
      DBGrid2.DataSource.DataSet.FieldByName('code').AsString+
      ' ORDER BY bb.bank_book');
    Open;
  end;
  DBGrid3.Columns[0].FieldName := 'code_firm';
  DBGrid3.Columns[1].FieldName := 'code_utility';
  DBGrid3.Columns[2].FieldName := 'bank_book';
end;

procedure TFormBankbook.DBGrid3DblClick(Sender: TObject);
var
  bb_params: TBankbookParams;
  ADOQ: TADOQuery;
begin
  if FormInfo.Visible then
    FormInfo.Close;
  bb_params := TBankbookParams.Create;
  bb_params.id :=
    DBGrid3.DataSource.DataSet.FieldByName('id').AsInteger;
  bb_params.code_firm :=
    DBGrid3.DataSource.DataSet.FieldByName('code_firm').AsInteger;
  bb_params.code_utility :=
    DBGrid3.DataSource.DataSet.FieldByName('code_utility').AsInteger;
  bb_params.bank_book :=
    DBGrid3.DataSource.DataSet.FieldByName('bank_book').AsString;
  bb_params.id_utility :=
    DBGrid3.DataSource.DataSet.FieldByName('id_utility').AsInteger;
  FormInfo.bankbook_params := bb_params;
  payer_list.Clear;
  ADOQ := TADOQuery.Create(self);
  ADOQ.ConnectionString := connection_string;
  get_payers_by_bankbook_params(payer_list, ADOQ,
    DBGrid3.DataSource.DataSet.FieldByName('code_firm').AsString,
    DBGrid3.DataSource.DataSet.FieldByName('code_utility').AsString,
    bb_params.bank_book);
  TERCCodeOwnerParams(payer_list.Objects[0]).id_city :=
    DBGrid3.DataSource.DataSet.FieldByName('id_city').AsInteger;
  FormInfo.current_owner_erc_code := TERCCodeOwnerParams(payer_list.Objects[0]);
  ADOQ.Free;
  FormInfo.Show;
end;

procedure TFormBankbook.DBNBankbookClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBGrid3DblClick(Sender);
end;

procedure TFormBankbook.DBNFirmClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBGrid1Enter(Sender);
end;

procedure TFormBankbook.DBNUtilityClick(Sender: TObject; Button: TNavigateBtn);
begin
  DBGrid2Enter(Sender);
end;

procedure TFormBankbook.FormCreate(Sender: TObject);
begin
  ADOTFirms.ConnectionString := connection_string;
  ADOQutility.ConnectionString := connection_string;
  ADOQbankbook.ConnectionString := connection_string;
  ADOTFirms.Active := true;
  payer_list := TStringList.Create;
end;

procedure TFormBankbook.FormShow(Sender: TObject);
begin
  DBGrid1Enter(Sender);
end;

end.
