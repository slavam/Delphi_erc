unit test_pr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, DB,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  connection_string : string;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  q: TADOQuery;
  i: integer;
  code_old, code_new: string;
begin
  q := TADOQuery.Create(self);
  q.ConnectionString := connection_string;
  with q do begin
    SQL.Clear;
    SQL.Add('select d.code code, h.code_erc code_erc '+
      ' from humans h inner join bankbooks b on (h.id = b.id_human) '+
      ' inner join [10.40.28.34].erc.dbo.dolgs d on (d.abcount = b.bank_book and '+
      ' d.code_firme = b.code_firm) '+
      ' where h.code_erc <> d.code');
    open;
    for I := 0 to recordCount - 1 do begin
      code_new := FieldByName('code_erc').AsString;
      code_old := FieldByName('code').AsString;
      SQL.Clear;
      SQL.Add('update humans set code_erc = '+code_old+
        ' where code_erc = '+code_new);
      try
        ExecSQL;
      Except
        ShowMessage('code_erc="'+code_new+
          '; code='+code_old);
      end;
    end;

  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  connection_string :=
    'Provider=SQLOLEDB.1'+
    '; Password=celeron10'+
    '; Persist Security Info=True'+
    '; User ID=pavel'+
    '; Data Source=10.40.28.35'+
    '; Initial Catalog=ERC_CENTER';

end;

end.
