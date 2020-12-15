unit ProgrBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Gauges;

type
  TPrBar = class(TForm)
    G1: TGauge;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrBar: TPrBar;

implementation

{$R *.DFM}

end.
