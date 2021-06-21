create table if not exists funcionarios (
	id serial,
	nome varchar(50),
	gerente integer,
	primary key (id),
	foreign key (gerente) references funcionarios (id)
);

insert into funcionarios (nome, gerente) values ('Ancelmo', null);
insert into funcionarios (nome, gerente) values ('Beatriz', 1);
insert into funcionarios (nome, gerente) values ('Magno', 1);
insert into funcionarios (nome, gerente) values ('Cremilda', 2);
insert into funcionarios (nome, gerente) values ('Wagner', 4);

select id, nome, gerente from funcionarios where gerente is null
union all
select id, nome, gerente from funcionarios where id = 2 or id = 3; --Apenas para exemplificar

create or replace recursive view vw_func (id, gerente, funcionario) as (
	select id, gerente, nome
	from funcionarios
	where gerente is null
	union all
	select 
	funcionarios.id, 
	funcionarios.gerente, 
	funcionarios.nome
	from funcionarios
	join vw_func on vw_func.id = funcionarios.gerente
);

select id, gerente, funcionario from vw_func;


-- DESAFIO SUBSTITUIR CÓDIGO DO GERENTE POR SEU NOME:
create or replace view vw_func_e_gerentes (id_func, nome, gerente) as (
	select vw_func.id, 
			vw_func.funcionario, 
			funcionarios.nome
	from vw_func
	left join funcionarios on vw_func.gerente = funcionarios.id
);

select id_func, nome, gerente from vw_func_e_gerentes;


