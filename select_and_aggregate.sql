select numero, nome, ativo from banco;
select banco_numero, numero, nome from agencia;
select numero, nome, email from cliente;
select id, nome from tipo_transacao;
select banco_numero, agencia_numero, numero, cliente_numero from conta_corrente;
select banco_numero, agencia_numero, cliente_numero from cliente_transacoes;

select * from cliente_transacoes;

select * from information_schema.columns where table_name = 'banco';
select column_name, data_type from information_schema.columns where table_name = 'banco';