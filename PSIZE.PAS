unit PSize;
                             
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TPSizeForm = class(TForm)
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    Pcenter: TCheckBox;
    FullPage: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PSizeForm: TPSizeForm;

implementation

{$R *.DFM}

end.
