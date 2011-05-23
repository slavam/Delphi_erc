unit viewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, ADODB, DB,
  Dialogs, ExtCtrls, Tabs, StdCtrls, DBCtrls, Grids, DBGrids;

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
  TStreetParams = class(TObject)
    sl_id: integer;
    name: string;
    id_type: integer;
    short_type: string;
  end;

type
  TFormViewPayer = class(TForm)
    TSMode: TTabSet;
    PAddress: TPanel;
    PDouble: TPanel;
    CBFirm: TComboBox;
    Label1: TLabel;
    CBPeriod: TComboBox;
    Label2: TLabel;
    BSearch: TButton;
    MDoubles: TMemo;
    CBCity: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    CBStreet: TComboBox;
    CBHome: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CBRoom: TComboBox;
    LBOccupants: TListBox;
    Label5: TLabel;
    Label8: TLabel;
    LBBankbooks: TListBox;
    PErrors: TPanel;
    Label9: TLabel;
    Label10: TLabel;
    CBFirmsForErrors: TComboBox;
    ADOQErrors: TADOQuery;
    DSErrors: TDataSource;
    LBOtherBankbooks: TListBox;
    BMoveBankbooks: TButton;
    BMoveBankbook: TButton;
    Label14: TLabel;
    ECodeERC: TEdit;
    BFindByCode: TButton;
    Label15: TLabel;
    PFUBb: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    CBFirmForFind: TComboBox;
    CBUtility: TComboBox;
    DBNBankbook: TDBNavigator;
    CBperiod_bb: TComboBox;
    Label16: TLabel;
    BCreate: TButton;
    CBBankbooksByFirm: TComboBox;
    CBFiles: TComboBox;
    DBGrid3: TDBGrid;
    Label17: TLabel;
    DBNavigator1: TDBNavigator;
    BChangeFullName: TButton;
    DBGBankbooks: TDBGrid;
    DS: TDataSource;
    ADOQBankbooks: TADOQuery;
    procedure TSModeChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure CBFirmSelect(Sender: TObject);
    procedure BSearchClick(Sender: TObject);
    procedure CBCitySelect(Sender: TObject);
    procedure CBStreetSelect(Sender: TObject);
    procedure CBHomeSelect(Sender: TObject);
    procedure CBRoomSelect(Sender: TObject);
    procedure LBOccupantsClick(Sender: TObject);
    procedure LBBankbooksDblClick(Sender: TObject);
    procedure BFindByCodeClick(Sender: TObject);
    procedure CBFirmsForErrorsSelect(Sender: TObject);
    procedure CBFirmForFindSelect(Sender: TObject);
    procedure CBUtilitySelect(Sender: TObject);
    procedure DBGrid3DblClick(Sender: TObject);
    procedure LBOtherBankbooksDblClick(Sender: TObject);
    procedure BMoveBankbookClick(Sender: TObject);
    procedure BMoveBankbooksClick(Sender: TObject);
    procedure CBCityExit(Sender: TObject);
    procedure CBCityKeyPress(Sender: TObject; var Key: Char);
    procedure CBStreetExit(Sender: TObject);
    procedure CBStreetKeyPress(Sender: TObject; var Key: Char);
    procedure CBHomeKeyPress(Sender: TObject; var Key: Char);
    procedure CBHomeExit(Sender: TObject);
    procedure CBRoomExit(Sender: TObject);
    procedure CBRoomKeyPress(Sender: TObject; var Key: Char);
    procedure CBperiod_bbSelect(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
    procedure LBBankbooksClick(Sender: TObject);
    procedure CBFilesSelect(Sender: TObject);
    procedure CBBankbooksByFirmSelect(Sender: TObject);
    procedure BChangeFullNameClick(Sender: TObject);
    procedure DBGBankbooksDblClick(Sender: TObject);
    procedure DBGBankbooksCellClick(Column: TColumn);
  private
    { Private declarations }
    q_t, q: TADOQuery;
    utility_list, occupant_list, bb_list: TStringList;
    room_list, home_list, street_list: TStringList;
    city: TCityParams;
    current_firm_id: integer;
//    current_period_id: integer;
//    current_address_id: integer;
    lt: TStringList;
    database_name: string;
//    period_index: integer;
    procedure controls_erase;
    procedure move_bankbook(id, new_human_id: integer);
    procedure ClearControls;
    function PreparePeriods(city_id: integer): integer;
  public
    { Public declarations }
    firm_list, city_list : TStringList;
  end;

var
  FormViewPayer: TFormViewPayer;
  settings: TIniFile;
  connection_string : string;
  period_list : TStringList;
  log_in, pw: string;

implementation

{$R *.dfm}

uses
  db_service, ShortInfo;

procedure TFormViewPayer.BCreateClick(Sender: TObject);
var
//  s_erc_code: string;
  sp: TADOStoredProc;
begin

  sp := TADOStoredProc.Create(self);
  sp.ConnectionString := connection_string;
  sp.CommandTimeout := 300;
  sp.CommandTimeout := 300;
  with sp do begin
    ProcedureName := 'up_detachBankbookToNewCode;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_bankbook', ftinteger, pdInput, 10,
      TBankbookParams(LBBankbooks.Items.Objects[DBGBankbooks.DataSource.DataSet.RecNo-1]).id);
    if CBPeriod_bb.ItemIndex>0 then
      Parameters.CreateParameter('@id_period', ftInteger, pdInput, 10,
        TReportDateOptions(CBperiod_bb.Items.Objects[CBperiod_bb.ItemIndex]).id);
    ExecProc;
    Close;
  end;
  sp.Free;
  CBRoomSelect(Sender);
