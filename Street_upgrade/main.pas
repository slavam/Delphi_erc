unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, DB, IniFiles,
  Dialogs, StdCtrls, ExtCtrls;

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
  TRoomParams = class(TObject)
    rl_id: integer;
    r_id: integer;
    n_room: integer;
    a_room: string;
  end;

type
  TStreetParams = class(TObject)
    sl_id: integer;
    name: string;
    id_type: integer;
    short_type: string;
  end;

type
  THomeParams = class(TObject)
    hl_id: integer;
    h_id: integer;
    n_home: integer;
    f_home: integer;
    a_home: string;
    d_home: integer;
  end;

type
  TFormMain = class(TForm)
    BStart: TButton;
    CBCity: TComboBox;
    Label1: TLabel;
    CBStreet: TComboBox;
    Label2: TLabel;
    BStreetCreate: TButton;
    CBHome: TComboBox;
    Label3: TLabel;
    CBRoom: TComboBox;
    Label4: TLabel;
    CBCityTemplate: TComboBox;
    Label5: TLabel;
    CBStreetTemplate: TComboBox;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BStartClick(Sender: TObject);
    procedure CBCitySelect(Sender: TObject);
    procedure CBStreetSelect(Sender: TObject);
    procedure CBHomeSelect(Sender: TObject);
    procedure BStreetCreateClick(Sender: TObject);
  private
    city_id: integer;
    q_t, q_in: TADOQuery;
    procedure update_street(id_street_location, a_type: integer; a_name: string);
  public
    function get_street_location_id(street_name: string; street_type, city_id: integer): integer;
    procedure add_street_to_city(city_id: integer; name_street, name1_street: string;
          type_street: integer);
    procedure upgrade_street_mappings(street_template_id, street_location_id,
              street_id_local: Integer; street_name_local: string;
              street_type_local, city_id_local: integer);
  end;

var
  FormMain: TFormMain;
  Settings: TIniFile;
  connection_string : string;
  street_template_id: integer;
  room_list, home_list, street_list, city_list: TStringList;

implementation

uses newStreet;

{$R *.dfm}

function TFormMain.get_street_location_id(street_name: string; street_type, city_id: integer): integer;
var
  id_type: integer;
  name_street: string;
  id_street_location: integer;
