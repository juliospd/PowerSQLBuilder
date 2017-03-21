program Teste;

uses
  Vcl.Forms,
  Main in 'Main.pas' {frmMain},
  PowerSqlBuilder in 'PowerSqlBuilder.pas',
  SqlQuery in 'SqlQuery.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
