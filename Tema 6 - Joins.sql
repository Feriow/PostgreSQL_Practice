table nivel;

create table curso2 (
	codigocurso int primary key,
	nome varchar(90) not null unique,
	datacriacao date null,
	codigonivel int null, 
	foreign key (codigonivel) references nivel (codigonivel)
);

table curso2;

INSERT INTO NIVEL (CODIGONIVEL, DESCRICAO) VALUES
(1,'Graduação'),
(2,'Especialização'),
(3,'Mestrado'),
(4,'Doutorado');

INSERT INTO CURSO2 (CODIGOCURSO,NOME,DATACRIACAO,CODIGONIVEL) VALUES 
(1,'Sistemas de Informação','19/06/1999',1),
(2,'Medicina','10/05/1990',1),
(3,'Nutrição','19/02/2012',NULL),
(4,'Pedagogia','19/06/1999',1),
(5,'Saúde da Família','10/09/1999',3),
(6,'Computação Aplicada','10/09/1999',NULL);

table curso2;

SELECT * FROM CURSO2, NIVEL;
/*
O resultado da consulta anterior é uma tabela - em memória principal - originada da operação de produto cartesiano. 
Nessa operação, o sistema gerenciador de banco de dados (SGBD) combinou cada linha da tabela CURSO com cada 
registro da tabela NIVEL.

Note que a quantidade de (seis) colunas na tabela resultante é a soma das colunas das tabelas envolvidas. 
De forma semelhante, a quantidade (vinte e quatro) de registros da tabela é igual ao produto entre o número de 
linhas de CURSO e NIVEL.

Perceba que, ao longo do nosso estudo, temos interpretado cada linha de uma tabela como sendo um fato registrado 
no banco de dados, correspondendo a uma realidade do contexto do negócio sendo modelado.

Exemplo: ao visualizarmos o conteúdo da tabela NIVEL, afirmamos que há quatro registros ou ocorrências de nível 
no banco de dados. De forma semelhante, há seis cursos cadastrados na tabela CURSO.

No entanto, o mesmo raciocínio não pode ser aplicado à tabela resultante da consulta, já que temos todas as 
combinações possíveis entre as linhas, além de envolver todas as colunas das tabelas CURSO e NIVEL.

Há outra maneira de obtermos os mesmos resultados de SELECT * FROM CURSO2, NIVEL;?

Sim. Basta executar o código equivalente: SELECT * FROM CURSO2 CROSS JOIN NIVEL;
*/
-- JUNÇÃO INTERNA
select * from curso2 cross join nivel;

-- Para recuperar as linhas que correspondem à realidade cadastrada no banco de dados, você pode executar o 
-- comando a seguir:
select * from curso2,nivel where curso2.codigonivel = nivel.codigonivel;

/* Perceba que foram recuperadas as linhas que de fato relacionam cursos aos seus respectivos níveis. 
No entanto, a forma mais usada para retornar os mesmos resultados é com o auxílio da cláusula de junção 
interna, o qual possui sintaxe básica conforme a seguir: */
select * from curso2
inner join nivel
on (curso2.codigonivel = nivel.codigonivel);

/* Note também que é possível declarar a cláusula USING especificando a coluna alvo da junção. No caso do 
nosso exemplo, a coluna CODIGONIVEL. A consulta pode ser reescrita conforme a seguir: */
select * from curso2
inner join nivel
using (codigonivel);

-- NATURAL JOIN => Retorna o mesmo do código anterior quando a PK e a FK tem o mesmo nome:
select * from curso2 natural join nivel;

/* Se desejarmos exibir o código e o nome do curso, além do código e o nome do nível, podemos, então executar 
o código a seguir: */
SELECT CURSO2.CODIGOCURSO, CURSO2.NOME, nivel.codigonivel, nivel.descricao
FROM CURSO2 INNER JOIN NIVEL USING(CODIGONIVEL);

/* Perceba que, no comando SELECT, usamos uma referência mais completa: NOMETABELA.NOMECOLUNA. Essa referência 
só é obrigatória para a coluna CODIGONIVEL, uma vez que é necessário especificar de qual tabela o SGBD irá 
buscar os valores. No entanto, em termos de organização de código, é interessante usar esse tipo de referência 
para cada coluna.
Finalmente, observe que poderíamos também, no contexto da consulta, renomear as tabelas envolvidas, deixando o 
código mais elegante e legível, conforme a seguir: */
select c.codigocurso, c.nome, n.codigonivel, n.descricao
from curso2 c inner join nivel n
using (codigonivel);
/* O resultado de uma junção interna corresponde somente aos registros que atendem à condição da junção, 
ou seja, os registros que de fato estão relacionados no contexto das tabelas envolvidas. */ 

