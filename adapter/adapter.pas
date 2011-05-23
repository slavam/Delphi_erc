unit adapter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ADODB, DB, DBTables, DBCtrls,
  IniFiles,
  TypInfo;

type TResultField = class(TObject)
  result_field_type: string;
  result_field_name: string;
  result_field_value: string;
end;
type
  TKeyFields = (code_firme, abcount, date_d, code_plat,
    code_c, code_s,
    n_house, f_house, a_house, d_house,
    n_room, a_room);
type
  TFormAdapter = class(TForm)
    CBFirms: TComboBox;
    Label1: TLabel;
    ADOQuery1: TADOQuery;
    LBIn: TListBox;
    LBOut: TListBox;
    Label2: TLabel;
    Label3: TLabel;
    BOpenInData: TButton;
    ODInputData: TOpenDialog;
    QInputData: TQuery;
    LResultFieldName: TLabel;
    EValue: TEdit;
    LBRules: TListBox;
    Label5: TLabel;
    BAddRule: TButton;
    BSaveRules: TButton;
    CBRemainPreviousRules: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BOpenInDataClick(Sender: TObject);
    procedure LBOutDblClick(Sender: TObject);
    procedure BAddRuleClick(Sender: TObject);
    procedure LBInDblClick(Sender: TObject);
    procedure BSaveRulesClick(Sender: TObject);
    procedure CBFirmsSelect(Sender: TObject);
  private
    { Private declarations }
    code_firm: array [0..1000] of integer;
//    result_field_types: array [0..1000] of string;
    input_field_types: array [0..1000] of string;
//    result_field_values: array [0..1000] of string;
    current_code_firm: integer;
    key_fields: TKeyFields;
    is_rules_in_db: boolean;
    procedure UpdateRulesLB;
    function have_key_fields_rules:boolean;
  public
    { Public declarations }
  end;

var
  FormAdapter: TFormAdapter;
  settings: TIniFile;
  connection_string : string;
  result_fields: TStringList;

implementation

{$R *.dfm}

procedure TFormAdapter.BAddRuleClick(Sender: TObject);
begin
  TResultField(result_fields.objects[LBOut.ItemIndex]).result_field_value := trim(EValue.Text);
  UpdateRulesLB;
end;

function TFormAdapter.have_key_fields_rules:boolean;
var
  i: integer;
begin
  result := true;
  for I := 0 to LBRules.Count - 1 do begin
    if (GetEnumValue(TypeInfo(TKeyFields), LBOut.Items[i]) > -1) AND
      (TResultField(result_fields.objects[i]).result_field_value = '<?>') then begin
      result := false;
      exit;
    end;
  end;

end;

procedure TFormAdapter.BOpenInDataClick(Sender: TObject);
var
  inputFileName: string;
  i: integer;
