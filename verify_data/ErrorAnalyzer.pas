unit ErrorAnalyzer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ADODB,
  Dialogs, StdCtrls;

type
  TFormErrorAnalyzer = class(TForm)
    LCodeERC: TLabel;
    LFullName: TLabel;
    LBankbook: TLabel;
    LAddress: TLabel;
    LFirm: TLabel;
    LService: TLabel;
    LBErrors: TListBox;
    LDescription: TLabel;
    MAction: TMemo;
    BAction: TButton;
    BCompareData: TButton;
    LBErcCodeOwners: TListBox;
    Label1: TLabel;
    LPayers: TLabel;
    LBAccounts: TListBox;
    BSubstituteCode: TButton;
    BCreateCode: TButton;
    LTotalErrors: TLabel;
    LNowErrors: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LBErrorsClick(Sender: TObject);
    procedure BActionClick(Sender: TObject);
    procedure BCompareDataClick(Sender: TObject);
    procedure LBErcCodeOwnersClick(Sender: TObject);
    procedure BSubstituteCodeClick(Sender: TObject);
    procedure BCreateCodeClick(Sender: TObject);
    procedure LBAccountsDblClick(Sender: TObject);
    procedure LBErcCodeOwnersDblClick(Sender: TObject);
  private
    { Private declarations }
    q, qq: TADOQuery;
    owner_code_list: TStringList;
    bb_list: TStringList;
    NowErrors: integer;
    bankbook_for_update: string;
//    function GetErrorCount: integer;
    procedure UpdateErrorCount;
    procedure clear_controls;
    function get_error_index: integer;
  public
    { Public declarations }
  end;

var
  FormErrorAnalyzer: TFormErrorAnalyzer;

implementation
uses
  StrUtils,
  verify_data,
  PayerInfo,
  db_service, DB, comparing_data;
{$R *.dfm}

procedure TFormErrorAnalyzer.BActionClick(Sender: TObject);
begin
  case TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).error_code of
    101: begin
//      create_new_bankbook_utility();

    end;
    102, 107, 108: begin // Некорректный адрес, дом, квартира
      update_code_erc(qq, TERCCodeOwnerParams(owner_code_list.Objects[0]).erc_code,
        TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record,
        loading_params.reg_record_id);
      update_id_room_location(qq, TERCCodeOwnerParams(owner_code_list.Objects[0]).id_room,
        TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record,
        loading_params.reg_record_id);
      set_record_as_correct(qq,
        TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record,
        loading_params.reg_record_id);
    end;
  end;
  FormShow(Sender);
  LBErrors.ItemIndex := 0;
end;

procedure TFormErrorAnalyzer.BCompareDataClick(Sender: TObject);
begin
  if not FormComparingDate.Visible then
    FormComparingDate.Show;
  if LBErrors.Items.count>0 then
    FormComparingDate.UpdateContent(TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]));
end;

procedure TFormErrorAnalyzer.BCreateCodeClick(Sender: TObject);
var
  s_erc_code: string;
  sp: TADOStoredProc;
  fn, id_rl, ccc: string;
begin
  if LBErrors.Items.count=0 then
    exit;
  sp := TADOStoredProc.Create(self);
  sp.Connection := FormMain.ADOConnectionMain;
  s_erc_code := get_new_erc_code(sp, loading_params.main_city_id);
  with qq do begin
    SQL.Clear;
    SQL.Add('SELECT * FROM utilityfiles_bo WHERE '+
      ' record_number='+IntToStr(TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record)+
      ' AND id_file='+IntToStr(loading_params.reg_record_id));
    Open;
    fn := AnsiReplaceStr(FieldByName('full_name').AsString, chr(39), '');
    id_rl := FieldByName('id_room_location').Asstring;
    ccc := FieldByName('code_c_corr').Asstring;
    close;

    sql.Clear;
    sql.Add('INSERT INTO humans VALUES ('+s_erc_code+', '''+
      fn+''', '+
      id_rl+', '+
      ccc+', '''')');
    ExecSQL;
    Close;

    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET code_erc ='+
      s_erc_code+
      ' WHERE record_number='+
      IntToStr(TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record)+
      ' AND id_file='+IntToStr(loading_params.reg_record_id));
    ExecSQL;
    Close;
  end;
  UpdateErrorCount;
