program viewer_data;

uses
  Forms,
  viewer in 'viewer.pas' {FormViewPayer},
  Login in 'Login.pas' {LoginDlg},
  ShortInfo in 'ShortInfo.pas' {ShortInfoForm},
  DB_service in '..\tools\DB_service.pas';

{$R *.res}

begin
  LoginDlg := TLoginDlg.Create(Application);
  LoginDlg.ShowModal;
  Application.Initialize;
  Application.CreateForm(TFormViewPayer, FormViewPayer);
  Application.CreateForm(TShortInfoForm, ShortInfoForm);
  Application.Run;
end.