/* Junção externa
O resultado da consulta anterior exibe somente os cursos para os quais há registro de informação sobre o nível 
associado a eles. E se quiséssemos incluir na listagem todos os registros da tabela CURSO?

Para incluir no resultado da consulta todas as ocorrências da tabela CURSO, podemos usar a cláusula 
LEFT JOIN (junção à esquerda). Nesse tipo de junção, o resultado contém todos os registros da tabela declarada 
à esquerda da cláusula JOIN, mesmo que não haja registros correspondentes na tabela da direita. Em especial, 
quando não há correspondência, os resultados são retornados com o valor NULL. */

SELECT C.CODIGOCURSO, C.NOME,
N.CODIGONIVEL, N.DESCRICAO
FROM CURSO2 C LEFT JOIN NIVEL N ON (N.CODIGONIVEL=C.CODIGONIVEL);

/* Observe que o número de linhas do resultado da consulta coincide com o número de linhas da tabela CURSO, 
visto que todos os registros dessa tabela fazem parte do resultado e a chave estrangeira que implementa o 
relacionamento está localizada na tabela CURSO. Em especial, as linhas 3 e 6 correspondem a cursos onde não há 
informação sobre o nível associado a eles.

Perceba também que, de forma semelhante, poderíamos ter interesse em exibir todos os registros da tabela 
à direita da cláusula JOIN. Em nosso exemplo, a tabela NIVEL. A cláusula RIGHT JOIN (junção à direita) é 
usada para essa finalidade. Nesse tipo de junção, o resultado contém todos os registros da tabela declarada 
à direita da cláusula JOIN, mesmo que não haja registros correspondentes na tabela da esquerda. Em especial, 
quando não há correspondência, os resultados são retornados com o valor NULL. */

SELECT C.CODIGOCURSO, C.NOME,
N.CODIGONIVEL, N.DESCRICAO
FROM CURSO2 C right JOIN NIVEL N ON (N.CODIGONIVEL=C.CODIGONIVEL);

/* Note que todos os registros da tabela NIVEL aparecem no resultado. As quatro primeiras linhas do resultado 
da consulta correspondem aos registros que efetivamente estão relacionados à tabela CURSO. As duas últimas 
linhas são registros que não estão relacionados a qualquer curso existente no banco de dados.

Perceba que o mesmo resultado pode ser obtido se usarmos junção à esquerda e junção à direita, alternando 
a posição das tabelas envolvidas. Com isso, queremos dizer que TABELA1 LEFT JOIN TABELA2 é equivalente a 
TABELA2 RIGHT JOIN TABELA1. */

/* Outro tipo de junção externa, denominada FULL OUTER JOIN (junção completa), apresenta todos os registros 
das tabelas à esquerda e à direita, mesmo os registros não relacionados. Em outras palavras, a tabela resultante 
exibirá todos os registros de ambas as tabelas, além de valores NULL no caso dos registros sem correspondência. 
Veja exemplo a seguir: */

SELECT C.CODIGOCURSO, C.NOME,
N.CODIGONIVEL, N.DESCRICAO
FROM CURSO2 C full outer JOIN NIVEL N ON (N.CODIGONIVEL=C.CODIGONIVEL);

/* Note que, no resultado, aparecem os registros de cada tabela. Além disso, valores NULL são exibidos nos 
casos em que não há correspondência entre as tabelas (linhas 3, 6, 7 e 8).

Neste módulo, aprendemos que, quando há necessidade de extrair informações de mais de uma tabela, utilizamos 
a cláusula de junção. Estudamos diversos tipos de junção, que serão utilizados de acordo com a necessidade do
usuário, visto que cada tipo de junção possui uma especificidade. */


/* SUBCONSULTAS
Podemos admitir que o resultado de uma consulta SQL corresponde a uma tabela, mesmo que esteja temporariamente 
armazenada na memória principal do computador.

Vamos construir consultas que dependem dos - ou usam - resultados de outras consultas para recuperar 
informações de interesse. Essa categoria é conhecida por subconsulta, uma consulta sobre o resultado de outra 
consulta.

Ao longo do nosso estudo, vamos explorar dois tipos de subconsultas: aninhadas e correlatas. No primeiro caso, 
a consulta mais externa realizará algum tipo de teste junto aos dados originados da consulta mais interna. 
No segundo, a subconsulta utiliza valores da consulta externa. Nesse tipo de consulta, a subconsulta é executada 
para cada linha da consulta externa. */

