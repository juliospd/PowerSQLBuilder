{
  PowerSQLBuilder.
  ------------------------------------------------------------------------------
  Objetivo : Simplificar a execução de comandos SQL via codigos livre de
             componentes de terceiros.
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
unit PowerSqlBuilder;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, System.DateUtils,
  {ZeusLib}
  ZAbstractRODataset, ZAbstractDataset, ZDataset, ZConnection, ZAbstractTable,
  {FireDac}
  FireDAC.Stan.Intf, FireDAC.Stan.Option,FireDAC.Stan.Error, Rest.Json,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf,FireDAC.DApt, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.UI, FireDAC.Phys.PG, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  {ADO}
  Data.Win.ADODB,
  {UniDac}
  MemDS, DBAccess, Uni;

type
  TExecuteZc = procedure (var Connection : TZConnection ) of object;
  TExecuteZ = procedure (var Query : TZQuery ) of object;

  TExecuteFc = procedure (var Connection : TFDConnection ) of object;
  TExecuteF = procedure (var Query : TFDQuery ) of object;

  TExecuteUc = procedure (var Connection : TUniConnection ) of object;
  TExecuteU = procedure (var Query : TUniQuery ) of object;

  TExecuteAc = procedure (var Connection : TADOConnection ) of object;
  TExecuteA = procedure (var Query : TADOQuery ) of object;

  TOpenZ = procedure (var query : TZQuery ) of object;
  TOpenF = procedure (var query : TFDQuery ) of object;
  TOpenU = procedure (var query : TUniQuery ) of object;
  TOpenA = procedure (var query : TADOQuery ) of object;

  TSGDBType = ( dbPostGreSQL, dbMySQL, dbMsSQL, dbFireBird, dbSQLLite, dbNenhum );

  /// <summary>
  ///   PowerSQLBuilder é uma classe de manipulação SQL
  /// </summary>
  /// <comments>
  ///   Chega de ficar concatenando pedaços do texto gerando um scripts SQL manual
  ///   E muita das vezes falho, através do PowerSQLBuilder você apenas chama os
  ///   comandos SQL que ele mesmo interpreta e gera o scripts SQL automaticamente
  ///   <para><c>Mais o que torna ele ágil é a possibilidade de passar parâmetros sem se preocupar
  ///   com seu tipo de origem o PowerSQLBulder faz isso automaticamente para você.
  ///   interpleta e gera o scripts SQL automaticamente</c></para>
  /// </comments>
  /// <remarks>
  ///   Para saber mais entre no site https://github.com/juliospd/PowerSQLBuilder
  /// </remarks>
  TPowerSQLBuilder = class(TObject)
  private
    FValuePSB : TStringBuilder;
    FSGDBType: TSGDBType;
    FWhere : Boolean;

    FOpenFire: TOpenF;
    FOpenZeus: TOpenZ;
    FOpenUniDac : TOpenU;
    FOpenADO : TOpenA;
    FExecuteFire: TExecuteF;
    FExecuteZeus: TExecuteZ;
    FExecuteUniDac: TExecuteU;
    FExecuteADO: TExecuteA;
    FExecuteZeusC: TExecuteZc;
    FExecuteFireC: TExecuteFc;
    FExecuteUniDacC: TExecuteUc;
    FExecuteADOC: TExecuteAc;

    function Test( const Value : String; Condition : String ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Double; DecimalValue : ShortInt = 2; Condition : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Int64; Condition : String ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Integer; Condition : String ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Boolean; Condition : String ) : TPowerSQLBuilder; overload; virtual;
    function TestDate(Value : TDateTime; Condition : String; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function TestOfDate(Value : TDateTime; Condition : String; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function TestOfTime(const Value : TDateTime; Seconds : Boolean = True; Condition : String = ''; Mask : String = '' ) : TPowerSQLBuilder; virtual;
  protected
    procedure SetZeus( ExecuteZeusC : TExecuteZc; ExecuteZeus : TExecuteZ; OpenZeus : TOpenZ );
    procedure SetFireDac( ExecuteFireC : TExecuteFc; ExecuteFire : TExecuteF; OpenFire : TOpenF );
    procedure SetUniDac( ExecuteUniDacC : TExecuteUc; ExecuteUniDac : TExecuteU; OpenUniDac : TOpenU );
    procedure SetADO( ExecuteADOC : TExecuteAc; ExecuteADO : TExecuteA; OpenADO : TOpenA );
  public
    property SGDBType : TSGDBType read FSGDBType;
    // Funções simples
    function Add(const Value : String) : TPowerSQLBuilder; virtual;
    function AddQuoted(const Value : String) : TPowerSQLBuilder; virtual;
    function AddLine(const Value : String) : TPowerSQLBuilder; virtual;
    function Clear : TPowerSQLBuilder; virtual;
    function GetString : String;
    // Teste de Igual a
    function Equal( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function EqualOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function EqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Maior que
    function Major( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MajorOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function MajorOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Maior igual
    function MajorEqual( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqualOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function MajorEqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Menor que
    function Minor( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MinorOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function MinorOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Menor Igual
    function MinorEqual( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqualOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function MinorEqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Diferença que
    function Different( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function DifferentOfDate( const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function DifferentOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Field usado na inserção
    function Field( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Field( Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function FieldFloat( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; virtual;
    function FieldOfDate( Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function FieldOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Campo e valor usado no Update
    function UpField( Field : String ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : String; const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function UpFieldNull(const Field: String): TPowerSQLBuilder;
    function UpFieldOfDate( Field : String; const Value : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function UpFieldOfTime( Field : String; const Value : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    // Power SQL
    function Insert( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Insert : TPowerSQLBuilder; overload; virtual;
    function Select : TPowerSQLBuilder; overload; virtual;
    function Select( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function SelectFrom : TPowerSQLBuilder; overload; virtual;
    function SelectFrom( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Update( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Update : TPowerSQLBuilder; overload; virtual;
    function Delete( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Delete : TPowerSQLBuilder; overload; virtual;
    function DeleteFrom( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function DeleteFrom : TPowerSQLBuilder; overload; virtual;
    function From( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function From : TPowerSQLBuilder; overload; virtual;
    function Where( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Where( const Value : String; const Cast : String ) : TPowerSQLBuilder; overload; virtual;
    function Order_By : TPowerSQLBuilder; overload; virtual;
    function Order_By( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Partition_By : TPowerSQLBuilder; overload; virtual;
    function Partition_By( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Desc : TPowerSQLBuilder; virtual;
    function Group_By( const Value : String ) : TPowerSQLBuilder; virtual;
    function Values : TPowerSQLBuilder; virtual;
    function EndValues : TPowerSQLBuilder; virtual;
    function EndValuesID : TPowerSQLBuilder; virtual;
    function Sum : TPowerSQLBuilder;  overload; virtual;
    function Sum( const Value : String ) : TPowerSQLBuilder;  overload; virtual;
    function SumAs( const Value : String; asValue : String ) : TPowerSQLBuilder; virtual;
    function having( const Value : String ) : TPowerSQLBuilder; virtual;
    function CreateTable( const Value : String ) : TPowerSQLBuilder; virtual;
    function AlterTable( const Value : String ) : TPowerSQLBuilder; virtual;
    function DropTable( const Value : String ) : TPowerSQLBuilder; virtual;
    function CreateView( const Value : String ) : TPowerSQLBuilder; virtual;
    function AlterView( const Value : String ) : TPowerSQLBuilder; virtual;
    function DropView( const Value : String ) : TPowerSQLBuilder; virtual;
    function Union : TPowerSQLBuilder; virtual;
    function Over : TPowerSQLBuilder; virtual;
    function All : TPowerSQLBuilder; overload; virtual;
    function TruncateTable( const Value : String ) : TPowerSQLBuilder; virtual;

    /// <summary>
    /// sP : Abre um Parentese Start Parent '('
    /// </summary>
    function sP : TPowerSQLBuilder; virtual;
    /// <summary>
    /// eP : Fecha um Parentese end parent ')'
    /// </summary>
    function eP : TPowerSQLBuilder; virtual;
    function LeftJoin( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function LeftJoin : TPowerSQLBuilder; overload; virtual;
    function RightJoin( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function RightJoin : TPowerSQLBuilder; overload; virtual;
    function InnerJoin( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function InnerJoin : TPowerSQLBuilder; overload; virtual;
    function FullJoin( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function FullJoin : TPowerSQLBuilder; overload; virtual;
    function Top( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Limit( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Limit( const pag1, pag2 : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Like( const Value : String ) : TPowerSQLBuilder; virtual;
    function Next : TPowerSQLBuilder; virtual;
    function NextField(const Value : String ) : TPowerSQLBuilder; virtual;
    function Fields( const Value : String ) : TPowerSQLBuilder; virtual;
    function FieldsStart( const Value : String ) : TPowerSQLBuilder; virtual;
    function FieldsInline( const Value : String ) : TPowerSQLBuilder; virtual;
    function FieldsEnd( const Value : String ) : TPowerSQLBuilder; virtual;
    function BetWeen( const ValueStart, ValueEnd : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Integer ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeenOfDate( const ValueStart, ValueEnd : TDateTime; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function BetWeenOfTime( const ValueStart, ValueEnd : TDateTime; Seconds : Boolean = True; Mask : String = '' ) : TPowerSQLBuilder; virtual;
    function Cast( Field : String; const Value : String ) : TPowerSQLBuilder; virtual;
    function Distinct : TPowerSQLBuilder; overload; virtual;
    function Distinct( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function Count : TPowerSQLBuilder; virtual;
    function CountAs( const asValue : String ) : TPowerSQLBuilder; virtual;
    function Max(const Value : String ) : TPowerSQLBuilder; virtual;
    function Min(const Value : String ) : TPowerSQLBuilder; Virtual;
    function AutoIncrement(const Value : Integer ) : TPowerSQLBuilder; virtual;
    function EndIn : TPowerSQLBuilder; virtual;
    function EndOver : TPowerSQLBuilder; virtual;
    function Returning( Field : String ) : TPowerSQLBuilder; virtual;
    function OutPut( Field : String ) : TPowerSQLBuilder; virtual;
    function OutPutField( Field : String ) : TPowerSQLBuilder; virtual;
    function constraint(const Field : String ) : TPowerSQLBuilder; virtual;
    function unique(const Field : String ) : TPowerSQLBuilder; virtual;
    function AddConstraint( const Value : String ) : TPowerSQLBuilder; virtual;
    function AddColumn( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function DropColumn( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function AlterColumn( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function ModifyColumn( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function PrimaryKey( const Value : String ) : TPowerSQLBuilder; virtual;
    function IsNull : TPowerSQLBuilder; virtual;
    function IsNotNull : TPowerSQLBuilder; virtual;
    function NotIn : TPowerSQLBuilder; overload; virtual;
    function NotIn(const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function NotNull : TPowerSQLBuilder; virtual;
    function Default( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Default( const Value : Double ) : TPowerSQLBuilder; overload; virtual;
    function Default( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    //
    function &Is : TPowerSQLBuilder; virtual;
    function &As( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &As : TPowerSQLBuilder; overload; virtual;
    function &Or( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &Or : TPowerSQLBuilder; overload; virtual;
    function &And( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &And : TPowerSQLBuilder; overload; virtual;
    function &On( const Value : String ) : TPowerSQLBuilder; virtual;
    function &In : TPowerSQLBuilder;  overload; virtual;
    function &In( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &Not : TPowerSQLBuilder; overload; virtual;
    function &Not( const Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &Null : TPowerSQLBuilder; virtual;
    function &Case( Condition : String ) : TPowerSQLBuilder; overload; virtual;
    function &Case : TPowerSQLBuilder; overload; virtual;
    function &When( Condition : String )  : TPowerSQLBuilder; overload; virtual;
    function &When  : TPowerSQLBuilder; overload; virtual;
    function &Then  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : String )  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : Double; DecimalValue : ShortInt = 2 )  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : TDateTime; Mask : String = ''  )  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : Int64 )  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : Integer )  : TPowerSQLBuilder; overload; virtual;
    function &Then( Value : Boolean )  : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : String )  : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : Double; DecimalValue : ShortInt = 2 )  : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : TDateTime; Mask : String = ''  )  : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : Int64 )  : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function &Else( Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function &End( Name : String ) : TPowerSQLBuilder; overload; virtual;
    function &End : TPowerSQLBuilder; overload; virtual;
    function &With( Value : String ) : TPowerSQLBuilder; overload; virtual;
    function &With : TPowerSQLBuilder; overload; virtual;

    function GetJson( var Query : TZQuery; NameArray : String ) : String; overload;

    function Execute(var Connection : TZConnection ) : TPowerSQLBuilder; overload;
    function Execute(var Query : TZQuery ) : TPowerSQLBuilder; overload;
    function Execute(var Connection : TFDConnection ) : TPowerSQLBuilder; overload;
    function Execute(var Query : TFDQuery ) : TPowerSQLBuilder; overload;
    function Execute(var Connection : TUniConnection ) : TPowerSQLBuilder; overload;
    function Execute(var Query : TUniQuery ) : TPowerSQLBuilder; overload;
    function Execute(var Connection : TADOConnection ) : TPowerSQLBuilder; overload;
    function Execute(var Query : TADOQuery ) : TPowerSQLBuilder; overload;
    function Open(var query : TZQuery ) : TPowerSQLBuilder; overload;
    function Open(var query : TFDQuery ) : TPowerSQLBuilder; overload;
    function Open(var query : TUniQuery ) : TPowerSQLBuilder; overload;
    function Open(var query : TADOQuery ) : TPowerSQLBuilder; overload;

    function PostGreSQL : TPowerSQLBuilder;
    function FireBird : TPowerSQLBuilder;
    function MSSQL : TPowerSQLBuilder;
    function MySQL : TPowerSQLBuilder;
    function SQLLite : TPowerSQLBuilder;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

{ TPowerSQLBuilder }

function TPowerSQLBuilder.&ON(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' on (').Add( Value ).EndValues;
end;

function TPowerSQLBuilder.Open(var query: TADOQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FOpenADO ) then
    Self.FOpenADO( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Open(var query: TFDQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FOpenFire ) then
    Self.FOpenFire( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Open(var query: TZQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FOpenZeus ) then
    Self.FOpenZeus( Query );

  Result := Self;
end;

function TPowerSQLBuilder.&IN(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' in (').Add( Value );
end;

function TPowerSQLBuilder.InnerJoin: TPowerSQLBuilder;
begin
  Result := Add(' Inner Join');
end;

function TPowerSQLBuilder.Insert: TPowerSQLBuilder;
begin
  Result := Add('insert into');
end;

function TPowerSQLBuilder.NotIn(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' not in (').Add( Value ).eP;
end;

function TPowerSQLBuilder.NotNull: TPowerSQLBuilder;
begin
  Result := Add(' not null ');
end;

function TPowerSQLBuilder.&Null: TPowerSQLBuilder;
begin
  Result := Add(' null ');
end;

function TPowerSQLBuilder.&IN: TPowerSQLBuilder;
begin
  Result := Add(' in (');
end;

function TPowerSQLBuilder.&As(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' as ').Add( Value );
end;

function TPowerSQLBuilder.AutoIncrement(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' auto_increment').Equal( Value );
end;

function TPowerSQLBuilder.&Case: TPowerSQLBuilder;
begin
  Result := Add(' case');
end;

function TPowerSQLBuilder.&Case(Condition: String): TPowerSQLBuilder;
begin
  Result := Add(' case ').Add( Condition );
end;

function TPowerSQLBuilder.&Else(Value: Int64): TPowerSQLBuilder;
begin
  Result := Add(' else ').Field( Value );
end;

function TPowerSQLBuilder.&Else(Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' else ').Field( Value );
end;

function TPowerSQLBuilder.&Else( Value: Boolean ): TPowerSQLBuilder;
begin
  Result := Add(' else ').Field( Value );
end;

function TPowerSQLBuilder.&Else(Value: String): TPowerSQLBuilder;
begin
  Result := Add(' else ').AddQuoted( Value );
end;

function TPowerSQLBuilder.&Else(Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' else ').Field( Value, DecimalValue );
end;

function TPowerSQLBuilder.&Else(Value: TDateTime; Mask: String): TPowerSQLBuilder;
begin
  Result := Add(' else ').Field( Value, Mask );
end;

function TPowerSQLBuilder.&End: TPowerSQLBuilder;
begin
  Result := Add(' end');
end;

function TPowerSQLBuilder.&End(Name: String): TPowerSQLBuilder;
begin
  Result := Add(' end').&As( Name );
end;

function TPowerSQLBuilder.&Then: TPowerSQLBuilder;
begin
  Result := Add(' then ');
end;

function TPowerSQLBuilder.&Then(Value: Int64): TPowerSQLBuilder;
begin
  Result := Add(' then ').Field( Value );
end;

function TPowerSQLBuilder.&Then(Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' then ').Field( Value );
end;

function TPowerSQLBuilder.&Then(Value: Boolean): TPowerSQLBuilder;
begin
  Result := Add(' then ').Field( Value );
end;

function TPowerSQLBuilder.Top(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' TOP ').Field(Value);
end;

function TPowerSQLBuilder.TruncateTable( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' truncate table ').Add( Value );
end;

function TPowerSQLBuilder.&Then(Value: String): TPowerSQLBuilder;
begin
  Result := Add(' then ').AddQuoted( Value );
end;

function TPowerSQLBuilder.&Then(Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' then ').Field( Value, DecimalValue );
end;

function TPowerSQLBuilder.&Then(Value: TDateTime; Mask: String): TPowerSQLBuilder;
begin
  Result := Add(' then ').Field( Value, Mask );
end;

function TPowerSQLBuilder.&Is: TPowerSQLBuilder;
begin
  Result := Add(' is ');
end;

function TPowerSQLBuilder.IsNotNull: TPowerSQLBuilder;
begin
  Result := Add(' is not null ');
end;

function TPowerSQLBuilder.IsNull: TPowerSQLBuilder;
begin
  Result := Add(' is null ');
end;

function TPowerSQLBuilder.&And: TPowerSQLBuilder;
begin
  Result := Add(' and  ');
end;

function TPowerSQLBuilder.&Or: TPowerSQLBuilder;
begin
  Result := Add(' or ');
end;

function TPowerSQLBuilder.&With: TPowerSQLBuilder;
begin
  Result := Add(' with ');
end;

function TPowerSQLBuilder.&With(Value: String): TPowerSQLBuilder;
begin
  Result := Add(' with ').Add( Value );
end;

function TPowerSQLBuilder.&As: TPowerSQLBuilder;
begin
  Result := Add(' as ');
end;

function TPowerSQLBuilder.&Not: TPowerSQLBuilder;
begin
  Result := Add(' not ');
end;

function TPowerSQLBuilder.Add(const Value: String): TPowerSQLBuilder;
begin
  Self.FValuePSB.Append( Value );
  Result := Self;
end;

function TPowerSQLBuilder.AddColumn( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' add ').Add( Value );
end;

function TPowerSQLBuilder.AddConstraint( const Value: String): TPowerSQLBuilder;
begin
  Result := Add( ' ADD CONSTRAINT ' ).Add( Value );
end;

function TPowerSQLBuilder.AddLine(const Value: String): TPowerSQLBuilder;
begin
  Result := Add( Value ).Add( #10 );
end;

function TPowerSQLBuilder.AddQuoted( const Value: String): TPowerSQLBuilder;
begin
  Result := Add( QuotedStr( Value ) );
end;

function TPowerSQLBuilder.All: TPowerSQLBuilder;
begin
  Result := Add(' * ');
end;

function TPowerSQLBuilder.AlterColumn( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' alter column ').Add( Value );
end;

function TPowerSQLBuilder.AlterTable(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' alter table ').Add( value );
end;

function TPowerSQLBuilder.AlterView(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' alter view ').Add( value );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart, DecimalValue ).Add(' and ').Field( ValueEnd, DecimalValue );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: Int64): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart ).Add(' and ').Field( ValueEnd );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: Integer): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart ).Add(' and ').Field( ValueEnd );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart, Mask ).Add(' and ').Field( ValueEnd, Mask );
end;

function TPowerSQLBuilder.BetWeenOfDate(const ValueStart, ValueEnd: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfDate( ValueStart, Mask ).Add(' and ').FieldOfDate( ValueEnd, Mask );
end;

function TPowerSQLBuilder.BetWeenOfTime(const ValueStart, ValueEnd: TDateTime; Seconds : Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfTime( ValueStart, Seconds, Mask ).Add(' and ').FieldOfTime( ValueEnd, Seconds, Mask );
end;

function TPowerSQLBuilder.Cast(Field: String; const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' cast(').Add(Field).&As(Value).Add(')');
end;

function TPowerSQLBuilder.Clear: TPowerSQLBuilder;
begin
  Self.FValuePSB.Clear;
  Self.FWhere := False;
  Result := Self;
end;

function TPowerSQLBuilder.constraint(const Field: String): TPowerSQLBuilder;
begin
  Result := Add(' constraint ').Add( Field );
end;

function TPowerSQLBuilder.CountAs(const asValue: String): TPowerSQLBuilder;
begin
  Result := Add(' count(*)').&As( asValue );
end;

function TPowerSQLBuilder.Count: TPowerSQLBuilder;
begin
  Result := Add(' count(*)');
end;

constructor TPowerSQLBuilder.Create;
begin
  Self.FValuePSB := TStringBuilder.Create;
  Self.FSGDBType := dbNenhum;
end;

function TPowerSQLBuilder.CreateTable(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' create table ').Add( Value );
end;

function TPowerSQLBuilder.CreateView(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' create view ').Add( Value );
end;

function TPowerSQLBuilder.Desc: TPowerSQLBuilder;
begin
  Result := Add(' Desc');
end;

destructor TPowerSQLBuilder.Destroy;
begin
  FreeAndNil( Self.FValuePSB );
  inherited;
end;

function TPowerSQLBuilder.Different(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<>');
end;

function TPowerSQLBuilder.Different(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>' );
end;

function TPowerSQLBuilder.Different(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '<>', Mask );
end;

function TPowerSQLBuilder.Different(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>' );
end;

function TPowerSQLBuilder.Different(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>' );
end;

function TPowerSQLBuilder.Different(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>' );
end;

function TPowerSQLBuilder.DifferentOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<>', Mask );
end;

function TPowerSQLBuilder.DifferentOfTime(const Value: TDateTime;Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds,  '<>', Mask );
end;

function TPowerSQLBuilder.Distinct(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' Distinct ').Add( Value );
end;

function TPowerSQLBuilder.DropColumn( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' drop column ').Add( Value );
end;

function TPowerSQLBuilder.DropTable(const Value : String ): TPowerSQLBuilder;
begin
  Result := Add(' drop table ').Add( Value );
end;

function TPowerSQLBuilder.DropView(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' drop view ').Add( Value );
end;

function TPowerSQLBuilder.Distinct: TPowerSQLBuilder;
begin
  Result := Add(' Distinct');
end;

function TPowerSQLBuilder.Equal(const Value: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '=', Mask);
end;

function TPowerSQLBuilder.Equal(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '=' );
end;

function TPowerSQLBuilder.Equal(const Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '=' );
end;

function TPowerSQLBuilder.Equal(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '=' );
end;

function TPowerSQLBuilder.EndIn: TPowerSQLBuilder;
begin
  Result := eP;
end;

function TPowerSQLBuilder.EndOver: TPowerSQLBuilder;
begin
  Result := eP;
end;

function TPowerSQLBuilder.EndValues: TPowerSQLBuilder;
begin
  Result := eP;
end;

function TPowerSQLBuilder.EndValuesID: TPowerSQLBuilder;
begin
  Result := eP.Add(' returning id ');
end;

function TPowerSQLBuilder.eP: TPowerSQLBuilder;
begin
  Result := Add(')');
end;

function TPowerSQLBuilder.Equal(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '=' );
end;

function TPowerSQLBuilder.Equal(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '=' );
end;

function TPowerSQLBuilder.EqualOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '=', Mask );
end;

function TPowerSQLBuilder.EqualOfTime(const Value: TDateTime; Seconds : Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '=', Mask );
end;

function TPowerSQLBuilder.Execute(var Connection: TADOConnection): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteADOC ) then
    Self.FExecuteADOC( Connection );

  Result := Self;
end;

function TPowerSQLBuilder.Execute(var Query: TADOQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteADO ) then
    Self.FExecuteADO( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Execute(var Connection: TZConnection): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteZeusC ) then
    Self.FExecuteZeusC( Connection );

  Result := Self;
end;

function TPowerSQLBuilder.Execute(var Connection: TFDConnection): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteFireC ) then
    Self.FExecuteFireC( Connection );

  Result := Self;
end;

function TPowerSQLBuilder.Execute(var Query: TFDQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteFire ) then
    Self.FExecuteFire( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Execute(var Query: TZQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteZeus ) then
    Self.FExecuteZeus( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Field(Value: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd hh:nn:ss';

  if YearOf(Value) < 1890 then
    Value := 0;

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
        Add( QuotedStr( '0000.00.00 00:00:00' ) )
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Field(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Field(const Value: Boolean): TPowerSQLBuilder;
begin
  case Self.FSGDBType of
    dbPostGreSQL: Add( IfThen(Value, 'true', 'false') );
    dbMySQL, dbSQLLite: Add( IfThen(Value, '1', '0') );
    dbMsSQL: Add( IfThen(Value, '1', '0') );
    dbFireBird: Add( IfThen(Value, 'true', 'false') );
    dbNenhum: Add( IfThen(Value, 'true', 'false') );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.FieldFloat(const Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.Field(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.FieldOfDate(Value: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd';

  if YearOf(Value) < 1890 then
    Value := 0;

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime(Mask, Value ) ) );
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
        Add( QuotedStr( '0000.00.00' ) )
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime(Mask, Value ) ) );
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime(Mask, Value ) ) );
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime(Mask, Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.FieldOfTime(const Value: TDateTime; Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  if Mask = '' then
  begin
    if Seconds then
      Mask := 'hh:mm:ss'
    else
      Mask := 'hh:mm'
  end;

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
      begin
        if Seconds then
          Add( QuotedStr( '00:00:00' ) )
        else
          Add( QuotedStr( '00:00' ) )
      end
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Fields(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' (').Add( Value ).EndValues;
end;

function TPowerSQLBuilder.FieldsEnd( const Value: String): TPowerSQLBuilder;
begin
  Result := Add( Value ).EndValues;
end;

function TPowerSQLBuilder.FieldsInline( const Value: String): TPowerSQLBuilder;
begin
  Result := Add( Value );
end;

function TPowerSQLBuilder.FieldsStart( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' (').Add( Value );
end;

function TPowerSQLBuilder.FireBird: TPowerSQLBuilder;
begin
  Self.FSGDBType := dbFireBird;
  Result := Self;
end;

function TPowerSQLBuilder.From: TPowerSQLBuilder;
begin
  Result := Add(' from');
end;

function TPowerSQLBuilder.FullJoin: TPowerSQLBuilder;
begin
  Result := Add(' full join');
end;

function TPowerSQLBuilder.Field(const Value: String): TPowerSQLBuilder;
begin
  Result := AddQuoted(Value);
end;

function TPowerSQLBuilder.Field(const Value: Double; DecimalValue : ShortInt = 2): TPowerSQLBuilder;
begin
  Result := Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.GetJson(var Query: TZQuery; NameArray: String): String;
var
  SqlFreeze : String;
begin
  Result := '';

  if Self.FSGDBType <> dbPostGreSQL then
    Exit;

  SqlFreeze := GetString;

  if Trim(NameArray) = '' then
    NameArray := 'tabela';

  Clear;

  Add('SELECT CAST ( row_to_json ( T ) AS TEXT ) AS json  FROM ( ');
  Add('select ');
  Add('(select array_to_json(array_agg(row_to_json(a))) as json from ( ');
  Add( SqlFreeze );
  Add(') as a) as ').Add( NameArray ).Add(') AS T');

  Open( Query );

  Result := Query.FieldByName('json').AsString;
end;

function TPowerSQLBuilder.GetString: String;
begin
  Result := Self.FValuePSB.ToString;
end;

function TPowerSQLBuilder.&AND( const Value : String ) : TPowerSQLBuilder;
begin
  if not Self.FWhere then
  begin
    Result := Add(' where ').Add( Value );
    Self.FWhere := True;
  end
  else Result := Add(' and ').Add( Value );
end;

function TPowerSQLBuilder.Delete( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('delete ').Add( Value );
end;

function TPowerSQLBuilder.DeleteFrom( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('delete from ').Add( Value );
end;

function TPowerSQLBuilder.From( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' from ').Add( Value );
end;

function TPowerSQLBuilder.FullJoin( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' full join ').Add( Value );
end;

function TPowerSQLBuilder.Group_By( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' group by ').Add( Value );
end;

function TPowerSQLBuilder.having(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' having (').Add( Value ).eP;
end;

function TPowerSQLBuilder.InnerJoin( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' Inner Join ').Add( Value );
end;

function TPowerSQLBuilder.Insert( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('insert into ').Add( Value );
end;

function TPowerSQLBuilder.LeftJoin( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' Left Join ').Add( Value );
end;

function TPowerSQLBuilder.LeftJoin: TPowerSQLBuilder;
begin
  Result := Add(' Left Join');
end;

function TPowerSQLBuilder.Like(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' like ').AddQuoted( Trim(Value) + '%' );
end;

function TPowerSQLBuilder.Limit(const pag1, pag2: Integer): TPowerSQLBuilder;
begin
  Result := Add(' limit ').Field(pag1).Add(', ').Field(pag2);
end;

function TPowerSQLBuilder.Limit(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' limit ').Field(Value);
end;

function TPowerSQLBuilder.Major(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '>');
end;

function TPowerSQLBuilder.Major(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '>');
end;

function TPowerSQLBuilder.Major(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '>');
end;

function TPowerSQLBuilder.Major(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '>');
end;

function TPowerSQLBuilder.Major(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '>');
end;

function TPowerSQLBuilder.Major(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '>', Mask);
end;

function TPowerSQLBuilder.MajorEqual(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '>=');
end;

function TPowerSQLBuilder.MajorEqual(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '>=');
end;

function TPowerSQLBuilder.MajorEqual(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '>=');
end;

function TPowerSQLBuilder.MajorEqual(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '>=');
end;

function TPowerSQLBuilder.MajorEqual(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '>=', Mask);
end;

function TPowerSQLBuilder.MajorEqual(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '>=');
end;

function TPowerSQLBuilder.MajorEqualOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '>=', Mask);
end;

function TPowerSQLBuilder.MajorEqualOfTime(const Value: TDateTime;Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '>=', Mask);
end;

function TPowerSQLBuilder.MajorOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '>', Mask);
end;

function TPowerSQLBuilder.MajorOfTime(const Value: TDateTime;Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '>', Mask);
end;

function TPowerSQLBuilder.Max(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' max(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Min(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' min(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Minor(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '<', Mask);
end;

function TPowerSQLBuilder.Minor(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '<');
end;

function TPowerSQLBuilder.Minor(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '<');
end;

function TPowerSQLBuilder.Minor(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '<');
end;

function TPowerSQLBuilder.Minor(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<');
end;

function TPowerSQLBuilder.Minor(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '<');
end;

function TPowerSQLBuilder.MinorEqual(const Value: String): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestDate( Value, '<=', Mask);
end;

function TPowerSQLBuilder.MinorEqual(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=');
end;

function TPowerSQLBuilder.MinorEqualOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<=', Mask);
end;

function TPowerSQLBuilder.MinorEqualOfTime(const Value: TDateTime;Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '<=', Mask);
end;

function TPowerSQLBuilder.MinorOfDate(const Value: TDateTime; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<', Mask);
end;

function TPowerSQLBuilder.MinorOfTime(const Value: TDateTime;Seconds: Boolean; Mask : String): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '<', Mask);
end;

function TPowerSQLBuilder.ModifyColumn( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' modify column ').Add( Value );
end;

function TPowerSQLBuilder.MSSQL: TPowerSQLBuilder;
begin
  Self.FSGDBType := dbMsSQL;
  Result := Self;
end;

function TPowerSQLBuilder.MySQL: TPowerSQLBuilder;
begin
  Self.FSGDBType := dbMySQL;
  Result := Self;
end;

function TPowerSQLBuilder.Next: TPowerSQLBuilder;
begin
  Result := Add(', ');
end;

function TPowerSQLBuilder.NextField(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(', ').add( Value );
end;

function TPowerSQLBuilder.&OR( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' or ').Add( Value );
end;

function TPowerSQLBuilder.Order_By: TPowerSQLBuilder;
begin
  Result := Add(' order by');
end;

function TPowerSQLBuilder.&Not( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' not ').Add( Value );
end;

function TPowerSQLBuilder.NotIn: TPowerSQLBuilder;
begin
  Result := Add(' not in (')
end;

function TPowerSQLBuilder.Order_By( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' order by ').Add( Value );
end;

function TPowerSQLBuilder.OutPut(Field: String): TPowerSQLBuilder;
begin
  Result := Add(' output inserted.').Add(Trim(Field)).Add(' ');
end;


function TPowerSQLBuilder.OutPutField(Field: String): TPowerSQLBuilder;
begin
  Result := Add(', inserted.').Add(Trim(Field)).Add(' ');
end;

function TPowerSQLBuilder.Over: TPowerSQLBuilder;
begin
  Result := Add(' over (')
end;

function TPowerSQLBuilder.Partition_By(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' partition by ').Add( Value );
end;

function TPowerSQLBuilder.Partition_By: TPowerSQLBuilder;
begin
  Result := Add(' partition by ')
end;

function TPowerSQLBuilder.PostGreSQL: TPowerSQLBuilder;
begin
  Self.FSGDBType := dbPostGreSQL;
  Result := Self;
end;

function TPowerSQLBuilder.PrimaryKey(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' PRIMARY KEY ').Add( Value );
end;

function TPowerSQLBuilder.Returning(Field: String): TPowerSQLBuilder;
begin
  Result := Add(' returning ').Add( Field );
end;

function TPowerSQLBuilder.RightJoin: TPowerSQLBuilder;
begin
  Result := Add(' Right Join');
end;

function TPowerSQLBuilder.RightJoin( const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' Right Join ').Add( Value );
end;

function TPowerSQLBuilder.Select( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('select ').Add( Value );
end;

function TPowerSQLBuilder.SelectFrom: TPowerSQLBuilder;
begin
  Result := Add('select * from');
end;

function TPowerSQLBuilder.Select: TPowerSQLBuilder;
begin
  Result := Add('select ');
end;

function TPowerSQLBuilder.SelectFrom( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('select * from ').Add( Value );
end;

procedure TPowerSQLBuilder.SetADO(ExecuteADOC: TExecuteAc; ExecuteADO: TExecuteA; OpenADO: TOpenA);
begin
  Self.FExecuteADOC    := ExecuteADOC;
  Self.FExecuteADO     := ExecuteADO;
  Self.FOpenADO        := OpenADO;
end;

procedure TPowerSQLBuilder.SetFireDac(ExecuteFireC: TExecuteFc; ExecuteFire: TExecuteF; OpenFire: TOpenF);
begin
  Self.FExecuteFireC   := ExecuteFireC;
  Self.FExecuteFire    := ExecuteFire;
  Self.FOpenFire       := OpenFire;
end;

procedure TPowerSQLBuilder.SetUniDac(ExecuteUniDacC: TExecuteUc; ExecuteUniDac: TExecuteU; OpenUniDac: TOpenU);
begin
  Self.FExecuteUniDacC := ExecuteUniDacC;
  Self.FExecuteUniDac  := ExecuteUniDac;
  Self.FOpenUniDac     := OpenUniDac;
end;

procedure TPowerSQLBuilder.SetZeus(ExecuteZeusC: TExecuteZc; ExecuteZeus: TExecuteZ; OpenZeus: TOpenZ);
begin
  Self.FExecuteZeusC   := ExecuteZeusC;
  Self.FExecuteZeus    := ExecuteZeus;
  Self.FOpenZeus       := OpenZeus;
end;

function TPowerSQLBuilder.sP: TPowerSQLBuilder;
begin
  Result := Add(' (')
end;

function TPowerSQLBuilder.SQLLite: TPowerSQLBuilder;
begin
  Self.FSGDBType := dbSQLLite;
  Result := Self;
end;

function TPowerSQLBuilder.Sum(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' sum(').Add(Value).Add(')');
end;

function TPowerSQLBuilder.Sum: TPowerSQLBuilder;
begin
  Result := Add(' sum(');
end;

function TPowerSQLBuilder.SumAs(const Value: String; asValue: String): TPowerSQLBuilder;
begin
  Result := Add(' sum(').Add(Value).Add(') as ').Add( asValue );
end;

function TPowerSQLBuilder.Test(const Value: Int64;Condition: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.TestDate(Value: TDateTime;Condition: String; Mask : String): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd hh:nn:ss';

  Add(' ').Add( Condition ).Add(' ');

  if YearOf(Value) < 1890 then
    Value := 0;

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
        Add( QuotedStr( '0000.00.00 00:00:00' ) )
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Test(const Value: Boolean;Condition: String): TPowerSQLBuilder;
begin
  case Self.FSGDBType of
    dbPostGreSQL: Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, 'true', 'false') );
    dbMySQL, dbSQLLite: Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, '1', '0') );
    dbMsSQL: Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, '1', '0') );
    dbFireBird: Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, 'true', 'false') );
    dbNenhum: Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, 'true', 'false') );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Test(const Value: Integer;Condition: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Test(const Value: String;Condition: String): TPowerSQLBuilder;
begin
  if UpperCase(Value) = 'NULL' then
    Result := Add(' ').Add( Condition ).Add(' ').Add(Value)
  else
    Result := Add(' ').Add( Condition ).Add(' ').AddQuoted(Value);
end;

function TPowerSQLBuilder.Test(const Value: Double; DecimalValue: ShortInt;Condition: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.TestOfDate(Value: TDateTime;Condition: String; Mask : String): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd';

  Add(' ').Add( Condition ).Add(' ');

  if YearOf(Value) < 1890 then
    Value := 0;

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
        Add( QuotedStr( '0000.00.00 00:00:00' ) )
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.TestOfTime(const Value: TDateTime;Seconds: Boolean; Condition: String; Mask : String): TPowerSQLBuilder;
begin
  if Mask = '' then
  begin
    if Seconds then
      Mask := 'hh:mm:ss'
    else
      Mask := 'hh:mm';
  end;

  Add(' ').Add( Condition ).Add(' ');

  case Self.FSGDBType of
    dbPostGreSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbMySQL, dbSQLLite:
    begin
      if DateOf(Value) = 0 then
      begin
        if Seconds then
          Add( QuotedStr( '00:00:00' ) )
        else
          Add( QuotedStr( '00:00' ) )
      end
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
    end;
    dbMsSQL:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbFireBird:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
    dbNenhum:
    begin
      if DateOf(Value) = 0 then
        Add('null')
      else
        Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Update( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add('update ').Add( Value ).Add(' set ');
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value, DecimalValue );
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.Union: TPowerSQLBuilder;
begin
  Result := Add(' union ');
end;

function TPowerSQLBuilder.unique(const Field: String): TPowerSQLBuilder;
begin
  Result := Add(' UNIQUE ( ').AddQuoted( Field ).Add(') ');
end;

function TPowerSQLBuilder.Update: TPowerSQLBuilder;
begin
  Result := Add('update');
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: Int64): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: String; const Value: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Equal( Value, Mask );
end;

function TPowerSQLBuilder.UpField(Field: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Add(' = ');
end;

function TPowerSQLBuilder.UpFieldNull(const Field: String): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).Add( ' = null ' );
end;

function TPowerSQLBuilder.UpFieldOfDate(Field: String; const Value: TDateTime; Mask : String ): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).EqualOfDate( Value, Mask );
end;

function TPowerSQLBuilder.UpFieldOfTime(Field: String; const Value: TDateTime; Seconds: Boolean; Mask : String ): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Field ).EqualOfTime( Value, Seconds, Mask );
end;

function TPowerSQLBuilder.Values: TPowerSQLBuilder;
begin
  Result := Add(' Values (');
end;

function TPowerSQLBuilder.When(Condition: String): TPowerSQLBuilder;
begin
  Result := Add(' when ').Add( Condition );
end;

function TPowerSQLBuilder.When: TPowerSQLBuilder;
begin
  Result := Add(' when');
end;

function TPowerSQLBuilder.Where(const Value, Cast: String): TPowerSQLBuilder;
begin
  Result := Add(' where ').Cast( Value, Cast );
  Self.FWhere := True;
end;

function TPowerSQLBuilder.Where( const Value : String ) : TPowerSQLBuilder;
begin
  Result := Add(' where ').Add( Value );
  Self.FWhere := True;
end;

function TPowerSQLBuilder.Default(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' default ').Field( Value );
end;

function TPowerSQLBuilder.Default(const Value: Double): TPowerSQLBuilder;
begin
  Result := Add(' default ').Field( Value );
end;

function TPowerSQLBuilder.Default(const Value: String): TPowerSQLBuilder;
begin
  Result := Add(' default ').Field( Value );
end;

function TPowerSQLBuilder.Delete: TPowerSQLBuilder;
begin
  Result := Add('delete');
end;

function TPowerSQLBuilder.DeleteFrom: TPowerSQLBuilder;
begin
  Result := Add('delete from');
end;

function TPowerSQLBuilder.Execute( var Connection: TUniConnection): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteUniDacC ) then
    Self.FExecuteUniDacC( Connection );

  Result := Self
end;

function TPowerSQLBuilder.Execute(var Query: TUniQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FExecuteUniDac ) then
    Self.FExecuteUniDac( Query );

  Result := Self;
end;

function TPowerSQLBuilder.Open(var query: TUniQuery): TPowerSQLBuilder;
begin
  if Assigned( Self.FOpenUniDac ) then
    Self.FOpenUniDac( Query );

  Result := Self;
end;

end.
