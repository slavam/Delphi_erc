unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, DB, IniFiles,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DBCtrls;

type
  TMode = (mView, mEdit, mNew);

type
  TCityParams = class(TObject)
    id: integer;
    name_1: string;
    name_2: string;
    id_parent: integer;
    last_erc_code: integer;
    id_type: integer;
    code_koatuu: int64;
  end;

type
  TFormMain = class(TForm)
    CBCity: TComboBox;
    Label1: TLabel;
    CBCityTemplate: TComboBox;
    Label5: TLabel;
    CBStreetTemplate: TComboBox;
    Label6: TLabel;
    DBGStreets: TDBGrid;
    DSStreets: TDataSource;
    ADOQStreets: TADOQuery;
    DBNavigator1: TDBNavigator;
    Label2: TLabel;
    LID: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    EName1: TEdit;
    Label8: TLabel;
    EName2: TEdit;
    CBStreetType: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    ELocalStreetId: TEdit;
    Label11: TLabel;
    ELocalStreetName: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    ECity: TEdit;
    EType: TEdit;
    BUpdate: TButton;
    BAdd: TButton;
    BDelete: TButton;
    BSave: TButton;
    BCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CBCitySelect(Sender: TObject);
    procedure CBStreetTemplateSelect(Sender: TObject);
    procedure DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
    procedure DBGStreetsCellClick(Column: TColumn);
    procedure BUpdateClick(Sender: TObject);
    procedure BCancelClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure BAddClick(Sender: TObject);
    procedure BDeleteClick(Sender: TObject);
    procedure ShowStreetData(Sender: TObject; Field: TField);
  private
    city_id: integer;
    q_t, q_in: TADOQuery;
    curr_mode: TMode;
    is_street_mapping_empty: boolean;
    procedure ShowStreetLocalData;
    procedure clear_fields;
    procedure local_street_field_clear;
    procedure set_mode(mode: Tmode);
  public
  end;

var
  FormMain: TFormMain;
  Settings: TIniFile;
  connection_string : string;
  street_template_id: integer;
  local_street_list, street_list, city_list: TStringList;
  log_in, pw: string;

implementation

{$R *.dfm}

procedure TFormMain.BAddClick(Sender: TObject);
begin
  set_mode(mNew);
end;

procedure TFormMain.BCancelClick(Sender: TObject);
begin
  ShowStreetData(nil, nil);
end;

procedure TFormMain.BDeleteClick(Sender: TObject);
var
  sp: TADOStoredProc;
  s: string;
begin
  s := 'Будут удалены все дома, квартиры, плательщики'+
    #10+#13+' и долги по этой улице (ID='+
    IntToStr(DBGStreets.Columns[0].Field.Value)+'). УДАЛИТЬ?';
  if Application.MessageBox(PChar(s),
    PChar('ВНИМАНИЕ!'), MB_YESNO+MB_ICONEXCLAMATION)=IDYES then begin
      sp:= TADOStoredProc.Create(self);
      sp.ConnectionString := connection_string;
      with sp do begin
        ProcedureName := 'up_deleteStreet;1';
        Parameters.CreateParameter('@id_street_location', ftInteger, pdInput, 10,
          DBGStreets.Columns[0].Field.Value);
        ExecProc;
      end;
      sp.Free;
      CBCitySelect(Sender);
    end;
end;

procedure TFormMain.BSaveClick(Sender: TObject);
var
  bmCurrent : TBookmark;  { Holds the current position }
  new_street_id: string;
