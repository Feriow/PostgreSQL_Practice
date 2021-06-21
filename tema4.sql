-- Comando para criar um database.
CREATE DATABASE BDESTUDO;

-- Comando para remover um database.
DROP DATABASE BDESTUDO;

create table if not exists nivel (
	codigonivel int not null,
	descricao varchar(90) not null,
	constraint chavepnivel primary key (codigonivel)
);

create table if not exists curso (
	codigocurso int not null,
	nome varchar(90) not null unique,
	datacriacao date null,
	codigonivel int null,
	constraint chavepcurso primary key (codigocurso),
	foreign key (codigonivel) references nivel (codigonivel)
);

--Identificar o nome correspondente ao OID do PostgreSQL (numero da pasta dentro da pasta DATA), 
--basta executar o comando a seguir:
SELECT OID, DATNAME FROM PG_DATABASE;

-- Comando para alterar a tabela CURSO, adicionando coluna DTRECONH
alter table curso add dtreconh date;

-- Comando para alterar a tabela CURSO, removendo a coluna DTRECONH
alter table curso drop dtreconh;

-- Comando para remover a tabela CURSO
DROP TABLE CURSO;

--poderíamos ter optado por criar as tabelas NIVEL e CURSO sem relacionamento, para, 
--em seguida, alterar a tabela CURSO, adicionando a restrição de chave estrangeira.
create table if not exists nivel (
	codigonivel int not null,
	descricao varchar(90) not null,
	constraint chavepnivel primary key (codigonivel)
);
create table if not exists curso (
	codigocurso int not null,
	nome varchar(90) not null unique,
	datacriacao date null,
	codigonivel int null,
	constraint chavepcurso primary key (codigocurso)
);
alter table curso add foreign key (codigonivel) references nivel;

-- Comando para remover a tabela NIVEL - remoção em cascata. 
-- Internamente, o comando altera a estrutura da tabela CURSO, removendo a restrição de chave estrangeira 
-- da coluna CODIGONIVEL. Em seguida, a tabela NIVEL é removida do banco de dados.
DROP TABLE NIVEL CASCADE;

select * from nivel;
select * from curso;

-- Exercicio módulo 3
drop table curso;

create table if not exists curso (
	codigocurso int not null,
	nome varchar(90) not null,
	datacriacao date,
	constraint CURSO_pk primary key (codigocurso)
);

create table if not exists disciplina (
	codigodisciplina int not null,
	nome varchar(90) not null,
	cargahoraria int not null,
	constraint DISCIPLINA_pk primary key (codigodisciplina)
);

create table if not exists cursodisciplina (
	codigocurso int,
	codigodisciplina int,
	constraint CURSODISCIPLINA_pk primary key (codigocurso, codigodisciplina),
	constraint CURSODISCIPLINA_CURSO foreign key (codigocurso) references curso (codigocurso) on delete cascade,
	constraint CURSODISCIPLINA_DISCIPLINA foreign key (codigodisciplina) references disciplina (codigodisciplina)
);

-- INSERÇÃO DE REGISTROS
-- Inserção registros em CURSO
insert into curso (codigocurso, nome, datacriacao)
values (1,'Sistemas de Informação','19/06/1999');
INSERT INTO CURSO (CODIGOCURSO,NOME,DATACRIACAO)
VALUES( 2,'Medicina','10/05/1990');
INSERT INTO CURSO (CODIGOCURSO,NOME,DATACRIACAO)
VALUES( 3,'Nutrição','19/02/2012');
INSERT INTO CURSO (CODIGOCURSO,NOME,DATACRIACAO)
VALUES( 4,'Pedagogia','19/06/1999');

-- Inserção registros em DISCIPLINA
insert into disciplina (codigodisciplina, nome, cargahoraria)
values (1,'Leitura e Produção de Textos',60);
INSERT INTO DISCIPLINA (CODIGODISCIPLINA,NOME,CARGAHORARIA)
VALUES( 2,'Redes de Computadores',60);
INSERT INTO DISCIPLINA (CODIGODISCIPLINA,NOME,CARGAHORARIA)
VALUES( 3,'Computação Gráfica',40);
INSERT INTO DISCIPLINA (CODIGODISCIPLINA,NOME,CARGAHORARIA)
VALUES( 4,'Anatomia',60);

-- Inserção relações em CURSODISCIPLINA
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (1,1);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (1,2);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (1,3);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (2,1);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (2,3);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (3,1);
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (3,3);

-- E se submetermos ao SGBD o comando a seguir?
INSERT INTO CURSODISCIPLINA(CODIGOCURSO,CODIGODISCIPLINA) VALUES (3,30);
-- O SGBD não realizará a inserção e retornará uma mensagem de erro informando que 30 não é um valor 
-- previamente existente na chave primária da tabela DISCIPLINA. Isso acontece porque, quando definimos 
-- (linha 16 do script da seção anterior) a chave estrangeira da tabela CURSODISCIPLINA, nós delegamos 
--ao SGBD a tarefa de realizar esse tipo de validação com objetivo de sempre manter a integridade dos 
--dados do banco de dados. Note que não existe disciplina identificada de código 30 na tabela DISCIPLINA.

