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
  IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient;

type
  TBlobFieldsinSQL = class
  private
    FFieldBlob: TMemoryStream;
    FFieldName: WideString;

    procedure SetFieldBlob(const Value: TMemoryStream);
    procedure SetFieldName(const Value: WideString);
  public
    property FieldName : WideString read FFieldName write SetFieldName;
    property FieldBlob : TMemoryStream read FFieldBlob write SetFieldBlob;

    constructor Create;
    destructor Destroy; override;
  end;

  TSQLQuery = class( TPowerSQLBuilder )
  private
    FDataSet : TDataSet;
    FFieldBlob: TList<TBlobFieldsinSQL>;
    FFailCount : Integer;

    procedure FieldBlobClear;

    procedure SetDataSet(const Value: TDataSet);
  public
    property DataSet : TDataSet read FDataSet write SetDataSet;

    function FieldBlob( FieldName : WideString; FieldBlob : TMemoryStream ) : TSQLQuery; virtual;
    function UpFieldBlob( FieldName : WideString; FieldBlob : TMemoryStream ) : TSQLQuery; virtual;

    function Execute(var Query : TZQuery ) : TSqlQuery; overload;
    function Execute(var Query : TFDQuery ) : TSqlQuery; overload;
    function Open(var query : TZQuery ) : TSqlQuery; overload;
    function Open(var query : TFDQuery ) : TSqlQuery; overload;

    // Atalhos do DataSet
    function RecordCount : Integer;
    function RecNo : Integer;
    function Eof : Boolean;
    function Bof : Boolean;
    function Active : Boolean;
    function SetField( Field : WideString; Value : WideString ) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : Double ) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : Currency) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : TDateTime ) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : Int64 ) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : Integer ) : TSQLQuery; overload; virtual;
    function SetField( Field : WideString; Value : Boolean ) : TSQLQuery; overload; virtual;
    //
    function First : TSQLQuery; virtual;
    function Prior : TSQLQuery; virtual;
    function NextRecord : TSQLQuery; virtual;
    function Last: TSQLQuery; virtual;
    //
    function Append : TSQLQuery; virtual;
    function Edit : TSQLQuery; virtual;
    function Post : TSQLQuery; virtual;
    //
    function getInteger( NameField : WideString ) : Integer; overload;
    function getLongInt( NameField : WideString ) : Int64; overload;
    function getWideString( NameField : WideString ) : WideString; overload;
    function getAnsiString( NameField : WideString ) : AnsiString; overload;
    function getFloat( NameField : WideString ) : Double; overload;
    function getCurrency( NameField : WideString ) : Currency; overload;
    function getBoolean( NameField : WideString ) : Boolean; overload;
    function getDateTime( NameField : WideString ) : TDateTime; overload;
    function getBlob( NameField : WideString ) : TMemoryStream; overload;

    function IntToString( NameField : WideString ) : WideString;
    function IntToStringZero( NameField : WideString; Size : Integer ) : WideString;
    function LongToString( NameField : WideString ) : WideString;
    function LongToStringZero( NameField : WideString; Size : Integer ) : WideString;
    function DateToString( NameField : WideString; Format : WideString = 'yyyy.mm.dd hh:nn:ss' ) : WideString;
    function FloatToString( NameField : WideString; Format : WideString = '#0.00' ) : WideString;
    function StringToInt( NameField : WideString ) : Integer;
    function StringToLog( NameField : WideString ) : Int64;
    function CurrencyToString( NameField : WideString; Format : WideString = '#0.00' ) : WideString;

    constructor Create; override;
    destructor Destroy; override;
  end;

function Ping(const AHost : string) : Boolean;

implementation

{ TSqlQuery }

function TSqlQuery.Execute(var Query: TZQuery): TSqlQuery;
var
  Executed : Boolean;
  I: Integer;
begin
  if not Ping( Query.Connection.HostName ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.HostName );

  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
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
          if PostGreSQL then
          begin
            if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
            begin
              Query.Connection.Disconnect;
              Query.Connection.Connect;
            end
            else raise;
          end
          else
          begin
            if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
            begin
              Query.Connection.Disconnect;
              Query.Connection.Connect;
            end
            else raise;
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
    Result := Self;
  end;
end;

function TSqlQuery.Open(var query: TZQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.HostName ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.HostName );

  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
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
          if PostGreSQL then
          begin
            if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
            begin
              Query.Connection.Disconnect;
              Query.Connection.Connect;
            end
            else raise;
          end
          else
          begin
            if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
            begin
              Query.Connection.Disconnect;
              Query.Connection.Connect;
            end
            else raise;
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
    Result := Self;
  end;
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

constructor TSQLQuery.Create;
begin
  inherited Create;
  Self.FFieldBlob := TList<TBlobFieldsinSQL>.Create;
end;

function TSQLQuery.CurrencyToString(NameField, Format: WideString): WideString;
begin
  if Length(Trim(Format)) = 0  then
    Format := '#0.00';

  Result := FormatCurr( Format, getCurrency( NameField ) );
end;

function TSQLQuery.DateToString(NameField, Format: WideString): WideString;
begin
  if Length(Trim(Format)) = 0  then
    Format := 'yyyy.mm.dd hh:nn:ss';

  Result := FormatDateTime( Format, getDateTime(NameField) );
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

function TSQLQuery.FloatToString(NameField, Format: WideString): WideString;
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
var
  Executed : Boolean;
  I: Integer;
