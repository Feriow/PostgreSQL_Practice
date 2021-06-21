-- Alguns SGBDs, como o PostgreSQL, implementam uma forma simplificada do comando SELECT * FROM TABELA, que 
-- simplesmente TABLE tabela (você pode testar isso no PostgreSQL).
table curso;

create table if not exists aluno (
	codigoaluno int primary key not null,
	nome varchar(90) not null,
	sexo char(1) not null,
	dtnascimento date not null,
	email varchar(50) null
);

insert into aluno (codigoaluno, nome, sexo, dtnascimento, email)
values (1, 'JOSÉ FRANCISCO TERRA', 'M', '28/10/1989', 'JFT@GMAIL.COM');
INSERT INTO ALUNO (CODIGOALUNO, NOME, SEXO, DTNASCIMENTO,EMAIL) 
VALUES (2,'ANDREY COSTA FILHO','M','20/10/1999','ANDREYCF@HOTMAIL.COM');
INSERT INTO ALUNO (CODIGOALUNO, NOME, SEXO, DTNASCIMENTO,EMAIL) 
VALUES (3,'PATRÍCIA TORRES LOUREIRO','F','20/10/1980','PTORRES@GMAIL.COM');
INSERT INTO ALUNO (CODIGOALUNO, NOME, SEXO, DTNASCIMENTO,EMAIL) 
VALUES (4,'CARLA MARIA MACIEL','F','20/11/1996',NULL);
INSERT INTO ALUNO (CODIGOALUNO, NOME, SEXO, DTNASCIMENTO,EMAIL) 
VALUES (5,'LEILA SANTANA COSTA','F','20/11/2001',NULL);

-- Exibir todas as informações dos alunos.
SELECT * FROM ALUNO;
-- OU
table aluno;

-- Retornar o código, o nome e a data de nascimento de todos os alunos.
SELECT CODIGOALUNO, NOME, DTNASCIMENTO
FROM ALUNO;

-- Em especial, pode ser interessante “renomear” as colunas resultantes da consulta, visando tornar os 
-- resultados mais “apresentáveis” ao usuário da aplicação. Por exemplo, a consulta 02 pode ser reescrita 
-- conforme a seguir: (Obs usar string para nomes compostos e caixa alta)
SELECT CODIGOALUNO AS "Matrícula",
NOME AS "Nome do discente",
DTNASCIMENTO AS "Data de nascimento"
FROM ALUNO;

-- Um resumo contendo algumas funções de data do PostgreSQL pode ser visualizado na tabela a seguir:
-- Função	          			O que retorna?
-- current_date	      			data de hoje
-- current_time	      			hora do dia
-- current_timestamp  			data e a hora
-- extract (campo from fonte)	subcampos de data e hora: século, ano, dia, mês

SELECT CURRENT_DATE AS "Data Atual",
 CURRENT_TIME AS "Hora Atual",
 CURRENT_TIMESTAMP "Data e Hora atuais",
-- DOW 0 - domingo, 1 - segunda, ..., 6 - sábado
 EXTRACT( DOW FROM CURRENT_DATE) AS "Dia da semana",
 EXTRACT( DAY FROM CURRENT_DATE) AS "Dia Atual",
 EXTRACT( DOY FROM CURRENT_DATE) AS "Dia do ano",
 EXTRACT( MONTH FROM CURRENT_DATE) AS "Mês Atual",
 EXTRACT( YEAR FROM CURRENT_DATE) AS "Ano Atual",
 EXTRACT( CENTURY FROM CURRENT_DATE) AS "Século Atual";
 
 -- Convém ressaltar que, no padrão SQL, a cláusula FROM é obrigatória. No entanto, o PostgreSQL 
 -- permite executar um comando SELECT sem a cláusula FROM. Experimente executar SELECT 5+5:
 select 5+5;

-- Exibindo o nome do dia da semana
-- Perceba que a linha 6 do código acima retorna um inteiro representativo do dia da semana. 
-- No entanto, se houver necessidade de exibir o dia da semana, você pode usar o código a seguir:
select case when extract(dow from current_date) = 0 then 'DOMINGO'
			when extract(dow from current_date) = 1 then 'SEGUNDA-FEIRA'
			when extract(dow from current_date) = 2 then 'TERÇA-FEIRA'
			when extract(dow from current_date) = 3 then 'QUARTA-FEIRA'
			when extract(dow from current_date) = 4 then 'QUINTA-FEIRA'
			when extract(dow from current_date) = 5 then 'SEXTA-FEIRA'
			when extract(dow from current_date) = 6 then 'SÁBADO'
		end as "Nome do dia da semana";

