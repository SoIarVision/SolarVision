DROP DATABASE IF EXISTS solar_Vision;
CREATE DATABASE IF NOT EXISTS solar_Vision;
USE solar_Vision;

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL,
endereco VARCHAR(100)
);

CREATE TABLE cargo (
idCargo INT PRIMARY KEY AUTO_INCREMENT,
cargo VARCHAR(50) NOT NULL
);

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(60) NOT NULL,
cpf CHAR(11) UNIQUE,
contato VARCHAR(15),
email VARCHAR(60) NOT NULL,
senha VARCHAR(50) NOT NULL,
fkCargo INT,
fkEmpresa INT,
CONSTRAINT fkUsuarioCargo FOREIGN KEY (fkCargo) REFERENCES cargo(idCargo),
CONSTRAINT fkUsuarioEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE placa (
idPlaca INT PRIMARY KEY AUTO_INCREMENT,
fkEmpresa INT NOT NULL,
localizacao VARCHAR(100),
descricao VARCHAR(100),
CONSTRAINT fkPlacaEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE grupo_sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
localizacao VARCHAR(45),
tipo VARCHAR(8),
CONSTRAINT chkTipoSensor CHECK (tipo IN ('Controle', 'Ideal')),
status_sensor VARCHAR(50),
valor_leitura INT,
fkPlaca INT,
CONSTRAINT fkSensorPlaca FOREIGN KEY (fkPlaca)REFERENCES placa(idPlaca)
);

CREATE TABLE registro (
idRegistro INT AUTO_INCREMENT,
valor INT,
data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
fkSensor INT,
PRIMARY KEY (idRegistro, fkSensor),
CONSTRAINT fkRegistroSensor FOREIGN KEY (fkSensor) REFERENCES grupo_sensor(idSensor)
);

CREATE TABLE historico_eficiencia (
idEficiencia INT AUTO_INCREMENT,
valor_eficiencia DECIMAL(4,1),
dt_eficiencia datetime default current_timestamp,
fkPlaca INT,
PRIMARY KEY (idEficiencia, fkPlaca),
CONSTRAINT fkEficienciaPlaca FOREIGN KEY (fkPlaca) REFERENCES placa(idPlaca)
);

INSERT INTO empresa (nome, cnpj, endereco) VALUES
('BYD ENERGY', '04567898765432', 'Rua Magalhaes 350'),
('Samsung', '23403291232123', 'Av Paulista 1000'),
('Complexo Janaúva', '10454392321456', 'Rua Manoel Jardim 3456');

INSERT INTO cargo (cargo) VALUES
('Administrador'),
('Suporte'),
('Gerente'),
('Funcionário');

INSERT INTO usuario (nome, cpf, contato, email, senha, fkCargo, fkEmpresa) VALUES
('Leonardo Pires', '67044302901', '11989456032', 'leonardoresp@gmail.com', 'Leopiresmk1@', 3, 1),
('Manoela Albuquerque', '23400192454', '11988887777', 'manoelaalb@gmail.com', 'manoelaalbufd', 3, 2),
('Vinicius Borges', '12345678911', '11988887777', 'vinicius.bnascimento@gmail.com', 'manoelaalbufd', 3, 3),
('Pedro', '88888888888','','pedro@gmail.com','Pedro12#',2,null),
('Lucas', '77777777777','','lucass3neogalvao@gmail.com','Lucas12#',1,null);

