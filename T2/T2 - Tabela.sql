--SET datestyle TO SQL, DMY; --Muda o datastyle (ou usar to_date())
--CRIACAO TABELA
create table construtora
(cod_const char(10) not null,
cgc char(20) unique not null,
nome_const char(30) not null,
primary key (cod_const));

create table engenheiro
(crea char(8) not null,
cpf char(11) unique not null,
nome_eng char(30) not null,
area_atuacao char(20) not null,
primary key (crea));

create table obra
(cod_obra integer not null,
nome_obra char(30) not null,
localizacao char(50) not null,
tipo char(15) not null,
cod_const char(10) not null,
cod_eng_resp char(8) not null,
primary key (cod_obra),
foreign key (cod_const) references construtora,
foreign key (cod_eng_resp) references engenheiro);

create table operario
(cart_trab char(15) not null,
nomeop char(30) not null,
endereco char(50) not null,
telefone char(20),
primary key (cart_trab));

create table obra_operario
(cod_obra integer not null,
cart_trab char(15) not null,
data date not null,
atividades char(200),
primary key (cod_obra, cart_trab, data),
foreign key (cod_obra) references obra,
constraint fk_obra_op foreign key (cart_trab) references operario);

create table operario_construtora
(cart_trab char(15) not null,
cod_const char(10) not null,
primary key (cart_trab, cod_const),
constraint fk_opconst foreign key (cart_trab) references operario,
foreign key (cod_const) references construtora);

--INSERINDO DADOS
/* Dados da tabela Construtora */
insert into construtora
values ('c1', '12365423512489','Encol');
insert into construtora
values ('c2','78874529890133','Goldzstein');
insert into construtora
values ('c3', '89083484166739','A3');
insert into construtora
values ('c4', '87294592979871','Metaplan');

/* Dados da tabela Engenheiro */
insert into engenheiro
values ('e1','5637279211','Luis Silva','Edificacao');
insert into engenheiro
values ('e2','73941939815','Carlos Alvarez','Pontes/Viadutos');
insert into engenheiro
values ('e3','89058348193','Maria Souza','Pontes/Viadutos');
insert into engenheiro
values ('e4','83489347851','Jose Silva','Edificacao');

/* Dados da tabela Obra */
insert into obra
values (01,'Boqueirao','BR 116, Km 25','Viaduto','c4','e2');
insert into obra
values (02,'Solar Firenze','Rua Mariland, 512 - Porto Alegre','Edificio','c1','e1');
insert into obra
values (03,'Serraria','Rua Sarandi, 600 - Porto Alegre','Ponte','c4','e3');
insert into obra
values (04,'Venezia','Av. Carlos Soares, 890 - Canoas','Edificio','c3','e4');
insert into obra
values (05,'Guaiba','Av. Praia de Belas, 1200 - Porto Alegre','Edificio','c2','e1');
insert into obra
values (06,'particular','Rua Ipanema, 310 - Porto Alegre','Casa','c3','e3');

/* Dados da tabela Operario */
insert into operario
values ('op030','Joao Souza','Rua Lima, 89 - Porto Alegre','249-9087');
insert into operario
values ('op010','Paulo Castro','Av. Protasio Alves, 23/101 - Porto Alegre',NULL);
insert into operario
values ('op876','Luis Padilha','Av. Salgado Filho, 345 - Canoas','472-9083');
insert into operario
values ('op452','Marcos Freitas','Travessa do Canto, 67/304 - Porto Alegre','331-7838');

/* Dados da tabela obra_operario */
insert into obra_operario
values (03,'op010',to_date('15/06/1997','dd/mm/yyyy'),'preparacao da base');
insert into obra_operario
values (01,'op030',to_date('18/06/1997','dd/mm/yyyy'),'preparacao e colocacao de ferros');
insert into obra_operario
values (01,'op010',to_date('02/08/1997','dd/mm/yyyy'),NULL);
insert into obra_operario
values (02,'op876',to_date('20/08/1997','dd/mm/yyyy'),'pintura aberturas do 2o. andar');
insert into obra_operario
values (02,'op030',to_date('12/08/1997','dd/mm/yyyy'),'colocacao aberturas 20. andar');
insert into obra_operario
values (04,'op010',to_date('03/03/1997','dd/mm/yyyy'),'colocacao telhado');

