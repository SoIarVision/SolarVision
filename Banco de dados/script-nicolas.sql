-- CRIAÇÃO DO BANCO

CREATE DATABASE solarVision;
USE solarVision;

-- TABELA DE CLIENTES

CREATE TABLE clientes (
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
endereco VARCHAR(100) NOT NULL,
telefone VARCHAR(15) UNIQUE NOT NULL
);

-- TABELA DE PAINÉIS SOLARES

CREATE TABLE painel (
id INT PRIMARY KEY AUTO_INCREMENT,
qtd_paineis INT NOT NULL,
dt_instalacao DATE NOT NULL,
ult_limpeza DATE,
luminosidade INT,
CONSTRAINT chk_luminosidade CHECK (luminosidade BETWEEN 0 AND 1023),
CONSTRAINT chk_limpeza CHECK (ult_limpeza >= '2000-01-01')
);

-- TABELA DE REGISTRO DOS SENSORES

CREATE TABLE registro_sensor (
id INT PRIMARY KEY AUTO_INCREMENT,
idCliente INT,
data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
valor_luminosidade INT,
CONSTRAINT chk_luminosidade2 CHECK (valor_luminosidade BETWEEN 0 AND 1023),
FOREIGN KEY (idCliente) REFERENCES clientes(id)
);

-- INSERINDO CLIENTES

INSERT INTO clientes VALUES
(DEFAULT,'Marco','Rua Estero Belaco','11997540302'),
(DEFAULT,'Ashley','Rua das Rosas','1199990011'),
(DEFAULT,'Wellington','Vila das Sombras','1198887851'),
(DEFAULT,'Kaijo','Vila da Folha','11977776767'),
(DEFAULT,'Lara','Rua Santa Cruz','11967676666'),
(DEFAULT,'Enzo','Rua da Liberdade','11955640033'),
(DEFAULT,'Nicolas','Rua da Ladeira','11904662828'),
(DEFAULT,'Gabryel','Rua do Mar','1199870908');

-- INSERINDO PAINÉIS

INSERT INTO painel VALUES
(DEFAULT,5,'2017-08-18','2025-01-01',900),
(DEFAULT,10,'2020-12-20','2025-01-02',500),
(DEFAULT,30,'2026-01-01',NULL,1000),
(DEFAULT,2,'2025-01-29',NULL,400),
(DEFAULT,100,'2024-12-12','2025-09-13',750);

-- REGISTRO DE LEITURAS DOS SENSORES

INSERT INTO registro_sensor VALUES
(DEFAULT,1,DEFAULT,1000),
(DEFAULT,2,DEFAULT,980),
(DEFAULT,3,DEFAULT,995),
(DEFAULT,4,DEFAULT,750),
(DEFAULT,5,DEFAULT,450),
(DEFAULT,6,DEFAULT,890),
(DEFAULT,7,DEFAULT,930);

-- CONSULTAS

-- listar clientes
SELECT * FROM clientes;

-- listar painéis
SELECT * FROM painel;

-- listar leituras do sensor
SELECT * FROM registro_sensor;

-- painéis com limpeza em data específica
SELECT id FROM painel
WHERE ult_limpeza = '2025-01-02';

-- painéis com boa luminosidade
SELECT * FROM painel
WHERE luminosidade >= 500;

-- clientes com telefone contendo 9
SELECT id FROM clientes
WHERE telefone LIKE '%9%';

-- registros de um cliente específico
SELECT * FROM registro_sensor
WHERE idCliente = 1;

-- classificação do tamanho do sistema solar
SELECT 
id,
qtd_paineis,
CASE
WHEN qtd_paineis >= 20 THEN 'Usina Solar'
WHEN qtd_paineis >= 7 THEN 'Grande'
WHEN qtd_paineis >= 5 THEN 'Médio'
ELSE 'Pequeno'
END AS classificacao
FROM painel;

-- ATUALIZAÇÕES

UPDATE clientes SET nome = 'LARA' WHERE id = 5;
UPDATE clientes SET nome = 'ENZO' WHERE id = 6;
UPDATE clientes SET nome = 'NICOLAS' WHERE id = 7;
UPDATE clientes SET nome = 'GABRYEL' WHERE id = 8;

UPDATE painel
SET luminosidade = 100
WHERE id = 1;