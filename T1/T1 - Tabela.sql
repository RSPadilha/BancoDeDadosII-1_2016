--ALTER DATABASE "T1" SET datestyle TO SQL, DMY; --Muda permanentemente o datastyle para dd/mm/yyyy
--SET datestyle TO SQL, DMY; --Muda o datastyle (ou usar to_date())

--CRIACAO TABELA
create table voo
(num_voo char(10) not null,
hora_part char(4) not null,
hora_cheg char(4) not null,
cidade_part char(20) not null,
cidade_cheg char(20) not null,
primary key (num_voo));

create table piloto
(cod_piloto char(10) not null,
nome char(30) not null,
endereco char(50) not null,
data_admissao date not null,
primary key (cod_piloto));

create table execucao_voo
(num_voo char(10) not null,
data date not null,
cod_piloto char(15) not null,
n_lugares integer not null,
primary key (num_voo,data),
foreign key (num_voo) references voo);

create table cliente_p
(cod_cli char(10) not null,
nome char(30) not null,
endereco char(50) not null,
telefone char(20),
primary key (cod_cli));

create table passagem
(num_voo char(10) not null,
data date not null,
poltrona char(3) not null,
cod_cli char(10),
data_reserva date,
primary key (num_voo, data, poltrona),
foreign key (num_voo, data) references execucao_voo,
foreign key (cod_cli) references cliente_p);

--INSERINDO DADOS
/* insercao de dados na tabela voo */
insert into voo
values ('v1','800','845','Sao Paulo','Rio de Janeiro');
insert into voo
values ('v2','1000','1330','Sao Paulo','Salvador');
insert into voo
values ('v3','2200','2330','Porto Alegre','Sao Paulo');
insert into voo
values ('v5','1200','1345','Porto Alegre','Rio de Janeiro');
insert into voo
values ('v4','1100','1150','Porto Alegre','Florianopolis');

/* insercao de dados na tabela piloto */
insert into piloto
values ('p1','Pedro','Rua Carlos Gomes, 607',to_date('03/03/1989','dd/mm/yyyy'));
insert into piloto
values ('p4','Ronaldo','Rua 24 de outubro, 312/201',to_date('20/04/1980','dd/mm/yyyy'));
insert into piloto
values ('p2','Paulo','Rua Nilo Peçanha, 804/203',to_date('13/11/1990','dd/mm/yyyy'));
insert into piloto
values ('p3','Marcos','Rua Mariland, 645/302',to_date('12/07/1988','dd/mm/yyyy'));

/* insercao de dados na tabela execucao_voo */
insert into execucao_voo
values ('v1',to_date('18/06/2002','dd/mm/yyyy'),'p2',70);
insert into execucao_voo
values ('v1',to_date('20/09/2002','dd/mm/yyyy'),'p2',200);
insert into execucao_voo
values ('v3',to_date('10/08/2002','dd/mm/yyyy'),'p2',140);
insert into execucao_voo
values ('v4',to_date('20/09/2002','dd/mm/yyyy'),'p4',100);
insert into execucao_voo
values ('v3',to_date('11/11/2002','dd/mm/yyyy'),'p2',300);
insert into execucao_voo
values ('v1',to_date('22/09/2002','dd/mm/yyyy'),'p1',110);
insert into execucao_voo
values ('v5',to_date('20/09/2002','dd/mm/yyyy'),'p3',145);
insert into execucao_voo
values ('v2',to_date('01/09/2002','dd/mm/yyyy'),'p4',350);
insert into execucao_voo
values ('v1',to_date('23/09/2002','dd/mm/yyyy'),'p4',290);
insert into execucao_voo
values ('v1',to_date('11/11/2002','dd/mm/yyyy'),'p4',125);
insert into execucao_voo
values ('v5',to_date('10/11/2002','dd/mm/yyyy'),'p4',185);

/* insercao de dados na tabela cliente */
insert into cliente_p
values ('c1','Joao','Rua Freire Alemao, 83/501','(051) 330-9009');
insert into cliente_p
values ('c2','Luis','Rua Anita Garibaldi, 1001/703','(051) 330-1009');
insert into cliente_p
values ('c3','Carlos','Av. Carazinho', 120);
insert into cliente_p
values ('c4','Maria','Av. Protasio Alves, 3244/303','(051) 333-7445');

