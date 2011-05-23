unit DataView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, ExtCtrls,
  Dialogs, StdCtrls, DB;

type
  TFormPreview = class(TForm)
    LTitle: TLabel;
    ADOQ: TADOQuery;
    ADODSW: TADODataSet;
    LFieldName: TLabel;
    BChange: TButton;
    BSaveNewValue: TButton;
    LAddress: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ENewValue: TEdit;
    ADOSP: TADOStoredProc;
    LBOccupants: TListBox;
    LOccupants: TLabel;
    LService: TLabel;
    LBPayers: TListBox;
    LPayers: TLabel;
    LBBankbook: TListBox;
    LBankbookOf: TLabel;
    LDBValue: TLabel;
    CBStreet: TComboBox;
    CBHome: TComboBox;
    CBRoom: TComboBox;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure BChangeClick(Sender: TObject);
    procedure BSaveNewValueClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LBPayersClick(Sender: TObject);
    procedure LBBankbookDblClick(Sender: TObject);
    procedure LBOccupantsClick(Sender: TObject);
    procedure CBStreetChange(Sender: TObject);
    procedure CBHomeChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function obtain_selected_record(record_num: integer): Boolean;
  public
    { Public declarations }
    RoomList, HomeList, StreetList, BankbookList, PayerList, OccupantList: TStringList;{ declare the list }
  end;

var
  FormPreview: TFormPreview;

implementation

uses
  FullInfo,
  controller, DB_service;
{$R *.dfm}

procedure TFormPreview.BChangeClick(Sender: TObject);
begin
  if TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]).field_name = 'n_house' then
    ENewValue.Text := get_full_address(ADOQ,
//        InttoStr(FormControl.current_city_id),
        InttoStr(TStreetParams(StreetList.Objects[CBStreet.ItemIndex]).id_city),
        InttoStr(TStreetParams(StreetList.Objects[CBStreet.ItemIndex]).code_street),
        IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).n_home),
        IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).f_home),
        THomeParams(HomeList.Objects[CBHome.ItemIndex]).a_home,
        IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).d_home),
        IntToStr(TRoomParams(RoomList.Objects[CBRoom.ItemIndex]).n_room),
        TRoomParams(RoomList.Objects[CBRoom.ItemIndex]).a_room
        )
  else
    ENewValue.Text := LDBValue.Caption;
end;