create table departamento (
	codigodepartamento int primary key,
	nome varchar(90) not null
);
table departamento;

alter table funcionario 
add column codigodepartamento int null;
alter table funcionario 
add foreign key (codigodepartamento) references departamento (codigodepartamento);

table funcionario order by codigofuncionario;

insert into departamento (codigodepartamento, nome) values
(1, 'Tecnologia da Informação'),
(2, 'Contabilidade'),
(3, 'Marketing');

update funcionario 
set codigodepartamento = 1 where codigofuncionario = 1 or codigofuncionario = 3;
update funcionario 
set codigodepartamento = 2 where codigofuncionario = 2 or codigofuncionario = 4;

/* Subconsultas aninhadas
Uma subconsulta aninhada ocorre quando é necessário obter dados que dependem do resultado de uma - ou mais - 
consulta(s) mais interna(s). Para isso, cria-se uma condição na cláusula WHERE de forma a envolver o resultado 
da subconsulta em algum tipo de teste. */

-- Consulta 01: Retornar o código e o nome do(s) funcionário(s) que ganha(m) o maior salário.
select codigofuncionario, nome, salario
from funcionario
where salario = (
	select max(salario) from funcionario
);

-- Consulta 02: Retornar o código, o nome e o salário do(s) funcionário(s) que ganha(m) mais que a média 
-- salarial dos colaboradores.
select codigofuncionario, nome, salario
from funcionario
where salario > (
	select avg(salario) from funcionario
);
/* Inicialmente, o SGBD processa a subconsulta, a qual retorna a média salarial a partir da tabela 
FUNCIONARIO. Em seguida, esse resultado é utilizado na avaliação da cláusula WHERE. Finalmente, são 
exibidas as linhas da tabela FUNCIONARIO com as colunas CODIGOFUNCIONARIO, NOME e SALARIO, cujo valor de 
SALARIO satisfaz a condição da cláusula WHERE. */

/* Retornar o código, o nome e o salário do(s) funcionário(s) que ganha(m) menos que a média salarial 
dos colaboradores do departamento de Tecnologia da Informação. */
select codigofuncionario, nome, salario
from funcionario
where salario < (
	select avg(salario) from funcionario where codigodepartamento=1
);

select codigofuncionario, nome, salario
from funcionario
where salario < (
	select avg(salario) from funcionario where codigodepartamento in (
		select codigodepartamento from departamento where nome='Tecnologia da Informação'
	)
);

/* Perceba que, para retornar os resultados de interesse, o SGBD precisa calcular a média salarial dos 
funcionários do departamento de Tecnologia da Informação. Para isso, a subconsulta da linha 4 – que calcula 
essa média - utiliza o resultado da subconsulta da linha 6, a qual recupera o código do departamento de 
Tecnologia da Informação). */
-- Há outra maneira de resolver a consulta 03?
-- Sim, você pode trocar uma subconsulta por uma junção. O código a seguir produz os mesmos resultados:
select codigofuncionario, nome, salario
from funcionario
where salario < (
	select avg(salario) from funcionario f join departamento d using (codigodepartamento)
	where d.nome='Tecnologia da Informação'
);

/* Consulta 04: Quantos funcionários recebem menos que a funcionária que possui o maior salário entre as 
colaboradoras de sexo feminino? */
select count(*) as quantidade
from funcionario
where salario < (
	select max(salario) from funcionario where sexo='F'
);
/* No exemplo, o SGBD recupera o maior salário entre as funcionárias. Em seguida, conta os registros cujo 
valor da coluna SALARIO é menor que o valor do salário em questão. */


/* Subconsultas correlatas
Uma subconsulta correlata – ou correlacionada – é um tipo especial de consulta aninhada. Uma consulta 
correlata ocorre quando é necessário obter dados que dependem do resultado de uma - ou mais - consulta(s) 
mais interna(s). Para isso, cria-se uma condição na cláusula WHERE de forma a envolver o resultado da 
subconsulta em algum tipo de teste. */

/* Consulta 05: Retornar o código, o nome e o salário do(s) funcionário(s) que ganha(m) mais que a média 
salarial dos colaboradores do departamento ao qual pertencem. */
select codigofuncionario, nome, salario
from funcionario f
where salario > ( 
	select
	avg(salario) from funcionario where codigodepartamento=f.codigodepartamento
);
/* Trata-se de uma consulta com lógica de construção semelhante ao que foi desenvolvido na consulta 02. 
No entanto, a média salarial é calculada levando em consideração somente os funcionários de cada departamento. 
Isso ocorre em função da condição WHERE declarada na linha 6. */

