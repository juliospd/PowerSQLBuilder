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
  TPowerSQLBuilder = class(TObject)
  private
    FValuePSB : WideString;
    FPostGreSQL: Boolean;
    procedure SetPostGreSQL(const Value: Boolean);
  public
    property PostGreSQL : Boolean read FPostGreSQL write SetPostGreSQL;
    // StringBuilder Padrão
    function Add(const Value : WideString) : TPowerSQLBuilder; virtual;
    function AddQuoted(const Value : WideString) : TPowerSQLBuilder; virtual;
    function AddLine(const Value : WideString) : TPowerSQLBuilder; virtual;
    function Equal( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : TDateTime ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Equal( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function EqualOfDate( const Value : TDateTime ) : TPowerSQLBuilder; virtual;
    function EqualOfTime( const Value : TDateTime; Seconds : Boolean = True ) : TPowerSQLBuilder; virtual;
    function Field( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : TDateTime ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function Field( const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function FieldOfDate( const Value : TDateTime ) : TPowerSQLBuilder; virtual;
    function FieldOfTime( const Value : TDateTime; Seconds : Boolean = True ) : TPowerSQLBuilder; virtual;
    function UpField( Field : WideString; const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : TDateTime ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Integer ) : TPowerSQLBuilder; overload; virtual;
    function UpField( Field : WideString; const Value : Boolean ) : TPowerSQLBuilder; overload; virtual;
    function UpFieldOfDate( Field : WideString; const Value : TDateTime ) : TPowerSQLBuilder; virtual;
    function UpFieldOfTime( Field : WideString; const Value : TDateTime; Seconds : Boolean = True ) : TPowerSQLBuilder; virtual;
    function Clear : TPowerSQLBuilder; virtual;
    function GetString : WideString; virtual;
    // Power SQL
    function Insert( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Select : TPowerSQLBuilder; overload; virtual;
    function Select( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function SelectFrom( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Update( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Delete( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function DeleteFrom( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function From( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Where( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Where( const Value : WideString; const Cast : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Order_By( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Desc : TPowerSQLBuilder; virtual;
    function Group_By( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Values : TPowerSQLBuilder; virtual;
    function EndValues : TPowerSQLBuilder; virtual;
    function LeftJoin( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function RightJoin( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function InnerJoin( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function FullJoin( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Limit( const Value : Integer ) : TPowerSQLBuilder; virtual;
    function Like( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Next : TPowerSQLBuilder; virtual;
    function Fields( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function BetWeen( const ValueStart, ValueEnd : TDateTime ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Int64 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Integer ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Double; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeen( const ValueStart, ValueEnd : Currency; DecimalValue : ShortInt = 2 ) : TPowerSQLBuilder; overload; virtual;
    function BetWeenOfDate( const ValueStart, ValueEnd : TDateTime ) : TPowerSQLBuilder; virtual;
    function BetWeenOfTime( const ValueStart, ValueEnd : TDateTime; Seconds : Boolean = True ) : TPowerSQLBuilder; virtual;
    function Cast( Field : WideString; const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Distinct : TPowerSQLBuilder; overload; virtual;
    function Distinct( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function Count : TPowerSQLBuilder; virtual;
    function Max(const Value : WideString ) : TPowerSQLBuilder; virtual;
    function Min(const Value : WideString ) : TPowerSQLBuilder; Virtual;
    //
    function &As( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &NOT( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &OR( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &AND( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &ON( const Value : WideString ) : TPowerSQLBuilder; virtual;
    function &IN : TPowerSQLBuilder;  overload; virtual;
    function &IN( const Value : WideString ) : TPowerSQLBuilder; overload; virtual;
    function &NOT_IN : TPowerSQLBuilder; overload; virtual;
    function &NOT_IN(const Value : WideString ) : TPowerSQLBuilder; overload; virtual;

    constructor Create;
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

function TPowerSQLBuilder.Add(const Value: WideString): TPowerSQLBuilder;
begin
  System.Insert(Value, Self.FValuePSB, Length(Self.FValuePSB)+1);
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

function TPowerSQLBuilder.BetWeen(const ValueStart, ValueEnd: TDateTime ): TPowerSQLBuilder;
begin
  Result := Add(' between ').Field( ValueStart ).Add(' and ').Field( ValueEnd );
end;

function TPowerSQLBuilder.BetWeenOfDate(const ValueStart, ValueEnd: TDateTime ): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfDate( ValueStart ).Add(' and ').FieldOfDate( ValueEnd );
end;

function TPowerSQLBuilder.BetWeenOfTime(const ValueStart, ValueEnd: TDateTime; Seconds : Boolean = True): TPowerSQLBuilder;
begin
  Result := Add(' between ').FieldOfTime( ValueStart, Seconds ).Add(' and ').FieldOfTime( ValueEnd, Seconds );
end;

function TPowerSQLBuilder.Cast(Field: WideString; const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add('cast(').Add(Field).Add(', as ').Add(Value).Add(')');
end;

function TPowerSQLBuilder.Clear: TPowerSQLBuilder;
begin
  Self.FValuePSB := '';
  Result := Self;
end;

function TPowerSQLBuilder.Count: TPowerSQLBuilder;
begin
  Result := Add(' count(*)');
end;

constructor TPowerSQLBuilder.Create;
begin
  Self.FValuePSB := '';
end;

function TPowerSQLBuilder.Desc: TPowerSQLBuilder;
begin
  Result := Add(' Desc');
end;

destructor TPowerSQLBuilder.Destroy;
begin
  Self.FValuePSB := '';
  inherited;
end;

function TPowerSQLBuilder.Distinct( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Distinct ').Add( Value );
end;

function TPowerSQLBuilder.Distinct: TPowerSQLBuilder;
begin
  Result := Add(' Distinct');
end;

function TPowerSQLBuilder.Equal(const Value: TDateTime ): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' = null ')
    else
      Add(' = ').Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd hh:nn:ss', Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add(' = ').Add( QuotedStr( '0000.00.00 00:00:00' ) )
    else
      Add(' = ').Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd hh:nn:ss', Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Equal(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' = ').AddQuoted(Value);
end;

function TPowerSQLBuilder.Equal(const Value: Double; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' = ').Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.Equal(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' = ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.EndValues: TPowerSQLBuilder;
begin
  Result := Add(')');
end;

function TPowerSQLBuilder.Equal(const Value: Boolean): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
    Add(' = ').Add( IfThen(Value, 'true', 'false') )
  else
    Add(' = ').Add( IfThen(Value, '1', '0') );

  Result := Self;
end;

function TPowerSQLBuilder.Equal(const Value: Int64): TPowerSQLBuilder;
begin
  Result := Add(' = ').Add( IntToStr( Value ) );
end;

function TPowerSQLBuilder.Equal(const Value: Currency; DecimalValue: ShortInt): TPowerSQLBuilder;
begin
  Result := Add(' = ').Add( StringReplace(FormatFloat('#0.' + Format('%.' + IntToStr(DecimalValue) +'d', [0]), Value ),',','.',[rfReplaceAll]) );
end;

function TPowerSQLBuilder.EqualOfDate(const Value: TDateTime): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' = null ')
    else
      Add(' = ').Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd', Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add(' = ').Add( QuotedStr( '0000.00.00' ) )
    else
      Add(' = ').Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd', Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.EqualOfTime(const Value: TDateTime; Seconds : Boolean): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add(' = null ')
    else
    begin
      if Seconds then
        Add(' = ').Add( QuotedStr( FormatDateTime( 'hh:mm.ss', Value ) ) )
      else
        Add(' = ').Add( QuotedStr( FormatDateTime( 'hh:mm', Value ) ) )
    end;
  end
  else
  begin
    if DateOf(Value) = 0 then
    begin
      if Seconds then
        Add(' = ').Add( QuotedStr( '00:00:00' ) )
      else
        Add(' = ').Add( QuotedStr( '00:00' ) )
    end
    else
    begin
      if Seconds then
        Add(' = ').Add( QuotedStr( FormatDateTime( 'hh:mm:ss', Value ) ) )
      else
        Add(' = ').Add( QuotedStr( FormatDateTime( 'hh:mm', Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Field(const Value: TDateTime): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
      Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd hh:nn:ss', Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add( QuotedStr( '0000.00.00 00:00:00' ) )
    else
      Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd hh:nn:ss', Value ) ) );
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

function TPowerSQLBuilder.FieldOfDate(const Value: TDateTime): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
      Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd', Value ) ) );
  end
  else
  begin
    if DateOf(Value) = 0 then
      Add( QuotedStr( '0000.00.00' ) )
    else
      Add( QuotedStr( FormatDateTime( 'yyyy.mm.dd', Value ) ) );
  end;

  Result := Self;
end;

function TPowerSQLBuilder.FieldOfTime(const Value: TDateTime; Seconds: Boolean): TPowerSQLBuilder;
begin
  if Self.FPostGreSQL then
  begin
    if DateOf(Value) = 0 then
      Add('null')
    else
    begin
      if Seconds then
        Add( QuotedStr( FormatDateTime( 'hh:mm.ss', Value ) ) )
      else
        Add( QuotedStr( FormatDateTime( 'hh:mm', Value ) ) )
    end;
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
    begin
      if Seconds then
        Add( QuotedStr( FormatDateTime( 'hh:mm:ss', Value ) ) )
      else
        Add( QuotedStr( FormatDateTime( 'hh:mm', Value ) ) );
    end;
  end;

  Result := Self;
end;

function TPowerSQLBuilder.Fields(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' (').Add( Value ).EndValues;
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
  Result := Self.FValuePSB;
end;

function TPowerSQLBuilder.&AND( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' and ').Add( Value );
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

function TPowerSQLBuilder.Like(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' like ').AddQuoted( Trim(Value) + '%' );
end;

function TPowerSQLBuilder.Limit(const Value: Integer): TPowerSQLBuilder;
begin
  Result := Add(' limit ').Field(Value);
end;

function TPowerSQLBuilder.Max(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' max(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Min(const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' min(').Add( Value ).EndValues
end;

function TPowerSQLBuilder.Next: TPowerSQLBuilder;
begin
  Result := Add(', ');
end;

function TPowerSQLBuilder.&OR( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' or ').Add( Value );
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

function TPowerSQLBuilder.RightJoin( const Value: WideString): TPowerSQLBuilder;
begin
  Result := Add(' Right Join ').Add( Value );
end;

function TPowerSQLBuilder.Select( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add('select ').Add( Value );
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

function TPowerSQLBuilder.UpField(Field: WideString; const Value: TDateTime ): TPowerSQLBuilder;
begin
  Result := Add( Field ).Equal( Value );
end;

function TPowerSQLBuilder.UpFieldOfDate(Field: WideString; const Value: TDateTime ): TPowerSQLBuilder;
begin
  Result := Add( Field ).EqualOfDate( Value );
end;

function TPowerSQLBuilder.UpFieldOfTime(Field: WideString; const Value: TDateTime; Seconds: Boolean): TPowerSQLBuilder;
begin
  Result := Add( Field ).EqualOfTime( Value, Seconds );
end;

function TPowerSQLBuilder.Values: TPowerSQLBuilder;
begin
  Result := Add(' Values (');
end;

function TPowerSQLBuilder.Where(const Value, Cast: WideString): TPowerSQLBuilder;
begin
  Result := Add(' where ').Cast( Value, Cast );
end;

function TPowerSQLBuilder.Where( const Value : WideString ) : TPowerSQLBuilder;
begin
  Result := Add(' where ').Add( Value );
end;

end.
