unit view_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB,
  db_service,
  Dialogs, StdCtrls;

type
  TFormViewInfo = class(TForm)
    BSave: TButton;
    Label1: TLabel;
    EValue: TEdit;
    LNumRecord: TLabel;
    LError: TLabel;
    LBBankbooks: TListBox;
    LBOccupants: TListBox;
    Label8: TLabel;
    Label2: TLabel;
    CBCity: TComboBox;
    Label4: TLabel;
    CBStreet: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    CBHome: TComboBox;
    Label7: TLabel;
    CBRoom: TComboBox;
    BSubstituteAddress: TButton;
    LBFields: TListBox;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CBFieldsSelect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LBOccupantsClick(Sender: TObject);
    procedure LBBankbooksDblClick(Sender: TObject);
    procedure BSaveClick(Sender: TObject);
    procedure CBCitySelect(Sender: TObject);
    procedure CBStreetSelect(Sender: TObject);
    procedure CBHomeSelect(Sender: TObject);
    procedure CBRoomSelect(Sender: TObject);
    procedure BSubstituteAddressClick(Sender: TObject);
    procedure LBFieldsClick(Sender: TObject);
  private
    q, qq: TADOQuery;
//    city_id: array[0..1500] of integer;
//    procedure Init;
  public
    occupant_list, bb_list: TStringList;
    room_list, home_list, street_list: TStringList;
    q_in: TADOQuery;
  end;

var
  FormViewInfo: TFormViewInfo;

implementation

uses verify_data,
//ViewInfo,
  DB , PayerInfo;

{$R *.dfm}

procedure TFormViewInfo.BSaveClick(Sender: TObject);
var
  q: TADOQuery;
  sp: TADOStoredProc;