/* Há outra maneira de resolver a consulta 05?
Sim, você pode trocar uma subconsulta por uma junção. O código a seguir produz os mesmos resultados: */
select codigofuncionario, nome, salario
from funcionario f
	join (
		select codigodepartamento, avg(salario) as media
		from funcionario
		group by codigodepartamento
	) teste
on f.codigodepartamento=teste.codigodepartamento
where salario > media;

/* Consulta 06: suponha que surgiu a necessidade de equiparar os salários dos funcionários que atuam no 
mesmo departamento. Os funcionários de cada departamento terão salário atualizado em função do maior salário 
dos seus setores. */

select * from funcionario order by codigodepartamento;

update funcionario f
set salario = 
	(select max(salario) from funcionario where codigodepartamento=f.codigodepartamento)
where f.codigodepartamento is not null;
/* Trata-se de uma consulta com objetivo de recuperar o maior salário dentro do contexto de cada departamento e, 
em seguida, usar esse valor para atualização salarial na tabela FUNCIONARIO, de acordo com o departamento de cada 
colaborador. Perceba também que a atualização ocorre somente para os funcionários para os quais existe alocação 
a departamento, ou seja, a cláusula WHERE da linha 6 inibe atualização de salário caso não haja departamento 
associado a algum colaborador. */


/* Consulta correlacionada com uso de [NOT] EXISTS
Podemos utilizar o operador EXISTS em uma consulta correlacionada. Tal operador testa a existência de 
linha(s) retornada(s) por alguma subconsulta. Veja o exemplo a seguir:

Consulta 07: exibir o código e o nome do departamento onde há pelo menos um funcionário alocado. */
select d.codigodepartamento, d.nome
from departamento d
where exists 
	(select f.codigodepartamento
	from funcionario f
	where f.codigodepartamento=d.codigodepartamento);
/* A subconsulta correlacionada (linhas 4 a 6) é executada. Caso haja pelo menos uma linha em seu retorno, 
a avaliação da cláusula WHERE retorna verdadeiro e as colunas especificadas na linha 1 são exibidas. */

/* Finalmente, se estivéssemos interessados em saber se há departamento sem ocorrência de colaborador alocado, 
bastaria usar a negação (NOT), conforme a seguir: */
select d.codigodepartamento, d.nome
from departamento d
where not exists 
	(select f.codigodepartamento
	from funcionario f
	where f.codigodepartamento=d.codigodepartamento);


/* Módulo 3 - OPERADORES DE CONJUNTO
Vamos aprender que os resultados de diversas consultas podem ser combinados em um único conjunto de dados, 
caso sigam regras específicas dos operadores utilizados para essa finalidade. Estamos falando dos operadores 
de conjunto, que incluem UNION, INTERSECT e EXCEPT.*/

update funcionario set cpf = '82998' where codigofuncionario=1;
update funcionario set cpf = '9876' where codigofuncionario=2;
update funcionario set cpf = '32998' where codigofuncionario=3;
update funcionario set cpf = '9999' where codigofuncionario=4;
update funcionario set cpf = '9111' where codigofuncionario=5;
select * from funcionario order by codigofuncionario;

create table aluno2 (
	codigoaluno int primary key,
	nome varchar(90) not null,
	cpf char(15) not null,
	sexo char(1) not null,
	dtnascimento date not null
);

insert into aluno2 (codigoaluno, nome, cpf, sexo, dtnascimento) 
values (1,'JOSÉ FRANCISCO TERRA','82988','M','28/10/1989');
INSERT INTO ALUNO2 (CODIGOALUNO, NOME, CPF, SEXO, DTNASCIMENTO)
VALUES (2,'ANDREY COSTA FILHO','0024','M','20/10/1999');
INSERT INTO ALUNO2 (CODIGOALUNO, NOME, CPF, SEXO, DTNASCIMENTO)
VALUES (3,'ROBERTA SILVA BRASIL','82998','F','20/02/1980');
INSERT INTO ALUNO2 (CODIGOALUNO, NOME, CPF, SEXO, DTNASCIMENTO)
VALUES (4,'CARLA MARIA MACIEL','0044','F','20/11/1996');
INSERT INTO ALUNO2 (CODIGOALUNO, NOME, CPF, SEXO, DTNASCIMENTO)
VALUES (5,'MARCOS PEREIRA BRASIL','9999','M','20/02/1999');

select * from aluno2;

create table cliente (
	codigocliente int primary key,
	nome varchar(90) not null,
	cpf char(15) not null,
	sexo char(1) not null
);

