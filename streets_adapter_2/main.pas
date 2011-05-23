unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, DBTables, StrUtils,
  Dialogs, StdCtrls, Grids, DBGrids, DB, ADODB, ExtCtrls, DBCtrls;

type
  TMainForm = class(TForm)
    DSStreets: TDataSource;
    QStreets: TADOQuery;
    DBGridERC: TDBGrid;
    CBCity: TComboBox;
    Label4: TLabel;
    CBFirm: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    DBNERCStreet: TDBNavigator;
    Panel1: TPanel;
    LCodeStreet: TLabel;
    LEName: TLabeledEdit;
    Label3: TLabel;
    LEName2: TLabeledEdit;
    DBGridUTC: TDBGrid;
    DSUTCStreets: TDataSource;
    DBNUTCStreet: TDBNavigator;
    BSave: TButton;
    BAdd: TButton;
    CBType: TComboBox;
    BSplit: TButton;
    LLinkedTo: TLabel;
    QUTCStreets: TADOQuery;
    CBStreetTemplates: TComboBox;
    Label5: TLabel;
    BDisposition: TButton;
    procedure CBCitySelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBNERCStreetClick(Sender: TObject; Button: TNavigateBtn);
    procedure BSaveClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BSplitClick(Sender: TObject);
    procedure DBNUTCStreetClick(Sender: TObject; Button: TNavigateBtn);
    procedure CBStreetTemplatesSelect(Sender: TObject);
    procedure BDispositionClick(Sender: TObject);
  private
    { Private declarations }
    q: TADOQuery;
    city_id: array[0..2000] of integer;
    is_link: boolean;
//    current_firm_id: integer;
    current_street_template_id: integer;
    function get_code_street(id_location, erc_code_street: integer): string;
    procedure Actualize;
    procedure  init_utc_streets;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  settings: TIniFile;
  connection_string : string;

implementation

{$R *.dfm}

procedure TMainForm.BAddClick(Sender: TObject);
var
  s: string;
begin
  s := DBGridUTC.Columns[3].field.value;
  s := AnsiReplaceStr(s, chr(39), '"');
  LEName2.Text := s; 
  is_link := true;
end;

procedure TMainForm.BDispositionClick(Sender: TObject);
var
  format_date: string ;
  qq: TQuery;
begin
  format_date := 'dd.mm.yyyy';
  qq := TQuery.Create(self);
  qq.DatabaseName := 'ERC_DATA';
  qq.SQL.Clear;
  qq.SQL.Add('DELETE FROM bo644601');
  qq.ExecSQL;
  qq.Free;

  q.SQL.Clear;
  q.SQL.Add('TRUNCATE table ukrtelecom_address_dispositions');
  q.ExecSQL;
  q.SQL.Clear;
  q.SQL.Add('INSERT INTO ukrtelecom_address_dispositions '+
    'SELECT  6446 firm, 901 utility, '''' bankbook, '''+   // top 50
    DateToStr(Date)+
//    +FormatDateTime(format_date,Date())+
    ''', 0 debt, 0 sum, full_name , 1 city_id, sm.code_street_outer, '+
    'h.n_house, h.f_house, h.a_house, h.d_house, '+
    'r.n_room, r.a_room, '''' prim '+
    'FROM humans hum '+
    'JOIN room_locations rl ON rl.id=hum.id_room_location '+
      'JOIN rooms r ON r.id=rl.id_room '+
    'JOIN house_locations hl ON hl.id=rl.id_house_location '+
      'JOIN houses h ON h.id=hl.id_house '+
    'JOIN street_locations sl ON sl.id=hl.id_street_location '+
      'JOIN street_mappings sm ON sm.id_street_location=sl.id AND sm.id_template=5 '+
    'WHERE hum.id_city=1');
  q.ExecSQL;
  q.Close;
  ShowMessage('Диспозиция адресов создана');
end;

procedure TMainForm.BSaveClick(Sender: TObject);
var
  BigInteger    : Int64;
  bmCurrent : TBookmark;  { Holds the current position }
