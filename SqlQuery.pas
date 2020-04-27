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
  System.Generics.Defaults, System.Generics.Collections,
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,
  {ADO}
  Data.Win.ADODB,
  {UniDac}
  MemDS, DBAccess, Uni;

type
  TBlobFieldsinSQL = class
  private
    FFieldBlob: TMemoryStream;
    FFieldName: String;

    procedure SetFieldBlob(const Value: TMemoryStream);
    procedure SetFieldName(const Value: String);
  public
    property FieldName : String read FFieldName write SetFieldName;
    property FieldBlob : TMemoryStream read FFieldBlob write SetFieldBlob;

    constructor Create;
    destructor Destroy; override;
  end;

  /// <summary>
  ///   SQLBuilder é uma classe de manipulação SQL vinculada a PowerSQLBuilder
  /// </summary>
  /// <comments>
  ///   Chega de ficar concatenando pedaços do texto gerando um scripts SQL manual
  ///   com erros no script, através do PowerSQLBuilder você apenas chama os
  ///   comandos SQL que ele mesmo interpreta e gera o scripts SQL automaticamente
  ///   <para><c>Mais o que torna ele ágil é a possibilidade de passar parâmetros sem se preocupar
  ///   com seu tipo de origem o PowerSQLBulder faz isso automaticamente para você.
  ///   interpleta e gera o scripts SQL automaticamente</c></para>
  /// </comments>
  /// <remarks>
  ///   Para saber mais entre no site https://github.com/juliospd/PowerSQLBuilder
  /// </remarks>
  TSQLQuery = class( TPowerSQLBuilder )
  private
    FDataSet : TDataSet;
    FFieldBlob: TList<TBlobFieldsinSQL>;
    FFailCount : Integer;
    FLogSQL: Boolean;
    FPathLog: String;

    procedure ExecuteZeusC(var Connection : TZConnection );
    procedure ExecuteZeus(var Query : TZQuery );

    procedure ExecuteFireC(var Connection : TFDConnection );
    procedure ExecuteFire(var Query : TFDQuery );

    procedure ExecuteUniDacC(var Connection : TUniConnection );
    procedure ExecuteUniDac(var Query : TUniQuery );

    procedure ExecuteADOC(var Connection : TADOConnection );
    procedure ExecuteADO(var Query : TADOQuery );

    procedure OpenZeus(var query : TZQuery );
    procedure OpenFire(var query : TFDQuery );
    procedure OpenUniDac(var query : TUniQuery );
    procedure OpenADO(var query : TADOQuery );

    procedure FieldBlobClear;
    procedure WriteLog( Log : String );

    procedure SetDataSet(const Value: TDataSet);
    procedure SetLogSQL(const Value: Boolean);
    procedure SetPathLog(const Value: String);
  public
    property DataSet : TDataSet read FDataSet write SetDataSet;
    property LogSQL : Boolean read FLogSQL write SetLogSQL;
    property PathLog : String read FPathLog write SetPathLog;

    function FieldBlob( FieldName : String; FieldBlob : TMemoryStream ) : TSQLQuery; virtual;
    function UpFieldBlob( FieldName : String; FieldBlob : TMemoryStream ) : TSQLQuery; virtual;

    function Execute(var Query : TZQuery ) : TSqlQuery; overload;
    function Execute(var Query : TFDQuery ) : TSqlQuery; overload;
    function Execute(var Query : TUniQuery ) : TSqlQuery; overload;
    function Execute(var Query : TADOQuery ) : TSqlQuery; overload;

    function Execute(var Connection : TZConnection ) : TSqlQuery; overload;
    function Execute(var Connection : TFDConnection ) : TSqlQuery; overload;
    function Execute(var Connection : TUniConnection ) : TSqlQuery; overload;
    function Execute(var Connection : TADOConnection ) : TSqlQuery; overload;

    function Open(var query : TZQuery ) : TSqlQuery; overload;
    function Open(var query : TFDQuery ) : TSqlQuery; overload;
    function Open(var query : TUniQuery ) : TSqlQuery; overload;
    function Open(var query : TADOQuery ) : TSqlQuery; overload;

    // Atalhos do DataSet
    function RecordCount : Integer;
    function RecNo : Integer;
    function Eof : Boolean;
    function Bof : Boolean;
    function Active : Boolean;

    function SetField( Field : String; Value : String ) : TSQLQuery; overload; virtual;
    function SetField( Field : String; Value : Double ) : TSQLQuery; overload; virtual;
    function SetField( Field : String; Value : TDateTime ) : TSQLQuery; overload; virtual;
    function SetField( Field : String; Value : Int64 ) : TSQLQuery; overload; virtual;
    function SetField( Field : String; Value : Integer ) : TSQLQuery; overload; virtual;
    function SetField( Field : String; Value : Boolean ) : TSQLQuery; overload; virtual;
    //
    function First : TSQLQuery; virtual;
    function Prior : TSQLQuery; virtual;
    function NextRecord : TSQLQuery; virtual;
    function Last: TSQLQuery; virtual;
    //
    function Append : TSQLQuery; virtual;
    function Edit : TSQLQuery; virtual;
    function Post : TSQLQuery; virtual;
    function Close : TSQLQuery; virtual;
    //
    function getInteger( NameField : String ) : Integer; virtual;
    function getLongInt( NameField : String ) : Int64; virtual;
    function getWideString( NameField : String ) : String; virtual;
    function getAnsiString( NameField : String ) : AnsiString; virtual;
    function getFloat( NameField : String ) : Double; virtual;
    function getCurrency( NameField : String ) : Double; virtual;
    function getBoolean( NameField : String ) : Boolean; virtual;
    function getDateTime( NameField : String ) : TDateTime; virtual;
    function getBlob( NameField : String ) : TMemoryStream; virtual;
    //
    function isEmpty( NameField : String ) : Boolean; virtual;

    function IntToString( NameField : String ) : String;
    function IntToStringZero( NameField : String; Size : Integer ) : String;
    function LongToString( NameField : String ) : String;
    function LongToStringZero( NameField : String; Size : Integer ) : String;
    function DateToString( NameField : String; Format : String = 'yyyy.mm.dd hh:nn:ss' ) : String;
    function FloatToString( NameField : String; Format : String = '#0.00' ) : String;
    function StringToInt( NameField : String ) : Integer;
    function StringToLog( NameField : String ) : Int64;
    function CurrencyToString( NameField : String; Format : String = '#0.00' ) : String;
    function QueryToString : String;

    constructor Create; override;
    destructor Destroy; override;
  end;