-- Calculando idade e faixa etária
-- Em geral, quando estamos diante de alguma coluna representativa da data de nascimento de uma pessoa, 
-- é comum extrair informações derivadas, tais como idade e faixa etária. Por exemplo, o código a seguir 
-- retorna o nome, a data de nascimento e a idade dos alunos:
select nome,
		dtnascimento,
		age(dtnascimento) as "Idade [ano/mês/dia]",
		extract(year from age(dtnascimento)) as "Idade do aluno"
		from aluno;
-- Perceba que na linha 3 utilizamos a função AGE, que retorna uma frase representativa da informação 
-- sobre a idade em questão. Na linha 4, usamos a função EXTRACT para exibir a idade do aluno.

-- Muito bem, agora, vamos exibir o nome, a idade e a faixa etária dos alunos.
select nome,
		extract(year from age(dtnascimento)) as "Idade do aluno",
		case when extract(year from age(dtnascimento)) <=20 then '1. até 20 anos'
			when extract(year from age(dtnascimento)) between 21 and 30 then '2. 21 a 30 anos'
			when extract(year from age(dtnascimento)) between 31 and 40 then '3. 31 a 40 anos'
			when extract(year from age(dtnascimento)) between 41 and 50 then '4. 41 a 50 anos'
			when extract(year from age(dtnascimento)) between 51 and 60 then '5. 51 a 60 anos'
			when extract(year from age(dtnascimento)) >60 then '6. mais de 60 anos'
		end as "Faixa etária" 
from aluno;
-- Perceba que cada linha com a cláusula WHEN avalia a expressão que retorna uma faixa etária de acordo 
-- com a idade do aluno.

-- FUNÇÕES DE RESUMO OU DE AGREGAÇÃO
-- As funções a seguir são úteis para obtermos resumo dos dados de alguma tabela:
-- Função						O que retorna?
-- COUNT(*)						número de linhas da consulta
-- MIN(COLUNA/EXPRESSÃO)		menor de uma coluna ou expressão
-- AVG(COLUNA/EXPRESSÃO)		valor médio da coluna ou expressão
-- MAX(COLUNA/EXPRESSÃO)		maior valor de uma coluna ou expressão
-- SUM(COLUNA/EXPRESSÃO)		soma dos valores de uma coluna ou expressão
-- STDDEV(COLUNA/EXPRESSÃO)		desvio padrão dos valores de uma coluna ou expressão
-- VARIANCE(COLUNA/EXPRESSÃO)	variância dos valores de uma coluna ou expressão

select
	count(*) as "Número de alunos",
	min(extract(year from age(dtnascimento))) as "Menor idade",
	avg(extract(year from age(dtnascimento))) as "Idade média",
	max(extract(year from age(dtnascimento))) as "Maior idade",
	sum(extract(year from age(dtnascimento)))/count(*) as "Idade média"
from aluno;

-- Suponha que haja interesse em conhecer os quantitativos de cursos, disciplinas e alunos do nosso 
-- banco de dados.
-- Poderíamos submeter ao SGBD as consultas a seguir:
SELECT COUNT(*) NCURSOS FROM CURSO;
SELECT COUNT(*) NDISCIPINAS FROM DISCIPLINA;
SELECT COUNT(*) NALUNOS FROM ALUNO;

-- Estamos diante de três consultas. No entanto, pode ser mais interessante mostrarmos os resultados 
-- em apenas uma linha.
-- Podemos, então, submeter o código a seguir:

select
(SELECT COUNT(*) NCURSOS FROM CURSO),
(SELECT COUNT(*) NDISCIPINAS FROM DISCIPLINA),
(SELECT COUNT(*) NALUNOS FROM ALUNO);

-- CRIANDO TABELA A PARTIR DE CONSULTA
-- Em alguns momentos, você terá interesse em salvar os resultados de uma consulta em uma nova tabela.
-- Para isso, basta usar o comando CREATE TABLE <CONSULTA>.
create table tteste as
select nome,
		extract(year from age(dtnascimento)) as "Idade do aluno",
		case when extract(year from age(dtnascimento)) <=20 then '1. até 20 anos'
			when extract(year from age(dtnascimento)) between 21 and 30 then '2. 21 a 30 anos'
			when extract(year from age(dtnascimento)) between 31 and 40 then '3. 31 a 40 anos'
			when extract(year from age(dtnascimento)) between 41 and 50 then '4. 41 a 50 anos'
			when extract(year from age(dtnascimento)) between 51 and 60 then '5. 51 a 60 anos'
			when extract(year from age(dtnascimento)) >60 then '6. mais de 60 anos'
		end as "Faixa etária" 
