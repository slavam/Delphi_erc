unit login;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  IniFiles,
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
    LFileNum: TLabel;
    EFileNum: TEdit;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginDlg: TLoginDlg;
  Settings: TIniFile;
  m: integer;
  analyze_file_number: integer;

implementation
uses
  verify_data;

{$R *.dfm}

procedure TLoginDlg.CancelBtnClick(Sender: TObject);
begin
  log_in := '';
  pw := '';
end;

procedure TLoginDlg.FormCreate(Sender: TObject);
begin
  Settings := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Load_settings.ini');
  m := Settings.ReadInteger('Main', 'ONLYANALYZE', 0);
  Settings.Free;
  EFileNum.Enabled := m=1;
  LFileNum.Enabled := EFileNum.Enabled;
end;

procedure TLoginDlg.OKBtnClick(Sender: TObject);
begin
  log_in := ELogin.text;
  pw := EPassword.Text;
  if trim(EFileNum.Text)='' then
    analyze_file_number := 0
  else
    analyze_file_number := StrToInt(EFileNum.Text);
end;

end.
