program upgrade_streets;

uses
  Forms,
  main in 'main.pas' {FormMain},
  newStreet in 'newStreet.pas' {FormNewStreet};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormNewStreet, FormNewStreet);
  Application.Run;
end.
