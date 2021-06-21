select numero,nome,ativo from banco;

create or replace view vw_bancos as (
	select numero, nome, ativo
	from banco
);

select numero,nome,ativo from vw_bancos;

create or replace view vw_bancos_2 (banco_numero, banco_nome, banco_ativo) as (
	select numero, nome, ativo from banco
);

select banco_numero, banco_nome, banco_ativo from vw_bancos_2;

insert into vw_bancos_2 (banco_numero, banco_nome, banco_ativo)
values (51, 'Banco Boa Ideia', true);

select banco_numero, banco_nome, banco_ativo from vw_bancos_2
where banco_numero = 51;
select numero, nome, ativo from banco
where numero = 51;

update vw_bancos_2 set banco_ativo = false where banco_numero = 51;

delete from vw_bancos_2 where banco_numero = 51;

create or replace temp view vw_agencia as (
	select nome from agencia
);

select nome from vw_agencia;

create or replace view vw_bancos_ativos as (
	select numero, nome, ativo
	from banco
	where ativo = true
);

insert into vw_bancos_ativos (numero, nome, ativo) values (51, 'Banco Boa Ideia', false);

create or replace view vw_bancos_com_a as (
	select numero, nome, ativo
	from vw_bancos_ativos
	where nome ilike 'a%'
) with cascaded check option;

select numero, nome, ativo from vw_bancos_com_a;

insert into vw_bancos_com_a (numero, nome, ativo) values (333, 'Alfa Omega', true);
insert into vw_bancos_com_a (numero, nome, ativo) values (331, 'Alfa Gama', false);
insert into vw_bancos_com_a (numero, nome, ativo) values (332, 'Alfa Gama Beta', false);