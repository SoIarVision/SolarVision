CREATE DATABASE solar_Vision;
USE solar_Vision;

CREATE TABLE placa(
	idPlaca INT PRIMARY KEY AUTO_INCREMENT,
    modelo VARCHAR(50),
    qtd_painel VARCHAR(50)
);

CREATE TABLE cliente(
	idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cpf CHAR(11) UNIQUE,
    telefone VARCHAR(15),
    endereco VARCHAR(20)
);

CREATE TABLE registros (
    idRegistro INT PRIMARY KEY AUTO_INCREMENT,
    valorLuminosidade INT,
    porcentagemEficiencia DECIMAL(5,2),
    valorPrejuizo DECIMAL(10,2),
    dt_instalacao DATE NOT NULL,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023)
);

INSERT INTO cliente (nome, cpf, telefone, endereco) VALUES 
('Gabryel', '12345678901', '11911111111', 'Rua A'),
('Ashley', '23456789012', '11922222222', 'Rua B'),
('Marco', '34567890123', '11933333333', 'Rua C'),
('Wellington', '45678901234', '11944444444', 'Rua D'),
('Enzo', '56789012345', '11955555555', 'Rua E'),
('Lara', '67890123456', '11966666666', 'Rua F'),
('Kaijo', '78901234567', '11977777777', 'Rua G'),
('Nicolas', '89012345678', '11988888888', 'Rua H');

INSERT INTO placa (modelo, qtd_painel) VALUES 
('Monocristalino S1', '10'),
('Policristalino A2', '15'),
('Filme Fino B3', '8'),
('Monocristalino C4', '20'),
('Policristalino D5', '12');

INSERT INTO registros (valorLuminosidade, porcentagemEficiencia, valorPrejuizo, dt_instalacao) VALUES 
(1023, 100.00, 0.00, '2025-01-15'),
(850, 83.09, 18.25, '2000-02-10'),
(512, 50.00, 54.00, '2005-03-05'),
(200, 19.55, 86.88, '1999-04-20'),
(0, 0.00, 108.00, '2018-05-12');

SELECT * FROM cliente;
SELECT * FROM placa;
SELECT * FROM registros;

SELECT valorLuminosidade FROM registros WHERE dt_instalacao >= '1999-01-01';

SELECT * FROM registros WHERE valorLuminosidade >= 500;

SELECT nome FROM cliente WHERE endereco != 'Rua C';

SELECT modelo,
CASE
    WHEN qtd_painel >= 7 THEN 'Grande'
    WHEN qtd_painel >= 5 THEN 'Médio'
    ELSE 'Pequeno'
END AS categoria_painel
FROM placa;

UPDATE cliente SET nome = 'Lara' WHERE idCliente = 5;
UPDATE cliente SET nome = 'Enzo' WHERE idCliente = 6;
UPDATE cliente SET nome = 'Nicolas' WHERE idCliente = 7;
UPDATE cliente SET nome = 'Gabryel' WHERE idCliente = 8;

UPDATE placa SET qtd_Painel = 10 WHERE idPlaca = 1;