-- Já vimos que o SGBD é responsável por manter a integridade dos dados ao longo de todo o ciclo de vida 
--do banco de dados. A consequência disso pode ser percebida ao tentarmos executar (novamente) o comando a seguir:
INSERT INTO DISCIPLINA (CODIGODISCIPLINA, NOME, CARGAHORARIA) VALUES (4,'Anatomia',60);
-- Como já existe um registro com valor de CODIGODISCIPLINA igual a 4, o SGBD exibirá mensagem de erro 
-- informando que o referido valor já existe no banco de dados. Semelhantemente, devemos lembrar que todo 
--valor de chave primária é obrigatório.

-- Vamos agora tentar inserir uma disciplina sem valor para CODIGODISCIPLINA, conforme comando SQL a seguir:
INSERT INTO DISCIPLINA (CODIGODISCIPLINA, NOME, CARGAHORARIA) VALUES (NULL,'Biologia Celular e Molecular',60);
-- O SGBD exibirá mensagem de erro informando que o valor da coluna CODIGODISCIPLINA não pode ser nulo.

-- ALTERAÇÃO DE REGISTROS
-- Alteraremos para 70 a carga horária da disciplina Redes de Computadores. Para isso, basta executar o 
-- comando a seguir:
update disciplina set
cargahoraria = 70
where codigodisciplina = 2;
-- No comando, o SGBD busca na tabela a disciplina cujo valor da coluna CODIGODIISCIPLINA seja igual a 2. 
-- Em seguida, atualiza o valor da coluna CARGAHORARIA para 70. Note também que poderíamos ter executado o 
-- comando a seguir:
UPDATE DISCIPLINA SET CARGAHORARIA=70 WHERE NOME='Redes de Computadores';

-- Suponha agora que houve a necessidade de alterar em 20% a carga horária de todas as disciplinas cadastradas 
-- no banco de dados. Podemos executar o seguinte comando:
update disciplina set cargahoraria = cargahoraria * 1.2;


--Vamos supor que seja necessário alterar para 6 o valor de CODIGOCURSO referente ao curso de Pedagogia. 
-- Podemos, então, executar o comando a seguir:
UPDATE CURSO SET CODIGOCURSO=6 WHERE CODIGOCURSO=4;
-- Perceba que o SGBD processará a alteração, visto que não há vínculo na tabela CURSODISCIPLINA envolvendo 
-- este curso. No entanto, o que aconteceria se tentássemos alterar para 10 o valor de CODIGOCURSO referente ao 
-- curso de Sistemas de Informação?
-- Seguindo a mesma linha de raciocínio da última alteração, vamos submeter o comando a seguir:
UPDATE CURSO SET CODIGOCURSO=10 WHERE CODIGOCURSO=1;
-- O SGBD não realizará a alteração e retornará uma mensagem de erro indicando que o valor 1 está registrado na 
--tabela CURSODISCIPLINA, coluna CODIGOCURSO. Isso significa que, se o SGBD aceitasse a alteração, a tabela 
--CURSODISCIPLINA ficaria com dados inconsistentes, o que não deve ser permitido.

-- Assim, de modo semelhante ao que aprendemos na seção Mecanismo de chave primária em ação, deixaremos o 
-- SGBD realizar as alterações necessárias para manter a integridade dos dados. Vamos, então, submeter o 
-- comando a seguir:
ALTER TABLE CURSODISCIPLINA
DROP CONSTRAINT CURSODISCIPLINA_CURSO,
ADD CONSTRAINT CURSODISCIPLINA_CURSO
FOREIGN KEY (CODIGOCURSO) REFERENCES CURSO (CODIGOCURSO)
ON UPDATE CASCADE ;
-- O que fizemos? Usamos o comando ALTER TABLE para alterar a estrutura da tabela CURSODISCIPLINA:, removemos 
-- a chave estrangeira (comando DROP CONSTRAINT) e, por último, recriamos a chave (ADD CONSTRAINT), especificando 
-- a operação de atualização (UPDATE) em cascata.
-- Assim, após o processamento da alteração anterior, podemos então submeter o comando, conforme a seguir:
UPDATE CURSO SET CODIGOCURSO=10 WHERE CODIGOCURSO=1;