begin
  bmCurrent := DBGStreets.DataSource.DataSet.getBookmark;       { save position }
  if curr_mode=mEdit then begin
    with q_t do begin
      SQL.Clear;
      SQL.Add('UPDATE street_locations SET '+
        ' id_city='+IntToStr(city_id)+
        ', name='''+UpperCase(trim(EName1.Text))+
        ''', second_name='''+trim(EName2.Text)+
        ''', id_type='+
          IntToStr(integer(CBStreetType.Items.Objects[CBStreetType.ItemIndex]))+
        ' WHERE id='+LID.Caption);
      if is_street_mapping_empty then begin
        if trim(ELocalStreetName.Text)>'' then
          SQL.Add('INSERT INTO street_mappings VALUES('+
            IntToStr(integer(CBStreetTemplate.Items.Objects[CBStreetTemplate.ItemIndex]))+
            ', '+LID.Caption+
            ', '+ELocalStreetId.Text+
            ', '''+trim(ELocalStreetName.Text)+
            ''', '''+trim(EType.Text)+
            ''', '+ECity.Text+')');
      end else
        SQL.Add('UPDATE street_mappings SET '+
          ' code_street_outer='+ELocalStreetId.Text+
          ', name_street_outer='''+trim(ELocalStreetName.Text)+
          ''', type_outer='''+trim(EType.Text)+
          ''', id_city_outer='+ECity.Text+
          ' WHERE id_street_location='+LID.Caption+
          ' AND id_template='+
            IntToStr(integer(CBStreetTemplate.Items.Objects[CBStreetTemplate.ItemIndex])));
      ExecSQL;
      Close;
    end;
  end else begin // add record
    with q_t do begin
      SQL.Clear;
      SQL.Add('INSERT INTO street_locations VALUES('+
        IntToStr(city_id)+
        ', '''+UpperCase(trim(EName1.Text))+
        ''', '''+trim(EName2.Text)+
        ''', '+
        IntToStr(integer(CBStreetType.Items.Objects[CBStreetType.ItemIndex]))+
        ')');
      ExecSQL;
      if trim(ELocalStreetName.Text)>'' then begin
        SQL.Clear;
        SQL.Add('select scope_identity() as new_street_id');
        Open;
        new_street_id := FieldByName('new_street_id').AsString;
        SQL.Clear;
        SQL.Add('INSERT INTO street_mappings VALUES('+
          IntToStr(integer(CBStreetTemplate.Items.Objects[CBStreetTemplate.ItemIndex]))+
          ', '+new_street_id+
          ', '+ELocalStreetId.Text+
          ', '''+trim(ELocalStreetName.Text)+
          ''', '''+trim(EType.Text)+
          ''', '+ECity.Text+')');
        ExecSQL;
      end;
      Close;
    end;
  end;
  CBCitySelect(Sender);
  DBGStreets.DataSource.DataSet.gotoBookmark(bmCurrent);     { restore position }
  DBGStreets.DataSource.DataSet.freeBookmark(bmCurrent);     { free memory }
  ShowStreetData(nil, nil);
end;

procedure TFormMain.BUpdateClick(Sender: TObject);
begin
  set_mode(mEdit);
end;

procedure TFormMain.CBCitySelect(Sender: TObject);
procedure update_city_templates(ci:integer);
var
  i: integer;
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT cmt.id, cmt.[description] FROM cities c '+
      'JOIN city_mappings cm ON c.id=cm.id_city '+
      'JOIN city_mapping_templates cmt ON cm.id_template=cmt.id AND cmt.id>0 '+
      'WHERE c.id='+Inttostr(ci));
    Open;
    if recordcount>0 then begin
      first;
      for I := 0 to recordcount - 1 do begin
        CBCityTemplate.Items.Add(FieldByName('description').AsString);
        next;
      end;
      if CBCityTemplate.ItemIndex < 0 then
        CBCityTemplate.ItemIndex := 0;
      if CBCityTemplate.Items.Count<2 then
        CBCityTemplate.Enabled := false
      else
        CBCityTemplate.Enabled := true;
    end;
    close;
  end;
end;

procedure update_street_templates(ci:integer);
var
  i: integer;
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM street_mapping_templates smt WHERE id in '+
      '(SELECT distinct sm.id_template FROM street_mappings sm '+
        'WHERE sm.id_street_location in '+
          '(SELECT sl.id FROM street_locations sl WHERE sl.id_city='+Inttostr(ci)+'))');
    Open;
    if recordcount>0 then begin
      first;
      for I := 0 to recordcount - 1 do begin
        CBStreetTemplate.Items.AddObject(FieldByName('description').AsString,
        TObject(FieldByName('id').AsInteger));
        next;
      end;
      CBStreetTemplate.ItemIndex := 0;
      if CBStreetTemplate.Items.Count<2 then begin
        CBStreetTemplate.Enabled := false;
      end else
        CBStreetTemplate.Enabled := true;
    end else begin
      CBStreetTemplate.Text := '';
      local_street_field_clear;
    end;
    close;
    CBStreetTemplateSelect(Sender);
  end;
end;

begin
  street_list.Clear;
  CBCityTemplate.Clear;
  CBCityTemplate.Text := '';
  CBStreetTemplate.Items.Clear;
  CBStreetTemplate.Text := '';
  city_id := TCityParams(city_list.Objects[CBCity.ItemIndex]).id;
  update_city_templates(city_id);
  if CBCity.ItemIndex>=0 then
    with ADOQStreets do begin
      SQL.Clear;
      SQL.Add('SELECT sl.id sl_id, sl.name name, st.id id_type, '+
      'st.short_name short_type, sl.second_name name2, '+
      '(SELECT COUNT(*) FROM street_mappings sm WHERE sm.id_street_location = sl.id) ref_count '+
        'FROM street_locations sl '+
          'JOIN street_types st ON sl.id_type=st.id '+
        'WHERE id_city='+IntToStr(city_id)+
        ' ORDER BY name');
      Open;
      if recordcount>0 then begin
        first;
        DBGStreets.Columns[0].FieldName := 'sl_id';
        DBGStreets.Columns[1].FieldName := 'short_type';
        DBGStreets.Columns[2].FieldName := 'name';
        DBGStreets.Columns[3].FieldName := 'name2';
        DBGStreets.Columns[4].FieldName := 'ref_count';
        Active := true;
        First;
      end;
    end;
  DSStreets.OnDataChange := ShowStreetData;
  ShowStreetData(nil, nil);
  update_street_templates(city_id);
end;

procedure TFormMain.CBStreetTemplateSelect(Sender: TObject);
begin
  if CBStreetTemplate.Items.Count>0 then
    ShowStreetLocalData;
end;

procedure TFormMain.ShowStreetLocalData;
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM street_mappings WHERE id_street_location='+
      IntToStr(DBGStreets.Columns[0].Field.Value)+
      ' AND id_template='+IntToStr(integer(TObject(CBStreetTemplate.Items.Objects[CBStreetTemplate.ItemIndex]))));
    Open;
    is_street_mapping_empty := false;
    if eof then
      is_street_mapping_empty := true;
    ELocalStreetId.Text := FieldByName('code_street_outer').AsString;
    ELocalStreetName.Text := FieldByName('name_street_outer').AsString;
    EType.Text := FieldByName('type_outer').AsString;
    ECity.Text := FieldByName('id_city_outer').AsString;
    Close;
  end;
end;

procedure TFormMain.local_street_field_clear;
begin
  EType.Text := '';
  ECity.Text := '';
  ELocalStreetId.Text := '';
  ELocalStreetName.Text := '';
end;

procedure TFormMain.clear_fields;
begin
  LID.Caption := '';
  EName2.Text := '';
  EName1.Text := '';
  CBStreetType.ItemIndex := 0;
  local_street_field_clear;
end;

procedure TFormMain.ShowStreetData(Sender: TObject; Field: TField);
begin
  set_mode(mView);
  if DBGStreets.Columns[0].Field.Value=null then begin
    clear_fields;
    BUpdate.Enabled := false;
    BDelete.Enabled := false;
    exit;
  end;
  BUpdate.Enabled := true;
  BAdd.Enabled := true;
  BDelete.Enabled := true;
  LID.Caption := IntToStr(DBGStreets.Columns[0].Field.Value);
  CBStreetType.ItemIndex := CBStreetType.Items.IndexOf(DBGStreets.Columns[1].Field.Value);
  EName1.Text := DBGStreets.Columns[2].Field.Value;
  if DBGStreets.Columns[3].Field.Value=null then
    EName2.Text := ''
  else
    EName2.Text := DBGStreets.Columns[3].Field.Value;
  CBStreetTemplateSelect(nil);
end;

procedure TFormMain.DBGStreetsCellClick(Column: TColumn);
begin
  ShowStreetData(nil, nil);
end;

procedure TFormMain.DBNavigator1Click(Sender: TObject; Button: TNavigateBtn);
begin
  ShowStreetData(nil, nil);
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: integer;
  city: TCityParams;
begin
  curr_mode := mView;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+
    'Load_settings.ini');
  connection_string :=
    'Provider='+
    Settings.ReadString('Main', 'PROVIDER', 'SQLOLEDB.1')+
    '; Password='+pw+
    '; Persist Security Info='+
    Settings.ReadString('Main', 'PERSISTSECURITYINFO', 'True')+
    '; User ID='+log_in+
    '; Data Source='+
    Settings.ReadString('Main', 'DATASOURCE', '10.40.28.34')+
    '; Initial Catalog='+
    Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
  Settings.Free;
  q_in := TADOQuery.Create(self);
  q_in.ConnectionString := connection_string;
  q_t := TADOQuery.Create(self);
  q_t.ConnectionString := connection_string;
  q_t.CommandTimeout := 300;
  ADOQStreets.ConnectionString := connection_string;
  city_list := TStringList.Create;
  street_list := TStringList.Create;
  local_street_list := TStringList.Create;
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM street_types ORDER BY id');
    try
      Open;
    Except
     MessageDlg('Проблемы с регистацией', mtError, [mbOK], 0);
     Application.Terminate;
    end;
    while not eof do begin
      CBStreetType.Items.AddObject(FieldByName('short_name').AsString,
        TObject(FieldByName('id').AsInteger));
      next;
    end;
    CBStreetType.ItemIndex := 0;

    SQL.Clear;
    SQL.Add('SELECT c.*, ct.short_name short_type FROM cities c '+
      'JOIN city_types ct ON c.id_type=ct.id '+
      'WHERE id_type>0 ORDER BY c.name_rus');
    Open;
    if recordcount>0 then begin
      first;
      for I := 0 to recordcount - 1 do begin
        city:= TCityParams.Create;
        with city do begin
          id := FieldByName('id').AsInteger;
          name_1 := FieldByName('name_rus').AsString;
          name_2 := FieldByName('name_ukr').AsString;
          id_parent := FieldByName('id_parent').AsInteger;
          last_erc_code := FieldByName('lastGenERCCode').AsInteger;
          id_type := FieldByName('id_type').AsInteger;
          code_koatuu := FieldByName('code_koatuu').AsInteger;
        end;
        city_list.AddObject(FieldByName('name_rus').AsString+' ('+
          FieldByName('short_type').AsString+') - '+
          FieldByName('id').AsString+'/'+
          FieldByName('code_koatuu').AsString, TObject(city));
        next;
      end;
      CBCity.Items := city_list;
      CBCity.ItemIndex := 0;
      CBCitySelect(Sender);
      city_id := TCityParams(city_list.Objects[CBCity.ItemIndex]).id;
    end;
    close;
  end;
end;

procedure TFormMain.set_mode(mode: Tmode);
begin
  case mode of
    mView: begin
      EName2.Enabled := false;
      EName1.Enabled := false;
      CBStreetType.Enabled := false;
      EType.Enabled := false;
      ECity.Enabled := false;
      ELocalStreetId.Enabled := false;
      ELocalStreetName.Enabled := false;
      BSave.Enabled := false;
      BCancel.Enabled := false;
      BUpdate.Enabled := true;
      BAdd.Enabled := true;
      BDelete.Enabled := true;
      curr_mode := mView;
    end;
    mEdit: begin
      BUpdate.Enabled := false;
      BAdd.Enabled := false;
      BDelete.Enabled := false;
      EName2.Enabled := true;
      EName1.Enabled := true;
      CBStreetType.Enabled := true;
      EType.Enabled := true;
      ECity.Enabled := true;
      ELocalStreetId.Enabled := true;
      ELocalStreetName.Enabled := true;
      BSave.Enabled := true;
      BCancel.Enabled := true;
      curr_mode := mEdit;
    end;
    mNew: begin
      BUpdate.Enabled := false;
      BAdd.Enabled := false;
      BDelete.Enabled := false;
      LID.Caption := '';
      EName2.Enabled := true;
      EName1.Enabled := true;
      CBStreetType.Enabled := true;
      EType.Enabled := true;
      ECity.Enabled := true;
      ELocalStreetId.Enabled := true;
      ELocalStreetName.Enabled := true;
      BSave.Enabled := true;
      BCancel.Enabled := true;
      curr_mode := mNew;
    end;
  end;
end;
end.