from aluno;

table tteste;

drop table tteste;

-- CRIANDO VIEW A PARTIR DE CONSULTA
-- Outro recurso interessante, diretamente relacionado ao processo de construção de consultas, é o objeto 
-- view (visão). Uma view encapsula a complexidade da consulta SQL, que a forma. Para criar esse objeto, 
-- usa-se o comando CREATE VIEW <CONSULTA>
create view tteste as
select nome,
		extract(year from age(dtnascimento)) as "Idade do aluno",
		case when extract(year from age(dtnascimento)) <=20 then '1. até 20 anos'
			when extract(year from age(dtnascimento)) between 21 and 30 then '2. 21 a 30 anos'
			when extract(year from age(dtnascimento)) between 31 and 40 then '3. 31 a 40 anos'
			when extract(year from age(dtnascimento)) between 41 and 50 then '4. 41 a 50 anos'
			when extract(year from age(dtnascimento)) between 51 and 60 then '5. 51 a 60 anos'
			when extract(year from age(dtnascimento)) >60 then '6. mais de 60 anos'
		end as "Faixa etária" 
from aluno;

select * from tteste;
select * from aluno;
-- Selects usando where para filtrar a query. Com o count serviu para contar uma característica específica.
select count(sexo) from aluno where sexo = 'M';
select nome,email from aluno where email ilike '%hotmail.com';
select count(email) from aluno where email ilike '%hotmail.com';

-- A construção de uma condição na cláusula WHERE envolve operadores relacionais, conforme tabela a seguir:

-- Operador		Significado
-- <			menor
-- <=			menor ou igual a
-- >			maior
-- >=			maior ou igual a
-- =			igual
-- <> ou !=	> 	diferente
-- AND			conjunção
-- OR			disjunção
-- NOT			negação

select nome, dtnascimento from aluno where sexo = 'F';

-- Mostrar o nome e a data de nascimento das alunas que fazem aniversário em novembro.
select nome, dtnascimento
from aluno
where sexo='F' and extract(month from dtnascimento)=11;

--RECUPERANDO DADOS COM O USO DO OPERADOR IN
-- O operador [NOT] IN pode ser utilizado em consultas que envolvam comparações usando uma lista de valores.
-- Listar o nome dos alunos que fazem aniversário no segundo semestre:
select nome, dtnascimento
from aluno
where extract(month from dtnascimento) in (7,8,9,10,11,12);

-- RECUPERANDO DADOS COM O USO DO OPERADOR BETWEEN
-- O operador [NOT] BETWEEN verifica se determinado valor encontra-se no intervalo entre dois valores.
-- Por exemplo, X BETWEEN Y AND Z é equivalente a X>=Y AND X<=Z. De modo semelhante, X NOT BETWEEN Y AND Z 
-- é equivalente a X<Y OR X>Z.
-- Listar o nome dos alunos nascidos entre 1999 e 2005:
select nome, dtnascimento
from aluno
where extract(year from dtnascimento) between 1999 and 2005;

-- Note que a expressão na cláusula WHERE compara o ano de nascimento de cada aluno junto ao intervalo 
-- especificado pelo operador BETWEEN. Caso quiséssemos extrair o mesmo resultado sem o uso do BETWEEN, 
-- poderíamos programar um comando equivalente, conforme a seguir:

select nome, dtnascimento
from aluno
where extract(year from dtnascimento) >= 1999 and extract(year from dtnascimento) <= 2005;

-- RECUPERANDO DADOS COM O USO DO OPERADOR LIKE
-- O uso do [NOT] LIKE permite realizar buscas em uma cadeia de caracteres. Ou o [NOT] ILIKE para buscas que 
-- ignoram caixa alta e baixa.
-- Trata-se de um recurso bastante utilizado em buscas textuais. Você pode utilizar os símbolos especiais a seguir:
-- _ (underline) para ignorar qualquer caractere específico;
-- % (porcentagem) para ignorar qualquer padrão.
-- Listar o nome dos alunos que possuem a string COSTA em qualquer parte do nome.
select nome from aluno where nome ilike '%COSTA%';
-- O uso do padrão ‘%COSTA%’ significa que não importa o conteúdo localizado antes e depois da string “COSTA”.

-- Listar o nome dos alunos que possuem a letra “A” na segunda posição do nome.
table aluno;
select nome from aluno where nome ilike 'a%'; -- retorna A na primeira posição
select nome from aluno where nome ilike '_a%';
-- Note que, para especificar o “A” na segunda posição, o SGBD desprezará qualquer valor na primeira posição 
-- da string, não importando o que estiver localizado à direita do “A”.

