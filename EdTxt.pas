unit EdTxt;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, {TextData,} Grids, DBGrids;

type
  TEdText = class(TForm)
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
   // TextDataSet1: TTextDataSet;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EdText: TEdText;
implementation

{$R *.DFM}

procedure TEdText.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 //EdText.TextDataSet1.Active := false;
end;

end.
