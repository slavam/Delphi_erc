program Verification;

uses
  Forms,
  verify_data in 'verify_data.pas' {FormMain},
  view_info in 'view_info.pas' {FormViewInfo},
  ErrorAnalyzer in 'ErrorAnalyzer.pas' {FormErrorAnalyzer},
  comparing_data in 'comparing_data.pas' {FormComparingDate},
  login in 'login.pas' {LoginDlg},
  loading in 'loading.pas' {FormLoading},
  PayerInfo in 'PayerInfo.pas' {PayerInfoForm},
  LoadState in 'LoadState.pas' {FormLoadingState},
  DB_service in '..\tools\DB_service.pas';

{$R *.res}

begin
  LoginDlg := TLoginDlg.Create(Application);
  LoginDlg.ShowModal;
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormErrorAnalyzer, FormErrorAnalyzer);
  Application.CreateForm(TFormViewInfo, FormViewInfo);
  Application.CreateForm(TFormLoading, FormLoading);
  Application.CreateForm(TPayerInfoForm, PayerInfoForm);
  Application.CreateForm(TFormLoadingState, FormLoadingState);
  //  Application.CreateForm(TFormFullInfo, FormFullInfo);
  Application.CreateForm(TFormComparingDate, FormComparingDate);
  Application.CreateForm(TLoginDlg, LoginDlg);
  Application.Run;
end.
