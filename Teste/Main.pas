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
  private
    FSQL : TSQLQuery;
    FModel : TModelClientes;

    procedure Select;
    procedure Insert;
    procedure Delete;
    procedure Update;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.Delete;
begin
  Self.FSQL.DeleteFrom('clientes').Where('nome').Like( Self.FModel.nome ).&And('ativo').Equal( Self.FModel.ativo );
  Self.FSQL.&And('data').Equal( Self.FModel.data );
  Self.FSQL.Execute( zCmd );
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Self.FSQL := TSQLQuery.Create;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil( Self.FSQL );
end;

procedure TfrmMain.Insert;
begin
  // se é um modelo você poderia informar assim
  // Self.FSQL.Insert('clientes').Fields( Self.FModel.ToString )
  // mais esta conversão estaria no sei model através de processos RTTI.

  Self.FSQL.Insert('clientes').Fields('nome, limite, ativo, data').Values;
  Self.FSQL.Field( Self.FModel.nome ).Next;
  Self.FSQL.Field( Self.FModel.limite ).Next;
  Self.FSQL.Field( Self.FModel.ativo ).Next;
  Self.FSQL.Field( Self.FModel.data ).EndValues;
  Self.FSQL.Execute( zCmd );
end;

procedure TfrmMain.Select;
begin
  // Select 1
  Self.FSQL.Select('nome, limite, ativo').From('clientes').Order_By('id');
  Self.FSQL.Open( zCmd );
  // Select 2
  Self.FSQL.SelectFrom('clientes').Where('ativo').Equal( Self.FModel.ativo ).&And('limite').MajorEqual( Self.FModel.limite ).Order_By('id');
  Self.FSQL.Open( zCmd );
end;

procedure TfrmMain.Update;
begin
  // a função UpField pedo o nome do campo e seu valor
  Self.FSQL.Update('clientes').UpField('limite', Self.FModel.limite ).Next;
  Self.FSQL.UpField('data', Self.FModel.data ).Where('ativo').Equal( Self.FModel.ativo );
  Self.FSQL.Execute( zCmd );
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
