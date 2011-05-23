unit NewPayer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormNewPayer = class(TForm)
    BCreate: TButton;
    BCancel: TButton;
    LAddress: TLabel;
    LEFullName: TLabeledEdit;
    procedure BCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewPayer: TFormNewPayer;

implementation
uses
  ADODB,
  DB_service,
  mainCRUD, DB;
{$R *.dfm}
var
  q: TADOQuery;
  sp: TADOStoredProc;

procedure TFormNewPayer.BCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormNewPayer.BCreateClick(Sender: TObject);
var
  s_erc_code: string;
begin
//  s_erc_code := new_erc_code(q, FormCRUD.city_id[FormCRUD.CBCity.itemIndex]);
  s_erc_code := get_new_erc_code(sp, FormCRUD.city_id[FormCRUD.CBCity.itemIndex]);
  with q do begin
    sql.Clear;
    sql.Add('INSERT INTO humans VALUES ('+s_erc_code+', '''+
      LEFullName.Text+''', '+
      Inttostr(TRoomParams(FormCRUD.room_list.Objects[FormCRUD.CBRoom.ItemIndex]).id)+', '+
      Inttostr(FormCRUD.city_id[FormCRUD.CBCity.itemIndex])+', '''')');
    ExecSQL;
    Close;
  end;
  Close;
end;

procedure TFormNewPayer.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  sp := TADOStoredProc.Create(self);
  sp.ConnectionString := connection_string;
end;

procedure TFormNewPayer.FormShow(Sender: TObject);
begin
  with FormCRUD do
  LAddress.Caption := 'јдрес: '+ FormCRUD.CBCity.Text+', '+
    CBStreet.Text+', дом '+CBHome.Text+', кв. '+CBRoom.Text;
//  Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).n_room)+
//  TRoomParams(room_list.Objects[CBRoom.ItemIndex]).a_room;
//    get_full_address(q, Inttostr(city_id[CBCity.itemIndex]),
//      IntToStr(TStreetParams(street_list.Objects[CBStreet.ItemIndex]).id),
//      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).n_home),
//      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).f_home),
//      THomeParams(home_list.Objects[CBHome.ItemIndex]).a_home,
//      IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).d_home),
//      Inttostr(TRoomParams(room_list.Objects[CBRoom.ItemIndex]).n_room),
//      TRoomParams(room_list.Objects[CBRoom.ItemIndex]).a_room);

end;

end.