-- DELEÇÃO DE REGISTROS
-- Suponha que temos interesse em apagar do banco de dados a disciplina de Anatomia. Podemos, então, 
-- submeter o código a seguir:
DELETE FROM DISCIPLINA WHERE CODIGODISCIPLINA=4;
-- O SGBD localiza na tabela DISCIPLINA a linha cujo conteúdo da coluna CODIGODISCIPLINA seja igual a 1. 
-- Em seguida, remove do banco de dados a linha em questão.
-- Agora vamos imaginar que tenha surgido a necessidade de remover do banco de dados a disciplina de Leitura e 
-- Produção de Textos. Podemos, então, submeter o código a seguir:
DELETE FROM DISCIPLINA WHERE CODIGODISCIPLINA=1;
-- O SGBD não realizará a remoção e retornará uma mensagem de erro indicando que o valor 1 está registrado 
-- na tabela CURSODISCIPLINA, coluna CODIGODISCIPLINA. Se o SGBD aceitasse a remoção, a tabela CURSODISCIPLINA 
-- ficaria com dados inconsistentes, o que não deve ser permitido.

-- Assim, de modo semelhante ao que aprendemos na seção Mecanismo de chave primária em ação, deixaremos o 
-- SGBD realizar as alterações necessárias para manter a integridade dos dados. Vamos, então, submeter o 
-- comando a seguir:
ALTER TABLE CURSODISCIPLINA
DROP CONSTRAINT CURSODISCIPLINA_DISCIPLINA,
ADD CONSTRAINT CURSODISCIPLINA_DISCIPLINA
FOREIGN KEY (CODIGODISCIPLINA) REFERENCES DISCIPLINA (CODIGODISCIPLINA)
ON DELETE CASCADE ;

-- O que fizemos? Usamos o comando ALTER TABLE para alterar a estrutura da tabela CURSODISCIPLINA:, 
-- removemos a chave estrangeira (comando DROP CONSTRAINT) e, por último, recriamos a chave (ADD CONSTRAINT), 
-- especificando operação de remoção (DELETE) em cascata.
-- Assim, após o processamento da alteração anterior, podemos submeter o comando conforme a seguir:
DELETE FROM DISCIPLINA WHERE CODIGODISCIPLINA=1;
-- Ao processar o comando, o SGBD verifica se existe alguma linha da tabela CURSODISCIPLINA com valor 1 para 
-- a coluna CODIGODISCIPLINA. Caso encontre, cada ocorrência é então removida do banco de dados.

-- E se quiséssemos eliminar todos os registros de todas as tabelas do banco de dados?
-- Para realizarmos esta operação, precisaremos identificar quais tabelas são mais independentes e quais 
-- são as que possuem vínculos de chave estrangeira.
-- No caso do nosso exemplo, CURSODISCIPLINA possui duas chaves estrangeiras, portanto, é a tabela mais 
-- dependente. As demais, não possuem chave estrangeira. De posse dessa informação, podemos submeter os 
-- comandos a seguir para completar a tarefa:
DELETE FROM CURSODISCIPLINA;
DELETE FROM CURSO;
DELETE FROM DISCIPLINA;
-- Perceba que a primeira tabela que foi usada no processo de remoção de linhas foi a CURSODISCIPLINA, 
-- pois essa é a responsável por manter as informações sobre o relacionamento entre as tabelas CURSO e 
-- DISCIPLINA. Após eliminar os registros de CURSODISCIPLINA, o SGBD removerá com sucesso os registros das 
-- tabelas CURSO e DISCIPLINA.

select * from curso;
select * from disciplina;
select * from cursodisciplina;

-- MÓDULO 4 - TRANSAÇÕES

-- A execução de um INSERT na tabela ocorre dentro do contexto implícito de uma transação:
-- BEGIN implícito
INSERT INTO CURSO (CODIGOCURSO,NOME,DATACRIACAO) VALUES (5,'Engenharia de Computação',NULL);
-- COMMIT implícito

-- Estudamos que, quando uma transação é desfeita, qualquer operação que faz parte da transação deve ser 
-- cancelada. Vamos, então, ver como podemos fazer isso no PostgreSQL. Veja o exemplo a seguir, construído 
-- com objetivo de inserir um registro na tabela CURSO e, em seguida, indicar que a operação de inserção ser 
-- desfeita pelo SGBD:
select * from curso;
begin;
insert into curso (codigocurso, nome, datacriacao) values (7, 'Psicologia', null);
select * from curso;
rollback;
select * from curso;

--update disciplina set cargahoraria = cargahoraria / 1.2 where codigodisciplina = 2 or codigodisciplina = 3;
--update disciplina set cargahoraria = 60 where codigodisciplina = 2;

-- Agora, nossa intenção é alterar a carga horária das disciplinas de acordo com os critérios a seguir:
-- Disciplinas que possuem 60 horas: aumento em 20%
-- Disciplinas que possuam 40 horas: aumento em 10%
select * from disciplina order by codigodisciplina;
begin;
update disciplina set cargahoraria = cargahoraria * 1.2 where cargahoraria = 60;
select * from disciplina order by codigodisciplina;
update disciplina set cargahoraria = cargahoraria * 1.1 where cargahoraria = 40;
select * from disciplina order by codigodisciplina;
commit;