-- Listar o nome e a data de nascimento dos alunos que não possuem a string “MARIA” fazendo parte do nome.
select nome, dtnascimento from aluno where nome not ilike '%maria%';

-- Quantos alunos possuem conta de e-mail no gmail?
select count(*) as "Alunos com gmail" from aluno where email ilike '%gmail%';

-- RECUPERANDO DADOS COM O USO DO OPERADOR NULL
-- Quando uma coluna é opcional, significa que existe possibilidade de que algum registro não possua valor 
-- cadastrado para a coluna em questão. Nessa hipótese, há entendimento de que o valor da coluna é “desconhecido” 
-- ou “não aplicável”.
-- Para testar se uma coluna possui valor cadastrado, usa-se a expressão COLUNA IS NOT NULL.
-- Listar o nome, a data de nascimento e o e-mail dos alunos que têm endereço eletrônico cadastrado.
select nome, dtnascimento, email
from aluno
where email is not null;

-- Retornar o nome dos alunos sem e-mail cadastrado no banco de dados.
select nome, dtnascimento
from aluno
where email is null;


-- RECUPERANDO DADOS USANDO ORDENAÇÃO DOS RESULTADOS
-- Para melhor organizar os resultados de uma consulta, nós podemos especificar critérios de ordenação. 
-- Retornar o nome e a data de nascimento dos alunos, ordenando os resultados por nome, de maneira ascendente.
select nome,dtnascimento from aluno order by nome;

-- Retornar o nome e a data de nascimento dos alunos, ordenando os resultados de modo ascendente pelo 
-- mês de nascimento e, em seguida, pelo nome, também de modo ascendente.
select nome,dtnascimento 
from aluno 
order by extract(month from dtnascimento), nome;
-- O SGBD retorna os registros da tabela ALUNO, levando em conta o critério de ordenação especificado na 
-- linha 3 da consulta. Foi realizada ordenação pelo mês de nascimento; em seguida, pelo nome.

-- MÓDULO 3
create table if not exists funcionario (
	codigofuncionario int primary key,
	nome varchar(90) not null,
	cpf char(15) null,
	sexo char(1) not null,
	dtnascimento date not null,
	salario real null
);

INSERT INTO FUNCIONARIO (CODIGOFUNCIONARIO, NOME, CPF, SEXO, DTNASCIMENTO, SALARIO)
VALUES (1,'ROBERTA SILVA BRASIL',NULL,'F','20/02/1980',7000);
INSERT INTO FUNCIONARIO (CODIGOFUNCIONARIO, NOME, CPF, SEXO, DTNASCIMENTO, SALARIO)
VALUES (2,'MARIA SILVA BRASIL',NULL,'F','20/09/1988',9500);
INSERT INTO FUNCIONARIO (CODIGOFUNCIONARIO, NOME, CPF, SEXO, DTNASCIMENTO, SALARIO)
VALUES (3,'GABRIELLA PEREIRA LIMA',NULL,'F','20/02/1990',6000);
INSERT INTO FUNCIONARIO (CODIGOFUNCIONARIO, NOME, CPF, SEXO, DTNASCIMENTO, SALARIO)
VALUES (4,'MARCOS PEREIRA BRASIL',NULL,'M','20/02/1999',6000);
INSERT INTO FUNCIONARIO (CODIGOFUNCIONARIO, NOME, CPF, SEXO, DTNASCIMENTO, SALARIO)
VALUES (5,'HEMERSON SILVA BRASIL',NULL,'M','20/12/1992',4000);

table funcionario;

--GRUPO DE DADOS
-- Nas próximas seções, vamos aprender a projetar consultas com o uso de agrupamento de dados, 
-- com auxílio dos comandos GROUP BY e HAVING.
-- Vamos perceber que a maior parte dessas consultas está atrelada ao uso de alguma função de resumo, 
-- por exemplo, SUM, AVG, MIN e MAX, as quais representam, respectivamente, soma, média, mínimo e máximo.
-- Logo, essas consultas são úteis para quem tem interesse em construir relatórios e aplicações de natureza 
--mais gerencial e analítica. Os valores de determinada coluna podem formar grupos sobre os quais podemos 
--ter interesse em recuperar dados.

-- A estrutura anterior possui somente um grupo, o qual é formado pela coluna SEXO da tabela FUNCIONARIO. 
-- Como exibir esse grupo em SQL?
-- Uma solução é adicionar a cláusula DISTINCT ao comando SELECT, conforme a seguir:
select distinct sexo from funcionario;