begin
  q := TADOQuery.Create(self);
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  if (q_in.FieldDefList[LBFields.itemindex].DataType = ftString) or
    (q_in.FieldDefList[LBFields.itemindex].DataType = ftDateTime) then begin
    if q_in.FieldDefList[LBFields.itemindex].DataType = ftDateTime then
      q.SQL.Add('UPDATE utilityfiles_bo SET '+
        q_in.FieldDefList[LBFields.itemindex].Name+'='''+
        FormatDateTime(format_date,StrToDate(EValue.Text))+
        ''' WHERE id_file='+q_in.FieldByName('id_file').AsString+
        ' AND record_number='+
        q_in.FieldByName('record_number').AsString)
    else
    q.SQL.Add('UPDATE utilityfiles_bo SET '+
      q_in.FieldDefList[LBFields.itemindex].Name+'='''+EValue.Text+
        ''' WHERE id_file='+q_in.FieldByName('id_file').AsString+
        ' AND record_number='+
        q_in.FieldByName('record_number').AsString);
  end else begin
    q.SQL.Add('UPDATE utilityfiles_bo SET '+
      q_in.FieldDefList[LBFields.itemindex].Name+'='+EValue.Text+
        ' WHERE id_file='+q_in.FieldByName('id_file').AsString+
        ' AND record_number='+
        q_in.FieldByName('record_number').AsString);
  end;
  q.ExecSQL;
  q.Free;

  sp := TADOStoredProc.Create(self);
  sp.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  sp.CommandTimeout := 300;

  with sp do begin
    ProcedureName := 'up_preauditUtilityFiles_bo;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@id_city_template', ftinteger, pdInput, 10, 1);
    Parameters.CreateParameter('@id_street_template', ftinteger, pdInput, 10, 1);
    Parameters.CreateParameter('@is_code_firmKIS', ftBoolean, pdInput, 10, false);
    Parameters.CreateParameter('@is_preauditfieldempty', ftBoolean, pdInput, 10, false);
    Parameters.CreateParameter('@record_number', ftInteger, pdInput, 10, q_in.FieldByName('record_number').AsInteger);
    ExecProc;
    Close;
  end;

  with sp do begin
    ProcedureName := 'up_verifyUtlityFiles_bo;1';
    Parameters.Clear;
    Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
    Parameters.CreateParameter('@id_file', ftinteger, pdInput, 10, loading_params.reg_record_id);
    Parameters.CreateParameter('@record_number', ftInteger, pdInput, 10, q_in.FieldByName('record_number').AsInteger);
    Parameters.CreateParameter('@is_short_control', ftBoolean, pdInput, 10, true); //FormMain.CBShortControl.Checked); //false);
    ExecProc;
    Close;
  end;

  FormMain.update_warnings;
end;

procedure TFormViewInfo.BSubstituteAddressClick(Sender: TObject);
var
  address_params: TAddressParams;
  q : TADOQuery;
begin
  q := TADOQuery.Create(self);
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  get_address_by_id_room_location(address_params, q,
    TRoomParams(room_list.Objects[CBRoom.ItemIndex]).id);
  with q do begin
    sql.clear;
    sql.Add(
      'update utilityfiles_bo set n_house='+
      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).n_home)+
      ', f_house='+
      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).f_home)+
      ', a_house="'+
      THomeParams(home_list.Objects[CBHome.ItemIndex]).a_home+
      '", d_house='+
      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).d_home)+
      ', n_room='+
      Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).n_room)+
      ', a_room="'+
      TRoomParams(room_list.Objects[CBRoom.ItemIndex]).a_room+
      '", id_room_location='+
      Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).id)+
      ', code_c='+
      Inttostr(address_params.local_city_id)+
      ', code_s='+
      Inttostr(address_params.local_street_code)+
      ', code_c_corr='+
      Inttostr(address_params.city_id)+
      ', code_s_corr='+
      Inttostr(address_params.street_code)+
      ' where id_file='+q_in.FieldByName('id_file').AsString+
      ' and record_number='+q_in.FieldByName('record_number').AsString
    );
    ExecSQL;
  end;
  q.Free;
end;

procedure TFormViewInfo.CBCitySelect(Sender: TObject);
begin
  street_list.Clear;
  CBStreet.Items.Clear;
  CBHome.Items.Clear;
  CBRoom.Items.Clear;
  get_street_id_list_by_city(street_list, q,
    integer(CBCity.Items.Objects[CBCity.ItemIndex]));
  if street_list.Count=0 then begin
    street_list.Clear;
    home_list.Clear;
    room_list.Clear;
    CBStreet.Text := '';
    CBHome.Text := '';
    CBRoom.Text := '';
    LBOccupants.Clear;
  end else begin
    CBStreet.Items := street_list;
    CBStreet.ItemIndex := CBStreet.Items.IndexOfObject(TObject(q_in.FieldByName('code_s_corr').asInteger));
    CBStreetSelect(Sender);
//    if (FormInfo <> nil) and FormInfo.Visible then
//      FormInfo.Close;
  end;
end;

procedure TFormViewInfo.CBFieldsSelect(Sender: TObject);
begin
  EValue.Text := q_in.FieldByName(q_in.FieldDefList[LBFields.itemindex].Name).AsString;
end;

procedure TFormViewInfo.CBHomeSelect(Sender: TObject);
begin
  room_list.Clear;
  get_room_list_by_home(room_list, q,
    THomeParams(home_list.Objects[CBHome.ItemIndex]).id);
  CBRoom.Items := room_list;
  CBRoom.ItemIndex := CBRoom.Items.IndexOf(q_in.FieldByName('n_room').AsString);
  if CBRoom.ItemIndex < 0 then
    CBRoom.ItemIndex := 0;
  CBRoomSelect(Sender);
end;

procedure TFormViewInfo.CBRoomSelect(Sender: TObject);
var
  q : TADOQuery;
  i: integer;
  payer_params: TERCCodeOwnerParams;
begin
  q := TADOQuery.Create(self);
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  occupant_list.Clear;
  LBOccupants.Clear;
  LBBankbooks.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id_room_location='+
      Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).id));
    Open;
    First;
    for I := 0 to recordCount - 1 do begin
      payer_params := TERCCodeOwnerParams.Create;
      payer_params.id := FieldByName('id').AsInteger;
      payer_params.erc_code := FieldByName('code_erc').AsInteger;
      payer_params.id_room := FieldByName('id_room_location').AsInteger;
      payer_params.fullName := FieldByName('full_name').AsString;
      occupant_list.AddObject(FieldByName('code_erc').AsString+' '+
        FieldByName('full_name').AsString, TObject(payer_params));
      Next;
    end;
    close;
  end;
  q.Free;
  BSubstituteAddress.Enabled := occupant_list.count>0;
  if occupant_list.count>0 then begin
    LBOccupants.Items := occupant_list;
    LBOccupants.ItemIndex := 0;
    LBOccupantsClick(Sender);
  end;
end;

procedure TFormViewInfo.CBStreetSelect(Sender: TObject);
begin
  if CBStreet.ItemIndex < 0 then CBStreet.ItemIndex := 0;
  home_list.Clear;
  get_home_list_by_street(home_list, q, integer(street_list.Objects[CBStreet.ItemIndex]));
  if home_list.Count=0 then begin
    home_list.Clear;
    room_list.Clear;
    CBHome.Items.Clear;
    CBRoom.Items.Clear;
    CBHome.Text := '';
    CBRoom.Text := '';
    LBOccupants.Clear;
  end else begin
    CBHome.Items := home_list;
    CBHome.ItemIndex := CBHome.Items.IndexOf(q_in.FieldByName('n_house').AsString);
    if CBHome.ItemIndex < 0 then
      CBHome.ItemIndex := 0;
    CBHomeSelect(Sender);
  end;
end;

procedure TFormViewInfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  q_in.Close;
  if (PayerInfoForm <> nil) and PayerInfoForm.Visible then
    PayerInfoForm.Close;
end;

procedure TFormViewInfo.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  q_in := TADOQuery.Create(self);
//  q_in.ConnectionString := connection_string;
  qq := TADOQuery.Create(self);
  bb_list := TStringList.Create;
  occupant_list := TStringList.Create;
  street_list := TStringList.Create;
  home_list := TStringList.Create;
  room_list := TStringList.Create;

end;

{
procedure TFormViewInfo.Init;
var
  q : TADOQuery;
  i: integer;
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  q.SQL.Clear;
  q.SQL.Add('SELECT c.id, c.name_rus, ct.short_name type FROM cities c '+
    'JOIN city_types ct ON ct.id=c.id_type'+
    ' WHERE id_type>0 ORDER BY name_rus');
  q.Open;
  q.First;
  for I := 0 to q.recordCount - 1 do begin
    CBCity.Items.Add(q.FieldByName('name_rus').AsString+' '+
      q.FieldByName('type').AsString);
    city_id[i] := q.FieldByName('id').AsInteger;
    q.Next;
  end;
  q.Close;
  CBCity.ItemIndex := 0;
  CBCitySelect(self);
end;
}
procedure TFormViewInfo.FormShow(Sender: TObject);
var
  i:integer;
  payer_params: TERCCodeOwnerParams;
begin
  q.Connection := FormMain.ADOConnectionMain;//String := connection_string;
//  if q_in.ConnectionString='' then
  q_in.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  qq.Connection := FormMain.ADOConnectionMain;//String := connection_string;
  LNumRecord.Caption := 'Запись - '+ IntToStr(current_record_num);
  q_in.SQL.Clear;

  q_in.sql.add('SELECT e.description, fe.record_number, fe.id_error, fe.description field '+
    'FROM file_errors fe'+
    ' JOIN errors e ON fe.id_error=e.code AND id_software=2 AND error_type <>2 '+
    'WHERE id_file='+IntToStr(loading_params.reg_record_id)+
    ' AND fe.record_number='+IntToStr(current_record_num));
  q_in.Open;
  if q_in.RecordCount>0 then
    LError.Caption := FormMain.LBWarnings.Items[FormMain.LBWarnings.itemindex]
//    LError.Caption := q_in.FieldByName('description').AsString+' '+q_in.FieldByName('field').AsString
  else
    LError.Caption := 'Запись без ошибок';

  q_in.SQL.Clear;
  q_in.SQL.Add('SELECT * FROM utilityfiles_bo WHERE record_number='
    +IntToStr(current_record_num)+' AND id_file='+IntToStr(loading_params.reg_record_id));
  q_in.Open;
  LBFields.Clear;
  for i:= 0 to q_in.FieldCount - 1 do
    LBFields.Items.Add(q_in.FieldDefList[i].Name+'='+
      q_in.FieldByName(q_in.FieldDefList[i].Name).AsString+';');

  occupant_list.Clear;
  LBOccupants.Items.Clear;
  bb_list.Clear;
  LBBankbooks.Items.Clear;
  with qq do begin
    SQL.Clear;
    if q_in.FieldByName('id_room_location').AsInteger=0 then
      SQL.Add('SELECT * FROM humans WHERE id in '+
        '(SELECT id_human FROM bankbooks where code_firm='+
        q_in.FieldByName('code_firme').AsString+' and bank_book='''+
        q_in.FieldByName('abcount').AsString+''')')
    else
      SQL.Add('SELECT * FROM humans WHERE id_room_location='+
        q_in.FieldByName('id_room_location').AsString);
    Open;
    if recordcount>0 then begin
      First;
      for I := 0 to recordCount - 1 do begin
        payer_params := TERCCodeOwnerParams.Create;
        payer_params.id := FieldByName('id').AsInteger;
        payer_params.erc_code := FieldByName('code_erc').AsInteger;
        payer_params.id_room := FieldByName('id_room_location').AsInteger;
        payer_params.fullName := FieldByName('full_name').AsString;
        occupant_list.AddObject(FieldByName('code_erc').AsString+' '+
          FieldByName('full_name').AsString, TObject(payer_params));
        Next;
      end;
      LBOccupants.Items := occupant_list;
      LBOccupants.ItemIndex := 0;
      LBOccupantsClick(Sender);
    end else begin
      bb_list.Clear;
      LBBankbooks.Items.Clear;
      get_all_bankbook_by_code_firm(bb_list, q,
        q_in.FieldByName('code_firme').Asinteger,
        q_in.FieldByName('abcount').AsString);

      LBBankbooks.Items := bb_list;
      LBBankbooks.ItemIndex := 0;
    end;
    close;
  end;

  CBCity.Items := FormMain.CBCities.Items;
  CBCity.ItemIndex := FormMain.CBCities.ItemIndex;
  CBCitySelect(Sender);

  LBFields.ItemIndex := 0;
  CBFieldsSelect(Sender);
end;

procedure TFormViewInfo.LBBankbooksDblClick(Sender: TObject);
begin
  Application.CreateForm(TPayerInfoForm, PayerInfoForm);

  PayerInfoForm.current_owner_erc_code :=
    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]);
  PayerInfoForm.bankbook_params :=
    TBankbookParams(bb_list.Objects[LBBankbooks.ItemIndex]);
  PayerInfoForm.Show;
end;

procedure TFormViewInfo.LBFieldsClick(Sender: TObject);
begin
  EValue.Text := q_in.FieldByName(q_in.FieldDefList[LBFields.itemindex].Name).AsString;
end;

procedure TFormViewInfo.LBOccupantsClick(Sender: TObject);
begin
  bb_list.Clear;
  LBBankbooks.Items.Clear;
  get_all_bankbook_by_human_id(bb_list, q,
    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id);
  LBBankbooks.Items := bb_list;
  LBBankbooks.ItemIndex := 0;
end;

end.