begin
  if not Ping( Query.Connection.Params.Values['server'] ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.ConnectionString );

  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
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
          if PostGreSQL then
          begin
            if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
            begin
              Query.Connection.Connected := False;
              Query.Connection.Connected := True;
            end
            else raise;
          end
          else
          begin
            if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
            begin
              Query.Connection.Connected := False;
              Query.Connection.Connected := True;
            end
            else raise;
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
    Result := Self;
  end;
end;

function TSqlQuery.Open(var query: TFDQuery): TSqlQuery;
var
  Executed : Boolean;
begin
  if not Ping( Query.Connection.Params.Values['server'] ) then
    raise Exception.Create('Falha de conexão com o Servidor de banco de dados : ' + Query.Connection.ConnectionString );

  Executed := False;

  try
    Self.FFailCount := 0;

    repeat
      try
        Query.DisableControls;
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.Add( GetString );
        Query.Open;

        Self.FDataSet := Query.Fields.DataSet;

        Executed := True;
      except
        on e: Exception do
        begin
          if PostGreSQL then
          begin
            if (Pos('SERVER', UpperCase(e.Message) ) > 0) then
            begin
              Query.Connection.Connected := False;
              Query.Connection.Connected := True;
            end
            else raise;
          end
          else
          begin
            if Pos( 'MySQL server has gone away' , e.Message ) > 0  then
            begin
              Query.Connection.Connected := False;
              Query.Connection.Connected := True;
            end
            else raise;
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
    Result := Self;
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

function TSQLQuery.RecNo: Integer;
begin
  Result := 0;

  if Active then
    Result := Self.FDataSet.RecNo;
end;

function TSQLQuery.SetField(Field: WideString; Value: Double): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsFloat := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field, Value: WideString): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsWideString := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: WideString; Value: Integer): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsInteger := Value;

  Result := Self;
end;

procedure TSQLQuery.SetDataSet(const Value: TDataSet);
begin
  FDataSet := Value;
end;

function TSQLQuery.SetField(Field: WideString; Value: Boolean): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsBoolean := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: WideString; Value: Int64): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsLargeInt := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: WideString; Value: Currency): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsCurrency := Value;

  Result := Self;
end;

function TSQLQuery.SetField(Field: WideString; Value: TDateTime): TSQLQuery;
begin
  if Active then
    Self.FDataSet.FieldByName( Field ).AsDateTime := Value;

  Result := Self;
end;

function TSQLQuery.StringToInt(NameField: WideString): Integer;
begin
  Result := StrToIntDef(Self.FDataSet.FieldByName(NameField).AsWideString,0);
end;

function TSQLQuery.StringToLog(NameField: WideString): Int64;
begin
  Result := StrToInt64Def(FDataSet.FieldByName(NameField).AsWideString, 0);
end;

function TSQLQuery.UpFieldBlob(FieldName: WideString; FieldBlob: TMemoryStream): TSQLQuery;
var
  I : Integer;
begin
  I := Self.FFieldBlob.Add( TBlobFieldsinSQL.Create );
  Self.FFieldBlob[I].FFieldName := FieldName;
  Self.FFieldBlob[I].FFieldBlob.LoadFromStream( FieldBlob );

  Self.Add( FieldName + ' = :' + Trim(FieldName) );

  Result := Self;
end;

function TSQLQuery.getInteger(NameField: WideString): Integer;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsInteger;
end;

function TSQLQuery.getWideString(NameField: WideString): WideString;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsWideString;
end;

function TSQLQuery.FieldBlob(FieldName: WideString; FieldBlob: TMemoryStream): TSQLQuery;
var
  I : Integer;
begin
  I := Self.FFieldBlob.Add( TBlobFieldsinSQL.Create );
  Self.FFieldBlob[I].FFieldName := FieldName;
  Self.FFieldBlob[I].FFieldBlob.LoadFromStream( FieldBlob );

  Self.Add(' :' + Trim(FieldName) );

  Result := Self;
end;

function TSQLQuery.IntToString(NameField: WideString): WideString;
begin
  Result := IntToStr( getInteger( NameField ) );
end;

function TSQLQuery.IntToStringZero(NameField: WideString; Size: Integer): WideString;
begin
  if Size > 0 then
    Result := Format( '%.' + IntToStr(Size) + 'd', [getInteger(NameField)])
  else
    Result := IntToStr( getInteger(NameField) );
end;

function TSQLQuery.Last : TSQLQuery;
begin
  if Assigned( Self.FDataSet ) then
    Self.FDataSet.Last;

  Result := Self;
end;

function TSQLQuery.LongToString(NameField: WideString): WideString;
begin
  Result := IntToStr( getInteger( NameField ) );
end;

function TSQLQuery.LongToStringZero(NameField: WideString; Size: Integer): WideString;
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

function TSQLQuery.getFloat(NameField: WideString): Double;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsFloat;
end;

function TSQLQuery.getLongInt(NameField: WideString): Int64;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsLargeInt;
end;

function TSQLQuery.getBlob(NameField: WideString): TMemoryStream;
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

function TSQLQuery.getBoolean(NameField: WideString): Boolean;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsBoolean;
end;

function TSQLQuery.getDateTime(NameField: WideString): TDateTime;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsDateTime;
end;

function TSQLQuery.getAnsiString(NameField: WideString): AnsiString;
begin
  Result := Self.FDataSet.FieldByName(NameField).AsAnsiString;
end;

function TSQLQuery.getCurrency(NameField: WideString): Currency;
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
      Exit;
    end;

    result := (MyIdIcmpClient.ReplyStatus.BytesReceived > 0);
  finally
    FreeAndNil( MyIdIcmpClient );
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

procedure TBlobFieldsinSQL.SetFieldName(const Value: WideString);
begin
  FFieldName := Value;
end;

end.