/* Dados da tabela operario_construtora */
insert into operario_construtora
values ('op010','c4');
insert into operario_construtora
values ('op030','c4');
insert into operario_construtora
values ('op030','c1');
insert into operario_construtora
values ('op010','c3');
insert into operario_construtora
values ('op876','c1');


/*1) Recuperar os nomes de todos os engenheiros, que projetaram obras nas quais o operário
João Souza tenha trabalhado em junho de 97*/
SELECT nome_eng FROM engenheiro eng, obra ob, obra_operario obop, operario op
 WHERE eng.crea = ob.cod_eng_resp
 AND ob.cod_obra = obop.cod_obra
 AND obop.data BETWEEN '01/06/1997' AND '30/06/1997' --IMPOSSIVEL COMPARAR DATA COM STRING. Mais performance
 AND obop.cart_trab = op.cart_trab
 AND op.nomeop = 'Joao Souza'

SELECT nome_eng FROM engenheiro eng, obra ob, obra_operario obop, operario op
 WHERE eng.crea = ob.cod_eng_resp
 AND ob.cod_obra = obop.cod_obra
 AND TO_CHAR(obop.data, 'dd/mm/yyyy') LIKE '%06/1997'
 AND obop.cart_trab = op.cart_trab
 AND op.nomeop = 'Joao Souza'

/*2) Recuperar os nomes dos operários que trabalharam em obras de
pelo menos todos os engenheiros da area de Pontes/Viadutos.*/
SELECT nomeop FROM operario op, obra_operario obop, obra ob, engenheiro eng
 WHERE op.cart_trab = obop.cart_trab
 AND obop.cod_obra = ob.cod_obra
 AND ob.cod_eng_resp = eng.crea
 AND eng.area_atuacao = 'Pontes/Viadutos'
--juntar as duas querys
 SELECT COUNT(*) FROM engenheiro WHERE area_atuacao = 'Pontes/Viadutos'


NOMEOP
------------------------------
Paulo Castro
/*3) Para cada operário que trabalha para mais de uma construtora,
recuperar o seu nome e os nomes das construtoras.*/
SELECT nomeop, nome_const FROM operario op, construtora cons, operario_construtora opcons
WHERE op.cart_trab = opcons.cart_trab
AND cons.cod_const = opcons.cod_const
GROUP BY nomeop

HAVING COUNT(cons.cod_const) > 1
GROUP BY nome_const
--mostrar acima de 2
ORDER BY nomeop DESC --excluir linha

NOMEOP NOME_CONST
----------------------------- ------------------------------
Paulo Castro A3
Paulo Castro Metaplan
Joao Souza Encol
Joao Souza Metaplan
/*4) Recuperar os nomes dos operários que trabalham em somente uma construtora.*/
SELECT nomeop FROM operario op, construtora cons, operario_construtora opcons
WHERE op.cart_trab = opcons.cart_trab
AND cons.cod_const = opcons.cod_const
GROUP BY nomeop
HAVING COUNT(cons.cod_const) < 2

NOMEOP
------------------------------
Luis Padilha
/*5) Recuperar os nomes dos engenheiros que atuam em alguma construtora além da Encol.*/



NOME_ENG
------------------------------
Luis Silva
/*6) Para cada construtora, recuperar o nome da construtora e o
número de engenheiros da área de Edificação.*/



NOME_CONST Qtde de Engenheiros
------------------------------ ---------------------------
A3 1
Encol 1
Goldzstein 1
/*7) Para cada operário da construtora Encol, recuperar o seu numero
de carteira de trabalho, nome e o numero de obras (mesmo não sendo da
construtora Encol) nas quais trabalhou no primeiro semestre de 97.*/




CART_TRAB NOMEOP Qtde de Obras
--------------- ------------------------------ -----------------------
op030 Joao Souza 1












