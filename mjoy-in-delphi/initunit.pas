unit initunit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TinitForm = class(TForm)
    cellEdit: TEdit;
    Label1: TLabel;
    okButton: TButton;
    cancelButton: TButton;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  initForm: TinitForm;

implementation

{$R *.dfm}

end.