end;

procedure TFormViewPayer.BFindByCodeClick(Sender: TObject);
var
//  i: integer;
//  payer_params: TERCCodeOwnerParams;
  sl, hl, rl: integer;
begin
  if trim(ECodeERC.Text)='' then exit;
  occupant_list.Clear;
  bb_list.Clear;
  LBOccupants.Items.Clear;
  LBBankbooks.Items.Clear;
  with q do begin
    close;
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    sql.Clear;
    sql.Add('SELECT id_room_location, rl.id_house_location id_house_location, hl.id_street_location id_street_location '+
      'FROM humans h '+
      'JOIN room_locations rl ON rl.id = h.id_room_location '+
      'JOIN house_locations hl ON hl.id = rl.id_house_location '+
      'WHERE h.id_city='+
      IntToStr(TCityParams(city_list.Objects[CBCity.ItemIndex]).id)+
      ' AND h.code_erc='+trim(ECodeERC.Text));
    Open;
//    First;
//    if recordcount>0 then begin
    if not eof then begin
      sl := FieldByName('id_street_location').AsInteger;
      hl := FieldByName('id_house_location').AsInteger;
      rl := FieldByName('id_room_location').AsInteger;
      CBStreet.ItemIndex :=
        CBStreet.Items.IndexOfObject(TObject(sl));
      CBStreetSelect(Sender);
      CBHome.ItemIndex :=
        home_list.IndexOfObject(TObject(hl));
      CBHomeSelect(Sender);
      CBRoom.ItemIndex :=
        room_list.IndexOfObject(TObject(rl));
      CBRoomSelect(Sender);
    end;
    close;
  end;
end;

procedure TFormViewPayer.BSearchClick(Sender: TObject);
//var
//  sp: TADOStoredProc;
//  i, j: integer;
//  s: string;
begin
{
  sp := TADOStoredProc.Create(self);
  sp.ConnectionString := connection_string;
  sp.CommandTimeout := 300;
  with sp do begin
    ProcedureName := 'up_getCrossingUtilitiesByCodeFirm;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@code_firm', ftinteger, pdInput, 10, current_firm_id);
    Parameters.CreateParameter('@id_period', ftInteger, pdInput, 10, current_period_id);
    Open;
    First;
    for I := 0 to Recordset.RecordCount - 1 do begin
      s := '';
      for j := 0 to Fields.Count-1 do
        s := s+Fields[j].AsString+'; ';
      MDoubles.Lines.Add(s);
      Next;
    end;
    Close;
  end;
}
end;

