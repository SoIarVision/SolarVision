-- CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE projetoPi;
USE projetoPi;

-- CRIAÇÃO DAS TABELAS

CREATE TABLE painel (
id INT PRIMARY KEY AUTO_INCREMENT,
qtd_painel VARCHAR(50),
dt_instalacao DATE NOT NULL,
ult_limpeza DATE,
CONSTRAINT chk_limpeza CHECK(ult_limpeza >= '1999-01-01'),
luminosidade INT,
CONSTRAINT chk_luminosidade CHECK(luminosidade BETWEEN 0 AND 1023)
);

CREATE TABLE clientes(
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
end_completo VARCHAR(50) NOT NULL,
telefone CHAR(12) NOT NULL UNIQUE
);

CREATE TABLE registro(
idCliente INT,
dia DATETIME DEFAULT NOW(),
valor INT,
CONSTRAINT chk_luminosidade2 CHECK(valor BETWEEN 0 AND 1023)
);


-- INSERÇÕES NAS TABELAS
INSERT INTO clientes VALUE(DEFAULT, 'MARCO', 'ESTERO BELACO', '1199754-0302');
INSERT INTO clientes VALUE(DEFAULT, 'ASHLEY', 'RUA DAS ROSAS', '119999-0011');
INSERT INTO clientes VALUE(DEFAULT, 'WELLINGTON', 'VILA DAS SOMBRAS', '119888-7851');
INSERT INTO clientes VALUE(DEFAULT, 'KAIJO', 'VILA DA FOLHA', '1197777-6767');
INSERT INTO clientes VALUE(DEFAULT, 'Lara', 'RUA SANTA CRUZ', '1196767-6666');
INSERT INTO clientes VALUE(DEFAULT, 'Enzo', 'RUA DA LIBERDADE', '1195564-0033');
INSERT INTO clientes VALUE(DEFAULT, 'Nicolas', 'RUA DA LADEIRA', '1190466-2828');
INSERT INTO clientes VALUE(DEFAULT, 'Gabryel', 'RUA DO MAR', '119987-0908');

INSERT INTO painel(id,qtd_painel, dt_instalacao, ult_limpeza, luminosidade) VALUE(DEFAULT, 5, '2017-08-18', 1001);
INSERT INTO painel VALUE(DEFAULT, 10, '2020-12-20', '2025-01-02', 500);
INSERT INTO painel VALUE(DEFAULT, 30, '2026-01-01', null, 1000);
INSERT INTO painel VALUE(DEFAULT, 2, '2025-01-29', null, 400);
INSERT INTO painel VALUE(DEFAULT, 100, '2024-12-12', 2025-09-13, 750);

INSERT INTO registro VALUE(1, default, 1000);
INSERT INTO registro VALUE(2, default, 980);
INSERT INTO registro VALUE(3, default, 995);
INSERT INTO registro VALUE(4, default, 750);
INSERT INTO registro VALUE(5, default, 450);
INSERT INTO registro VALUE(6, default, 890);
INSERT INTO registro VALUE(7, default, 930);

-- CONSULTA NAS TABELAS
SELECT * FROM clientes;

SELECT * FROM painel;

SELECT * FROM registro;

SELECT id FROM painel WHERE ult_limpeza = '2025-01-02';

SELECT * FROM painel WHERE luminosidade >= 500;

SELECT id FROM clientes WHERE telefone LIKE "%_9%";

SELECT * FROM registro where idCliente = 1;


SELECT CASE
when qtd_painel >= 7 then 'Grande' when qtd_painel >= 5 then 'Médio' else 'Pequeno' end
FROM painel;

UPDATE clientes SET nome = 'LARA' WHERE id = 5;
UPDATE clientes SET nome = 'ENZO' WHERE id = 6;
UPDATE clientes SET nome = 'NICOLAS' WHERE id = 7;
UPDATE clientes SET nome = 'GABRYEL' WHERE id = 8;

UPDATE painel SET luminosidade = 100 WHERE id = 1;