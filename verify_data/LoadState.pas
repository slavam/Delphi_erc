unit LoadState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DBGrids, DB, ADODB, DBClient, Provider;

type
  TFormLoadingState = class(TForm)
    DBGLoadindState: TDBGrid;
    DataSource: TDataSource;
    ADODataSet: TADODataSet;
    procedure DBGLoadindStateDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormLoadingState: TFormLoadingState;

implementation

{$R *.dfm}

procedure TFormLoadingState.DBGLoadindStateDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
if DBGLoadindState.DataSource.DataSet.Fields[3].Value=0 then begin
	with  DBGLoadindState.Canvas do
	begin
		Brush.Color:=clGreen;
		Font.Color:=clWhite;
		FillRect(Rect);
		TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
	end;
	end;
end;

end.