INSERT INTO placa (fkEmpresa, localizacao, descricao) VALUES
(1, 'Setor Norte', 'Placa principal da BYD'),
(1, 'Setor Norte', 'Placa principal da BYD'),
(1, 'Setor Norte', 'Placa principal da BYD'),
(1, 'Setor Norte', 'Placa principal da BYD'),
(1, 'Setor Norte', 'Placa principal da BYD'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(2, 'Setor Sul', 'Placa secundária da Samsung'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva'),
(3, 'Setor Sul', 'Placa primário da Janaúva');

INSERT INTO grupo_sensor (localizacao, tipo, status_sensor, valor_leitura, fkPlaca) VALUES
('Painel A1', 'Controle', 'Ativo', '750', 1),
('Painel A2', 'Ideal', 'Ativo', '820', 1),
('Painel B1', 'Controle', 'Manutenção', '610', 2);

INSERT INTO registro (valor, fkSensor) VALUES
(750, 1),
(820, 2),
(610, 3);

INSERT INTO historico_eficiencia (valor_eficiencia, fkPlaca) VALUES
(92.4, 1),
(87.5, 2);

SELECT
    p.idPlaca AS 'Placa Solar',
    p.descricao AS 'Descrição',
    p.localizacao AS 'Localização',
    e.nome AS 'Empresa',
    u.nome AS 'Responsável',
    ef.valor_eficiencia AS 'Eficiência',
    g.tipo AS 'Tipo Sensor',
    g.status_sensor AS 'Status',
    g.valor_leitura AS 'Leitura'
FROM placa p
JOIN empresa e
ON p.fkEmpresa = e.idEmpresa
JOIN usuario u
ON u.fkEmpresa = e.idEmpresa
LEFT JOIN historico_eficiencia ef
ON ef.fkPlaca = p.idPlaca
JOIN grupo_sensor g
ON g.fkPlaca = p.idPlaca;

SELECT
    e.nome AS 'Empresa',
    u.nome AS 'Funcionário Responsável',
    p.localizacao AS 'Localização da Placa',
    g.tipo AS 'Tipo de Sensor',
    r.valor AS 'Registro',
    r.data_registro AS 'Data'
FROM empresa e
JOIN usuario u
ON u.fkEmpresa = e.idEmpresa
JOIN placa p
ON p.fkEmpresa = e.idEmpresa
JOIN grupo_sensor g
ON g.fkPlaca = p.idPlaca
JOIN registro r
ON r.fkSensor = g.idSensor;

SELECT
    e.nome AS 'Empresa',
    u.nome AS 'Funcionário',
    u.email,
    c.cargo
FROM empresa e
JOIN usuario u
ON u.fkEmpresa = e.idEmpresa
JOIN cargo c
ON c.idCargo = u.fkCargo;

SELECT
    r.valor,
    r.data_registro,
    e.nome AS empresa,
    g.idSensor,
    g.tipo
FROM registro r
JOIN grupo_sensor g
ON r.fkSensor = g.idSensor
JOIN placa p
ON g.fkPlaca = p.idPlaca
JOIN empresa e
ON p.fkEmpresa = e.idEmpresa;

/* SELECT 
	u.idUsuario id,
	u.nome Nome,
    u.contato Telefone,
    c.cargo Cargo,
    e.idEmpresa idEmpresa,
    e.nome Empresa
FROM usuario u
JOIN cargo c ON c.idCargo = u.fkCargo
JOIN empresa e ON e.idEmpresa = u.fkEmpresa
where idEmpresa = ?;
*/

CREATE VIEW vw_listar_empresas AS
SELECT 
	e.idEmpresa id,
    e.nome Nome,
    e.endereco localidade,
	(SELECT u2.nome FROM usuario u2 
    JOIN cargo c2 ON u2.fkCargo = c2.idCargo 
    WHERE u2.fkEmpresa = e.idEmpresa AND c2.cargo = 'Gerente' LIMIT 1) Representante,
	(SELECT u.email FROM usuario u
    JOIN cargo c ON u.fkCargo = c.idCargo
    where u.fkEmpresa = e.idEmpresa and c.cargo = 'Gerente' LIMIT 1) Contato,
    COUNT(Distinct p.idPlaca) Placas,
    COUNT(Distinct u.idUsuario) Funcionarios
from empresa e
LEFT JOIN placa p ON p.fkEmpresa = e.idEmpresa
LEFT JOIN usuario u ON u.fkEmpresa = e.idEmpresa
group by e.idEmpresa, e.nome, e.endereco
order by e.idEmpresa;

create view vw_ultima_limpeza as 
SELECT * FROM historico_eficiencia WHERE valor_eficiencia >= 98.5 ORDER BY idEficiencia DESC LIMIT 1;

select * from vw_listar_empresas;
select * from vw_ultima_limpeza;

select * from grupo_sensor;
select * from registro;

SELECT 
	r.idRegistro,
	r.valor valor,
    r.data_registro dtRegistro,
    g.tipo tipo,
    g.valor_leitura leitura
FROM registro r
LEFT JOIN grupo_sensor g ON r.fkSensor = g.idSensor 
order by r.idRegistro DESC LIMIT 42;

select * from registro
order by idRegistro desc
LIMIT 6;

select * from grupo_sensor;
-- select * from limpeza order by idLimpeza desc limit 1;

-- INSERT INTO limpeza (dtLimpeza) VALUE (now())

/*
SELECT
    r.idRegistro,
    r.valor,
    r.data_registro,
    gs.tipo,
    gs.localizacao,
    e.idEmpresa,
    e.nome AS empresa
FROM registro r
JOIN grupo_sensor gs ON gs.idSensor = r.fkSensor
JOIN placa p ON p.idPlaca = gs.fkPlaca
JOIN empresa e ON e.idEmpresa = p.fkEmpresa
WHERE e.idEmpresa = ?
ORDER BY r.idRegistro DESC
LIMIT 6;
*/
select * from registro order by idRegistro desc;
select * from historico_eficiencia order by idEficiencia desc LIMIT 1;
select 
	idEficiencia,
	valor_eficiencia valor,
    dt_eficiencia
from historico_eficiencia order by idEficiencia desc LIMIT 7;

SELECT 
    DATE(dt_eficiencia) AS dia,
    ROUND(AVG(valor_eficiencia), 1) AS eficiencia_media
FROM historico_eficiencia
WHERE dt_eficiencia >= NOW() - INTERVAL 7 DAY
GROUP BY DATE(dt_eficiencia)
ORDER BY dia;