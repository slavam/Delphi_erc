program data_CRUD;

uses
  Forms,
  mainCRUD in 'mainCRUD.pas' {FormCRUD},
  FullInfo in 'FullInfo.pas' {FormFullInfo},
  NewPayer in 'NewPayer.pas' {FormNewPayer},
  DB_service in 'DB_service.pas',
  NewBankbook in 'NewBankbook.pas' {FormNewBankbook},
  ViewInfo in 'ViewInfo.pas' {FormInfo},
  viewBankbook in 'viewBankbook.pas' {FormBankbook};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormCRUD, FormCRUD);
  Application.CreateForm(TFormFullInfo, FormFullInfo);
  Application.CreateForm(TFormNewPayer, FormNewPayer);
  Application.CreateForm(TFormNewBankbook, FormNewBankbook);
  Application.CreateForm(TFormInfo, FormInfo);
  Application.CreateForm(TFormBankbook, FormBankbook);
  Application.Run;
end.
