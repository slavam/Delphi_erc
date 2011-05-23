unit login;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TLoginDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ELogin: TEdit;
    EPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginDlg: TLoginDlg;

implementation
uses
  main;

{$R *.dfm}

procedure TLoginDlg.CancelBtnClick(Sender: TObject);
begin
  log_in := '';
  pw := '';
end;

procedure TLoginDlg.OKBtnClick(Sender: TObject);
begin
  log_in := ELogin.text;
  pw := EPassword.Text;
end;

end.
