program mjoy;

uses
  Vcl.Forms,
  guiunit in 'guiunit.pas' {mjform},
  errunit in 'errunit.pas' {errForm},
  initunit in 'initunit.pas' {initForm},
  servunit in 'servunit.pas',
  vmunit in 'vmunit.pas',
  primunit in 'primunit.pas';

{$R *.res}

begin
  Application.Initialize;
  //Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmjform, mjform);
  Application.CreateForm(TerrForm, errForm);
  Application.CreateForm(TinitForm, initForm);
  Application.Run;
end.


// (CC BY 3.0) Fpstefan