//  if (LBErrors.Count>0) AND ((LBErrors.ItemIndex+1) < LBErrors.Count) then
//    LBErrors.ItemIndex := LBErrors.ItemIndex+1;
  LBErrors.ItemIndex := get_error_index;
  LBErrorsClick(Sender);
end;

function TFormErrorAnalyzer.get_error_index: integer;
var
  i: integer;
begin
  Result := LBErrors.ItemIndex;
  i := 1;
  while (LBErrors.ItemIndex+i) < LBErrors.Count do begin
    Result := LBErrors.ItemIndex+i;
    with qq do begin
      SQL.Clear;
      SQL.Add('SELECT * FROM utilityfiles_bo '+
        ' WHERE record_number='+
        IntToStr(TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex+i]).number_record)+
        ' AND id_file='+IntToStr(loading_params.reg_record_id));
      open;
      if not EOF and (FieldByName('code_erc').AsInteger=0) then
        Exit;
    end;
    inc(i);
  end;
end;

procedure TFormErrorAnalyzer.BSubstituteCodeClick(Sender: TObject);
begin
  with qq do begin
    CommandTimeout := 100;
    SQL.Clear;
    SQL.Add('UPDATE utilityfiles_bo SET code_erc ='+
      IntToStr(TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[LBErcCodeOwners.ItemIndex]).erc_code)+
      ' WHERE code_firme_corr='+IntToStr(loading_params.firm_id)+' AND abcount='''+
      bankbook_for_update+
      ''' AND id_file='+IntToStr(loading_params.reg_record_id));
    ExecSQL;
    close;
    SQL.Clear;
    SQL.Add('SELECT count(*) as cou FROM utilityfiles_bo '+
      ' WHERE code_firme_corr='+IntToStr(loading_params.firm_id)+' AND abcount='''+
      bankbook_for_update+''' AND id_file='+IntToStr(loading_params.reg_record_id));
    open;
    NowErrors := NowErrors-qq.FieldByName('cou').asinteger;
    LNowErrors.Caption := '/'+IntToStr(NowErrors);
    Close;
  end;
  LBErrors.ItemIndex := get_error_index;
  LBErrorsClick(Sender);
end;

procedure TFormErrorAnalyzer.FormCreate(Sender: TObject);
begin
  q := TADOQuery.Create(self);
  qq := TADOQuery.Create(self);
  owner_code_list := TStringList.Create;
  bb_list := TStringList.Create;
end;

procedure TFormErrorAnalyzer.clear_controls;
begin
  MAction.Lines.Clear;
  LDescription.Caption := '';
  LBAccounts.Items.Clear;
  LBErcCodeOwners.Items.Clear;
  LBErrors.Items.Clear;
end;

procedure TFormErrorAnalyzer.FormShow(Sender: TObject);
var
  error_info: TErrorInfo;
begin
  clear_controls;
  q.Connection := FormMain.ADOConnectionMain;
  qq.Connection := FormMain.ADOConnectionMain;
  with q do begin
    Close;
    CursorLocation := clUseServer;
    SQL.Clear;
    sql.add('SELECT e.description, fe.record_number, fe.id_error, '+
      ' fe.description field FROM file_errors fe '+
      ' JOIN utilityfiles_bo u ON u.record_number=fe.record_number '+
      ' AND u.is_correct_record=0  AND u.id_file='+IntToStr(loading_params.reg_record_id)+
      ' JOIN errors e ON fe.id_error=e.code and e.importance = 3 '+
      ' AND id_software=2 AND error_type <> 2 '+
      ' WHERE fe.id_file='+IntToStr(loading_params.reg_record_id)+
      ' and not exists(select null from file_errors fe1 '+
      ' inner join errors e1 on (fe1.id_error=e1.code AND e1.id_software=2) '+
      ' where fe1.id_file = u.id_file and fe1.record_number = u.record_number '+
      ' and e1.importance = 2) ORDER BY fe.record_number');
    Open;
    LTotalErrors.Caption := '';
    LTotalErrors.Caption := 'Ошибок:'+IntToStr(q.RecordCount);
    NowErrors := q.RecordCount;
    LNowErrors.Caption := '/'+IntToStr(NowErrors);
    LBErrors.Clear;
    while not EOF do begin
      error_info := TErrorInfo.Create;
      error_info.number_record := FieldByName('record_number').AsInteger;
      error_info.error_code := FieldByName('id_error').AsInteger;
      LBErrors.Items.AddObject(FieldByName('record_number').AsString+'; '+
        FieldByName('id_error').AsString+' - '+
        FieldByName('description').AsString+' '+
        FieldByName('field').AsString, error_info);
      next;
    end;
    Close;
    if LBErrors.Items.Count>0 then begin
      LBErrors.ItemIndex := 0;
      LBErrorsClick(Sender);
    end;
  end;
//  LTotalErrors.Caption := '';
//  LTotalErrors.Caption := 'Ошибок:'+IntToStr(GetErrorCount);
//  UpdateErrorCount;
end;

procedure TFormErrorAnalyzer.LBAccountsDblClick(Sender: TObject);
begin
  PayerInfoForm.current_owner_erc_code :=
    TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[LBErcCodeOwners.ItemIndex]);
  PayerInfoForm.bankbook_params :=
    TBankbookParams(LBAccounts.Items.Objects[LBAccounts.ItemIndex]);
  if not PayerInfoForm.Visible then
    PayerInfoForm.Show
  else
    PayerInfoForm.FormShow(Sender);
end;

procedure TFormErrorAnalyzer.LBErcCodeOwnersClick(Sender: TObject);
begin
  LBAccounts.clear;
  bb_list.clear;
  get_all_bankbook_by_human_id(bb_list, qq,
    TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[LBErcCodeOwners.ItemIndex]).id);
  LBAccounts.Items := bb_list;
  if bb_list.Count>0 then begin
    LBAccounts.ItemIndex := 0;
  end;
end;

procedure TFormErrorAnalyzer.LBErcCodeOwnersDblClick(Sender: TObject);
begin
  BSubstituteCodeClick(Sender);
end;

procedure TFormErrorAnalyzer.LBErrorsClick(Sender: TObject);
var
  i: integer;
  address_params: TAddressParams;
  home, room: string;
//procedure fill_address;
//begin
//      LAddress.Caption := address_params.city_type+' '+ address_params.city_name;
//      LAddress.Caption := LAddress.Caption+', '+address_params.street_type+' '+
//        address_params.street_name+', ';
//      LAddress.Caption := LAddress.Caption+'дом '+InttoStr(address_params.n_house);
//      if address_params.f_house <> 0 then
//        LAddress.Caption := LAddress.Caption+'-'+IntToStr(address_params.f_house);
//      if trim(address_params.a_house)>'' then
//        LAddress.Caption := LAddress.Caption+'"'+trim(address_params.a_house)+'"';
//      if (address_params.d_house <> 0)  then
//        LAddress.Caption := LAddress.Caption+'/'+Inttostr(address_params.d_house);
//      if (address_params.n_room <> 0) or (trim(address_params.a_room)>'') then begin
//        LAddress.Caption := LAddress.Caption+', кв. '+
//        IntToStr(address_params.n_room);
//        if trim(address_params.a_room)>'' then
//          LAddress.Caption := LAddress.Caption+'"'+ address_params.a_room+'"';
//      end;
//end;

function get_index_by_full_name(owner_code_list: TStringList; fn: string): integer;
var
  j, i: integer;
  ln: integer;
begin
  Result := 0;
  LFullName.Font.Color := clRed;
  fn := ANSIUpperCase(trim(fn));
  ln := Length(fn);
  j := 0;
  while ln-j>=1 do begin
    fn := copy(fn, 1, ln-j);
    for I := 0 to owner_code_list.Count - 1 do
      if pos(fn, ANSIUpperCase(TERCCodeOwnerParams(owner_code_list.Objects[i]).fullName))=1 then begin
        Result := i;
        if j>=(ln-1) then
          LFullName.Font.Color := clRed
        else
          LFullName.Font.Color := clBlack;
        exit;
      end;
    inc(j);
  end;
end;
begin
  MAction.Lines.Clear;
  with q do begin
    CursorLocation := clUseServer;
    SQL.Clear;
    SQL.Add('SELECT code_s_corr, code_c_corr, code_erc, full_name, code_firme_corr, abcount, '+
      ' n_house, d_house, f_house, a_house, n_room, a_room, '+
      ' firms.name firm_name, code_plat, utilities.name utility_name, '+
      ' utilityfiles_bo.id_room_location id_room_location, '+
      ' dbo.getAddressAsString(utilityfiles_bo.id_room_location) address'+
      ' FROM utilityfiles_bo '+
      ' inner join firms on utilityfiles_bo.code_firme_corr = firms.code '+
      ' inner join utilities on utilityfiles_bo.code_plat = utilities.code '+
      ' WHERE record_number='+
      IntToStr(TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).number_record)+
      ' AND id_file='+IntToStr(loading_params.reg_record_id));
    Open;
    if eof then begin
      ShowMessage('Проблемы с кодом организации или с кодом платежа');
      exit;
    end;
    LCodeERC.Caption :=
      'Код ЕРЦ: ' + FieldByName('code_erc').AsString;
    LFirm.Caption := 'Организация: '+
      FieldByName('code_firme_corr').AsString+'; '+
      FieldByName('firm_name').AsString;
    LService.Caption := 'Название платежа: '+
      FieldByName('utility_name').AsString;
    LFullName.Caption := 'ФИО: '+ FieldByName('full_name').AsString;
    LBankbook.Caption := 'Лицевой счет: '+ FieldByName('abcount').AsString;
    bankbook_for_update := FieldByName('abcount').AsString;
    LBErcCodeOwners.Items.Clear;
    LBAccounts.Items.Clear;
    owner_code_list.Clear;
    if FieldByName('id_room_location').AsInteger>0 then begin
      LAddress.Caption := FieldByName('address').AsString;
      BCreateCode.Enabled := (FieldByName('code_erc').AsInteger = 0);

      get_erc_code_owner_params_by_id_room(owner_code_list, qq,
        q.FieldByName('id_room_location').AsInteger);

      LPayers.Caption := 'Плательщики (найденные по месту жительства)';
      if owner_code_list.Count>0 then begin
        BSubstituteCode.Enabled := (FieldByName('code_erc').AsInteger = 0);
        LBErcCodeOwners.Items := owner_code_list;
        LBErcCodeOwners.ItemIndex :=
          get_index_by_full_name(owner_code_list,
            FieldByName('full_name').AsString);
        LBErcCodeOwnersClick(Sender);
      end;
    end else begin
//      case TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).error_code of
//        5: begin //Код улицы отсутствует в справочнике ЕРЦ
//          get_bankbooks_by_codefirm_codeutility_bankbook(owner_code_list, qq,
//            FieldByName('code_firme').AsString, FieldByName('code_plat').AsString,
//            FieldByName('abcount').AsString);
//          if owner_code_list.Count>0 then begin
//            LBErcCodeOwners.Items := owner_code_list;
//            LBErcCodeOwners.ItemIndex := 0;
//            LBErcCodeOwnersClick(Sender);
//          end else begin
//            get_payers_by_city_full_name(owner_code_list, qq,
//              FieldByName('code_c_corr').AsString, FieldByName('full_name').AsString);
//
//            if owner_code_list.Count>0 then begin
//              LBErcCodeOwners.Items := owner_code_list;
//              LBErcCodeOwners.ItemIndex := 0;
//              LBErcCodeOwnersClick(Sender);
//            end;
//          end;
//        end;
//        107, 108: begin //Некорректный дом
//          get_payers_by_codefirm_codeutility_bankbook(owner_code_list, qq,
//            FieldByName('code_c_corr').AsString,
//            FieldByName('code_firme_corr').AsString,
//            FieldByName('code_plat').AsString,
//            FieldByName('abcount').AsString);
//          if owner_code_list.Count>0 then begin
//            LPayers.Caption := 'Плательщики (найденные по фирме-услуге-счету)';
//            LBErcCodeOwners.Items := owner_code_list;
//            LBErcCodeOwners.ItemIndex := 0;
//            LBErcCodeOwnersClick(Sender);
//          end else begin
//            get_payers_by_city_full_name(owner_code_list, qq,
//              FieldByName('code_c_corr').AsString, FieldByName('full_name').AsString);
//            if owner_code_list.Count>0 then begin
//              LPayers.Caption := 'Плательщики (найденные по фамилии)';
//              LBErcCodeOwners.Items := owner_code_list;
//              LBErcCodeOwners.ItemIndex := 0;
//              LBErcCodeOwnersClick(Sender);
//            end;
//          end;
//        end;
//      end;

      get_payers_by_codefirm_codeutility_bankbook(owner_code_list, qq,
        FieldByName('code_c_corr').AsString,
        FieldByName('code_firme_corr').AsString,
        FieldByName('code_plat').AsString,
        FieldByName('abcount').AsString);
      if owner_code_list.Count>0 then begin
        LPayers.Caption := 'Плательщики (найденные по фирме-услуге-счету)';
        LBErcCodeOwners.Items := owner_code_list;
        LBErcCodeOwners.ItemIndex := 0;
        LBErcCodeOwnersClick(Sender);
      end else begin
        get_payers_by_city_full_name(owner_code_list, qq,
          FieldByName('code_c_corr').AsString, FieldByName('full_name').AsString);
        if owner_code_list.Count>0 then begin
          LPayers.Caption := 'Плательщики (найденные по фамилии)';
          LBErcCodeOwners.Items := owner_code_list;
          LBErcCodeOwners.ItemIndex := 0;
          LBErcCodeOwnersClick(Sender);
        end;
      end;

      LAddress.Caption :=
        get_city_by_id(qq, FieldByName('code_c_corr').AsString)+', '+
        get_street_by_id(qq, FieldByName('code_c_corr').AsInteger,
          FieldByName('code_s_corr').AsInteger);
      LAddress.Caption := LAddress.Caption+', дом '+FieldByName('n_house').AsString;
      if FieldByName('f_house').AsInteger <> 0 then
        LAddress.Caption := LAddress.Caption+'-'+FieldByName('f_house').AsString;
      if trim(FieldByName('a_house').AsString)>'' then
        LAddress.Caption := LAddress.Caption+'"'+trim(FieldByName('a_house').AsString)+'"';
      if FieldByName('d_house').AsInteger <> 0 then
        LAddress.Caption := LAddress.Caption+'/'+FieldByName('d_house').AsString;
      if (FieldByName('n_room').AsInteger <> 0) or (trim(FieldByName('a_room').AsString)<>'') then begin
        LAddress.Caption := LAddress.Caption+', кв. '+ FieldByName('n_room').AsString;
        if trim(FieldByName('a_room').AsString)>'' then
          LAddress.Caption := LAddress.Caption+'"'+trim(FieldByName('a_room').AsString)+'"';
      end;
      BCreateCode.Enabled := false;
    end;
    BSubstituteCode.Enabled := (FieldByName('code_erc').AsInteger = 0)
      and (owner_code_list.count>0);

    case TErrorInfo(LBErrors.Items.Objects[LBErrors.ItemIndex]).error_code of
//      5: begin  // Код улицы отсутствует в справочнике ЕРЦ
//        BAction.Caption := '????????';
//        LDescription.Caption := 'Для фамилии '+FieldByName('full_name').AsString+
//          ' найден(ы) адрес(а) и счет(а) для адреса:';
//        for I := 0 to owner_code_list.Count - 1 do begin
//          get_address_by_id_room_location(address_params, qq,
//            TERCCodeOwnerParams(owner_code_list.Objects[i]).id_room);
//          home := '';
//          room := '';
//          if address_params.f_house <> 0 then
//            home := '-'+IntToStr(address_params.f_house);
//          if trim(address_params.a_house)>'' then
//            home := home+'"'+trim(address_params.a_house)+'"';
//          if address_params.d_house <> 0 then
//            home := home+'/'+Inttostr(address_params.d_house);
//          if (address_params.n_room <> 0) or (trim(address_params.a_room)> '') then begin
//            room := ', кв. '+ IntToStr(address_params.n_room);
//            if trim(address_params.a_room)> '' then
//              room := room+'"'+ trim(address_params.a_room)+'"';
//          end;
//          MAction.Lines.Add(IntToStr(i+1)+'. '+
//            IntToStr(TERCCodeOwnerParams(owner_code_list.Objects[i]).erc_code)+'-'+
//            TERCCodeOwnerParams(owner_code_list.Objects[i]).fullName+'; '+
//          address_params.city_type+' '+ address_params.city_name+
//          ', '+address_params.street_type+' '+
//            address_params.street_name+', '+
//          'дом '+InttoStr(address_params.n_house)+home+room);
//        end;
//      end;
      101: begin  // Лицевой счет не найден в базе
        BAction.Caption := 'Создать счет';
        get_all_bankbook_by_id_room(bb_list, qq,
          FieldByName('id_room_location').AsInteger);
        LDescription.Caption := 'По адресу '+LAddress.Caption+
          ' найден(ы) счет(а):';
        for I := 0 to bb_list.Count - 1 do begin
          MAction.Lines.Add(IntToStr(i+1)+'. '+
            IntToStr(TBankbookParams(bb_list.Objects[i]).code_firm)+'-'+
            IntToStr(TBankbookParams(bb_list.Objects[i]).code_utility)+'-'+
            TBankbookParams(bb_list.Objects[i]).bank_book);
//            IntToStr(TERCCodeOwnerParams(owner_code_list.Objects[LBErcCodeOwners.ItemIndex]).erc_code)+'-'+
//            TERCCodeOwnerParams(owner_code_list.Objects[LBErcCodeOwners.ItemIndex]).fullName+'; ');
//            IntToStr(TBankbookParams(bb_list.Objects[i]).code_erc)+'-'+
//            TBankbookParams(bb_list.Objects[i]).full_name);
        end;
      end;
      103: begin  //Для счета найден другой адрес
        BAction.Caption := '????????';
        LDescription.Caption := 'Для лицевого счета '+FieldByName('abcount').AsString+
          ' найден(ы) адрес(а) и счет(а) для адреса:';
        get_erc_code_owner_params_by_firm_and_bankbook(owner_code_list, qq,
          FieldByName('code_firme_corr').AsInteger,
          FieldByName('abcount').AsString);
        for I := 0 to owner_code_list.Count - 1 do begin
          get_address_by_id_room_location(address_params, qq,
            TERCCodeOwnerParams(owner_code_list.Objects[i]).id_room);
          home := '';
          room := '';
          if address_params.f_house <> 0 then
            home := '-'+IntToStr(address_params.f_house);
          if trim(address_params.a_house)>'' then
            home := home+'"'+trim(address_params.a_house)+'"';
          if address_params.d_house <> 0 then
            home := home+'/'+Inttostr(address_params.d_house);
          if (address_params.n_room <> 0) or (trim(address_params.a_room)> '') then begin
            room := ', кв. '+ IntToStr(address_params.n_room);
            if trim(address_params.a_room)> '' then
              room := room+'"'+ trim(address_params.a_room)+'"';
          end;
          MAction.Lines.Add(IntToStr(i+1)+'. '+
            IntToStr(TERCCodeOwnerParams(owner_code_list.Objects[i]).erc_code)+'-'+
            TERCCodeOwnerParams(owner_code_list.Objects[i]).fullName+'; '+
          address_params.city_type+' '+ address_params.city_name+
          ', '+address_params.street_type+' '+
            address_params.street_name+', '+
          'дом '+InttoStr(address_params.n_house)+home+room);
        end;
        if owner_code_list.Count>0 then begin
          LBErcCodeOwners.Items := owner_code_list;
          LBErcCodeOwners.ItemIndex := 0;
          LBErcCodeOwnersClick(Sender);
        end;
        get_all_bankbook_by_id_room(bb_list, qq,
          FieldByName('id_room_location').AsInteger);
        for I := 0 to bb_list.Count - 1 do begin
          MAction.Lines.Add(IntToStr(i+1)+'. '+
            IntToStr(TBankbookParams(bb_list.Objects[i]).code_firm)+'-'+
            IntToStr(TBankbookParams(bb_list.Objects[i]).code_utility)+'-'+
            TBankbookParams(bb_list.Objects[i]).bank_book+'-'); //+
//            IntToStr(TBankbookParams(bb_list.Objects[i]).code_erc)+'-'+
//            TBankbookParams(bb_list.Objects[i]).full_name);
        end;
      end;
      102, 107, 108: begin // Некорректный дом
        BAction.Caption := 'Подставить адрес';
        LDescription.Caption := 'Адреса плательщиков';
        for I := 0 to LBErcCodeOwners.Items.Count - 1 do begin
          get_address_by_id_room_location(address_params, qq,
            TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[i]).id_room);
          home := '';
          room := '';
          if address_params.f_house <> 0 then
            home := '-'+IntToStr(address_params.f_house);
          if trim(address_params.a_house)> '' then
            home := home+'"'+trim(address_params.a_house)+'"';
          if address_params.d_house <> 0 then
            home := home+'/'+Inttostr(address_params.d_house);
          if (address_params.n_room <> 0) or (trim(address_params.a_room)> '') then begin
            room := ', кв. '+ IntToStr(address_params.n_room);
            if trim(address_params.a_room)> '' then
              room := room+'"'+ trim(address_params.a_room)+'"';
          end;
          MAction.Lines.Add(IntToStr(i+1)+'. '+
            IntToStr(TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[i]).erc_code)+'-'+
            TERCCodeOwnerParams(LBErcCodeOwners.Items.Objects[i]).fullName+'; '+
            address_params.city_type+' '+ address_params.city_name+
            ', '+address_params.street_type+' '+
            address_params.street_name+', '+
            'дом '+InttoStr(address_params.n_house)+home+room);
        end;
      end;
    end;
//    close;
  end;
end;

{
function TFormErrorAnalyzer.GetErrorCount: integer;
begin
  with qq do begin
    SQL.Clear;
    SQL.Add('SELECT count(*) num FROM utilityfiles_bo WHERE code_erc=0'+
    ' AND id_file='+IntToStr(loading_params.reg_record_id));
    Open;
    Result := Fields[0].AsInteger; //FieldByName('num').AsInteger;
    Close;
  end;
end;
}
procedure TFormErrorAnalyzer.UpdateErrorCount;
begin
//  LNowErrors.Caption := '/'+IntToStr(GetErrorCount);
  NowErrors := NowErrors-1;
  LNowErrors.Caption := '/'+IntToStr(NowErrors);
end;
end.