/* insercao de dados na tabela passagem */
insert into passagem
values ('v5',to_date('20/09/2002','dd/mm/yyyy'),'16a','c3',to_date('12/03/2002','dd/mm/yyyy'));
insert into passagem
values ('v1',to_date('20/09/2002','dd/mm/yyyy'),'16b','c4',to_date('15/05/2002','dd/mm/yyyy'));
insert into passagem
values ('v1',to_date('18/06/2002','dd/mm/yyyy'),'24b','c3',to_date('12/03/2002','dd/mm/yyyy'));
insert into passagem
values ('v3',to_date('10/08/2002','dd/mm/yyyy'),'13a','c4',to_date('10/05/2002','dd/mm/yyyy'));
insert into passagem
values ('v4',to_date('20/09/2002','dd/mm/yyyy'),'19c','c3',to_date('13/06/2002','dd/mm/yyyy'));
insert into passagem
values ('v3',to_date('10/08/2002','dd/mm/yyyy'),'1a','c1',to_date('20/03/2002','dd/mm/yyyy'));
insert into passagem
values ('v3',to_date('11/11/2002','dd/mm/yyyy'),'2a','c2',to_date('12/09/2002','dd/mm/yyyy'));
insert into passagem
values ('v5',to_date('20/09/2002','dd/mm/yyyy'),'21a','c1',to_date('05/04/2002','dd/mm/yyyy'));
insert into passagem
values ('v5',to_date('10/11/2002','dd/mm/yyyy'),'11a','c3',to_date('15/04/2002','dd/mm/yyyy'));
insert into passagem
values ('v4',to_date('20/09/2002','dd/mm/yyyy'),'19a','c2',to_date('02/06/2002','dd/mm/yyyy'));
insert into passagem
values ('v1',to_date('11/11/2002','dd/mm/yyyy'),'5a','c3',to_date('23/06/2002','dd/mm/yyyy'));

/*a) Recuperar os nomes de clientes que não voaram para o Rio de Janeiro no dia 20/09/02.*/
SELECT nome 
 FROM cliente_p
 WHERE cod_cli NOT IN(
  SELECT cod_cli
   FROM passagem
   WHERE data = '20/09/2002'
   AND num_voo IN(
    SELECT num_voo FROM voo WHERE cidade_cheg = 'Rio de Janeiro'));

/*b) Para cada vôo que o piloto Paulo tenha comandado, recuperar a cidade de partida
e a data do vôo, bem como o número de passagens marcadas.
Mostrar somente os vôos com menos de 500 passagens.*/
SELECT cidade_part, data, count(cod_cli)
 FROM passagem, voo
 WHERE passagem.num_voo = voo.num_voo
 AND (passagem.num_voo, data) IN(
SELECT num_voo, data
 FROM execucao_voo
 WHERE cod_piloto IN(
SELECT cod_piloto
 FROM piloto
 WHERE nome = 'Paulo'))
GROUP BY passagem.num_voo, data, cidade_part
HAVING count (cod_cli) < 500
ORDER BY cidade_part

/*c) Obter a cidade de partida e a data do último vôo que o piloto Paulo tenha comandado.*/
SELECT cidade_part, data
 FROM voo, execucao_voo
 WHERE voo.num_voo = execucao_voo.num_voo
 AND data IN(
SELECT max(data)
 FROM execucao_voo ev1
 WHERE cod_piloto = execucao_voo.cod_piloto
 AND cod_piloto IN(
SELECT cod_piloto
 FROM piloto
 WHERE nome = 'Paulo'));

--opcionais
/*d) Recuperar o código e nome de clientes que marcaram passagem em pelo menos todos os vôos
comandados pelo piloto Ronaldo, que saíram de Porto Alegre.*/

/*e) Recuperar o código e nome de clientes que marcaram passagem em pelo menos todos os vôos
comandados pelo piloto Ronaldo, que saíram de Porto Alegre. Selecionar somente aqueles clientes
que tenham mais de uma passagem marcada até o final do ano em vôos ainda não executados.*/