function Ping(const AHost : string) : Boolean;

implementation

{ TSqlQuery }

function TSqlQuery.Execute(var Query: TZQuery): TSqlQuery;
begin
  ExecuteZeus( Query );
  Result := Self;
end;

function TSqlQuery.Open(var query: TZQuery): TSqlQuery;
begin
  OpenZeus( query );
  Result := Self;
end;

function TSQLQuery.Active: Boolean;
begin
  Result := False;

  if Assigned( Self.FDataSet ) then
    Result := Self.FDataSet.Active;
end;

function TSQLQuery.Append : TSQLQuery;
begin
  if Active then
    Self.FDataSet.Append;

  Result := Self;
end;

function TSQLQuery.BOF: Boolean;
begin
  Result := False;

  if Active then
    Result := Self.FDataSet.Bof;
end;

function TSQLQuery.RecordCount: Integer;
begin
  Result := 0;

  if Active then
    Result := Self.FDataSet.RecordCount;
end;

function TSQLQuery.Close: TSQLQuery;
begin
  if Self.FDataSet.Active then
    Self.FDataSet.Close;

  Result := Self;
end;

constructor TSQLQuery.Create;
begin
  inherited Create;
  Self.FFieldBlob := TList<TBlobFieldsinSQL>.Create;

  SetZeus( ExecuteZeusC, ExecuteZeus, OpenZeus );
  SetFireDac( ExecuteFireC, ExecuteFire, OpenFire );
  SetUniDac( ExecuteUniDacC, ExecuteUniDac, OpenUniDac );
  SetADO( ExecuteADOC, ExecuteADO, OpenADO );
