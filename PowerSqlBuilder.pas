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
  System.SysUtils, System.Classes, System.StrUtils, System.DateUtils;

type
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
    FPostGreSQL: Boolean;
    FWhere : Boolean;

    function Test( const Value : WideString; Condition : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Double; DecimalValue : ShortInt = 2; Condition : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Currency; DecimalValue : ShortInt = 2; Condition : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : TDateTime; Condition : WideString; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Int64; Condition : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Integer; Condition : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Test( const Value : Boolean; Condition : WideString ) : TPowerSQLBuilder; overload; virtual;
    function TestOfDate( const Value : TDateTime; Condition : WideString; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function TestOfTime( const Value : TDateTime; Seconds : Boolean = True; Condition : WideString = ''; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;

    procedure SetPostGreSQL(const Value: Boolean);
  public
    property PostGreSQL : Boolean read FPostGreSQL write SetPostGreSQL;
    // Funções simples
    function Add(const Value : WideString) : TPowerSQLBuilder; virtual;
    function AddQuoted(const Value : WideString) : TPowerSQLBuilder; virtual;
    function AddLine(const Value : WideString) : TPowerSQLBuilder; virtual;
    function Clear : TPowerSQLBuilder; virtual;
    function GetString : WideString; virtual;
    // Teste de Igual a
    function Equal( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function EqualOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function EqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Maior que
    function Major( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Major( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MajorOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function MajorOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Maior igual
    function MajorEqual( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqual( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MajorEqualOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function MajorEqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Menor que
    function Minor( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Minor( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MinorOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function MinorOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Menor Igual
    function MinorEqual( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqual( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function MinorEqualOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function MinorEqualOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Teste de Diferença que
    function Different( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Different( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function DifferentOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function DifferentOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Field usado na inserção
    function Field( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function FieldOfDate( const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function FieldOfTime( const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Campo e valor usado no Update
    function UpField( Field : WideString; const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function UpFieldOfDate( Field : WideString; const Value : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function UpFieldOfTime( Field : WideString; const Value : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    // Power SQL
    function Insert( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Select : TPowerSQLBuilder; overload; virtual;
    function Select( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function SelectFrom : TPowerSQLBuilder; overload; virtual;
    function SelectFrom( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Update( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Delete( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function DeleteFrom( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function From( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function From : TPowerSQLBuilder; overload; virtual;
    function Where( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Where( const Value : WideString; const Cast : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Order_By : TPowerSQLBuilder; overload; virtual;
    function Order_By( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Desc : TPowerSQLBuilder; virtual;
    function Group_By( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Values : TPowerSQLBuilder; virtual;
    function EndValues : TPowerSQLBuilder; virtual;
    function Sum( const Value : WideString ) : TPowerSQLBuilder;  virtual;
    function SumAs( const Value : WideString; asValue : WideString ) : TPowerSQLBuilder; virtual;
    /// <summary>
    /// sP : Abre um Parentese Start Parent '('
    /// </summary>
    function sP : TPowerSQLBuilder; virtual;
    /// <summary>
    /// eP : Fecha um Parentese end parent ')'
    /// </summary>
    function eP : TPowerSQLBuilder; virtual;
    function LeftJoin( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function LeftJoin : TPowerSQLBuilder; overload; virtual;
    function RightJoin( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function RightJoin : TPowerSQLBuilder; overload; virtual;
    function InnerJoin( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function InnerJoin : TPowerSQLBuilder; overload; virtual;
    function FullJoin( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function FullJoin : TPowerSQLBuilder; overload; virtual;
    function Limit( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Limit( const pag1, pag2 : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Like( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Next : TPowerSQLBuilder; virtual;
    function Fields( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function BetWeen( const ValueStart, ValueEnd : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Integer ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeenOfDate( const ValueStart, ValueEnd : TDateTime; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function BetWeenOfTime( const ValueStart, ValueEnd : TDateTime; Seconds : Boolean = True; Mask : WideString = '' ) : TPowerSQLBuilder; virtual;
    function Cast( Field : WideString; const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Distinct : TPowerSQLBuilder; overload; virtual;
    function Distinct( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Count : TPowerSQLBuilder; virtual;
    function CountAs( const asValue : WideString ) : TPowerSQLBuilder; virtual;
    function Max(const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Min(const Value : WideString ) : TPowerSQLBuilder; Virtual;
    function AlterTable(const Value : WideString ) : TPowerSQLBuilder; virtual;
    function AutoIncrement(const Value : Integer ) : TPowerSQLBuilder; virtual;
    function EndIn : TPowerSQLBuilder; virtual;
    //
    function &As( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &Not( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &Or( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &And( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &On( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &In : TPowerSQLBuilder;  overload; virtual;
    function &In( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function &Not_In : TPowerSQLBuilder; overload; virtual;
    function &Not_In(const Value : WideString ) : TPowerSQLBuilder; overload; virtual;

    constructor Create; virtual;
    destructor Destroy; override;
  end;

implementation

{ TPowerSQLBuilder }

function TPowerSQLBuilder.&ON(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' on (').Add( Value ).EndValues;
end;

function TPowerSQLBuilder.&IN(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' in (').Add( Value );
end;

function TPowerSQLBuilder.InnerJoin: TPowerSQLBuilder;
begin
  Result := Add(' Inner Join ');
end;

function TPowerSQLBuilder.&NOT_IN(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' not in (').Add( Value );
end;

function TPowerSQLBuilder.&IN: TPowerSQLBuilder;
begin
  Result := Add(' in (');
end;

function TPowerSQLBuilder.&As(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' as ').Add( Value );
end;

function TPowerSQLBuilder.AutoIncrement(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' auto_increment ').Equal( Value );
end;

function TPowerSQLBuilder.Add(const Value: WideString): TPowerSQLBuilder;
begin
  Self.FValuePSB.Append( Value );
  Result := Self;
end;

function TPowerSQLBuilder.AddLine(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add( Value ).Add( #10 );
end;

function TPowerSQLBuilder.AddQuoted( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add( QuotedStr( Value ) );
end;

function TPowerSQLBuilder.AlterTable(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' alter table ').Add( value );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart, DecimalValue ).Add(' and ').Field( ValueEnd, DecimalValue );
end;

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: Currency; DecimalValue: ShortInt): TPowerSQLBuilder;
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

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart, Mask ).Add(' and ').Field( ValueEnd, Mask );
end;

function TPowerSQLBuilder.BetWeenOfDate(const ValueStart, ValueEnd: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfDate( ValueStart, Mask ).Add(' and ').FieldOfDate( ValueEnd, Mask );
end;

function TPowerSQLBuilder.BetWeenOfTime(const ValueStart, ValueEnd: TDateTime; Seconds : Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfTime( ValueStart, Seconds, Mask ).Add(' and ').FieldOfTime( ValueEnd, Seconds, Mask );
end;

function TPowerSQLBuilder.Cast(Field: WideString; const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add('cast(').Add(Field).Add(', as ').Add(Value).Add(')');
end;

function TPowerSQLBuilder.Clear: TPowerSQLBuilder;
begin
  Self.FValuePSB.Clear;
  Self.FWhere := False;
  Result := Self;
end;

function TPowerSQLBuilder.CountAs(const asValue: WideString): TPowerSQLBuilder;
begin
  Result := Add(' count(*) as ').Add( asValue );
end;

function TPowerSQLBuilder.Count: TPowerSQLBuilder;
begin
  Result := Add(' count(*)');
end;

constructor TPowerSQLBuilder.Create;
begin
  Self.FValuePSB := TStringBuilder.Create;
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

function TPowerSQLBuilder.Different(const Value: Currency;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<>');
end;

function TPowerSQLBuilder.Different(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<>');
end;

function TPowerSQLBuilder.Different(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>' );
end;

function TPowerSQLBuilder.Different(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '<>', Mask );
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

function TPowerSQLBuilder.DifferentOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<>', Mask );
end;

function TPowerSQLBuilder.DifferentOfTime(const Value: TDateTime;Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds,  '<>', Mask );
end;

function TPowerSQLBuilder.Distinct(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Distinct ').Add( Value );
end;

function TPowerSQLBuilder.Distinct: TPowerSQLBuilder;
begin
  Result := Add(' Distinct');
end;

function TPowerSQLBuilder.Equal(const Value: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Test( Value, '=', Mask);
end;

function TPowerSQLBuilder.Equal(const Value: WideString): TPowerSQLBuilder;
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

function TPowerSQLBuilder.EndValues: TPowerSQLBuilder;
begin
  Result := eP;
end;

/// <summary>
///   End Parent ')'
/// </summary>
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

function TPowerSQLBuilder.Equal(const Value: Currency; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '=' );
end;

function TPowerSQLBuilder.EqualOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '=', Mask );
end;

function TPowerSQLBuilder.EqualOfTime(const Value: TDateTime; Seconds : Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '=', Mask );
end;

function TPowerSQLBuilder.Field(const Value: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd hh:nn:ss';

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
      Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add( QuotedStr( '0000.00.00 00:00:00' ) )
    else
      Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Field(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Field(const Value: Boolean): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
    Add( IfThen(Value, 'true', 'false') )
  else
    Add( IfThen(Value, '1', '0') );

  Result := Self;
end;

function TPowerSQLBuilder.Field(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Field(const Value: Currency; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.FieldOfDate(const Value: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd';

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
      Add( QuotedStr( FormatDateTime(Mask, Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add( QuotedStr( '0000.00.00' ) )
    else
      Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.FieldOfTime(const Value: TDateTime; Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  if Mask = '' then
  begin
    if Seconds then
      Mask := 'hh:mm:ss'
    else
      Mask := 'hh:mm'
  end;

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
      Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
  end
  else
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

  Result := Self;
end;

function TPowerSQLBuilder.Fields(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' (').Add( Value ).EndValues;
end;

function TPowerSQLBuilder.From: TPowerSQLBuilder;
begin
  Result := Add(' from ');
end;

function TPowerSQLBuilder.FullJoin: TPowerSQLBuilder;
begin
  Result := Add(' full join ');
end;

function TPowerSQLBuilder.Field(const Value: WideString): TPowerSQLBuilder;
begin
  Result := AddQuoted(Value);
end;

function TPowerSQLBuilder.Field(const Value: Double; DecimalValue : ShortInt): TPowerSQLBuilder;
begin
  Result := Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.GetString: WideString;
begin
  Result := Self.FValuePSB.ToString;
end;

function TPowerSQLBuilder.&AND( const Value : WideString ) : TPowerSQLBuilder;
begin
  if not Self.FWhere then
  begin
    Result := Add(' where ').Add( Value );
    Self.FWhere := True;
  end
  else Result := Add(' and ').Add( Value );
end;

function TPowerSQLBuilder.Delete( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('delete ').Add( Value );
end;

function TPowerSQLBuilder.DeleteFrom( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('delete from ').Add( Value );
end;

function TPowerSQLBuilder.From( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' from ').Add( Value );
end;

function TPowerSQLBuilder.FullJoin( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' full join ').Add( Value );
end;

function TPowerSQLBuilder.Group_By( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' group by ').Add( Value );
end;

function TPowerSQLBuilder.InnerJoin( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Inner Join ').Add( Value );
end;

function TPowerSQLBuilder.Insert( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('insert into ').Add( Value );
end;

function TPowerSQLBuilder.LeftJoin( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Left Join ').Add( Value );
end;

function TPowerSQLBuilder.LeftJoin: TPowerSQLBuilder;
begin
  Result := Add(' Left Join ');
end;

function TPowerSQLBuilder.Like(const Value: WideString): TPowerSQLBuilder;
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

function TPowerSQLBuilder.Major(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '>');
end;

function TPowerSQLBuilder.Major(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '>', Mask);
end;

function TPowerSQLBuilder.Major(const Value: Currency;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '>');
end;

function TPowerSQLBuilder.MajorEqual(const Value: WideString): TPowerSQLBuilder;
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

function TPowerSQLBuilder.MajorEqual(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '>=', Mask);
end;

function TPowerSQLBuilder.MajorEqual(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '>=');
end;

function TPowerSQLBuilder.MajorEqual(const Value: Currency;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '>=');
end;

function TPowerSQLBuilder.MajorEqualOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '>=', Mask);
end;

function TPowerSQLBuilder.MajorEqualOfTime(const Value: TDateTime;Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '>=', Mask);
end;

function TPowerSQLBuilder.MajorOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '>', Mask);
end;

function TPowerSQLBuilder.MajorOfTime(const Value: TDateTime;Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '>', Mask);
end;

function TPowerSQLBuilder.Max(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' max(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Min(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' min(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Minor(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '<', Mask);
end;

function TPowerSQLBuilder.Minor(const Value: Currency;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<');
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

function TPowerSQLBuilder.Minor(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '<');
end;

function TPowerSQLBuilder.MinorEqual(const Value: WideString): TPowerSQLBuilder;
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

function TPowerSQLBuilder.MinorEqual(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=', Mask);
end;

function TPowerSQLBuilder.MinorEqual(const Value: Currency;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: Double;DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Test( Value, DecimalValue, '<=');
end;

function TPowerSQLBuilder.MinorEqual(const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Test( Value, '<=');
end;

function TPowerSQLBuilder.MinorEqualOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<=', Mask);
end;

function TPowerSQLBuilder.MinorEqualOfTime(const Value: TDateTime;Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '<=', Mask);
end;

function TPowerSQLBuilder.MinorOfDate(const Value: TDateTime; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfDate( Value, '<', Mask);
end;

function TPowerSQLBuilder.MinorOfTime(const Value: TDateTime;Seconds: Boolean; Mask : WideString): TPowerSQLBuilder;
begin
  Result := TestOfTime( Value, Seconds, '<', Mask);
end;

function TPowerSQLBuilder.Next: TPowerSQLBuilder;
begin
  Result := Add(', ');
end;

function TPowerSQLBuilder.&OR( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' or ').Add( Value );
end;

function TPowerSQLBuilder.Order_By: TPowerSQLBuilder;
begin
  Result := Add(' order by ');
end;

function TPowerSQLBuilder.&NOT( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' not ').Add( Value );
end;

function TPowerSQLBuilder.NOT_IN: TPowerSQLBuilder;
begin
  Result := Add(' not in (')
end;

function TPowerSQLBuilder.Order_By( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' order by ').Add( Value );
end;

function TPowerSQLBuilder.RightJoin: TPowerSQLBuilder;
begin
  Result := Add(' Right Join ');
end;

function TPowerSQLBuilder.RightJoin( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Right Join ').Add( Value );
end;

function TPowerSQLBuilder.Select( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('select ').Add( Value );
end;

function TPowerSQLBuilder.SelectFrom: TPowerSQLBuilder;
begin
  Result := Add('select * from ');
end;

function TPowerSQLBuilder.Select: TPowerSQLBuilder;
begin
  Result := Add('select ');
end;

function TPowerSQLBuilder.SelectFrom( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('select * from ').Add( Value );
end;

procedure TPowerSQLBuilder.SetPostGreSQL(const Value: Boolean);
begin
  FPostGreSQL := Value;
end;

/// <summary>
///   Start Parent '('
/// </summary>
function TPowerSQLBuilder.sP: TPowerSQLBuilder;
begin
  Result := Add('(')
end;

function TPowerSQLBuilder.Sum(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' sum(').Add(Value).Add(')');
end;

function TPowerSQLBuilder.SumAs(const Value: WideString; asValue: WideString): TPowerSQLBuilder;
begin
  Result := Add(' sum(').Add(Value).Add(') as ').Add( asValue );
end;

function TPowerSQLBuilder.Test(const Value: Int64;Condition: WideString): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Test(const Value: TDateTime;Condition: WideString; Mask : WideString): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd hh:nn:ss';

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' ').Add( Condition ).Add(' ').Add('null')
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( '0000.00.00 00:00:00' ) )
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Test(const Value: Boolean;Condition: WideString): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
    Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, 'true', 'false') )
  else
    Add(' ').Add( Condition ).Add(' ').Add( IfThen(Value, '1', '0') );

  Result := Self;
end;

function TPowerSQLBuilder.Test(const Value: Integer;Condition: WideString): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Test(const Value: Currency;DecimalValue: ShortInt; Condition: WideString): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.Test(const Value: WideString;Condition: WideString): TPowerSQLBuilder;
begin
  if UpperCase(Value) = 'NULL' then
    Result := Add(' ').Add( Condition ).Add(' ').Add(Value)
  else
    Result := Add(' ').Add( Condition ).Add(' ').AddQuoted(Value);
end;

function TPowerSQLBuilder.Test(const Value: Double; DecimalValue: ShortInt;Condition: WideString): TPowerSQLBuilder;
begin
  Result := Add(' ').Add( Condition ).Add(' ').Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.TestOfDate(const Value: TDateTime;Condition: WideString; Mask : WideString): TPowerSQLBuilder;
begin
  if Mask = '' then
    Mask := 'yyyy.mm.dd';

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' ').Add( Condition ).Add(' ').Add('null')
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( '0000.00.00' ) )
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.TestOfTime(const Value: TDateTime;Seconds: Boolean; Condition: WideString; Mask : WideString): TPowerSQLBuilder;
begin
  if Mask = '' then
  begin
    if Seconds then
      Mask := 'hh:mm:ss'
    else
      Mask := 'hh:mm';
  end;

  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' ').Add( Condition ).Add(' ').Add('null')
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
  end
  else
  begin
    if DateOf(Value) = 0 then
    begin
      if Seconds then
        Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( '00:00:00' ) )
      else
        Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( '00:00' ) )
    end
    else
      Add(' ').Add( Condition ).Add(' ').Add( QuotedStr( FormatDateTime( Mask, Value ) ) )
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Update( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('update ').Add( Value ).Add(' set ');
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: Currency; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value, DecimalValue );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value, DecimalValue );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: Boolean): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: Int64): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpField(Field: WideString; const Value: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value, Mask );
end;

function TPowerSQLBuilder.UpFieldOfDate(Field: WideString; const Value: TDateTime; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Add( Field ).EqualOfDate( Value, Mask );
end;

function TPowerSQLBuilder.UpFieldOfTime(Field: WideString; const Value: TDateTime; Seconds: Boolean; Mask : WideString ): TPowerSQLBuilder;
begin
  Result := Add( Field ).EqualOfTime( Value, Seconds, Mask );
end;

function TPowerSQLBuilder.Values: TPowerSQLBuilder;
begin
  Result := Add(' Values (');
end;

function TPowerSQLBuilder.Where(const Value, Cast: WideString): TPowerSQLBuilder;
begin
  Result := Add(' where ').Cast( Value, Cast );
  Self.FWhere := True;
end;

function TPowerSQLBuilder.Where( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' where ').Add( Value );
  Self.FWhere := True;
end;

end.