-- GRUPO DE DADOS COM GROUP BY
-- A cláusula GROUP BY serve para exibir resultados de consulta de acordo com um grupo especificado. 
-- Ela é declarada após a cláusula FROM, ou após a cláusula WHERE, caso exista na consulta. Por exemplo, 
-- para obter o mesmo resultado do comando anterior, podemos usar o código a seguir:
select sexo from funcionario group by sexo;
-- No entanto, vamos perceber que o uso mais conhecido da cláusula GROUP BY ocorre quando associada a 
-- funções de agregação, tais como COUNT, MIN, MAX e AVG.

-- Retornar o número de funcionários por sexo:
select sexo, count(*) as quantidade from funcionario group by sexo;
-- O SGBD realiza o agrupamento de dados de acordo com os valores da coluna SEXO. Em seguida, para cada grupo 
-- encontrado, a função COUNT(*) é executada e o resultado exibido.

-- E se tivéssemos interesse em exibir os resultados da consulta anterior em uma única linha? 
-- Poderíamos usar o código a seguir:
select
	(select count(*) as "M" from funcionario where sexo='M'),
	(select count(*) as "F" from funcionario where sexo='F');

-- Retornar a média salarial por sexo.
select sexo, avg(salario) as "Media salarial"
from funcionario
group by sexo;
-- O SGBD realiza o agrupamento de dados de acordo com os valores da coluna SEXO. Em seguida, para cada 
-- grupo encontrado, a função AVG (SALARIO) é executada; e o resultado, exibido.

-- Retornar, por mês de aniversário, a quantidade de colaboradores, o menor salário, o maior salário e o 
-- salário médio. Ordene os resultados por mês de aniversário.
select extract(month from dtnascimento) as "Mês de aniversário", 
	count(*) as quantidade,
	min(salario) as "Menor salário",
	max(salario) as "Maior salário",
	round(avg(salario)::numeric,2) as "Salário médio"
from funcionario
group by extract(month from dtnascimento)
order by extract(month from dtnascimento);
-- O SGBD realiza o agrupamento de dados de acordo com o mês de nascimento dos funcionários. 
-- Depois, para cada grupo encontrado, as funções de agregação são executadas e, em seguida, exibidos os 
-- resultados. Perceba também que, na linha 4, utilizamos a função ROUND com objetivo de mostrar ao usuário 
-- final somente a parte inteira dos valores resultantes da média salarial.

-- Retornar, por mês de aniversário, o mês, o sexo e a quantidade de colaboradores.
-- Apresentar os resultados ordenados pelo mês.
select extract(month from dtnascimento) as "Mês de aniversário",
	sexo as "Sexo",
	count(*) as "Quantidade"
from funcionario
group by extract(month from dtnascimento), sexo
order by extract(month from dtnascimento);
-- O SGBD realiza o agrupamento de dados de acordo com os valores do mês de aniversário. 
-- Em seguida, no contexto de cada mês encontrado, mais um grupo é construído por sexo. 
-- Finalmente, para cada ocorrência mês/sexo, o número de colaboradores é calculado.

-- GRUPO DE DADOS COM GROUP BY E HAVING
-- Até o momento, utilizamos a cláusula WHERE para programar filtros em consultas, com condições simples ou 
-- compostas envolvendo colunas da tabela ou funções de data.
-- Contudo, você vai vivenciar situações onde será necessário estabelecer algum tipo de filtro, 
-- tendo como base um cálculo originado a partir de uma função de agregação, não sendo possível usar a 
-- cláusula WHERE. Nesses casos, utilizamos a cláusula HAVING, que serve justamente para esse propósito.

-- Suponha que o departamento de recursos humanos esteja estudando a viabilidade de oferecer bônus de 5% aos 
-- funcionários por mês de nascimento, mas limitado somente aos casos onde há mais de um colaborador 
-- aniversariando. Assim, para cada mês em questão, deseja-se listar o mês, o número de colaboradores e o valor 
-- do bônus.
select extract(month from dtnascimento) as "Mês",
	count(*) as quantidade,
	sum(salario*0.05) as totalbonus
from funcionario
group by extract(month from dtnascimento)
	having count(*)>1
order by extract(month from dtnascimento);
-- Note que estamos diante de uma estrutura de consulta muito similar ao código da consulta 03. Porém, 
-- estamos interessados em retornar somente o(s) registro(s) cujo valor da coluna quantidade seja maior que a 
-- unidade. Acontece que quantidade é uma coluna calculada com auxílio de uma função de agregação, não sendo 
-- possível programar um filtro na cláusula WHERE (WHERE QUANTIDADE>1). Assim, declaramos o filtro de interesse 
-- fazendo uso da cláusula HAVING, conforme linha 6 da consulta.



