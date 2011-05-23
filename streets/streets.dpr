program upgrade_streets;

uses
  Forms,
  main in 'main.pas' {FormMain},
  login in 'login.pas' {LoginDlg};

{$R *.res}

begin
  LoginDlg := TLoginDlg.Create(Application);
  LoginDlg.ShowModal;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
