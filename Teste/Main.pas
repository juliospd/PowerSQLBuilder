{
   Nome do Projeto     : Teste
   Local do Projeto    : D:\Projects\PowerSQLBuilder-master\PowerSQLBuilder-master\Teste\
   -----------------------------------------------------------------------------
   Nome da Unidade     : Main.pas
   Criação da Unidade  : 15/02/2018 08:51:24
   Local da Unidade    : 'D:\Projects\PowerSQLBuilder-master\PowerSQLBuilder-master\Teste'
   -----------------------------------------------------------------------------
   Objetivo do Projeto : Objetivo deste codigo é apenas de ilustração para lhe
                         demonstrar a sintaxe dos comandos.

   -----------------------------------------------------------------------------
   Desenvolvedor       : Julio
   IDE Utilizada       : RAD Studio 101_BERLIN
}
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SQLQuery, Data.DB,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZAbstractConnection,
  ZConnection;

type
  TModelClientes = class
  private
    Fativo: Boolean;
    Fid: Integer;
    Flimite: Double;
    Fnome: WideString;
    Fdata: TDateTime;

    procedure Setativo(const Value: Boolean);
    procedure Setdata(const Value: TDateTime);
    procedure Setid(const Value: Integer);
    procedure Setlimite(const Value: Double);
    procedure Setnome(const Value: WideString);
  public
    property id : Integer read Fid write Setid;
    property nome : WideString read Fnome write Setnome;
    property limite : Double read Flimite write Setlimite;
    property ativo : Boolean read Fativo write Setativo;
    property data : TDateTime read Fdata write Setdata;
  end;

  TfrmMain = class(TForm)
    zConexao: TZConnection;
    zCmd: TZQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSQL : TSQLQuery;
    FModel : TModelClientes;

    procedure SQLSelect;
    procedure SQLInsert;
    procedure SQLDelete;
    procedure SQLUpdate;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.SQLDelete;
begin
  if not Assigned( Self.FModel ) then
    Exit;

  Self.FSQL.DeleteFrom('clientes').Where('nome').Like( Self.FModel.nome ).&And('ativo').Equal( Self.FModel.ativo );
  Self.FSQL.&And('data').Equal( Self.FModel.data ).Execute( zCmd );
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.FSQL := TSQLQuery.Create;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  SQLSelect;
  SQLInsert;
  SQLDelete;
  SQLUpdate;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil( Self.FSQL );
end;

procedure TfrmMain.SQLInsert;
begin
  if not Assigned( Self.FModel ) then
    Exit;

  // se for um Model você poderia informar assim
  // Self.FSQL.Insert('clientes').Fields( Self.FModel.ToString )
  // mais esta conversão estaria no sei model através de processos RTTI.

  Self.FSQL.Insert('clientes').Fields('nome, limite, ativo, data').Values
    .Field( Self.FModel.nome ).Next
    .Field( Self.FModel.limite ).Next
    .Field( Self.FModel.ativo ).Next
    .Field( Self.FModel.data ).EndValues
      .Execute( zCmd );
end;

procedure TfrmMain.SQLSelect;
begin
  if not Assigned( Self.FModel ) then
    Exit;

  { -- Exemple
  Self.FSQL.Select('basic.*, par.*').From
    .sP
      .Select('A.IDCLIFOR, A.DIGITOTITULO, A.DTMOVIHENTO, A.DTVENCIHENTO, A.IDTITULO, A.VALTITULO, A.OBSTITULO, B.DTPAGAHENTO, B.VALPAGAMENTOTITULO, A.FLAGBAIXADA ')
      .From('contas_pagar a')
        .LeftJoin('CONTAS_PAGAR_BAIXAS b').&On('b.IDCLIFOR = a.IDCLIFOR and b.IDTITULO = a.IDTITULO and b.DIGITOTITULO = a.DIGITOTITULO')
          .Order_By('a.IDCLIFOR, a.IDTITULO, a.DTMOVIHENTO, a.DIGITOTITULO')
    .eP.&As('basic').LeftJoin
    .sP
      .Select('A.IDCLIFOR, Max(A.DIGITOTITULO) as ParFim, A.DTMOVIHENTO, A.IDTITULO')
        .From('contas_pagar a').Group_By('A.IDCLIFOR, A.DTMOVIMENTO, A.IDTITULO')
    .eP.&As('par').&On('par.IDCLIFOR = basic.IDCLIFOR and par.DTMOVIMENTO = basic.DTMOVIMENTO and par.IDTITULO = basic.IDTITULO')
    .Order_By('basic.IDCLIFOR, basic.IDTITULO, basic.DTMOVIMENTO, basic.DIGITOTITULO')
      .Open( zCmd );
  }

  // Select 1
  Self.FSQL.Select('nome, limite, ativo')
    .From('clientes').Order_By('id')
      .Open( zCmd );
  // Select 2
  Self.FSQL.SelectFrom('clientes')
    .Where('ativo').Equal( Self.FModel.ativo )
      .&And('limite').MajorEqual( Self.FModel.limite )
        .Order_By('id').Open( zCmd );
end;

procedure TfrmMain.SQLUpdate;
begin
  if not Assigned( Self.FModel ) then
    Exit;

  // a função UpField pedo o nome do campo e seu valor
  Self.FSQL.Update('clientes')
    .UpField('limite', Self.FModel.limite ).Next
    .UpField('data', Self.FModel.data )
      .Where('ativo').Equal( Self.FModel.ativo )
        .Execute( zCmd );
end;

{ TModelClientes }

procedure TModelClientes.Setativo(const Value: Boolean);
begin
  Fativo := Value;
end;

procedure TModelClientes.Setdata(const Value: TDateTime);
begin
  Fdata := Value;
end;

procedure TModelClientes.Setid(const Value: Integer);
begin
  Fid := Value;
end;

procedure TModelClientes.Setlimite(const Value: Double);
begin
  Flimite := Value;
end;

procedure TModelClientes.Setnome(const Value: WideString);
begin
  Fnome := Value;
end;

end.
