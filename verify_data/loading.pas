unit loading;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB, DB,
  db_service,
  verify_data, StdCtrls,
  Dialogs, CheckLst;

type
  TFormLoading = class(TForm)
    CLBReadyFiles: TCheckListBox;
    Label1: TLabel;
    BLoad: TButton;
    BExit: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BExitClick(Sender: TObject);
    procedure BLoadClick(Sender: TObject);
    procedure CLBReadyFilesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    q: TADOQuery;
    sp: TADOStoredProc;
    procedure load_data_from_file(id_file, id_city, id_firm, id_period: integer);
  public
    { Public declarations }
  end;

var
  FormLoading: TFormLoading;

implementation

{$R *.dfm}

procedure TFormLoading.BExitClick(Sender: TObject);
begin
  close;
end;

procedure TFormLoading.load_data_from_file(id_file, id_city, id_firm, id_period: integer);
var
  correct_records: integer;
begin
  if get_for_loading_file_status(q, id_file)=9 then begin
    with q do begin
    sql.Clear;
    SQL.Add('SELECT count(*) as c FROM utilityfiles_bo  WHERE is_correct_record=1 AND id_file='+
      IntToStr(id_file));
      Open;
      correct_records := FieldByName('c').AsInteger;
      close;
    end;

    if is_update_statistics=1 then begin
      FormMain.to_protocol('Начато обновление статистики;');
      with sp do begin
        ProcedureName := 'SP_UPDATESTATS;1';
        Parameters.Clear;
        Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
        ExecProc;
        Close;
      end;
      FormMain.to_protocol('Завершено обновление статистики;');
    end;

    FormMain.to_protocol('Начата загрузка данных из файла № '+IntToStr(id_file));
    sp.CommandTimeout := 3600;
    update_reg_record(q, id_file, 10);
    with sp do begin
      ProcedureName := 'up_distributeUtilityFiles_bo;1';
      Parameters.Clear;
      Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
      Parameters.CreateParameter('@file_id', ftinteger, pdInput, 10, id_file);
      Parameters.CreateParameter('@id_city', ftinteger, pdInput, 10, id_city);
      ExecProc;
      Close;
    end;
    update_reg_record(q, id_file, 1);
    FormMain.to_protocol('Окончена загрузка данных.');
    with sp do begin
      ProcedureName := 'up_getFirmStatistics;1';
      Parameters.Clear;
      Parameters.CreateParameter('@result_value', ftinteger, pdReturnValue, 10, 0);
      Parameters.CreateParameter('@code_firm', ftinteger, pdInput, 10, id_firm);
      Parameters.CreateParameter('@id_period', ftinteger, pdInput, 10, id_period);
      Open;             
      FormMain.to_protocol('Должно быть загружено записей: '+
        IntToStr(correct_records));
      FormMain.to_protocol('Добавлено данных о долгах: '+
        FieldByName('cnt_debts').AsString);
      if correct_records <> FieldByName('cnt_debts').AsInteger then
        FormMain.to_protocol('ЧИСЛО КОРРЕКТНЫХ ЗАПИСЕЙ НЕ РАВНО ЧИСЛУ ЗАГРУЖЕННЫХ!!!');
      FormMain.to_protocol('Добавлено данных о льготах: '+
        FieldByName('cnt_lgots').AsString);
      FormMain.to_protocol('Добавлено данных о тарифах: '+
        FieldByName('cnt_tarifs').AsString);
      FormMain.to_protocol('Добавлено данных о жилье: '+
        FieldByName('cnt_rooms').AsString);
      FormMain.to_protocol('Добавлено данных о плательщиках: '+
        FieldByName('cnt_humans').AsString);
      Close;
    end;
  end;
end;

procedure TFormLoading.BLoadClick(Sender: TObject);
var
  i: integer;
  id_period: integer;
begin
  for I := 0 to CLBReadyFiles.Items.Count - 1 do begin
    if CLBReadyFiles.Checked[i] then begin
      id_period := get_period_id(q, TRegistrationData(CLBReadyFiles.Items.Objects[i]).id_city);
      if id_period>0 then
        load_data_from_file(TRegistrationData(CLBReadyFiles.Items.Objects[i]).id_file,
          TRegistrationData(CLBReadyFiles.Items.Objects[i]).id_city,
          TRegistrationData(CLBReadyFiles.Items.Objects[i]).id_firm, id_period)
      else
        ShowMessage('Не найден период для файла '+CLBReadyFiles.Items[i]);
    end;
  end;
end;

procedure TFormLoading.CLBReadyFilesMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button=mbRight then begin // Удаление файла из списка
    update_reg_record(q,
      TRegistrationData(CLBReadyFiles.Items.Objects[CLBReadyFiles.ItemAtPos(Point(x, y), true)]).id_file, -1);
    FormShow(Sender);
  end;
end;

procedure TFormLoading.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  q.CommandTimeout := 1200;
  sp := TADOStoredProc.Create(self);
end;

procedure TFormLoading.FormShow(Sender: TObject);
var
//  i: integer;
  reg_data: TRegistrationData;
begin
  q.Connection := FormMain.ADOConnectionMain;
  sp.Connection := FormMain.ADOConnectionMain;
// Подготовка списка файлов для загрузки
  with q do begin
    sql.Clear;
    SQL.Add('SELECT * FROM file_registrations WHERE id_status=9 ORDER BY id');
    open;
    first;
    CLBReadyFiles.Items.Clear;
    while not eof do begin
      reg_data := TRegistrationData.Create;
      reg_data.id_file := FieldByName('id').AsInteger;
      reg_data.id_city := FieldByName('id_city').AsInteger;
      reg_data.id_firm := FieldByName('code_firm').AsInteger;
      CLBReadyFiles.Items.AddObject(FieldByName('id').AsString+'-'+
        FieldByName('file_name').AsString+'('+
        FieldByName('file_size').AsString+') от '+
        FieldByName('date_reg').AsString, TObject(reg_data));
      next;
    end;
  end;
end;

end.