begin
  if is_link then begin
    BigInteger := DBGridUTC.Columns[0].Field.value;
    q.SQL.Clear;
    q.SQL.Add('UPDATE street_mappings SET id_street_location='+
      QStreets.FieldByName('location').AsString+
      ' WHERE id_template=5 AND code_street_outer='+IntToStr(BigInteger));
    q.ExecSQL;
    BSplit.Enabled := true;
  end;
  q.SQL.Clear;
  q.SQL.Add('UPDATE street_locations SET id_type='+
    IntToStr(CBType.ItemIndex)+
    ', name='''+trim(LEName.Text)+
    ''', second_name='''+trim(LEName2.Text)+
    ''' WHERE id='+QStreets.FieldByName('location').AsString);
  q.ExecSQL;
  q.Close;

  with DBNERCStreet.DataSource.DataSet do
  begin
    bmCurrent := getBookmark;       { save position }
    CBCitySelect(Sender);
    gotoBookmark(bmCurrent);     { restore position }
  end;
  with DBNUTCStreet.DataSource.DataSet do
  begin
    bmCurrent := getBookmark;       { save position }
    try
      init_utc_streets;
      gotoBookmark(bmCurrent);     { restore position }
    finally;
      freeBookmark(bmCurrent);     { free memory }
    end;
  end;
  Actualize;
end;

procedure TMainForm.BSplitClick(Sender: TObject);
var
  BigInteger    : Int64;
  bmCurrent : TBookmark;  { Holds the current position }
begin
  BigInteger := DBGridUTC.Columns[0].Field.value;
  q.SQL.Clear;
  q.SQL.Add('UPDATE street_mappings SET id_street_location=0'+
    ' WHERE id_template=5 AND id_street_location='+
    QStreets.FieldByName('location').AsString);
//    code_street_outer='+IntToStr(BigInteger));
//
//  q.SQL.Add('DELETE FROM truth_street_codes WHERE id_street='+
//    QStreets.FieldByName('id').AsString+
//    ' AND id_firm='+IntToStr(current_firm_id));
  q.ExecSQL;
  q.Close;
  with DBNUTCStreet.DataSource.DataSet do
  begin
    bmCurrent := getBookmark;       { save position }
    try
      init_utc_streets;
      gotoBookmark(bmCurrent);     { restore position }
    finally;
      freeBookmark(bmCurrent);     { free memory }
    end;
  end;
  Actualize;
  BSplit.Enabled := false;
end;

procedure TMainForm.CBCitySelect(Sender: TObject);
begin
  with QStreets do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT sl.id_type ti, sl.id location, sm.code_street_outer code, st.short_name ts, sl.name name, sl.second_name name2 '+
      'from street_locations sl '+
      'join street_types st on st.id=sl.id_type '+
      'join street_mappings sm on sm.id_street_location=sl.id and sm.id_template='+
      IntToStr(current_street_template_id)+
      'where id_city='+Inttostr(city_id[CBCity.ItemIndex])+' ORDER BY sl.name');
    Open;
    if recordcount > 0 then begin
      DBNERCStreetClick(Sender, nbFirst);
      BSave.Enabled := true;
    end else begin
      LCodeStreet.Caption := 'Код:';
      CBType.ItemIndex := 0;
      LEName.Text := '';
      LEName2.Text := '';
      BSave.Enabled := false;
    end;

  end;
  DBGridERC.Columns[0].FieldName := 'location';
  DBGridERC.Columns[1].FieldName := 'code';
  DBGridERC.Columns[2].FieldName := 'ts';
  DBGridERC.Columns[3].FieldName := 'name';
  DBGridERC.Columns[4].FieldName := 'name2';
end;

procedure TMainForm.CBStreetTemplatesSelect(Sender: TObject);
begin
  current_street_template_id := CBStreetTemplates.ItemIndex+1;
  CBCitySelect(Sender);
end;

function TMainForm.get_code_street(id_location, erc_code_street: integer): string;
begin
  Result := 'Код: '+IntToStr(erc_code_street);
  q.SQL.Clear;
  q.SQL.Add('SELECT code_street_outer FROM street_mappings WHERE id_template=5 '+
    ' AND id_street_location='+IntToStr(id_location));
  q.Open;
  q.First;
  BSplit.Enabled := false;
  if q.recordCount > 0 then begin
    Result := Result+' == '+q.FieldByName('code_street_outer').AsString;
    BSplit.Enabled := true;
  end;
  q.Close;
end;

procedure TMainForm.Actualize;
begin
  LCodeStreet.Caption := get_code_street(QStreets.FieldByName('location').AsInteger,
    DBGridERC.Columns[0].field.value);
  CBType.ItemIndex := QStreets.FieldByName('ti').AsInteger;
  LEName.Text := DBGridERC.Columns[3].Field.Value;
  if DBGridERC.Columns[4].field.IsNull then
    LEName2.Text := ''
  else
    LEName2.Text := DBGridERC.Columns[4].Field.Value;
end;

procedure TMainForm.DBNERCStreetClick(Sender: TObject; Button: TNavigateBtn);
begin
  case Button of
    nbFirst, nbPrior, nbNext, nbLast: begin
      is_link := false;
      Actualize;
    end;
  end;
end;

procedure TMainForm.DBNUTCStreetClick(Sender: TObject; Button: TNavigateBtn);
var
  BigInteger    : Int64;
begin
//  BigInteger := DBGridUTC.Columns[0].Field.value;
//  q.SQL.Clear;
//  q.SQL.Add('SELECT code_street, s.code_s sc FROM truth_street_codes JOIN streets1 s ON id_street=s.id WHERE code_street='+
//    IntToStr(BigInteger)+
//    ' AND id_firm='+IntToStr(current_firm_id));
//  q.Open;
//  q.First;
//  if q.recordCount > 0 then
//    LLinkedTo.Caption := 'Связь с '+ q.FieldByName('sc').AsString
//  else
//    LLinkedTo.Caption := '';
end;

procedure  TMainForm.init_utc_streets;
begin
  with QUTCStreets do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM street_mappings s WHERE s.id_template=5 '+
    ' ORDER BY s.name_street_outer');
    Open;
  end;
  DBGridUTC.Columns[0].FieldName := 'code_street_outer';
  DBGridUTC.Columns[1].FieldName := 'id_street_location';
  DBGridUTC.Columns[2].FieldName := 'type_outer';
  DBGridUTC.Columns[3].FieldName := 'name_street_outer';
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
// debug only!!!!!
//  current_firm_id := 6446;
  is_link := false;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Settings.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=S-050-ERC; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
  Settings.Free;
  QUTCStreets.ConnectionString := connection_string;
  QStreets.ConnectionString := connection_string;
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;

  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM street_mapping_templates ORDER BY id');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBStreetTemplates.Items.Add(q.FieldByName('description').AsString);
    q.next;
  end;
  CBStreetTemplates.ItemIndex := 0;

  q.SQL.Clear;
  q.SQL.Add('SELECT c.id id, c.name_rus name, ct.short_name type FROM cities c '+
    'JOIN city_types ct on ct.id=c.id_type '+
    'WHERE id_type > 0 ORDER BY name_rus');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBCity.Items.Add(q.FieldByName('name').AsString+
      ' '+q.FieldByName('type').AsString+
      '-'+q.FieldByName('id').AsString);
    city_id[i] := q.FieldByName('id').AsInteger;
    q.Next;
  end;
  q.Close;

  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM street_types ORDER BY id');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBType.Items.Add(q.FieldByName('full_name').AsString);
    q.Next;
  end;
  q.Close;
  CBType.ItemIndex := 0;

  init_utc_streets;

  CBCity.ItemIndex := 0;
  CBCitySelect(Sender);
end;

end.