procedure TFormPreview.BSaveNewValueClick(Sender: TObject);
begin
  with ADOQ do begin
    SQL.Clear;
    if TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]).field_name= 'n_house' then
      SQL.Add('UPDATE utilityfiles_bo SET '+
        ' code_s='+InttoStr(TStreetParams(StreetList.Objects[CBStreet.ItemIndex]).code_street)+
        ', n_house='+IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).n_home)+
        ', f_house='+IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).f_home)+
        ', a_house='''+THomeParams(HomeList.Objects[CBHome.ItemIndex]).a_home+
        ''', d_house='+IntToStr(THomeParams(HomeList.Objects[CBHome.ItemIndex]).d_home)+
        ', n_room='+IntToStr(TRoomParams(RoomList.Objects[CBRoom.ItemIndex]).n_room)+
        ', a_room='''+TRoomParams(RoomList.Objects[CBRoom.ItemIndex]).a_room+
        ''' WHERE record_number = '+IntToStr(FormControl.selected_record_num))
    else
      if (ADODSW.FieldByName(TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]).field_name).DataType = ftString) then
        SQL.Add('UPDATE utilityfiles_bo SET '+
          TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]).field_name+
          ' = '''+ENewValue.Text+''' WHERE record_number = '+
          IntToStr(FormControl.selected_record_num))
      else
        SQL.Add('UPDATE utilityfiles_bo SET '+
          TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]).field_name+
          ' = '+ENewValue.Text+
          ' WHERE record_number = '+
          IntToStr(FormControl.selected_record_num));

    ExecSQL;
    Close;
  end;
//  FormControl.LBWarnings.DeleteSelected;
  Close;
end;

procedure TFormPreview.Button1Click(Sender: TObject);
var
  q: TADOQuery;

begin
  q := TADOQuery.Create(Self);
  q.ConnectionString := connection_string;
  q.SQL.Clear;
  q.SQL.Add('DELETE FROM utilityfiles_bo WHERE record_number = '+
          IntToStr(FormControl.selected_record_num));
  q.ExecSQL;
  q.Close;
  q.Free;
  Close;
end;

procedure TFormPreview.CBHomeChange(Sender: TObject);
begin
  RoomList.Clear;
  get_room_list_by_home(RoomList, ADOQ,
    THomeParams(HomeList.Objects[CBHome.ItemIndex]).id);
  CBRoom.Items := RoomList;
  CBRoom.ItemIndex := 0;

end;

procedure TFormPreview.CBStreetChange(Sender: TObject);
var
  pos: integer;
begin
  if CBStreet.ItemIndex < 0 then CBStreet.ItemIndex := 0;

  HomeList.Clear;
  get_home_list_by_street(HomeList, ADOQ,
    TStreetParams(StreetList.Objects[CBStreet.ItemIndex]).id);
  CBHome.Items := HomeList;
  CBHome.ItemIndex := 0;

end;

procedure TFormPreview.FormCreate(Sender: TObject);
begin
  OccupantList := TStringList.Create;{ construct the list object }
  PayerList := TStringList.Create;
  BankbookList := TStringList.Create;
  StreetList := TStringList.Create;
  HomeList := TStringList.Create;
  RoomList := TStringList.Create;
  ADOQ.ConnectionString := connection_string;
  ADODSW.ConnectionString := connection_string;
  ADOSP.ConnectionString := connection_string;
end;

procedure TFormPreview.FormDestroy(Sender: TObject);
begin
  OccupantList.Free;{ destroy the list object }
  PayerList.Free;
  BankbookList.free;
  StreetList.Free;
  HomeList.Free;
  RoomList.Free;
end;

procedure TFormPreview.FormShow(Sender: TObject);
var
  address_params: TAddressParams;
  full_address: string;
  list_index: integer;
begin
  CBStreet.Hide;
  CBHome.Hide;
  CBRoom.Hide;
  LBOccupants.Clear;
  OccupantList.Clear;
  LBPayers.Clear;
  PayerList.Clear;
  LBBankbook.Clear;
  BankbookList.clear;
  LBankbookOf.Caption := '';
  try    { use the string list }
    if obtain_selected_record(FormControl.selected_record_num) then begin
      LTitle.Caption := 'Организация '+Inttostr(FormControl.current_firm_code)+
        ';  Отчетная дата '+DateToStr(FormControl.report_date)+
        ';  Запись '+IntToStr(FormControl.selected_record_num)+
        ';  Лицевой счет '+ ADODSW.FieldByName('abcount').AsString+';';
      LService.Caption := 'Название платежа: '+
        get_service_name_by_service_id(ADOQ, ADODSW.FieldByName('code_plat').AsInteger);
      full_address := get_full_address(ADOQ,
        ADODSW.FieldByName('code_c').AsString,
        ADODSW.FieldByName('code_s').AsString,
        ADODSW.FieldByName('n_house').AsString,
        ADODSW.FieldByName('f_house').AsString,
        ADODSW.FieldByName('a_house').AsString,
        ADODSW.FieldByName('d_house').AsString,
        ADODSW.FieldByName('n_room').AsString,
        ADODSW.FieldByName('a_room').AsString
        );
        LAddress.Caption := 'Адрес: '+ full_address;
        get_occupants_by_address(OccupantList, ADOQ,
          ADODSW.FieldByName('code_c').AsString,
          ADODSW.FieldByName('code_s').AsString,
          ADODSW.FieldByName('n_house').AsString,
          ADODSW.FieldByName('f_house').AsString,
          ADODSW.FieldByName('a_house').AsString,
          ADODSW.FieldByName('d_house').AsString,
          ADODSW.FieldByName('n_room').AsString,
          ADODSW.FieldByName('a_room').AsString);
        LOccupants.Caption := 'Плательщики по адресу '+ full_address;
        LBOccupants.Items := OccupantList;
        get_payers_by_bankbook_params(PayerList, ADOQ,
            ADODSW.FieldByName('code_firme').AsString,
            ADODSW.FieldByName('code_plat').AsString,
            ADODSW.FieldByName('abcount').AsString);
        LPayers.Caption := 'Плательщики по счету '+
          ADODSW.FieldByName('abcount').AsString;
        LBPayers.Items := PayerList;


      with TWarningInfo(FormControl.LBWarnings.Items.Objects[FormControl.LBWarnings.ItemIndex]) do begin
        LFieldName.Caption := field_name;
        ENewValue.Text := ADODSW.FieldByName(field_name).AsString;
        LDBValue.Caption:= db_value;
//        if field_name = 'fio' then begin
//          if db_value = '' then
//            EdbValue.Text := get_fullname_by_bankbook_params(ADOSP,
//              ADODSW.FieldByName('code_firme').AsInteger,
//              ADODSW.FieldByName('code_plat').AsInteger,
//              ADODSW.FieldByName('abcount').AsString)
//          else
//            EdbValue.Text := db_value;
//        end else
        if (field_name = 'n_house') then begin // wrong address
          StreetList.Clear;
          get_street_list_by_city(StreetList, ADOQ,
            ADODSW.FieldByName('code_c').AsInteger);
//          FormControl.current_city_id);
          CBStreet.Items := StreetList;
          LFieldName.Caption := 'Адрес';
          ENewValue.Text := full_address;
          if get_address_params_by_bankbook(address_params, ADOQ,
            ADODSW.FieldByName('code_firme').AsString,
            ADODSW.FieldByName('code_plat').AsString,
            ADODSW.FieldByName('abcount').AsString) then
            LDBValue.Caption:= '';
//            address_params.city_name+' '+
//              address_params.street_name+' '+IntToStr(address_params.n_house)+' '+
//              IntToStr(address_params.n_room);
          if StreetList.Find(address_params.street_name, list_index) then
            CBStreet.ItemIndex := list_index
          else
            CBStreet.ItemIndex := 0;
          CBStreetChange(Sender);
          CBStreet.Show;
          if HomeList.Find(IntToStr(address_params.n_house)+
            trim(address_params.a_house)+'-'+
            IntToStr(address_params.f_house)+'/'+
            IntToStr(address_params.d_house), list_index) then
            CBHome.ItemIndex := list_index
          else
            CBHome.ItemIndex := 0;
          CBHomeChange(Sender);
          CBHome.Show;
          if RoomList.Find(IntToStr(address_params.n_room)+
            trim(address_params.a_room), list_index) then
            CBRoom.ItemIndex := list_index
          else
            CBRoom.ItemIndex := 0;
          CBRoom.Show;
        end;
      end;
    end;
  finally
  end;
end;

procedure TFormPreview.LBBankbookDblClick(Sender: TObject);
begin
  FormFullInfo.current_period_id := FormControl.report_date_params.id;
  FormFullInfo.bankbook_params := TBankbookParams(BankbookList.Objects[LBBankbook.ItemIndex]);
  FormFullInfo.ShowModal;
end;

procedure TFormPreview.LBOccupantsClick(Sender: TObject);
begin
  FormFullInfo.current_owner_erc_code := TERCCodeOwnerParams(OccupantList.Objects[LBOccupants.ItemIndex]);
  BankbookList.Clear;
  get_all_bankbook_by_human_id(BankbookList, ADOQ, FormFullInfo.current_owner_erc_code.id);
  LBBankbook.Clear;
  LBBankbook.Items := BankbookList;
  LBankbookOf.Caption := 'Счета плательщика (по адресу)';
end;

procedure TFormPreview.LBPayersClick(Sender: TObject);
begin
  FormFullInfo.current_owner_erc_code := TERCCodeOwnerParams(PayerList.Objects[LBPayers.ItemIndex]);
  BankbookList.Clear;
  get_all_bankbook_by_human_id(BankbookList, ADOQ, FormFullInfo.current_owner_erc_code.id);
  LBBankbook.Clear;
  LBBankbook.Items := BankbookList;
  LBankbookOf.Caption := 'Счета плательщика (по счету)';
end;

function TFormPreview.obtain_selected_record(record_num: integer): boolean;
begin
  result := false;
  with ADOQ do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM utilityfiles_bo WHERE record_number = '+IntToStr(record_num));
    Open;
    if Recordset.RecordCount > 0 then begin
      ADODSW.Recordset := Recordset;
      result := true;
    end;
  end;
end;

end.