begin
  if ODInputData.Execute then begin
    inputFileName := ODInputData.FileName;
    while pos('\',inputFileName)<>0 do
      delete(inputFileName, 1, pos('\',inputFileName));
    inputFileName := copy(inputFileName, 1, pos('.', inputFileName)-1);
  end else begin
    exit;
  end;
  QInputData.SQL.Clear;
  QInputData.SQL.Add('select * from '+inputFileName);
  QInputData.Open;
  QInputData.First;
  for i:= 0 to QInputData.FieldCount - 1 do begin
    LBIn.Items.Add(QInputData.FieldDefList[i].Name);
    input_field_types[i] := QInputData.Fields[i].ClassName;
  end;
  QInputData.Close;
end;

procedure TFormAdapter.BSaveRulesClick(Sender: TObject);
var
  i: integer;
  input_field_name, default_value: string;
begin
  ADOQuery1.Close;
  if is_rules_in_db then
    if Application.MessageBox(PChar('Заменить предыдущие правила для '+
                            trim(CBFirms.Items[CBFirms.ItemIndex])+'?'),
                            PChar('Adapter'),
                            MB_OKCANCEL+MB_ICONQUESTION) = IDCANCEL then
      exit
    else begin
      ADOQuery1.SQL.clear;
      ADOQuery1.SQL.Add('DELETE FROM conversion_rules WHERE code_firm = '+
        IntToStr(current_code_firm));
      ADOQuery1.ExecSQL;
      ADOQuery1.Close;
    end;
  for I := 0 to LBOut.Items.Count - 1 do begin
    if pos('<', TResultField(result_fields.objects[i]).result_field_value) = 0 then begin
      default_value := TResultField(result_fields.objects[i]).result_field_value;
      input_field_name := '';
    end else begin
      default_value := '';
      input_field_name := copy(TResultField(result_fields.objects[i]).result_field_value,
        2, length(TResultField(result_fields.objects[i]).result_field_value)-2);
    end;
    ADOQuery1.SQL.clear;
    ADOQuery1.SQL.Add('INSERT INTO conversion_rules VALUES ('+
      IntToStr(current_code_firm)+', '''+
      LBOut.Items[i]+''', '''+
      default_value+''', '''+
      input_field_name+''', '''+
      input_field_types[i]+''')');
    ADOQuery1.ExecSQL;
  end;
  ADOQuery1.Close;
  is_rules_in_db := true;
end;

procedure TFormAdapter.CBFirmsSelect(Sender: TObject);
var
  i: integer;
begin
  is_rules_in_db := false;
  LBIn.Clear;
  current_code_firm := code_firm[CBFirms.ItemIndex];
  LBRules.Items.Clear;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('SELECT * FROM conversion_rules WHERE code_firm ='+
    IntToStr(current_code_firm));
  ADOQuery1.Open;
  if ADOQuery1.RecordCount = 0 then begin
    is_rules_in_db := false;
    if not CBRemainPreviousRules.Checked then
      for I := 0 to LBOut.Items.Count - 1 do begin
        if GetEnumValue(TypeInfo(TKeyFields), LBOut.Items[i]) > -1 then
          TResultField(result_fields.objects[i]).result_field_value := '<?>'
        else
          if TResultField(result_fields.objects[i]).result_field_type = 'TStringField' then
            TResultField(result_fields.objects[i]).result_field_value := ''
          else  if TResultField(result_fields.objects[i]).result_field_type = 'TFloatField' then
            TResultField(result_fields.objects[i]).result_field_value := '0'
          else  if TResultField(result_fields.objects[i]).result_field_type = 'TDateTimeField' then
            TResultField(result_fields.objects[i]).result_field_value := '31.12.1899'
          else
            TResultField(result_fields.objects[i]).result_field_value := '0';
      end;
  end else begin
    is_rules_in_db := true;
    ADOQuery1.First;
    if not CBRemainPreviousRules.Checked then
      for I := 0 to ADOQuery1.RecordCount - 1 do begin
        if ADOQuery1.FieldByName('input_field_name').AsString <> '' then
          TResultField(result_fields.objects[i]).result_field_value :=
            '<'+ADOQuery1.FieldByName('input_field_name').AsString+'>'
        else
          TResultField(result_fields.objects[i]).result_field_value :=
            ADOQuery1.FieldByName('default_value').AsString;
        ADOQuery1.Next;
      end;
  end;
  ADOQuery1.Close;
  UpdateRulesLB;

end;

procedure TFormAdapter.FormCreate(Sender: TObject);
var
  i, j: integer;
  rf : TResultField;
begin
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Client.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=S-050-ERC; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER_TEST');
  Settings.Free;

  result_fields := TStringList.Create;
  is_rules_in_db := false;
  ADOQuery1.ConnectionString := connection_string;
(*
	sqlMakeProto.Format("if exists(select name from changes_temp.dbo.sysobjects where name='%s')
  drop table changes_temp.dbo.%s
  create table changes_temp.dbo.%s(code_firme int, name char(14), error int, num_zap int)",
		m_strProtocolName,
		m_strProtocolName,
		m_strProtocolName
		);

     arc_query->SQL->Text="create table ppp ( \
            date_time char(30),\
            name_zp int, \
            kod_obr number, \
            date_ob datetime,\
            uiuyy int \
             )";
     arc_query->ExecSQL();

*)

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('SELECT * FROM active_firms_short_view ORDER BY code');
  ADOQuery1.Open;
  ADOQuery1.First;
  for I := 0 to ADOQuery1.RecordCount - 1 do begin
    CBFirms.Items.Add('('+ADOQuery1.FieldByName('code').AsString+') '
      +ADOQuery1.FieldByName('name').AsString);
    code_firm[i] := ADOQuery1.FieldByName('code').AsInteger;
    ADOQuery1.Next;
  end;
  ADOQuery1.Close;
  CBFirms.ItemIndex := 0;
  current_code_firm := code_firm[0];

  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('SELECT * FROM utilityfiles_bo');
  ADOQuery1.Open;
//  ADOQuery1.ExecSQL;
  ADOQuery1.First;
  LBOut.Clear;
  result_fields.Clear;
  for i:= 0 to ADOQuery1.FieldCount - 1 do
    if (ADOQuery1.FieldDefList[i].Name = 'record_number') or
      (ADOQuery1.FieldDefList[i].Name = 'id_file') then
      Continue
    else begin
      rf := TResultField.Create;
      rf.result_field_type := ADOQuery1.Fields[i].ClassName;
      rf.result_field_name := ADOQuery1.FieldDefList[i].Name;
      rf.result_field_value := '';
      result_fields.AddObject(ADOQuery1.FieldDefList[i].Name, TObject(rf));
    end;
  ADOQuery1.Close;
  LBOut.Items := result_fields;
  CBFirmsSelect(Sender);
end;

procedure TFormAdapter.LBInDblClick(Sender: TObject);
begin
  EValue.Text := '<'+LBIn.Items[LBIn.itemindex]+'>';
end;

procedure TFormAdapter.LBOutDblClick(Sender: TObject);
begin
  LResultFieldName.Caption := LBOut.Items[LBOut.itemindex]+ ' =';
  EValue.Text := TResultField(result_fields.objects[LBOut.itemindex]).result_field_value;
end;

procedure TFormAdapter.UpdateRulesLB;
var
  i: integer;
begin
  LBRules.Items.Clear;
  for I := 0 to LBOut.Items.Count - 1 do
    LBRules.Items.Add(LBOut.Items[i]+'="'+TResultField(result_fields.objects[i]).result_field_value+'"');
  BSaveRules.Enabled := have_key_fields_rules;
end;

end.

//resourcestring
//  SElementNotFound = 'Element "%s" not found in %s enumeration';
//
//function StrToFakeStr(const AStr: string): TKeyFields;
//var
//  i: Integer;
//begin
//  i := GetEnumValue(TypeInfo(TKeyFields), AStr);
//  if i > -1 then
//    Result := TKeyFields(i)
//  else
//    raise Exception.CreateFmt(SElementNotFound, [AStr, 'TFakeStr']);
//end;

