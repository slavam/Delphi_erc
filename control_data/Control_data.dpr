program Control_data;

uses
  Forms,
  controller in 'controller.pas' {FormControl},
  DB_service in 'DB_service.pas',
  DataView in 'DataView.pas' {FormPreview},
  FullInfo in 'FullInfo.pas' {FormFullInfo},
  Absentees in 'Absentees.pas' {FormAbsentees};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormControl, FormControl);
  Application.CreateForm(TFormPreview, FormPreview);
  Application.CreateForm(TFormFullInfo, FormFullInfo);
  Application.CreateForm(TFormAbsentees, FormAbsentees);
  Application.Run;
end.
