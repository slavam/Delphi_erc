unit newStreet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, DB,
  Dialogs, StdCtrls;

type
  TFormNewStreet = class(TForm)
    Label1: TLabel;
    CBType: TComboBox;
    Label2: TLabel;
    BCreate: TButton;
    BExit: TButton;
    EName: TEdit;
    EStreetCodeLocal: TEdit;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBTypeSelect(Sender: TObject);
    procedure BCreateClick(Sender: TObject);
    procedure BExitClick(Sender: TObject);
  private
    q_t : TADOQuery;
  public
  end;

var
  FormNewStreet: TFormNewStreet;

implementation
uses
  main;

{$R *.dfm}

procedure TFormNewStreet.BCreateClick(Sender: TObject);
var
  street_location_id: integer;
  city_id_local: integer;
begin
  street_location_id := FormMain.get_street_location_id(trim(EName.Text),
    CBType.ItemIndex, TCityParams(city_list.Objects[FormMain.CBCity.ItemIndex]).id);
  if street_location_id=0 then begin
    FormMain.add_street_to_city(TCityParams(city_list.Objects[FormMain.CBCity.ItemIndex]).id,
      trim(EName.Text), '', CBType.ItemIndex);
    street_location_id := FormMain.get_street_location_id(trim(EName.Text),
      CBType.ItemIndex, TCityParams(city_list.Objects[FormMain.CBCity.ItemIndex]).id);
  end;
  with q_t do begin
    sql.clear;
    sql.Add('SELECT * FROM city_mappings WHERE id_template='+
      IntToStr(FormMain.CBCityTemplate.ItemIndex)+' AND id_city='+
      IntToStr(TCityParams(city_list.Objects[FormMain.CBCity.ItemIndex]).id));
    open;
    city_id_local := FieldByName('code_city_outer').AsInteger;
    close;
  end;

  FormMain.upgrade_street_mappings(street_template_id, street_location_id,
    StrToInt(trim(EStreetCodeLocal.Text)), trim(EName.Text),
    CBType.ItemIndex, city_id_local);
end;

procedure TFormNewStreet.BExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFormNewStreet.CBTypeSelect(Sender: TObject);
begin
  BCreate.Enabled := (CBType.ItemIndex>0) AND (trim(EName.text)<>'');
end;

procedure TFormNewStreet.FormCreate(Sender: TObject);
var
  i: integer;
begin
  q_t := TADOQuery.Create(self);
  q_t.ConnectionString := connection_string;
  with q_t do begin
    SQL.Clear;
    SQL.Add('SELECT st.short_name type FROM street_types st '+
      'ORDER BY id');
    Open;
    first;
    for I := 0 to recordcount - 1 do begin
      CBType.Items.Add(FieldByName('type').AsString);
      Next;
    end;
    CBType.ItemIndex := 1;
  end;
end;

procedure TFormNewStreet.FormShow(Sender: TObject);
begin
  street_template_id := FormMain.CBStreetTemplate.ItemIndex+1;
  CBType.ItemIndex := 1;
end;

end.
