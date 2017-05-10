# PowerSQLBuilder

PowerSQLBuilder é uma classe de manipulação SQL

Chega de ficar concatenando pedaços do texto gerando um scripts SQL manual
E muita das vezes falho, através do PowerSQLBuilder você apenas chama os
comandos SQL que ele mesmo interpreta e gera o scripts SQL automaticamente.
  
   Mais o que torna ele ágil é a possibilidade de passar parâmetros sem se preocupar
   com seu tipo de origem o PowerSQLBulder faz isso automaticamente para você.
   interpleta e gera o scripts SQL automaticamente

Exemplo de um select entre 2 tabelas virtuais :

SQL.Select('basic.*, par.*').From;
  SQL.sP.Select('A.IDCLIFOR, A.DIGITOTITULO, A.DTMOVIMENTO, A.DTVENCIMENTO, A.IDTITULO, ');
    SQL.Add('A.VALTITULO, A.OBSTITULO, B.DTPAGAMENTO, B.VALPAGAMENTOTITULO, A.FLAGBAIXADA ').From('contas_pagar a');
    SQL.LeftJoin('CONTAS_PAGAR_BAIXAS b')
    SQL.&On('b.IDCLIFOR = a.IDCLIFOR and b.IDTITULO = a.IDTITULO and b.DIGITOTITULO = a.DIGITOTITULO');
    SQL.Order_By('a.IDCLIFOR, a.IDTITULO, a.DTMOVIMENTO, a.DIGITOTITULO');
  SQL.eP.&As('basic').LeftJoin;
  SQL.sP.Select('A.IDCLIFOR, Max(A.DIGITOTITULO) as ParFim, A.DTMOVIMENTO, A.IDTITULO');
    SQL.From('contas_pagar a').Group_By('A.IDCLIFOR, A.DTMOVIMENTO, A.IDTITULO');
  SQL.eP.&As('par');
  SQL.&On('par.IDCLIFOR = basic.IDCLIFOR and par.DTMOVIMENTO = basic.DTMOVIMENTO and par.IDTITULO = basic.IDTITULO');
  SQL.Order_By('basic.IDCLIFOR, basic.IDTITULO, basic.DTMOVIMENTO, basic.DIGITOTITULO'); 

PowerSQLBuilder - Delphi single units with 2 class TPowerSQLBuilder and TSQLQuery.

Unidade simples de Exemplo : 

Teste.dpr 
# Apenas de ilustração para demonstrar como aplicar o PowerSQLBuilder no seu dia a dia.
