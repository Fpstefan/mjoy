unit errunit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  terrForm = class(TForm)
    errPanel: TPanel;
    Bevel1: TBevel;
    buttonPanel: TPanel;
    okButton: TButton;
    errImage: TImage;
    errMemo: TMemo;
    procedure okButtonClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  errForm: terrForm;

implementation

{$R *.dfm}

procedure TerrForm.okButtonClick(Sender: TObject);
begin errform.hide
end;

end.
