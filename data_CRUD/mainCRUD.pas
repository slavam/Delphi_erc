unit mainCRUD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  IniFiles, ExtCtrls, StdCtrls, ADODB, DB, DBTables, DBCtrls, DBGrids,
  Dialogs, Grids;

type
  TFormCRUD = class(TForm)
    Panel1: TPanel;
    Label4: TLabel;
    CBCity: TComboBox;
    Label5: TLabel;
    CBStreet: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    CBHome: TComboBox;
    CBRoom: TComboBox;
    LBOccupants: TListBox;
    BNewPayer: TButton;
    BAddBankbook: TButton;
    LBBankbooks: TListBox;
    Label8: TLabel;
    BShowBB: TButton;
    LECodeERC: TLabeledEdit;
    BSearch: TButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CBCitySelect(Sender: TObject);
    procedure CBStreetSelect(Sender: TObject);
    procedure CBHomeSelect(Sender: TObject);
    procedure CBRoomSelect(Sender: TObject);
    procedure BNewPayerClick(Sender: TObject);
    procedure LBOccupantsClick(Sender: TObject);
    procedure BAddBankbookClick(Sender: TObject);
    procedure LBBankbooksDblClick(Sender: TObject);
    procedure BShowBBClick(Sender: TObject);
    procedure BSearchClick(Sender: TObject);
  private
    { Private declarations }
  public
    city_id: array[0..1500] of integer;
    bb_list, occupant_list, room_list, home_list, street_list: TStringList;
  end;

var
  FormCRUD: TFormCRUD;
  settings: TIniFile;
  connection_string : string;

implementation
uses
  DB_service,
  FullInfo, NewPayer, NewBankbook, ViewInfo, viewBankbook;
{$R *.dfm}

var
  q: TADOQuery;

procedure TFormCRUD.BNewPayerClick(Sender: TObject);
begin
  FormNewPayer.ShowModal;
  CBRoomSelect(Sender);
end;

procedure TFormCRUD.BSearchClick(Sender: TObject);
var
  i: integer;
  payer_params: TERCCodeOwnerParams;
begin
  if trim(LECodeERC.Text)='' then exit;
  
  occupant_list.Clear;
  LBOccupants.Items.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id_city='+IntToStr(city_id[CBCity.ItemIndex])+
    ' AND code_erc ='+
      LECodeERC.Text);
    Open;
    First;
    if recordcount>0 then begin
      for I := 0 to recordCount - 1 do begin
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
      LBOccupantsClick(Sender);
    end;
    BAddBankbook.Enabled := occupant_list.Count >0;
    close;
  end;
end;

procedure TFormCRUD.BShowBBClick(Sender: TObject);
begin
  FormBankBook.Show;
end;

procedure TFormCRUD.BAddBankbookClick(Sender: TObject);
begin
  FormNewBankbook.ShowModal;
  if (room_list <> nil) and (room_list.count>0) then
    CBRoomSelect(Sender);
end;

procedure TFormCRUD.CBCitySelect(Sender: TObject);
begin
  street_list.Clear;
  CBStreet.Items.Clear;
  CBHome.Items.Clear;
  CBRoom.Items.Clear;
  get_street_list_by_city(street_list, q, city_id[CBCity.ItemIndex]);
  if street_list.Count=0 then begin
    street_list.Clear;
    home_list.Clear;
    room_list.Clear;
    CBStreet.Text := '';
    CBHome.Text := '';
    CBRoom.Text := '';
    LBOccupants.Clear;
    BNewPayer.Enabled := false;
  end else begin
    CBStreet.Items := street_list;
    CBStreet.ItemIndex := 0;
    CBStreetSelect(Sender);
    if (FormInfo <> nil) and FormInfo.Visible then
      FormInfo.Close;
  end;
end;

procedure TFormCRUD.CBHomeSelect(Sender: TObject);
begin
  room_list.Clear;
  get_room_list_by_home(room_list, q,
    THomeParams(home_list.Objects[CBHome.ItemIndex]).id);
  CBRoom.Items := room_list;
  CBRoom.ItemIndex := 0;
  CBRoomSelect(Sender)
end;

procedure TFormCRUD.CBRoomSelect(Sender: TObject);
var
  i: integer;
  payer_params: TERCCodeOwnerParams;
begin
  occupant_list.Clear;
  LBOccupants.Items.Clear;
  LBBankbooks.Items.Clear;
  with q do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM humans WHERE id_room_location='+
      Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).id));
    Open;
    First;
    if recordcount>0 then begin
      for I := 0 to recordCount - 1 do begin
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
      BAddBankbook.Enabled := occupant_list.Count >0;
      LBOccupants.Items := occupant_list;
      LBOccupants.ItemIndex := 0;
      LBOccupantsClick(Sender);
    end;
    close;
  end;
end;

procedure TFormCRUD.CBStreetSelect(Sender: TObject);
begin
  if CBStreet.ItemIndex < 0 then CBStreet.ItemIndex := 0;
  home_list.Clear;
  get_home_list_by_street(home_list, q, TStreetParams(street_list.Objects[CBStreet.ItemIndex]).id);
  if home_list.Count=0 then begin
    home_list.Clear;
    room_list.Clear;
    CBHome.Items.Clear;
    CBRoom.Items.Clear;
    CBHome.Text := '';
    CBRoom.Text := '';
    LBOccupants.Clear;
    BNewPayer.Enabled := false;
  end else begin
    BNewPayer.Enabled := true;
    CBHome.Items := home_list;
    CBHome.ItemIndex := 0;
    CBHomeSelect(Sender);
  end;
end;

procedure TFormCRUD.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Client.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=S-050-ERC; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER_old');
  Settings.Free;
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
  street_list := TStringList.Create;
  home_list := TStringList.Create;
  room_list := TStringList.Create;
  occupant_list := TStringList.Create;
  bb_list := TStringList.Create;
  CBCity.ItemIndex := 0;
  CBCitySelect(Sender);
end;

procedure TFormCRUD.FormDestroy(Sender: TObject);
begin
  street_list.Free;
  home_list.Free;
  room_list.Free;
  occupant_list.Free;
  bb_list.Free;
  q.Free;
end;

procedure TFormCRUD.LBBankbooksDblClick(Sender: TObject);
begin
  if FormInfo.Visible then
    FormInfo.Close;
  FormInfo.current_owner_erc_code := TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]);
  FormInfo.bankbook_params := TBankbookParams(bb_list.Objects[LBBankbooks.ItemIndex]);
  FormInfo.Show;
end;

procedure TFormCRUD.LBOccupantsClick(Sender: TObject);
begin
  bb_list.Clear;
  get_all_bankbook_by_human_id(bb_list, q,
    TERCCodeOwnerParams(occupant_list.Objects[LBOccupants.ItemIndex]).id);
  LBBankbooks.Items := bb_list;
  LBBankbooks.ItemIndex := 0;
end;

end.