end;

function TSQLQuery.CurrencyToString(NameField, Format: String): String;
begin
  if Length(Trim(Format)) = 0  then
    Format := '#0.00';

  Result := FormatFloat( Format, getCurrency( NameField ) );
end;

function TSQLQuery.DateToString(NameField, Format: String): String;
begin
  if Length(Trim(Format)) = 0  then
    Format := 'yyyy.mm.dd hh:nn:ss';

  if Self.FDataSet.FieldByName(NameField).IsNull then
    Result := 'Null'
  else
    Result := FormatDateTime( Format, Self.FDataSet.FieldByName(NameField).AsDateTime );
end;

destructor TSQLQuery.Destroy;
begin
  FieldBlobClear;
  FreeAndNil( Self.FFieldBlob );
  inherited;
end;

procedure TSQLQuery.FieldBlobClear;
var
  I: Integer;
  Obj : TBlobFieldsinSQL;
begin
  for I := Self.FFieldBlob.Count -1  downto 0 do
  begin
    Obj := Self.FFieldBlob[I];
    FreeAndNil(Obj);
    Self.FFieldBlob.Delete(I);
  end;
end;

function TSQLQuery.First : TSQLQuery;
begin
  if Active then
    Self.FDataSet.First;

  Result := Self;
end;

function TSQLQuery.FloatToString(NameField, Format: String): String;
begin
  if Length(Trim(Format)) = 0  then
    Format := '#0.00';

  Result := FormatFloat( Format, getCurrency( NameField ) );
end;

function TSQLQuery.Edit : TSQLQuery;
begin
  if Active then
    Self.FDataSet.Edit;

  Result := Self;
end;

function TSQLQuery.EOF: Boolean;
begin
  Result := False;

  if Active then
    Result := Self.FDataSet.Eof;
end;

function TSqlQuery.Execute(var Query: TFDQuery): TSqlQuery;
begin
  ExecuteFire( Query );
  Result := Self;
end;

function TSQLQuery.Execute(var Connection: TZConnection): TSqlQuery;
begin
  ExecuteZeusC( Connection );
  Result := Self;
end;

function TSQLQuery.Execute(var Connection: TFDConnection): TSqlQuery;
begin
  ExecuteFireC( Connection );
  Result := Self;
end;

