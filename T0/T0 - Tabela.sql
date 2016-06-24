--CRIANDO TABELAS
create table Xproduto
(codproduto int not null,
descricaoproduto varchar(50) not null,
unidade char(2) not null,
preco float not null,
primary key (codproduto));

create table Xcliente
(codcliente int not null,
cliente varchar(50) not null,
cpf char(11) not null,
endereco char(30) not null,
primary key (codcliente));

create table Xtipospagamento
(codtppagamento int not null,
descricaotppagamento varchar(20) not null,
primary key (codtppagamento));

create table Xvenda
(nnf int not null,
dtvenda date not null,
codcliente int not null,
codtppagamento int not null,
vlvenda float not null,
primary key (nnf, dtvenda),
foreign key (codcliente) references Xcliente,
foreign key (codtppagamento) references Xtipospagamento);

create table Xitensvenda
(nnf int not null,
dtvenda date not null,
codproduto int not null,
qtde float not null,
primary key (nnf, dtvenda, codproduto),
foreign key (nnf, dtvenda) references Xvenda,
foreign key (codproduto) references Xproduto);

--INSERINDO DADOS
insert into Xproduto values (1, 'Coca Cola', 'lt', 1.20);
insert into Xproduto values (2, 'Presunto Sadia', 'kg', 5.40);
insert into Xproduto values (3, 'Sabonete Palmolive', 'un', 0.65);
insert into Xproduto values (4, 'Shampoo Colorama', 'un', 2.60);
insert into Xproduto values (5, 'Cerveja Skol', 'gf', 0.99);

insert into Xcliente values (1, 'Joao da Silva', '123456789', 'Rua Andradas, 250');
insert into Xcliente values (2, 'Maria do Rosario', '26547899', 'Rua Lima e Silva, 648');
insert into Xcliente values (3, 'Paulo Silveira', '8963254', 'Rua Plinio Brasil Milano, 980');
insert into Xcliente values (4, 'Rosa Aparecida dos Santos', '5896332123', 'Av Ipiranga, 8960');

insert into Xtipospagamento values (1, 'Cheque');
insert into Xtipospagamento values (2, 'Dinheiro');
insert into Xtipospagamento values (3, 'Crediario');

insert into Xvenda values (1, '20/04/2002', 1, 1, 15.00);
insert into Xvenda values (2, '20/04/2002', 2, 1, 7.50);
insert into Xvenda values (1, '25/04/2002', 3, 2, 7.90);
insert into Xvenda values (1, '30/04/2002', 3, 2, 8.50);

insert into Xitensvenda values (1, '20/04/2002', 1, 1);
insert into Xitensvenda values (1, '20/04/2002', 2, 2);
insert into Xitensvenda values (2, '20/04/2002', 1, 3);
insert into Xitensvenda values (2, '20/04/2002', 2, 2);
insert into Xitensvenda values (2, '20/04/2002', 4, 4);
insert into Xitensvenda values (1, '25/04/2002', 3, 9);
insert into Xitensvenda values (1, '30/04/2002', 3, 7);

/*1 – Selecionar o nome do cliente e quantidade de produtos comprados,
somente para clientes que compraram Coca Cola.*/
SELECT cliente, SUM (qtde)
FROM Xcliente, Xvenda, Xitensvenda, Xproduto
WHERE Xcliente.codcliente = Xvenda.codcliente
AND (Xvenda.nnf, Xvenda.dtvenda) = (Xitensvenda.nnf, Xitensvenda.dtvenda)
AND Xitensvenda.codproduto = Xproduto.codproduto 
AND Xproduto.codproduto = 1
GROUP BY cliente

/*2 – Selecionar o nome do cliente e o valor total comprado por ele.*/
SELECT Xcliente.cliente, SUM(Xvenda.vlvenda) 
FROM Xcliente, Xvenda
WHERE Xcliente.codcliente = Xvenda.codcliente
GROUP BY cliente

/*3 – Selecionar a descrição e o maior preço de produto vendido.*/
SELECT descricaoproduto, preco FROM Xproduto
WHERE preco = (SELECT MAX(preco) FROM Xproduto)

/*4 – Selecionar o nome do cliente e descrição do tipo de pagamento utilizado nas vendas.*/
SELECT DISTINCT cliente, descricaotppagamento
FROM Xcliente, Xtipospagamento, Xvenda
WHERE Xcliente.codcliente = Xvenda.codcliente
AND Xvenda.codtppagamento = Xtipospagamento.codtppagamento
ORDER BY cliente

/*5 – Selecionar o nome do cliente, nnf, data da venda, descrição do tipo de pagamento,
descrição do produto e quantidade vendida dos itens vendidos.*/
SELECT xc.cliente, xv.nnf, xv.dtvenda, xt.descricaotppagamento, xp.descricaoproduto, xi.qtde
FROM Xcliente xc, Xvenda xv, Xitensvenda xi, Xproduto xp, Xtipospagamento xt
WHERE xc.codcliente = xv.codcliente
AND xv.nnf = xi.nnf
AND xv.dtvenda = xi.dtvenda
AND xi.codproduto = xp.codproduto
AND xv.codtppagamento = xt.codtppagamento

/*6 – Selecionar a média de preço dos produtos vendidos.*/
SELECT AVG(Xproduto.preco)
FROM Xproduto, Xitensvenda
WHERE Xproduto.codproduto = Xitensvenda.codproduto

/*7 – Selecionar o nome do cliente e a descrição dos produtos comprados por ele.
Não repetir os dados (distinct)*/
SELECT DISTINCT xc.cliente, xp.descricaoproduto
FROM Xcliente xc, Xvenda xv, Xitensvenda xi, Xproduto xp
WHERE xc.codcliente = xv.codcliente
AND xv.nnf = xi.nnf
AND xv.dtvenda = xi.dtvenda
AND xi.codproduto = xp.codproduto

/*8 – Selecionar a descrição do tipo de pagamento, e a maior data de venda que utilizou
esse tipo de pagamento. Ordenar a consulta pela descrição do tipo de pagamento.*/
SELECT t.descricaotppagamento, max(v.dtvenda)
FROM Xvenda v, Xtipospagamento t
WHERE v.codtppagamento = t.codtppagamento
GROUP BY t.descricaotppagamento
ORDER BY t.descricaotppagamento

/*9 – Selecionar a data da venda e a média da quantidade de produtos vendidos.
Ordenar pela data da venda decrescente.*/
SELECT dtvenda, AVG(qtde)
FROM Xitensvenda
GROUP BY dtvenda
ORDER BY dtvenda DESC

/*10 – Selecionar a descrição do produto e a média de quantidades vendidas do produto.
Somente se a média for superior a 4.*/
SELECT xp.descricaoproduto, avg(xi.qtde)
FROM Xproduto xp, Xitensvenda xi
WHERE xp.codproduto = xi.codproduto
GROUP BY xp.descricaoproduto
HAVING AVG(xi.qtde) > 4