begin
  Result := 0;
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT id FROM street_locations WHERE name='''+street_name+
      ''' AND id_type='+Inttostr(street_type)+
      ' AND id_city='+Inttostr(city_id));
    Open;
    if recordcount>0 then
      Result := q_t.FieldByName('id').AsInteger
    else begin
      SQL.Clear;
      SQL.Add('select sm.*, st.short_name type, sl.* from street_mappings sm '+
        'join street_locations sl on sl.id=sm.id_street_location and name='''+street_name+
        ''' AND id_city='+Inttostr(city_id)+
        ' join street_types st on st.id=sl.id_type '+
        'where code_street_outer='+q_in.FieldByName('code_s').AsString);
      Open;
      if recordcount>0 then begin
        if Application.MessageBox(PChar('Для кода '+q_in.FieldByName('code_s').Asstring+'-'+
          q_in.FieldByName('type_id').Asstring+' '+q_in.FieldByName('name').Asstring+
          ' уже есть '+FieldByName('type').Asstring+' '+
          FieldByName('name_street_outer').Asstring+
          '. Обновить?'
          ),
          PChar('Предупреждение!'),
          MB_OKCANCEL+MB_ICONQUESTION) = IDOK then begin
            id_type := q_in.FieldByName('type_id').AsInteger;
            name_street := q_in.FieldByName('name').Asstring;
            id_street_location := FieldByName('id').AsInteger;
            Result := FieldByName('id').AsInteger;
            close;
            update_street(id_street_location, id_type, name_street);
        end;
      end;
    end;
    close;
  end;
end;

procedure TFormMain.update_street(id_street_location, a_type: integer; a_name: string);
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('UPDATE street_locations '+
      'SET id_type='+IntToStr(a_type)+
      ', name='''+a_name+''' WHERE id='+IntToStr(id_street_location));
    ExecSQL;
    SQL.Clear;
    SQL.Add('UPDATE street_mappings '+
      'SET type_outer='+IntToStr(a_type)+
      ', name_street_outer='''+a_name+''' WHERE id_street_location='+
      IntToStr(id_street_location)+
      ' AND code_street_outer='+q_in.FieldByName('code_s').AsString+
      ' AND id_template='+IntToStr(street_template_id));
    ExecSQL;
    Close;
  end;
end;

procedure TFormMain.upgrade_street_mappings(street_template_id, street_location_id,
              street_id_local: Integer; street_name_local: string;
              street_type_local, city_id_local: integer);
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM street_mappings WHERE id_template='+IntToStr(street_template_id)+
      ' AND id_street_location='+Inttostr(street_location_id)+
      ' AND code_street_outer='+Inttostr(street_id_local)+
      ' AND id_city_outer='+Inttostr(city_id_local)
      );
    Open;
    if recordcount=0 then begin
      close;
      SQL.Clear;
      SQL.Add('INSERT INTO street_mappings VALUES('+IntToStr(street_template_id)+
      ', '+Inttostr(street_location_id)+', '+Inttostr(street_id_local)+', '''+
      street_name_local+''', '+IntToStr(street_type_local)+', '+
      IntToStr(city_id_local)+')');
      ExecSQL;
    end;
    Close;
  end;
end;

procedure TFormMain.add_street_to_city(city_id: integer; name_street, name1_street: string;
          type_street: integer);
begin
  with q_t do begin
    SQL.Clear;
    SQL.Add('INSERT INTO street_locations VALUES('+
      IntToStr(city_id)+', '''+name_street+
      ''', '''+name1_street+''', '+
      IntToStr(type_street)+')');
    ExecSQL;
    Close;
  end;
end;

procedure TFormMain.BStartClick(Sender: TObject);
var
  i:integer;
  name_street: string;
  type_street: integer;
  street_location_id : integer;
  city_id_local: integer;
function get_city_id_local: integer;
begin
  Result := 0;
  with q_t do begin
    sql.clear;
    sql.Add('SELECT * FROM city_mappings WHERE id_template='+
      IntToStr(CBCityTemplate.ItemIndex)+' AND id_city='+IntToStr(city_id));
    open;
    Result := FieldByName('code_city_outer').AsInteger;
    close;
  end;
end;

begin
  street_template_id := CBStreetTemplate.ItemIndex+1;
  with q_in do begin
//    sql.clear;
//    sql.Add('SELECT * FROM city_mappings WHERE id_template='+
//      IntToStr(CBCityTemplate.ItemIndex)+' AND id_city='+IntToStr(city_id));
//    open;
//    city_id_local := q_in.FieldByName('code_city_outer').AsInteger;
//    close;
    sql.Clear;
    sql.Add('SELECT * FROM streets_addition'); // WHERE id_city='+IntToStr(city_id));
    Open;
    first;
    for I := 0 to RecordCount - 1 do begin
      city_id := q_in.FieldByName('id_city').AsInteger;
      name_street := trim(q_in.FieldByName('name').AsString);
      type_street := q_in.FieldByName('type_id').AsInteger;
      street_location_id := get_street_location_id(name_street, type_street, city_id);
      if street_location_id=0 then begin
        add_street_to_city(city_id, name_street, q_in.FieldByName('name1').AsString,
          type_street);
        street_location_id := get_street_location_id(name_street, type_street, city_id);
      end;
      upgrade_street_mappings(street_template_id, street_location_id,
        q_in.FieldByName('code_s').AsInteger, name_street,
        type_street, get_city_id_local);
      next;
    end;
  end;
end;

procedure TFormMain.BStreetCreateClick(Sender: TObject);
begin
  if FormNewStreet.Visible then
    FormNewStreet.Close;
  FormNewStreet.ShowModal;
end;

procedure TFormMain.CBCitySelect(Sender: TObject);
var
  i: integer;
  street: TStreetParams;
begin
  street_list.Clear;
  CBStreet.Items.Clear;
  CBStreet.Text := '';
  city_id := TCityParams(city_list.Objects[CBCity.ItemIndex]).id;
  if CBCity.ItemIndex>=0 then
    with q_t do begin
      SQL.Clear;
      SQL.Add('SELECT sl.id sl_id, sl.name name, st.id id_type, st.short_name short_type '+
        'FROM street_locations sl '+
          'JOIN street_types st ON sl.id_type=st.id '+
        'WHERE id_city='+IntToStr(TCityParams(city_list.Objects[CBCity.ItemIndex]).id)+
        ' ORDER BY name');
      Open;
      if recordcount>0 then begin
        first;
        for I := 0 to recordcount - 1 do begin
          street:= TStreetParams.Create;
          with street do begin
            sl_id := FieldByName('sl_id').AsInteger;
            name := FieldByName('name').AsString;
            id_type := FieldByName('id_type').AsInteger;
            short_type := FieldByName('short_type').AsString;
          end;
          street_list.AddObject(FieldByName('name').AsString+' '+
            FieldByName('short_type').AsString, TObject(street));
          next;
        end;
        CBStreet.Items := street_list;
        CBStreet.ItemIndex := 0;
        CBStreetSelect(Sender);
      end;
      close;
    end;
end;

procedure TFormMain.CBHomeSelect(Sender: TObject);
var
  i: integer;
  room: TRoomParams;
begin
  room_list.Clear;
  CBRoom.Items.Clear;
  CBRoom.Text := '';
  if CBHome.ItemIndex>=0 then
    with q_t do begin
      SQL.Clear;
      SQL.Add('SELECT rl.id rl_id, r.id r_id, r.n_room n_room, r.a_room a_room '+
        'FROM room_locations rl '+
        'JOIN rooms r ON rl.id_room=r.id '+
        'WHERE id_house_location='+IntToStr(THomeParams(home_list.Objects[CBHome.ItemIndex]).hl_id)+
        ' ORDER BY n_room');
      Open;
      if recordcount>0 then begin
        first;
        for I := 0 to recordcount - 1 do begin
          room:= TRoomParams.Create;
          with room do begin
            rl_id := FieldByName('rl_id').AsInteger;
            r_id := FieldByName('r_id').AsInteger;
            n_room := FieldByName('n_room').AsInteger;
            a_room := FieldByName('a_room').AsString;
          end;
          room_list.AddObject(FieldByName('n_room').AsString+'"'+
            FieldByName('a_room').AsString+'"', TObject(room));
          next;
        end;
        CBRoom.Items := room_list;
        CBRoom.ItemIndex := 0;
      end;
      close;
    end;
end;

procedure TFormMain.CBStreetSelect(Sender: TObject);
var
  i: integer;
  home: THomeParams;
begin
  home_list.Clear;
  CBHome.Items.Clear;
  CBHome.Text := '';
  if CBStreet.ItemIndex>=0 then
    with q_t do begin
      SQL.Clear;
      SQL.Add('SELECT hl.id hl_id, h.id h_id, h.n_house n_home, h.f_house f_home, h.a_house a_home, h.d_house d_home '+
        'FROM house_locations hl '+
        'JOIN houses h ON hl.id_house=h.id '+
        'WHERE id_street_location='+IntToStr(TStreetParams(street_list.Objects[CBStreet.ItemIndex]).sl_id)+
        ' ORDER BY n_home');
      Open;
      if recordcount>0 then begin
        first;
        for I := 0 to recordcount - 1 do begin
          home:= THomeParams.Create;
          with home do begin
            hl_id := FieldByName('hl_id').AsInteger;
            h_id := FieldByName('h_id').AsInteger;
            n_home := FieldByName('n_home').AsInteger;
            f_home := FieldByName('f_home').Asinteger;
            a_home := FieldByName('a_home').AsString;
            d_home := FieldByName('d_home').Asinteger;
          end;
          home_list.AddObject(FieldByName('n_home').AsString+'-'+
            FieldByName('d_home').AsString+'/'+
            FieldByName('f_home').AsString+'"'+
            FieldByName('a_home').AsString+'"', TObject(home));
          next;
        end;
        CBHome.Items := home_list;
        CBHome.ItemIndex := 0;
        CBHomeSelect(Sender);
      end;
      close;
    end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: integer;
  city: TCityParams;
begin
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Load_settings.ini');
  connection_string :=
    'Provider=SQLOLEDB.1;Password=mwm;Persist Security Info=True;User ID=slava;'+
    'Data Source=10.40.28.34; Initial Catalog='+
  Settings.ReadString('Main', 'DATABASENAME', 'ERC_CENTER');
  Settings.Free;
  q_in := TADOQuery.Create(self);
  q_in.ConnectionString := connection_string;
  q_t := TADOQuery.Create(self);
  q_t.ConnectionString := connection_string;
  q_t.CommandTimeout := 300;


  city_list := TStringList.Create;
  street_list := TStringList.Create;
  home_list := TStringList.Create;
  room_list := TStringList.Create;
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM city_mapping_templates ORDER BY id');
    Open;
    if recordcount>0 then begin
      first;
      for I := 0 to recordcount - 1 do begin
        CBCityTemplate.Items.Add(FieldByName('description').AsString);
        next;
      end;
      CBCityTemplate.ItemIndex := 3;
    end;

    SQL.Clear;
    SQL.Add('SELECT * FROM street_mapping_templates ORDER BY id');
    Open;
    if recordcount>0 then begin
      first;
      for I := 0 to recordcount - 1 do begin
        CBStreetTemplate.Items.Add(FieldByName('description').AsString);
        next;
      end;
      CBStreetTemplate.ItemIndex := 3;
      street_template_id := 3;
    end;

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
  CBRoom.Text := '';
  CBHome.Text := '';
  CBStreet.Text := '';
end;
end.