procedure TFormViewPayer.BChangeFullNameClick(Sender: TObject);
begin
  with q do begin
    sql.Clear;
    sql.Add('UPDATE humans SET full_name='''+
      TBankbookParams(LBBankbooks.Items.Objects[DBGBankbooks.DataSource.DataSet.RecNo-1]).payer_full_name+
      ''' WHERE id='+
      Inttostr(TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id));
    ExecSQL;
  end;
  if TSMode.TabIndex=0 then
    CBRoomSelect(Sender)
  else
    CBBankbooksByFirmSelect(Sender);
//  ShowMessage(TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).fullName+
//  '<='+TBankbookParams(LBBankbooks.Items.Objects[LBBankbooks.ItemIndex]).payer_full_name
//  );
end;

procedure TFormViewPayer.BMoveBankbooksClick(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to LBOtherBankbooks.Items.Count - 1 do begin
    move_bankbook(TBankbookParams(LBOtherBankbooks.Items.Objects[i]).id,
      TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id);
  end;
  LBOccupantsClick(Sender);
end;

procedure TFormViewPayer.BMoveBankbookClick(Sender: TObject);
begin
  move_bankbook(TBankbookParams(LBOtherBankbooks.Items.Objects[LBOtherBankbooks.ItemIndex]).id,
    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id);
  LBOccupantsClick(Sender);
end;

procedure TFormViewPayer.move_bankbook(id, new_human_id: integer);
begin
  with q do begin
    SQL.Clear;
    SQL.Add('UPDATE bankbooks SET id_human='+IntToStr(new_human_id)+
      'WHERE id='+IntToStr(id));
    ExecSQL;
  end;
end;

procedure TFormViewPayer.CBFirmsForErrorsSelect(Sender: TObject);
var
  q : TADOQuery;
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  with q do begin
    close;
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    SQL.Clear;
    SQL.Add('select id, file_name, file_size, date_reg, id_status '+
      ' from file_registrations '+
      ' where id_type=6 and code_firm='+
      IntToStr(integer(CBFirmsForErrors.Items.Objects[CBFirmsForErrors.ItemIndex]))+
      ' order by id');
    open;
    CBFiles.Clear;
    while not eof do begin
      CBFiles.Items.AddObject(FieldByName('id').AsString+'-'+
        FieldByName('file_name').AsString+' ('+
        FieldByName('file_size').AsString+') '+
        FieldByName('date_reg').AsString+' - '+
        FieldByName('id_status').AsString,
        TObject(FieldByName('id').AsInteger));
      next;
    end;
    CBFiles.ItemIndex := 0;
    close;
  end;
  q.Free;
  CBFilesSelect(sender);
end;

procedure TFormViewPayer.CBBankbooksByFirmSelect(Sender: TObject);
var
  payer_params: TERCCodeOwnerParams;
begin
  occupant_list.Clear;
  LBOccupants.Items.Clear;
  LBBankbooks.Items.Clear;
  LBOtherBankbooks.Items.Clear;
  if CBBankbooksByFirm.items.Count=0 then exit;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id in '+
      ' (SELECT id_human FROM bankbooks WHERE code_firm='+
      Inttostr(integer(CBFirmForFind.Items.Objects[CBFirmForFind.ItemIndex]))+
      ' AND bank_book='''+CBBankbooksByFirm.Items[CBBankbooksByFirm.itemindex]+''')');
    Open;
//    First;
//    if recordcount>0 then begin
//      for I := 0 to recordCount - 1 do begin
    while not eof do begin
        payer_params := TERCCodeOwnerParams.Create;
        payer_params.id := FieldByName('id').AsInteger;
        payer_params.erc_code := FieldByName('code_erc').AsInteger;
        payer_params.id_room := FieldByName('id_room_location').AsInteger;
        payer_params.fullName := FieldByName('full_name').AsString;
        payer_params.id_city := FieldByName('id_city').AsInteger;
        occupant_list.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(payer_params));
        Next;
    end;
    LBOccupants.Items := occupant_list;
    LBOccupants.ItemIndex := 0;
    CBperiod_bb.ItemIndex :=
      PreparePeriods(TERCCodeOwnerParams(occupant_list.Objects[0]).id_city);
    CBperiod_bb.Enabled := occupant_list.Count>0;
    LBOccupantsClick(Sender);
//    end;
    close;
  end;
end;

procedure TFormViewPayer.CBCityExit(Sender: TObject);
begin
  if CBCity.Items.IndexOf(CBCity.Text)<0 then begin
    ClearControls;
    CBStreet.Text := '';
    ShowMessage('Нет населенного пункта "'+CBCity.Text+'"');
    CBCity.ItemIndex := 0;
    CBCitySelect(Sender);
  end;
end;

procedure TFormViewPayer.CBCityKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    CBCityExit(Sender);
end;

function TFormViewPayer.PreparePeriods(city_id: integer): integer;
var
  i:integer;
  tdo: TReportDateOptions;
begin
  get_all_periods_by_city(lt, q, city_id);
  tdo := TReportDateOptions.Create;
  tdo.id := 0;
  tdo.id_city := city_id;
  tdo.report_date := now;
  tdo.description:= 'Все периоды';
  tdo.state:= 0;

  lt.InsertObject(0, 'Все периоды', tdo);
  Result := 0;
  for I := 0 to lt.Count - 1 do
    if TReportDateOptions(lt.Objects[i]).state=1 then begin
      Result := i;
      Break;
    end;

  CBperiod_bb.Items := lt;
end;


procedure TFormViewPayer.CBCitySelect(Sender: TObject);
var
  city_id: integer;
begin
  BCreate.Enabled := false;
  controls_erase;
  city_id := TCityParams(city_list.Objects[CBCity.ItemIndex]).id;

  CBperiod_bb.ItemIndex := PreparePeriods(city_id);

  if CBCity.ItemIndex>=0 then
    with q do begin
      close;
      CursorLocation := clUseServer;
      CursorType := ctOpenForwardOnly;
      SQL.Clear;
      SQL.Add('SELECT sl.id sl_id, sl.name name, st.id id_type, '+
      'st.short_name short_type, sl.second_name name2, '+
      '(SELECT COUNT(*) FROM street_mappings sm WHERE sm.id_street_location = sl.id) ref_count '+
        'FROM street_locations sl '+
          'JOIN street_types st ON sl.id_type=st.id '+
        'WHERE id_city='+IntToStr(city_id)+
        ' ORDER BY name');
      Open;
      if not eof then  begin
        while not eof do begin
          CBStreet.Items.AddObject(FieldByName('name').AsString+' '+
          FieldByName('short_type').AsString+' - '+
          FieldByName('sl_id').AsString,
          TObject(FieldByName('sl_id').AsInteger));
          next;
        end;
        CBStreet.Enabled := true;
        CBStreetSelect(Sender);
      end else
        CBStreet.Enabled := false;
      SQL.Clear;
      SQL.Add('SELECT count(*) num FROM humans WHERE id_city='+
        IntToStr(TCityParams(city_list.Objects[CBCity.ItemIndex]).id));
      Open;
      BFindByCode.Enabled := FieldByName('num').AsInteger>0;
    end;
end;

procedure TFormViewPayer.controls_erase;
begin
  street_list.Clear;
  CBStreet.Clear;
  CBStreet.Text := '';
  home_list.Clear;
  CBHome.Clear;
  CBHome.Text := '';
  room_list.Clear;
  CBRoom.Clear;
  CBRoom.Text := '';
  LBOccupants.Clear;
  LBBankbooks.Clear;
end;

procedure TFormViewPayer.DBGBankbooksCellClick(Column: TColumn);
begin
//  ShowMessage(IntToStr(DBGBankbooks.DataSource.DataSet.RecNo-1));
end;

procedure TFormViewPayer.DBGBankbooksDblClick(Sender: TObject);
begin
  ShortInfoForm.current_owner_erc_code :=
    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]);
  ShortInfoForm.bankbook_params :=
    TBankbookParams(LBBankbooks.Items.Objects[DBGBankbooks.DataSource.DataSet.RecNo-1]);
  if not ShortInfoForm.Visible then
    ShortInfoForm.Show
  else
    ShortInfoForm.FormShow(sender);
end;

procedure TFormViewPayer.DBGrid3DblClick(Sender: TObject);
var
  bb_params : TBankbookParams;
begin
  if ShortInfoForm.Visible then
    ShortInfoForm.Close;
  bb_params := TBankbookParams.Create;
//      bb.id := FieldByName('id').AsInteger;
//      bb.id_human := FieldByName('id_human').AsInteger;
//      bb.id_utility := FieldByName('id_utility').AsInteger;
//      bb.code_firm := FieldByName('code_firm').AsInteger;
//      bb.code_utility := FieldByName('code_utility').AsInteger;
//      bb.bank_book := FieldByName('bank_book').AsString;
//
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
  ShortInfoForm.bankbook_params := bb_params;
  occupant_list.Clear;
  get_payers_by_bankbook_params(occupant_list, q_t,
    IntToStr(integer(firm_list.Objects[CBFirmForFind.ItemIndex])),
    IntToStr(integer(utility_list.Objects[CBUtility.ItemIndex])),
    DBGrid3.DataSource.DataSet.FieldByName('bank_book').AsString);
  ShortInfoForm.current_owner_erc_code := TERCCodeOwnerParams(occupant_list.Objects[0]);
  ShortInfoForm.Show;
end;

procedure TFormViewPayer.CBFilesSelect(Sender: TObject);
begin
  with ADOQErrors do begin
    SQL.Clear;
    SQL.Add('select fe.record_number, e.description, ub.* '+
      ' from file_errors fe '+
      ' JOIN utilityfiles_bo ub ON fe.id_file=ub.id_file and fe.record_number=ub.record_number '+
      ' JOIN errors e ON e.code=fe.id_error and e.id_software=2 and e.error_type<>2 '+
      ' where fe.id_file='+
      IntToStr(integer(CBFiles.Items.Objects[CBFiles.ItemIndex]))+
      ' order by fe.record_number');
    open;
  end;
end;

procedure TFormViewPayer.CBFirmForFindSelect(Sender: TObject);
begin
  get_utilities_by_firm(utility_list, q_t, integer(firm_list.Objects[CBFirmForFind.ItemIndex]));
  CBUtility.Items := utility_list;
  CBUtility.ItemIndex := 0;
  CBUtilitySelect(Sender);
end;

procedure TFormViewPayer.CBFirmSelect(Sender: TObject);
begin
  current_firm_id := integer(firm_list.Objects[CBFirm.ItemIndex]);
end;

procedure TFormViewPayer.CBHomeExit(Sender: TObject);
begin
  if CBHome.Items.IndexOf(CBHome.Text)<0 then begin
    ClearControls;
    CBRoom.Text := '';
    ShowMessage('В населенном пункте '+CBCity.Text+#10+#13+
      'по '+CBStreet.Text+#10+#13+
      'нет дома "'+CBHome.Text+'"');
    CBHome.ItemIndex := 0;
    CBHomeSelect(Sender);
  end;
end;

procedure TFormViewPayer.CBHomeKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    CBHomeExit(Sender);
end;

procedure TFormViewPayer.ClearControls;
begin
  LBOccupants.Clear;
  LBBankbooks.Clear;
  LBOtherBankbooks.Clear;
  CBperiod_bb.Enabled := false;
end;

procedure TFormViewPayer.CBHomeSelect(Sender: TObject);
begin
  room_list.Clear;
  get_room_ids_by_home(room_list, q,
    integer(TObject(home_list.Objects[CBHome.ItemIndex])));
  CBRoom.Items := room_list;
  CBRoom.Enabled := room_list.Count>1;
  CBRoom.ItemIndex := 0;
  CBRoomSelect(Sender)
end;

procedure TFormViewPayer.CBperiod_bbSelect(Sender: TObject);
begin
  LBOccupantsClick(Sender);
end;

procedure TFormViewPayer.CBRoomExit(Sender: TObject);
begin
  if CBRoom.Items.IndexOf(CBRoom.Text)<0 then begin
    ClearControls;
    ShowMessage('В населенном пункте '+CBCity.Text+#10+#13+
      'по '+CBStreet.Text+#10+#13+
      'в доме '+CBHome.Text+ ' нет квартиры "'+CBRoom.Text+'"');
    CBRoom.ItemIndex := 0;
    CBRoomSelect(Sender);
  end;
end;

procedure TFormViewPayer.CBRoomKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    CBRoomExit(Sender);
end;

procedure TFormViewPayer.CBRoomSelect(Sender: TObject);
var
  payer_params: TERCCodeOwnerParams;
begin
  occupant_list.Clear;
  LBOccupants.Items.Clear;
  LBBankbooks.Items.Clear;
  LBOtherBankbooks.Items.Clear;
  if room_list.Count=0 then exit;
  with q do begin
    close;
    CursorLocation := clUseServer;
    CursorType := ctOpenForwardOnly;
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id_room_location='+
      Inttostr(integer(Tobject(room_list.Objects[CBRoom.ItemIndex]))));
    Open;
    while not eof do begin
      payer_params := TERCCodeOwnerParams.Create;
      payer_params.id := FieldByName('id').AsInteger;
      payer_params.erc_code := FieldByName('code_erc').AsInteger;
      payer_params.id_room := FieldByName('id_room_location').AsInteger;
      payer_params.fullName := FieldByName('full_name').AsString;
      payer_params.id_city := FieldByName('id_city').AsInteger;
      occupant_list.AddObject(FieldByName('code_erc').AsString+' '+
        FieldByName('full_name').AsString, TObject(payer_params));
      Next;
    end;
    close;
    LBOccupants.Items := occupant_list;
    CBperiod_bb.Enabled := occupant_list.Count>0;
    LBOccupants.ItemIndex := 0;
    if occupant_list.Count>0 then
      LBOccupantsClick(Sender);
  end;
end;

procedure TFormViewPayer.CBStreetExit(Sender: TObject);
begin
  if CBStreet.Items.IndexOf(CBStreet.Text)<0 then begin
    ClearControls;
    CBHome.Text := '';
    ShowMessage('В населенном пункте '+CBCity.Text+#10+#13+
      'нет улицы "'+CBStreet.Text+'"');
    CBStreet.ItemIndex := 0;
    CBStreetSelect(Sender);
  end;
end;

procedure TFormViewPayer.CBStreetKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_RETURN then
    CBStreetExit(Sender);
end;

procedure TFormViewPayer.CBStreetSelect(Sender: TObject);
begin
  if CBStreet.ItemIndex < 0 then CBStreet.ItemIndex := 0;
  home_list.Clear;
  get_home_ids_by_street(home_list, q,
    integer(TObject(CBStreet.Items.Objects[CBStreet.ItemIndex])));
  CBHome.Enabled := home_list.Count>0;
  if home_list.Count=0 then begin
    CBRoom.Text := '';
    CBRoom.Enabled := false;
    cbhome.text := '';
    ClearControls;
  end else begin
    CBHome.Items := home_list;
    CBHome.ItemIndex := 0;
    CBHomeSelect(Sender);
  end;
end;

procedure TFormViewPayer.CBUtilitySelect(Sender: TObject);
var
  bb_params : TBankbookParams;
begin
  CBBankbooksByFirm.Clear;
  with q_t do begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT bb.code_firm, bu.id id_utility, bu.code_utility, '+
      ' bb.bank_book, bb.id, h.id_city, h.id id_human '+
      'FROM bankbooks bb '+
      'JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id '+
      'JOIN humans h ON h.id=bb.id_human '+
      'WHERE bb.code_firm='+Inttostr(integer(firm_list.Objects[CBFirmForFind.ItemIndex]))+
      ' AND code_utility='+
      IntToStr(integer(utility_list.Objects[CBUtility.ItemIndex]))+
      ' ORDER BY bb.bank_book');
    Open;
    while not eof do begin
      bb_params := TBankbookParams.Create;
      bb_params.id := FieldByName('id').AsInteger;
      bb_params.id_human := FieldByName('id_human').AsInteger;
      bb_params.id_utility := FieldByName('id_utility').AsInteger;
      bb_params.code_firm := FieldByName('code_firm').AsInteger;
      bb_params.code_utility := FieldByName('code_utility').AsInteger;
      bb_params.bank_book := FieldByName('bank_book').AsString;
      CBBankbooksByFirm.Items.AddObject(FieldByName('bank_book').AsString,
        TObject(bb_params));
      next;
    end;
    CBBankbooksByFirm.ItemIndex := 0;
    CBBankbooksByFirmSelect(Sender);
  end;
//  DBGrid3.Columns[0].FieldName := 'code_firm';
//  DBGrid3.Columns[1].FieldName := 'code_utility';
//  DBGrid3.Columns[2].FieldName := 'bank_book';
end;

procedure TFormViewPayer.FormCreate(Sender: TObject);
var
  f: Boolean;
begin
  LoadKeyboardLayout( '00000419' , KLF_ACTIVATE ) ;
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'viewer.ini');
  connection_string :=
    'Provider='+
    Settings.ReadString('Main', 'PROVIDER', 'SQLOLEDB.1')+
    '; Password='+pw+
    '; Persist Security Info='+
    Settings.ReadString('Main', 'PERSISTSECURITYINFO', 'True')+
    '; User ID='+ log_in+
    '; Data Source='+
    Settings.ReadString('Main', 'DATASOURCE', '10.40.28.34')+
    '; Initial Catalog='+
    Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
    database_name := Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
  Settings.Free;
  Caption := caption+' ('+database_name+')';
//  Settings.Free;
  firm_list := TStringList.Create;
  utility_list := TStringList.Create;
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  q.close;
  q.CursorLocation := clUseServer;
  q.CursorType := ctOpenForwardOnly;
  q.SQL.Clear;
  q.SQL.Add('SELECT * FROM active_firms_short_view '+
    'ORDER BY code');
  try
    q.Open;
  Except
    MessageDlg('Проблемы с регистрацией', mtError, [mbOK],0);
    Application.Terminate;
  end;
//  q.First;
//  for I := 0 to q.recordCount - 1 do begin
  while not q.eof do begin
    firm_list.AddObject(q.FieldByName('code').AsString+'; '+
      q.FieldByName('name').AsString, TObject(q.FieldByName('code').AsInteger));
    q.Next;
  end;
  q.Close;
  CBFirmForFind.Items := firm_list;
  CBFirmForFind.ItemIndex :=0;
  CBFirm.ItemIndex := 0;
  CBPeriod.ItemIndex := 0;
  TSMode.TabIndex := 0;
  lt := TStringList.Create;
  period_list := TStringList.Create;
  city_list := TStringList.Create;
  occupant_list:= TStringList.Create;
  bb_list := TStringList.Create;
  street_list := TStringList.Create;
  room_list := TStringList.Create;
  home_list := TStringList.Create;
  q_t := TADOQuery.Create(self);
  q_t.ConnectionString := connection_string;
  q_t.close;
  q_t.CursorLocation := clUseServer;
  q_t.CursorType := ctOpenForwardOnly;
  ADOQErrors.ConnectionString := connection_string;
  ADOQBankbooks.ConnectionString := connection_string;
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT c.*, ct.short_name short_type FROM cities c '+
      'JOIN city_types ct ON c.id_type=ct.id '+
      'WHERE id_type>0 ORDER BY c.name_rus');
    Open;
//    if recordcount>0 then begin
//      first;
//      for I := 0 to recordcount - 1 do begin
    while not eof do begin
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
        city_list.AddObject(FieldByName('name_rus').AsString+' '+
          FieldByName('short_type').AsString+' - '+
          FieldByName('id').AsString, //+'/'+
//          FieldByName('code_koatuu').AsString,
          TObject(city));
        next;
    end;
    CBCity.Items := city_list;
    CBCity.ItemIndex := 0;
//    end;
    SQL.Clear;
    SQL.Add('select distinct fr.code_firm code, f.name name'+
      ' from file_registrations fr '+
      ' join  firms f on f.code=fr.code_firm '+
      ' where fr.id_type=6 order by code');
    open;
    while not eof do begin
      CBFirmsForErrors.Items.AddObject(FieldByName('code').AsString+'; '+
        FieldByName('name').AsString,
        TObject(FieldByName('code').AsInteger));
      next;
    end;
    CBFirmsForErrors.ItemIndex := 0;
    close;
  end;
//  q_t.Free;
  f := True;
  TSModeChange(Sender, 0, f);
  CBCitySelect(Sender);
end;

procedure TFormViewPayer.LBBankbooksClick(Sender: TObject);
begin
//
end;

procedure TFormViewPayer.LBBankbooksDblClick(Sender: TObject);
begin
//  ShortInfoForm.current_owner_erc_code :=
//    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]);
//  ShortInfoForm.bankbook_params :=
//    TBankbookParams(LBBankbooks.Items.Objects[LBBankbooks.ItemIndex]);
//  if not ShortInfoForm.Visible then
//    ShortInfoForm.Show
//  else
//    ShortInfoForm.FormShow(sender);
end;

procedure TFormViewPayer.LBOccupantsClick(Sender: TObject);
begin
  bb_list.Clear;
  if CBperiod_bb.ItemIndex=0 then begin
    with ADOQBankbooks do begin
      SQL.Clear;
      SQL.Add('SELECT bb.code_firm, u.short_name utility, bb.bank_book, f.name firm '+
        ' FROM bankbooks bb '+
        ' JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id'+
        ' JOIN firms f ON bb.code_firm=f.code'+
        ' JOIN utilities u ON u.code=bu.code_utility WHERE id_human ='+
        IntToStr(TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id)+
        ' ORDER BY bu.code_utility');

      Open;
    end;
    DBGBankbooks.Columns[0].Title.Caption := 'Орг.';
    DBGBankbooks.Columns[0].Width := 30;
    DBGBankbooks.Columns[0].FieldName := 'code_firm';
    DBGBankbooks.Columns[1].Title.Caption := 'Услуга';
    DBGBankbooks.Columns[1].Width := 120;
    DBGBankbooks.Columns[1].FieldName := 'utility';
    DBGBankbooks.Columns[2].Title.Caption := 'Счет';
    DBGBankbooks.Columns[2].Width := 70;
    DBGBankbooks.Columns[2].FieldName := 'bank_book';
    DBGBankbooks.Columns[3].Title.Caption := 'Название организации';
    DBGBankbooks.Columns[3].Width := 200;
    DBGBankbooks.Columns[3].FieldName := 'firm';
    get_all_bankbook_by_human_id(bb_list, q,
      TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id);
    LBBankbooks.Items := bb_list;
    LBBankbooks.ItemIndex := 0;

    if occupant_list.Count>1 then begin
      LBOtherBankbooks.Items.Clear;
      get_other_bankbooks(bb_list, q,
        TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id,
        TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id_room);
      LBOtherBankbooks.Items := bb_list;
      LBOtherBankbooks.ItemIndex := 0;
    end;
    CBperiod_bb.Enabled := (LBOtherBankbooks.Count>0) or (LBBankbooks.count>0);
  end else begin
    with ADOQBankbooks do begin
      SQL.Clear;
      SQL.Add('SELECT bb.code_firm, '+
        ' u.short_name utility, bb.bank_book, h.full_name  full_name, f.name firm '+
        ' FROM bankbooks bb '+
        ' JOIN firms f ON bb.code_firm=f.code'+
        ' JOIN bankbook_utilities bu ON bu.id_bankbook=bb.id'+
        ' JOIN utilities u ON u.code=bu.code_utility ' +
        ' JOIN bankbook_attributes_debts d ON d.id_bankbook_utility=bu.id AND d.id_period='+
        IntToStr(TReportDateOptions(CBperiod_bb.Items.Objects[CBperiod_bb.itemindex]).id)+
        ' JOIN bankbook_attributes_humans h ON h.id_bankbook=bb.id AND '+
        IntToStr(TReportDateOptions(CBperiod_bb.Items.Objects[CBperiod_bb.itemindex]).id)+
        ' between h.id_period_begin and h.id_period WHERE id_human ='+
        IntToStr(TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id)+
        ' ORDER BY bu.code_utility');
      Open;

    end;
    DBGBankbooks.Columns[0].Title.Caption := 'Орг.';
    DBGBankbooks.Columns[0].Width := 30;
    DBGBankbooks.Columns[1].Title.Caption := 'Услуга';
    DBGBankbooks.Columns[1].Width := 120;
    DBGBankbooks.Columns[2].Title.Caption := 'Счет';
    DBGBankbooks.Columns[2].Width := 70;
    DBGBankbooks.Columns[0].FieldName := 'code_firm';
    DBGBankbooks.Columns[1].FieldName := 'utility';
    DBGBankbooks.Columns[2].FieldName := 'bank_book';
    DBGBankbooks.Columns[3].Title.Caption := 'ФИО плательщика';
    DBGBankbooks.Columns[3].FieldName := 'full_name';
    DBGBankbooks.Columns[4].Title.Caption := 'Название организации';
    DBGBankbooks.Columns[4].Width := 200;
    DBGBankbooks.Columns[4].FieldName := 'firm';

    get_all_bankbook_by_human_id_by_period(bb_list, q,
      TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id,
      TReportDateOptions(CBperiod_bb.Items.Objects[CBperiod_bb.itemindex]).id);
    LBBankbooks.Items := bb_list;
    LBBankbooks.ItemIndex := 0;

    if occupant_list.Count>1 then begin
      LBOtherBankbooks.Items.Clear;
      get_other_bankbooks_by_period(bb_list, q,
        TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id,
        TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id_room,
        TReportDateOptions(CBperiod_bb.Items.Objects[CBperiod_bb.itemindex]).id);
      LBOtherBankbooks.Items := bb_list;
      LBOtherBankbooks.ItemIndex := 0;
    end;
  end;
  BChangeFullName.Enabled := LBBankbooks.Count>0;
  BMoveBankbook.Enabled := LBOtherBankbooks.Items.Count>0;
  BMoveBankbooks.Enabled := LBOtherBankbooks.Items.Count>1;
  BCreate.Enabled := LBBankbooks.Items.Count>0;
end;

procedure TFormViewPayer.LBOtherBankbooksDblClick(Sender: TObject);
var
  t_l: TStringList;
begin
  ShortInfoForm.bankbook_params :=
    TBankbookParams(LBOtherBankbooks.Items.Objects[LBOtherBankbooks.ItemIndex]);
  t_l:= TStringList.Create;
  get_payers_by_bankbook_params(t_l, q_t,
    Inttostr(TBankbookParams(LBOtherBankbooks.Items.Objects[LBOtherBankbooks.ItemIndex]).code_firm),
    Inttostr(TBankbookParams(LBOtherBankbooks.Items.Objects[LBOtherBankbooks.ItemIndex]).code_utility),
    TBankbookParams(LBOtherBankbooks.Items.Objects[LBOtherBankbooks.ItemIndex]).bank_book);
  ShortInfoForm.current_owner_erc_code := TERCCodeOwnerParams(t_l.Objects[0]);

  if not ShortInfoForm.Visible then
    ShortInfoForm.Show
  else
    ShortInfoForm.FormShow(sender);
end;

procedure TFormViewPayer.TSModeChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  PAddress.Visible := NewTab = 0;
  PFUBb.Visible := NewTab = 1;
  PErrors.Visible := NewTab = 2;
//  PDouble.Visible := NewTab = 3;
  bb_list.Clear;
  occupant_list.Clear;
  LBOccupants.Items.Clear;
  LBBankbooks.Items.Clear;
  case NewTab of
    0: begin
      CBCitySelect(Sender);
    end;
    1: begin
      CBFirmForFindSelect(Sender);
    end;
    2: begin
      CBFirmsForErrorsSelect(Sender);
    end;
  end;
end;

end.
