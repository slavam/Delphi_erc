unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, ADODB, DB,
  Dialogs, StdCtrls;

const
  PW = 'mwm';
  LOGIN = 'slava';

type
  TMainForm = class(TForm)
    Label1: TLabel;
    CBStreetTemplate: TComboBox;
    BLoad: TButton;
    procedure BLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    q, qq : TADOQuery;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  settings: TIniFile;
  connection_string: string;

implementation

{$R *.dfm}

procedure TMainForm.BLoadClick(Sender: TObject);
function is_street(s_id: string): boolean;
begin
  Result := false;
  qq.SQL.Clear;
  qq.SQL.Add('SELECT * FROM street_locations WHERE id='+s_id);
  qq.Open;
  if qq.RecordCount>0 then
    Result := true;  
end;
var
  error_rec, input_rec: integer;
begin
  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM street_addition_utc');
  q.Open;
  input_rec := q.RecordCount;
  error_rec := 0;
  while not q.Eof do begin
    if is_street(q.FieldByName('street_id').Asstring) then begin
      qq.SQL.Clear;
      qq.SQL.Add('INSERT INTO street_mappings VALUES('+
        IntToStr(integer(CBStreetTemplate.Items.Objects[CBStreetTemplate.ItemIndex]))+', '+
        q.FieldByName('street_id').AsString+', '+
        q.FieldByName('street_code_utc').AsString+', '''+
        q.FieldByName('street_name_utc').AsString+''', '+
        q.FieldByName('street_type_utc').AsString+', '+
        q.FieldByName('city_id').AsString+
        ')');
      try
        qq.ExecSQL;
      except
        ShowMessage('Проблемы с улицей #'+q.FieldByName('street_id').AsString+' '+
        q.FieldByName('street_name_utc').AsString);
        inc(error_rec);
      end;
    end else begin
      ShowMessage('В справочнике не найдена улица #'+q.FieldByName('street_id').AsString+' '+
      q.FieldByName('street_name_utc').AsString);
      inc(error_rec);
    end;
    q.next;
  end;
  q.Close;
  qq.Close;
  ShowMessage('Поступило улиц: '+IntToStr(input_rec)+#10+#13+
    'Загружено улиц: '+IntToStr(input_rec-error_rec)+#10+#13+
    'Отвергнуто улиц: '+ IntToStr(error_rec));
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'utc_adapter.ini');
  connection_string :=
    'Provider='+
    Settings.ReadString('Main', 'PROVIDER', 'SQLOLEDB.1')+
    '; Password='+PW+
    '; Persist Security Info='+
    Settings.ReadString('Main', 'PERSISTSECURITYINFO', 'True')+
    '; User ID='+ LOGIN+
    '; Data Source='+
    Settings.ReadString('Main', 'DATASOURCE', '10.40.28.35')+
    '; Initial Catalog='+
    Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
    Caption := caption+' ('+Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER')+')';
  Settings.Free;
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  qq := TADOQuery.Create(self);
  qq.ConnectionString := connection_string;
  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM street_mapping_templates '+
    'ORDER BY description');
  q.Open;
  while not q.Eof do begin
    CBStreetTemplate.Items.AddObject(q.FieldByName('description').AsString,
      TObject(q.FieldByName('id').AsInteger));
    q.next;
  end;
  q.Close;
  CBStreetTemplate.ItemIndex := 0;
end;

end.
