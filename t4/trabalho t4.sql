--TABLES CREATION
create table curso (
codcurso int not null primary key,
curso varchar(50) not null,
duracao int not null,
dtcurso date not null
);

create table analista (
codanalista int not null,
analista varchar(50) not null,
idade int not null,
endereco char(30) not null,
codcurso int not null,
salario float not null,
PRIMARY KEY (codanalista),
FOREIGN KEY (codcurso) REFERENCES curso (codcurso)
);

create table programador (
codprogramador int not null,
programador varchar(50) not null,
idade int not null,
endereco char(30) not null,
salario float not null,
PRIMARY KEY (codprogramador)
);

create table atividadesanalise(
codatividadeanalise int not null,
dtinicio date not null,
dttermino date not null,
descricao varchar(100) not null,
codanalista int not null,
PRIMARY KEY (codatividadeanalise),
FOREIGN KEY (codanalista) REFERENCES analista (codanalista)
);

create table atividadesprog(
codatividadeprog int not null,
dtinicio date not null,
dttermino date not null,
descricao varchar(100) not null,
codprogramador int not null,
codatividadeanalise int not null,
PRIMARY KEY (codatividadeprog),
FOREIGN KEY (codprogramador) REFERENCES programador (codprogramador),
FOREIGN KEY (codatividadeanalise) REFERENCES atividadesanalise (codatividadeanalise)
);

--INSERTING DATA
INSERT INTO curso (codcurso, curso, duracao, dtcurso) 
VALUES
(1, 'Oracle 8i', 360, '2009-03-01'),
(2, 'Delphi', 300, '2009-05-30'),
(3, 'Windows 98', 20, '2009-04-28'),
(4, 'Linux', 35, '2009-06-06'),
(5, 'Visual Basic', 120, '2009-04-28'),
(6, 'Office', 15, '2009-05-30');

INSERT INTO  analista (codanalista, analista, idade, endereco, codcurso, salario) 
VALUES
(1, 'João', 20, 'Av. Carlos Gomes, 200', 1, 2300),
(2, 'Joice', 24, 'Av Independência, 10', 1, 2245),
(3, 'Pedro', 32, 'Av. Carlos Gomes, 100', 2, 2145),
(4, 'Maria', 28, 'Dom Pedro II, 10', 6, 1890),
(5, 'Rafael', 39, 'Av. Nilo Peçanha, 40', 2, 2800);

INSERT INTO programador (codprogramador, programador, idade, endereco, salario) 
VALUES
(10, 'Jeferson', 34, 'Av. Ipiranga, 10', 1000),
(20, 'Andrea', 25, 'Souza Reis, 200', 1200),
(30, 'Ana Paula', 23, 'Av. Carlos Gomes, 100', 1450),
(40, 'Fernando', 20, 'Av. Ipiranga, 20', 1600),
(50, 'Susana', 40, 'Av. Assis Brasil, 200', 1180);

INSERT INTO atividadesanalise (codatividadeanalise, dtinicio, dttermino, descricao, codanalista) 
VALUES
(10, '2009-01-01', '2009-01-30', 'Processo de Venda', 2),
(20, '2009-02-03', '2009-02-28', 'Pedido de Compra', 2),
(30, '2009-05-04', '2009-06-20', 'Cadastro Fornecedor', 1),
(40, '2009-06-06', '2009-07-30', 'Cadastro Produto', 4);

INSERT INTO atividadesprog (codatividadeprog, dtinicio, dttermino, descricao, codprogramador, codatividadeanalise) 
VALUES
(100, '2009-01-05', '2009-01-07', 'Tela 105', 10, 10),
(101, '2009-02-05', '2009-02-10', 'Relatorio 12', 10, 20),
(102, '2009-02-05', '2009-02-15', 'Procedure 75', 20, 20),
(103, '2009-01-01', '2009-04-10', 'Tela 165', 10, 30),
(104, '2009-01-01', '2009-06-15', 'Relatorio 16', 30, 30);

--QUESTIONS

/*1 – Criar uma view com o nome de cursosanalista, que contém o nome do curso, nome do
analista e salário do analista com um aumento de 10%.
*/
CREATE OR REPLACE VIEW cursoanalista AS
SELECT curso, analista, salario + (salario * 0.1) AS "SAL + 10%" FROM curso, analista
WHERE curso.codcurso = analista.codcurso;
--OK
SELECT * FROM cursoanalista;

/*2 – Montar um cursor que mostra o nome do programador e a quantidade de dias de férias.
Caso o programador tenha idade:
de 20 a 24 anos 18 dias
de 25 a 35 anos 21 dias
acima de 35 anos 25 dias
*/
CREATE OR REPLACE FUNCTION funcCursorProg() RETURNS TABLE(nome VARCHAR(15), ferias INT) AS $$
DECLARE
	cursorProg CURSOR FOR
	SELECT programador, CASE
		WHEN (idade >= 20 AND idade <= 24) THEN 18
		WHEN (idade >= 25 AND idade <= 35) THEN 21
		WHEN (idade > 35) THEN 25
	END FROM programador;
BEGIN
	OPEN cursorProg;
	FETCH cursorProg INTO nome, ferias;
WHILE FOUND LOOP
	RETURN NEXT;
	FETCH cursorProg INTO nome, ferias;
END LOOP;
CLOSE cursorProg;
RETURN;
END;
$$ LANGUAGE PLPGSQL;
--OK
SELECT * from funcCursorProg();

/*3 – Criar uma view com o nome de ativanalista, contendo o nome do analista e a
quantidade de atividades de análise que ele realizou.
*/
CREATE OR REPLACE VIEW ativanalista AS
SELECT analista, COUNT(atividadesanalise.codanalista) AS "QTD ATIV" FROM analista, atividadesanalise
WHERE atividadesanalise.codanalista = analista.codanalista
GROUP BY analista ORDER BY analista;
--OK
SELECT * FROM ativanalista;

/*4 – Montar um cursor atualiza o salário dos analistas a partir da quantidade de atividades de
análise realizadas.
1 atividade 5%
2 atividades 10%
3 atividades ou mais 15%
*/
CREATE OR REPLACE FUNCTION atualizaSalario() RETURNS VOID AS $$
DECLARE
	atualiza CURSOR FOR SELECT salario FROM analista;
	--UPDATE analista SET salario = salario + (salario * 0.05);
	
BEGIN
	OPEN atualiza;
	FETCH atualiza;
WHILE FOUND LOOP
	RETURN NEXT;
	FETCH atualiza;
END LOOP;
CLOSE atualiza;
RETURN;
END;
$$ LANGUAGE PLPGSQL;

SELECT * FROM atualizaSalario();
SELECT analista, salario FROM analista;
/*joao 2300
joice 2245
pedro 2145
maria 1890
rafael 2800
*/

/*5 – Monte uma consulta para mostrar o nome do(s) analista(s) e o nome de seu respectivo
curso, o(s) qual(is) nunca tive(ram) atividades realizadas com o programador o qual tenha
em seu nome a palavra “Jefer”
*/
SELECT a.analista, c.curso FROM analista a, curso c WHERE c.codcurso = a.codcurso AND NOT EXISTS (
SELECT FROM atividadesanalise aa, atividadesprog ap, programador p
WHERE a.codanalista = aa.codanalista
AND aa.codatividadeanalise = ap.codatividadeanalise
AND ap.codprogramador = p.codprogramador
AND p.programador LIKE '%Jefer%'
);
--OK