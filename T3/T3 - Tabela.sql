﻿--CRIACAO TABELAS
CREATE TABLE ex_motorista
(cnh CHAR(5) PRIMARY KEY,
nome VARCHAR(20) NOT NULL,
totalMultas DECIMAL(9,2) );

CREATE TABLE ex_multa
(id serial PRIMARY KEY,
cnh CHAR(5) REFERENCES ex_motorista(cnh) NOT NULL,
velocidadeApurada DECIMAL(5,2) NOT NULL,
velocidadeCalculada DECIMAL(5,2),
pontos INTEGER NOT NULL,
valor DECIMAL(9,2) NOT NULL);

--INSERINDO DADOS
INSERT INTO ex_motorista VALUES('123AB', 'Carlo');

/*Exercicio 01:
–Recebe CNH e VelocidadeApurada
–Retorna texto com a mensagem: O motorista [nome] soma [X] pontos em em multas;
	–Se velocidade entre 80.01 e 110 motorista multado em 120,00 e receber 20 pontos;
	–Se velocidade entre 110.01 e 140 motorista multado em 350 e receber 40 pontos;
	–Se velocidade acima de 140 motorista multado em 680 e receber 60 pontos;
•O sistema deve considerar somente 90% da velocidade apurada para o cálculo da multa.
•Após o cálculo o sistema deve incluir a multa na tabela ex_multa (se o contribuinte foi multado)
•Então retornar o total acumulado de multas para o motorista.
*/
CREATE OR REPLACE FUNCTION insereMulta(CNH CHAR(05), velAp DECIMAL(5,2)) RETURNS VOID AS $$
DECLARE

	BEGIN
	SELECT * FROM ex_motorista mo
	WHERE mo.cnh = CNH


	
RAISE NOTICE 'O motorista [nome] soma [X] pontos em em multas'
$$ LANGUAGE PLPGSQL;


/*Exercicio 02:
•Escreva um outro procedimento que atualize o campo totalMultas da tabela ex_motorista
a partir dos totais apurados para cada motorista autuado na tabela ex_multa.
•OBS1: motorista sem multa deverão possuir valor 0.00 no campo total multa;
•OBS2:cuidado para não duplicar valores na coluna totalMultas para os casos em que a
rotina for disparada mais de uma vez.*/