INSERT INTO CLIENTE (CODIGOCLIENTE, NOME, CPF, SEXO)
VALUES (1,'ROBERTA SILVA BRASIL','82998','F');
INSERT INTO CLIENTE (CODIGOCLIENTE, NOME, CPF, SEXO)
VALUES (2,'MARCOS PEREIRA BRASIL','9999','M');
INSERT INTO CLIENTE (CODIGOCLIENTE, NOME, CPF, SEXO)
VALUES (3,'HEMERSON SILVA BRASIL','9111','M'); 

select * from cliente;

-- Consulta 01: Retornar o nome e o CPF de todos os funcionários e clientes:
select nome, cpf
from funcionario
union
select nome,cpf
from cliente;
/* Perceba que há cinco funcionários cadastrados (linhas 1 a 10 do script de inserção) e, de forma semelhante,
três clientes (linhas 18 a 20 do script de inserção). Note também que todos os clientes cadastrados também 
são funcionários. Após o processamento da operação de união, somente cinco registros foram exibidos, uma vez 
que as repetições por padrão são eliminadas. */

/* E se quiséssemos que todos registros aparecessem no resultado?
Bastaria usar o UNION ALL, conforme a seguir: */
select nome, cpf
from funcionario
union all
select nome,cpf
from cliente;

/* Finalmente, se quiséssemos especificar a “origem” de cada registro, poderíamos alterar o nosso código 
conforme a seguir: */
select nome, cpf, 'Dados da tabela funcionario' as ORIGEM
from funcionario
union all
select nome,cpf, 'Dados da tabela cliente' as ORIGEM
from cliente;

/* Consultas com o operador INTERSECT
O operador de interseção serve para exibir linhas que aparecem em ambos os resultados das consultas envolvidas. 
Para isso, todas as consultas devem possuir a mesma quantidade de colunas e deve haver compatibilidade de tipo 
de dados. Além disso, linhas repetidas são eliminadas do resultado. O operador de interseção possui a seguinte 
forma geral: */
/* Consulta 02: Retornar o nome e o CPF de todos os cidadãos que são funcionários e clientes. */
select nome, cpf
from funcionario
intersect
select nome,cpf
from cliente;
/* A consulta retorna três linhas que são fruto da interseção entre as tabelas FUNCIONARIO e CLIENTE. 
Como visto, todos os clientes são funcionários. */

/* Consulta 03: Retornar o nome e o CPF de todos os cidadãos que são funcionários, clientes e alunos. */
select nome, cpf
from funcionario
intersect
select nome,cpf
from cliente
intersect
select nome, cpf
from aluno2;
/* A consulta retorna duas linhas que são fruto da interseção entre as tabelas FUNCIONARIO, CLIENTE e ALUNO. */

/* Um aspecto importante é que uma consulta sob o formato X UNION Y INTERSECT Z é interpretada sendo X UNION 
(Y INTERSECT Z). Veja o exemplo a seguir: */
select nome, cpf
from funcionario
union
select nome,cpf
from cliente
intersect
select nome, cpf
from aluno2;

/* Consultas com o operador EXCEPT
O operador EXCEPT implementa a operação de subtração da Teoria dos Conjuntos e serve para exibir linhas 
que aparecem em uma consulta e não aparecem na outra. Para isso, todas as consultas devem possuir a mesma 
quantidade de colunas e deve haver compatibilidade de tipo de dados. Além disso, linhas repetidas são 
eliminadas do resultado. O operador de subtração possui a seguinte forma geral:

Convém ressaltar que alguns SGBDs implementam a mesmo operador, usando um nome diferente. O Oracle, 
por exemplo, utiliza o operador MINUS, significando subtração ou diferença. */

/* Consulta 04: Retornar o nome e o CPF dos funcionários que não são clientes. */
select nome, cpf
from funcionario
except
select nome, cpf
from cliente;

/* A consulta retorna duas linhas que são fruto da subtração entre as tabelas FUNCIONARIO e CLIENTE.

Perceba que uma operação X EXCEPT Y é diferente de Y EXCEPT X. Veja o código a seguir: */
select nome, cpf
from cliente
except
select nome, cpf
from funcionario;
-- A consulta retorna vazio pois todos os clientes são funcionários.

/* Consulta 05: Retornar o nome e o CPF dos cidadãos que são somente funcionários. */
select nome, cpf
from funcionario
except
select nome, cpf
from cliente
except
select nome, cpf
from aluno2;
/* Inicialmente, o SGBD processa a operação de subtração da linha 3. Em seguida, o resultado da operação é 
usado na subtração da linha 6. */


















