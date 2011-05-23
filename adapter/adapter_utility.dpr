program adapter_utility;

uses
  Forms,
  adapter in 'adapter.pas' {FormAdapter};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormAdapter, FormAdapter);
  Application.Run;
end.
