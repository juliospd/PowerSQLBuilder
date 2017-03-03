# PowerSQLBuilder

PowerSQLBuilder é uma classe de manipulação SQL

Chega de ficar concatenando pedaços do texto gerando um scripts SQL manual
E muita das vezes falho, através do PowerSQLBuilder você apenas chama os
comandos SQL que ele mesmo interpreta e gera o scripts SQL automaticamente.
  
   Mais o que torna ele ágil é a possibilidade de passar parâmetros sem se preocupar
   com seu tipo de origem o PowerSQLBulder faz isso automaticamente para você.
   interpleta e gera o scripts SQL automaticamente

PowerSQLBuilder - Delphi single units with 2 class TPowerSQLBuilder and TSQLQuery.

Exemplo de um Select :

  SQL.SelectFrom('pessoa').where('idade').MajorEqual(18).&And('nome').like('Maria');
  
Mais as maiores vantagens são os comandos Insert e UPDate.

Exemplo de um Insert : Tipos dos campos  "Integer, Int64, WideString, Double, Currency, TDateTime e Boolean".

  SQL.Insert('clientes').Fields( Model.Fields ).Values;
  SQL.Field( Model.Nome ).Next;  
  SQL.Field( Model.Endereco ).Next;
  SQL.Field( Model.Bairro ).Next;
  SQL.Field( Model.Cep ).Next;
  SQL.Field( Model.Estado ).Next;
  SQL.Field( Model.Salario ).Next;
  SQL.Field( Model.Data_nascimento ).Next;   <-- Não precisa se preocupar com Tipos 
  SQL.Field( Model.Dependentes ).EndValues;
  
Exemplo de um Update :
  
  SQL.Update('clientes').UpField('nome', Model.Nome ).Where('id').Equal( Model.ID );
