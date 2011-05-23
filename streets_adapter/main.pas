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
    QUTCStreets: TQuery;
    DSUTCStreets: TDataSource;
    DBNUTCStreet: TDBNavigator;
    BSave: TButton;
    BAdd: TButton;
    CBType: TComboBox;
    BSplit: TButton;
    LLinkedTo: TLabel;
    procedure CBCitySelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBNERCStreetClick(Sender: TObject; Button: TNavigateBtn);
    procedure BSaveClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BSplitClick(Sender: TObject);
    procedure DBNUTCStreetClick(Sender: TObject; Button: TNavigateBtn);
  private
    { Private declarations }
    q: TADOQuery;
    city_id: array[0..100] of integer;
    is_analog: boolean;
    is_link: boolean;
    current_firm_id: integer;
    function get_code_street(id_street, erc_code: integer): string;
    procedure Actualize;
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
  s := DBGridUTC.Columns[2].field.value;
  if pos(chr(63), s)=1 then begin
    s := copy(s,2,length(s)-1);
    Insert('I', s, 1);
  end;
  s := AnsiReplaceStr(s, ' '+chr(63), ' '+chr(73));
  s := AnsiReplaceStr(s, chr(39), '"');
  LEName2.Text := AnsiReplaceStr(s, chr(63), chr(105));
  is_link := true;
end;

procedure TMainForm.BSaveClick(Sender: TObject);
var
  BigInteger    : Int64;
  bmCurrent : TBookmark;  { Holds the current position }
begin
  if is_link then begin
    BigInteger := DBGridUTC.Columns[0].Field.value;
    q.SQL.Clear;
    if is_analog then
      q.SQL.Add('UPDATE truth_street_codes SET code_street='+
      IntToStr(BigInteger)+
      ' WHERE id_street='+QStreets.FieldByName('id').AsString+
      ' AND id_firm='+IntToStr(current_firm_id))
    else
      q.SQL.Add('INSERT INTO truth_street_codes VALUES('+
      QStreets.FieldByName('id').AsString+', '+
      IntToStr(current_firm_id)+', '+IntToStr(BigInteger)+')');
    q.ExecSQL;
    BSplit.Enabled := true;
  end;
  q.SQL.Clear;
  q.SQL.Add('UPDATE streets1 SET name='''+trim(LEName.Text)+''', name2='''+
    trim(LEName2.Text)+''', type_id='+IntToStr(CBType.ItemIndex+1)+
    'WHERE id='+QStreets.FieldByName('id').AsString);
  q.ExecSQL;
  q.Close;

  with DBNERCStreet.DataSource.DataSet do
  begin
    bmCurrent := getBookmark;       { save position }
    try
      CBCitySelect(Sender);
      gotoBookmark(bmCurrent);     { restore position }
    finally;
      freeBookmark(bmCurrent);     { free memory }
    end;
  end;
  Actualize;
end;

procedure TMainForm.BSplitClick(Sender: TObject);
begin
  q.SQL.Clear;
  q.SQL.Add('DELETE FROM truth_street_codes WHERE id_street='+
    QStreets.FieldByName('id').AsString+
    ' AND id_firm='+IntToStr(current_firm_id));
  q.ExecSQL;
  q.Close;
  Actualize;
  BSplit.Enabled := false;
end;

procedure TMainForm.CBCitySelect(Sender: TObject);
begin
  with QStreets do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT s.id, s.code_s, s.type_id, t.short_name ts, s.name, s.name2 FROM streets1 s JOIN street_name_types t ON s.type_id=t.id WHERE s.id_city='+
      Inttostr(city_id[CBCity.ItemIndex])+' ORDER BY s.name');
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
  DBGridERC.Columns[0].FieldName := 'code_s';
  DBGridERC.Columns[1].FieldName := 'ts';
  DBGridERC.Columns[2].FieldName := 'name';
  DBGridERC.Columns[3].FieldName := 'name2';
end;

function TMainForm.get_code_street(id_street, erc_code: integer): string;
begin
  Result := 'Код: '+IntToStr(erc_code);
  is_analog := false;
  q.SQL.Clear;
  q.SQL.Add('SELECT code_street FROM truth_street_codes WHERE id_street='+
    IntToStr(id_street)+
    ' AND id_firm='+IntToStr(current_firm_id));
  q.Open;
  q.First;
  if q.recordCount > 0 then begin
    Result := Result+' == '+q.FieldByName('code_street').AsString;
    is_analog := true;
    BSplit.Enabled := true;
  end;
  q.Close;
end;

procedure TMainForm.Actualize;
begin
  LCodeStreet.Caption := get_code_street(QStreets.FieldByName('id').AsInteger,
    DBGridERC.Columns[0].field.value);
  CBType.ItemIndex := QStreets.FieldByName('type_id').AsInteger-1;
  LEName.Text := DBGridERC.Columns[2].Field.Value;
  if DBGridERC.Columns[3].field.IsNull then
    LEName2.Text := ''
  else
    LEName2.Text := DBGridERC.Columns[3].Field.Value;
end;

procedure TMainForm.DBNERCStreetClick(Sender: TObject; Button: TNavigateBtn);
begin
  case Button of
    nbFirst, nbPrior, nbNext, nbLast: begin
//      is_analog := false;
      is_link := false;
      Actualize;
      BSplit.Enabled := is_analog;
    end;
  end;
end;

procedure TMainForm.DBNUTCStreetClick(Sender: TObject; Button: TNavigateBtn);
var
  BigInteger    : Int64;
begin
  BigInteger := DBGridUTC.Columns[0].Field.value;
  q.SQL.Clear;
  q.SQL.Add('SELECT code_street, s.code_s sc FROM truth_street_codes JOIN streets1 s ON id_street=s.id WHERE code_street='+
    IntToStr(BigInteger)+
    ' AND id_firm='+IntToStr(current_firm_id));
  q.Open;
  q.First;
  if q.recordCount > 0 then
    LLinkedTo.Caption := 'Связь с '+ q.FieldByName('sc').AsString
  else
    LLinkedTo.Caption := '';
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
// debug only!!!!!
  current_firm_id := 6446;
  is_analog := false;
  is_link := false;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Settings.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=S-050-ERC; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER_TEST');
  Settings.Free;
  QStreets.ConnectionString := connection_string;
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM cities ORDER BY name');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBCity.Items.Add(q.FieldByName('name').AsString);
    city_id[i] := q.FieldByName('id').AsInteger;
    q.Next;
  end;
  q.Close;

  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM street_name_types ORDER BY id');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBType.Items.Add(q.FieldByName('full_name').AsString);
    q.Next;
  end;
  q.Close;
  CBType.ItemIndex := 0;

  with QUTCStreets do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM streets_utc ORDER BY name');
    Open;
  end;
  DBGridUTC.Columns[0].FieldName := 'code';
  DBGridUTC.Columns[1].FieldName := 'type';
  DBGridUTC.Columns[2].FieldName := 'name';

  CBCity.ItemIndex := 0;
  CBCitySelect(Sender);
end;

end.
