{
  SQLQuery.
  ------------------------------------------------------------------------------
  Objetivo : Simplificar a execução de comandos SQL via codigos livre de
             componentes de terceiros.

  Suporta 2 tipos de componentes do ZeusLIB e FireDAC.
  ------------------------------------------------------------------------------
  Autor : Antonio Julio
  ------------------------------------------------------------------------------
  Esta biblioteca é software livre; você pode redistribuí-la e/ou modificá-la
  sob os termos da Licença Pública Geral Menor do GNU conforme publicada pela
  Free Software Foundation; tanto a versão 3.29 da Licença, ou (a seu critério)
  qualquer versão posterior.

  Esta biblioteca é distribuída na expectativa de que seja útil, porém, SEM
  NENHUMA GARANTIA; nem mesmo a garantia implícita de COMERCIABILIDADE OU
  ADEQUAÇÃO A UMA FINALIDADE ESPECÍFICA. Consulte a Licença Pública Geral Menor
  do GNU para mais detalhes. (Arquivo LICENÇA.TXT ou LICENSE.TXT)

  Você deve ter recebido uma cópia da Licença Pública Geral Menor do GNU junto
  com esta biblioteca; se não, escreva para a Free Software Foundation, Inc.,
  no endereço 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.
  Você também pode obter uma copia da licença em:
  http://www.opensource.org/licenses/lgpl-license.php
}
unit SQLQuery;

interface
uses
  System.SysUtils, System.Classes, Data.DB, PowerSqlBuilder,
  {ZeusLib}
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection, ZAbstractTable,
  {FireDac}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf,FireDAC.DApt, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Phys.PG, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient;

type
  TSQLQuery = class( TPowerSQLBuilder )
  private
    FDataSet : TDataSet;
    FFieldBytea: TMemoryStream;

    procedure SetFieldBytea(const Value: TMemoryStream);
    procedure SetDataSet(const Value: TDataSet);
  public
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property FieldBytea : TMemoryStream read FFieldBytea write SetFieldBytea;

    function Execute(var Query : TZQuery ) : TSqlQuery; overload;
    function Execute(var Query : TFDQuery ) : TSqlQuery; overload;
    function Open(var query : TZQuery ) : TSqlQuery; overload;
    function Open(var query : TFDQuery ) : TSqlQuery; overload;

    function GetI( NameField : WideString ) : Integer; overload;
    function GetL( NameField : WideString ) : Int64; overload;
    function GetW( NameField : WideString ) : WideString; overload;
    function GetA( NameField : WideString ) : AnsiString; overload;
    function GetF( NameField : WideString ) : Double; overload;
    function GetC( NameField : WideString ) : Currency; overload;
    function GetB( NameField : WideString ) : Boolean; overload;
    function GetD( NameField : WideString ) : TDateTime; overload;
    function GetS( NameField : WideString ) : TMemoryStream; overload;
  end;

function Ping(const AHost : string) : Boolean;

implementation

{ TSqlQuery }

function TSqlQuery.Execute(var Query: TZQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.HostName ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.HostName );

  try
    repeat
      Executed := False;
      try
        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        if Assigned( Self.FFieldBytea ) then
          Query.Params.ParamByName('file').LoadFromStream( Self.FFieldBytea, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
          begin
            Query.Connection.Disconnect;
            Query.Connection.Connect;
          end
          else
          begin
            raise;
          end;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    Result := Self;
  end;
end;

function TSqlQuery.Open(var query: TZQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.HostName ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.HostName );

  try
    repeat
      Executed := False;
      try
        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );
        Query.Open;

        Self.FDataSet := (Query as TDataSet);

        Executed := True;
      except
        on e: Exception do
        begin
          if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
          begin
            Query.Connection.Disconnect;
            Query.Connection.Connect;
          end
          else
          begin
            raise;
          end;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    Result := Self;
  end;
end;

function TSqlQuery.Execute(var Query: TFDQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.ConnectionString ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.ConnectionString );

  try
    repeat
      Executed := False;
      try
        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        if Assigned( Self.FFieldBytea ) then
          Query.Params.ParamByName('file').LoadFromStream( Self.FFieldBytea, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
          begin
            Query.Connection.Connected := False;
            Query.Connection.Connected := True;
          end
          else
          begin
            raise;
          end;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    Result := Self;
  end;
end;

function TSqlQuery.Open(var query: TFDQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.ConnectionString ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.ConnectionString );

  try
    repeat
      Executed := False;
      try
        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );
        Query.Open;

        Self.FDataSet := Query.DataSource.DataSet;

        Executed := True;
      except
        on e: Exception do
        begin
          if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
          begin
            Query.Connection.Connected := False;
            Query.Connection.Connected := True;
          end
          else
          begin
            raise;
          end;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    Result := Self;
  end;
end;

procedure TSQLQuery.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

procedure TSQLQuery.SetFieldBytea(const Value: TMemoryStream);
begin
  FFieldBytea := Value;
end;

function TSQLQuery.GetI(NameField: WideString): Integer;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsInteger;
end;

function TSQLQuery.GetW(NameField: WideString): WideString;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsWideString;
end;

function TSQLQuery.GetF(NameField: WideString): Double;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsFloat;
end;

function TSQLQuery.GetL(NameField: WideString): Int64;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsLargeInt;
end;

function TSQLQuery.GetS(NameField: WideString): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  TBlobField( Self.FDataSet.FieldByName( NameField )).SaveToStream( Result );
end;

function TSQLQuery.GetB(NameField: WideString): Boolean;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsBoolean;
end;

function TSQLQuery.GetD(NameField: WideString): TDateTime;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsDateTime;
end;

function TSQLQuery.GetA(NameField: WideString): AnsiString;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsAnsiString;
end;

function TSQLQuery.GetC(NameField: WideString): Currency;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsCurrency;
end;

function Ping(const AHost : string) : Boolean;
var
  MyIdIcmpClient : TIdIcmpClient;
begin
  try
    MyIdIcmpClient := TIdIcmpClient.Create(nil);
    MyIdIcmpClient.ReceiveTimeout := 200;
    MyIdIcmpClient.Host := AHost;

    try
      MyIdIcmpClient.Ping;
    except
      Result := False;
      MyIdIcmpClient.Free;
      Exit;
    end;

    result := not (MyIdIcmpClient.ReplyStatus.ReplyStatusType <> rsEcho)
  finally
    FreeAndNil( MyIdIcmpClient );
  end;
end;

end.