procedure TSQLQuery.ExecuteFire(var Query: TFDQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.ExecuteFireC(var Connection: TFDConnection);
var
  Executed : Boolean;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Connection.ExecSQL( GetString );

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Clear;
  end;
end;

procedure TSQLQuery.ExecuteUniDac(var Query: TUniQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.ExecuteUniDacC(var Connection: TUniConnection);
var
  Executed : Boolean;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Connection.ExecSQL( GetString );

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Clear;
  end;
end;

procedure TSQLQuery.ExecuteZeus(var Query: TZQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if LogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.ExecuteZeusC(var Connection: TZConnection);
var
  Executed : Boolean;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if LogSQL then
          WriteLog( GetString );

        Connection.ExecuteDirect( GetString );

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Disconnect;
                Connection.Connect;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Connection.Disconnect;
                Connection.Connect;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Disconnect;
                Connection.Connect;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Disconnect;
                Connection.Connect;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Disconnect;
                Connection.Connect;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Clear;
  end;
end;

function TSqlQuery.Open(var query: TFDQuery): TSqlQuery;
begin
  OpenFire( query );
  Result := Self;
end;

procedure TSQLQuery.OpenFire(var query: TFDQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.Open;

        Self.FDataSet := Query.Fields.DataSet;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.OpenUniDac(var query: TUniQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.Open;

        Self.FDataSet := Query.Fields.DataSet;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
          begin
            WriteLog( 'SQL : [' + GetString + ']' );
            WriteLog( e.Message );
          end;

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.OpenZeus(var query: TZQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Params.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.Open;

        Self.FDataSet := (Query as TDataSet);

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Disconnect;
                Query.Connection.Connect;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

function TSQLQuery.Post : TSQLQuery;
begin
  if Active then
    Self.FDataSet.Post;

  Result := Self;
end;

function TSQLQuery.Prior : TSQLQuery;
begin
  if Active then
    Self.FDataSet.Prior;

  Result := Self;
end;

function TSQLQuery.QueryToString: String;
var
  I: Integer;
begin
  Result := '';
  if Assigned( Self.FDataSet ) then
  begin
    if Self.FDataSet.RecordCount > 0 then
    begin
      Clear;

      for I := 0 to Self.FDataSet.FieldCount -1 do
      begin
        case Self.FDataSet.FieldList[I].DataType of
          ftString, ftWideString : Add( Self.FDataSet.FieldList[I].FieldName ).Equal( Self.FDataSet.FieldByName( Self.FDataSet.FieldList[I].FieldName ).AsString ).Next;
          ftShortint, ftSmallint, ftInteger, ftWord : Add( Self.FDataSet.FieldList[I].FieldName ).Equal( Self.FDataSet.FieldByName( Self.FDataSet.FieldList[I].FieldName ).AsInteger ).Next;
          ftBoolean : Add( Self.FDataSet.FieldList[I].FieldName ).Equal( Self.FDataSet.FieldByName( Self.FDataSet.FieldList[I].FieldName ).AsBoolean ).Next;
          ftFloat, ftCurrency : Add( Self.FDataSet.FieldList[I].FieldName ).Equal( Self.FDataSet.FieldByName( Self.FDataSet.FieldList[I].FieldName ).AsFloat ).Next;
          ftDate, ftTime, ftDateTime : Add( Self.FDataSet.FieldList[I].FieldName ).Equal( Self.FDataSet.FieldByName( Self.FDataSet.FieldList[I].FieldName ).AsDateTime ).Next;
        end;
      end;
      Result := GetString;
      Clear;
    end;
  end;
end;

function TSQLQuery.RecNo: Integer;
begin
  Result := 0;

  if Active then
    Result := Self.FDataSet.RecNo;
end;

function TSQLQuery.SetField(Field: String; Value: Double): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsFloat := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field, Value: String): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsString := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: String; Value: Integer): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsInteger := Value;

  Result := Self;
end;

procedure TSQLQuery.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

function TSQLQuery.SetField(Field: String; Value: Boolean): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsBoolean := Value;

  Result := Self;
end;

procedure TSQLQuery.SetLogSQL(const Value: Boolean);
begin
  FLogSQL := Value;
end;

procedure TSQLQuery.SetPathLog(const Value: String);
begin
  FPathLog := Value;
end;

function TSQLQuery.SetField(Field: String; Value: Int64): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsLargeInt := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: String; Value: TDateTime): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsDateTime := Value;

  Result := Self;
end;

function TSQLQuery.StringToInt(NameField: String): Integer;
begin
  Result := StrToIntDef(Self.FDataSet.FieldByName(NameField).AsString,0);
end;

function TSQLQuery.StringToLog(NameField: String): Int64;
begin
  Result := StrToInt64Def(FDataSet.FieldByName(NameField).AsString, 0);
end;

function TSQLQuery.UpFieldBlob(FieldName: String; FieldBlob: TMemoryStream): TSQLQuery;
var
  I : Integer;
begin
  if Assigned( FieldBlob ) then
  begin
    I := Self.FFieldBlob.Add( TBlobFieldsinSQL.Create );
    Self.FFieldBlob[I].FFieldName := FieldName;
    Self.FFieldBlob[I].FFieldBlob.LoadFromStream( FieldBlob );

    Self.Add( ' ' + FieldName + ' = :' + Trim(FieldName) );
  end;

  Result := Self;
end;

procedure TSQLQuery.WriteLog(Log: String);
var
  FileLog: TextFile;
begin
  try
    if PathLog = '' then
      Exit;

    System.AssignFile( FileLog, PathLog + 'LogSQL.txt' );

    if FileExists( PathLog + 'LogSQL.txt' ) then
      System.Append( FileLog )
    else
      System.Rewrite( FileLog );

    System.Writeln( FileLog , FormatDateTime('yyyy-mm-dd hh:mm:ss - ', Now ) + Log );

    System.CloseFile(FileLog);
  except end;
end;

function TSQLQuery.getInteger(NameField: String): Integer;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsInteger;
end;

function TSQLQuery.getWideString(NameField: String): String;
begin
  Result := Trim(Self.FDataSet.FieldByName(NameField).AsString);
end;

function TSQLQuery.FieldBlob(FieldName: String; FieldBlob: TMemoryStream): TSQLQuery;
var
  I : Integer;
begin
  if Assigned( FieldBlob ) then
  begin
    I := Self.FFieldBlob.Add( TBlobFieldsinSQL.Create );
    Self.FFieldBlob[I].FFieldName := FieldName;
    Self.FFieldBlob[I].FFieldBlob.LoadFromStream( FieldBlob );

    Self.Add(' :' + Trim(FieldName) );
  end
  else Self.Add('null ');

  Result := Self;
end;

function TSQLQuery.IntToString(NameField: String): String;
begin
  Result := IntToStr( getInteger( NameField ) );
end;

function TSQLQuery.IntToStringZero(NameField: String; Size: Integer): String;
begin
  if Size > 0 then
    Result := Format( '%.' + IntToStr(Size) + 'd', [getInteger(NameField)])
  else
    Result := IntToStr( getInteger(NameField) );
end;

function TSQLQuery.isEmpty(NameField: String): Boolean;
begin
  Result := Self.FDataSet.FieldByName(NameField).IsNull;
end;

function TSQLQuery.Last : TSQLQuery;
begin
  if Assigned( Self.FDataSet ) then
    Self.FDataSet.Last;

  Result := Self;
end;

function TSQLQuery.LongToString(NameField: String): String;
begin
  Result := IntToStr( getInteger( NameField ) );
end;

function TSQLQuery.LongToStringZero(NameField: String; Size: Integer): String;
begin
  if Size > 0 then
    Result := Format( '%.' + IntToStr(Size) + 'd', [getLongInt(NameField)])
  else
    Result := IntToStr( getLongInt(NameField) );
end;

function TSQLQuery.NextRecord : TSQLQuery;
begin
  if Assigned( Self.FDataSet ) then
    Self.FDataSet.Next;

  Result := Self;
end;

function TSQLQuery.getFloat(NameField: String): Double;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsFloat;
end;

function TSQLQuery.getLongInt(NameField: String): Int64;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsLargeInt;
end;

function TSQLQuery.getBlob(NameField: String): TMemoryStream;
var
  FieldStream : TStream;
begin
  try
    FieldStream := Self.FDataSet.CreateBlobStream( Self.FDataSet.FieldByName( NameField ), bmRead );
    Result := TMemoryStream.Create;
    Result.LoadFromStream( FieldStream );
  finally
    FreeAndNil( FieldStream );
  end;
end;

function TSQLQuery.getBoolean(NameField: String): Boolean;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsBoolean;
end;

function TSQLQuery.getDateTime(NameField: String): TDateTime;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsDateTime;
end;

function TSQLQuery.getAnsiString(NameField: String): AnsiString;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsAnsiString;
end;

function TSQLQuery.getCurrency(NameField: String): Double;
begin
  Result := Self.FDataSet.FieldByName(NameField).asFloat;
end;

function Ping(const AHost : string) : Boolean;
var
  MyIdIcmpClient : TIdIcmpClient;
begin
  try
    if (aHost = '127.0.0.1') or (UpperCase(aHost) = 'LOCALHOST') then
    begin
      Result := True;
      Exit;
    end;


    MyIdIcmpClient := TIdIcmpClient.Create(nil);
    MyIdIcmpClient.ReceiveTimeout := 200;
    MyIdIcmpClient.Host := AHost;

    try
      MyIdIcmpClient.Ping;
    except
      Result := False;
      Exit;
    end;

    result := (MyIdIcmpClient.ReplyStatus.BytesReceived > 0);
  finally
    FreeAndNil( MyIdIcmpClient );
  end;
end;

function TSQLQuery.Execute(var Query: TUniQuery): TSqlQuery;
begin
  ExecuteUniDac( Query );
  Result := Self;
end;

function TSQLQuery.Execute(var Connection: TUniConnection): TSqlQuery;
begin
  ExecuteUniDacC( Connection );
  Result := Self;
end;

procedure TSQLQuery.ExecuteADO(var Query: TADOQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Parameters.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.ExecSQL;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;
end;

procedure TSQLQuery.ExecuteADOC(var Connection: TADOConnection);
var
  Executed : Boolean;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Connection.Execute( GetString );

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Connection.Connected := False;
                Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Clear;
  end;
end;

function TSQLQuery.Open(var query: TUniQuery): TSqlQuery;
begin
  OpenUniDac( query );
  Result := Self;
end;

function TSQLQuery.Execute(var Connection: TADOConnection): TSqlQuery;
begin
  ExecuteADOC( Connection );
  Result := Self;
end;

function TSQLQuery.Execute(var Query: TADOQuery): TSqlQuery;
begin
  ExecuteADO( Query );
  Result := Self;
end;

function TSQLQuery.Open(var query: TADOQuery): TSqlQuery;
begin
  OpenADO( query );
  Result := Self;
end;

procedure TSQLQuery.OpenADO(var query: TADOQuery);
var
  Executed : Boolean;
  I: Integer;
begin
  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        if Self.FLogSQL then
          WriteLog( GetString );

        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );

        for I := 0 to Self.FFieldBlob.Count -1 do
          Query.Parameters.ParamByName( Self.FFieldBlob[I].FieldName ).LoadFromStream( Self.FFieldBlob[I].FFieldBlob, ftBlob );

        Query.Open;

        Self.FDataSet := Query.Fields.DataSet;

        Executed := True;
      except
        on e: Exception do
        begin
          if Self.FLogSQL then
            WriteLog( e.Message );

          case SGDBType of
            dbPostGreSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMySQL:
            begin
              if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbMsSQL:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbFireBird:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
            dbNenhum:
            begin
              if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
              begin
                Query.Connection.Connected := False;
                Query.Connection.Connected := True;
              end
              else raise;
            end;
          end;

          Inc(Self.FFailCount);

          Executed := (Self.FFailCount > 3);

          if Executed then
            raise;
        end;
      end;
    until (Executed);
  finally
    Query.EnableControls;
    Clear;
    FieldBlobClear;
  end;

end;

{ TBlobFieldsinSQL }

constructor TBlobFieldsinSQL.Create;
begin
  Self.FFieldName := '';
  Self.FFieldBlob := TMemoryStream.Create;
end;

destructor TBlobFieldsinSQL.Destroy;
begin
  FreeAndnil( Self.FFieldBlob );
  inherited;
end;

procedure TBlobFieldsinSQL.SetFieldBlob(const Value: TMemoryStream);
begin
  FFieldBlob := Value;
end;

procedure TBlobFieldsinSQL.SetFieldName(const Value: String);
begin
  FFieldName := Value;
end;

end.
