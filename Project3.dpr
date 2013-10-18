program Project3;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  DrawUnit in 'DrawUnit.pas' {DrawForm},
  DataUnit in 'DataUnit.pas' {DataForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDrawForm, DrawForm);
  Application.CreateForm(TDataForm, DataForm);
  Application.Run;
end.
