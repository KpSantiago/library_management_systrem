-- Sistema de gerenciamento de biblioteca online em MySQL
/* 
 * É um sistema no qual os professores e os alunos podem 
 * distribuir livros.
 * 
 * TABELAS 
 * livros
 * 	- id
 * 	- nome
 * 	- data_emissao
 * 	- data_devolucao
 * 	- estaDisponivel
 * 
 * autores
 * 	- id
 * 	- nome
 * 
 * autores_livros
 *  - id
 *  - idLivro
 * 	- idAutor
 * 
 * alunos
 * 	- id
 * 	- nome
 * 	- estaMultado
 * 	- idLivro
 */
 
create database if not exists library_management_system;

use library_management_system;

show tables;

create table livros (
	id int not null auto_increment,
	nome varchar(200) not null,
	data_emissao datetime,
	data_devolucao datetime,
	estaDisponivel bool not null default 1,
	primary key(id)
);

alter table livros add  
	column data_devolucao_estimada datetime after data_devolucao; 

create table alunos (
	id int not null auto_increment,
	nome varchar(200) not null,
	estaMultado bool not null default 0,
	idLivro int,
	primary key(id),
	foreign key(idLivro) references livros(id)
);

create table autores (
	id int not null auto_increment,
	nome varchar(200) not null,
	primary key(id)
);

create table autores_livros (
	id int not null auto_increment,
	idLivro int,
	idAutor int,
	primary key(id),
	foreign key(idLivro) references livros(id),
	foreign key(idAutor) references autores(id)
);


insert into livros (nome) values 
('O Livro dos Mártires'), 
('O Grande Conflito'), 
('Generais de Deus'),
('Harry Potter e a Pedra Filosofal'), 
('O Ceifador'), 
('A Nuvem'), 
('O Timbre');

select * from livros;

insert into autores (nome) values 
('John Foxe'), 
('Ellen G. White'), 
('J. K. Rowling'), 
('Neal Shusterman');

select * from autores;

insert into autores_livros (idLivro, idAutor) values (1,1), (2,2), (3,1), (4,3), (5,4), (6,4), (7,4);

select * from autores_livros;

insert into alunos (nome) values ('Kauã'), ('José'), ('Pereira'), ('Santiago');

select * from alunos;


-- TASKS

--  1. Selectionar todos os livros com os seus determinados autores
select l.nome, a.nome from livros as l join autores_livros as al 
on l.id = al.idLivro join autores as a on a.id = al.idAutor;

-- 	2. selecionar todos os alunos icluindo aqueles que pegaram livros ou não
select a.nome, a.estaMultado, l.nome, l.data_emissao, l.data_devolucao, l.data_devolucao_estimada from alunos as a 
left outer join livros as l on l.id = a.idLivro;

-- 3. mude o dado de um aluno no seguinte caso: o aluno alugou um livro, e ele precisa entregar o livro em 7 dias. 
--  adicione todos os dados necessarios e verifique 
-- se a transação ocorreu correatemente.
update alunos 
	set idLivro = 1
	where id = 1;
update livros 
	set data_emissao = now(), data_devolucao_estimada = '2024-01-11 11:00:00.000', estaDisponivel = 0
	where id = 1;
	
select a.nome, l.nome, l.data_emissao, l.data_devolucao_estimada from alunos as a 
inner join livros as l on a.idLivro = l.id where a.id = 1;

-- 4. infelizemente o aluno anterior não conseguiu terminar o livro no tempo determinado, ele decediu ficar com livro até terminar.
-- ele não conseguiu terminar mesmo 15 dias após a data de devolucao estimada. mostre os dados desse aluno e do livro (nome, livro, data_emissao, data_devolucao e data_devolucao_estimada, estaMultado)
update alunos 
	set estaMultado = 1
	where id = 1;

 select a.nome, a.estaMultado, l.nome, l.data_emissao, l.data_devolucao_estimada from alunos as a 
inner join livros as l on a.idLivro = l.id where a.id = 1;

-- 5. 30 dias após a data devolucao o aluno terminou o livro, pagou a multa e devolveu o livro em um bom estado, altere os dados do livro e do aluno da forma correspondente
-- e mostre as informações
update alunos 
	set estaMultado = 0, idLivro = null
	where id = 1;
update livros 
	set data_devolucao = '2024-02-11 17:30:22.587', estaDisponivel = 1
	where id = 1;

select * from alunos where id = 1;
select * from livros where id = 1;

-- 6. contar o numero de livros registrados no banco
select count(id) from livros;

-- 7. contar todos os alunos que não estão multados
select count(id) from alunos where estaMultado <> 1;

-- 8. contar todos autores do banco
select count(id) from autores;

