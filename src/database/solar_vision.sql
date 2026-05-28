CREATE DATABASE IF NOT EXISTS solar_Vision;
USE solar_Vision;

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(100) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL,
contato VARCHAR(50),
email VARCHAR(80),
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
tipo CHAR(8),
CONSTRAINT chkTipoSensor CHECK (tipo IN ('Controle', 'Ideal')),
status_sensor VARCHAR(50),
valor_leitura VARCHAR(40),
fkPlaca INT,
fkEmpresa INT,
CONSTRAINT fkSensorPlaca FOREIGN KEY (fkPlaca)REFERENCES placa(idPlaca),
CONSTRAINT fkSensorEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

CREATE TABLE registro (
idRegistro INT PRIMARY KEY AUTO_INCREMENT,
valor INT,
data_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
fkSensor INT,
CONSTRAINT fkRegistroSensor FOREIGN KEY (fkSensor) REFERENCES grupo_sensor(idSensor)
);

CREATE TABLE eficiencia (
idEficiencia INT PRIMARY KEY AUTO_INCREMENT,
valor_eficiencia VARCHAR(45),
fkPlaca INT,
fkEmpresa INT,
CONSTRAINT fkEficienciaPlaca FOREIGN KEY (fkPlaca) REFERENCES placa(idPlaca),
CONSTRAINT fkEficienciaEmpresa FOREIGN KEY (fkEmpresa) REFERENCES empresa(idEmpresa)
);

INSERT INTO empresa (nome, cnpj, contato, email, endereco) VALUES
('BYD ENERGY', '04567898765432', '11967054392', 'bydenergy@gmail.com', 'Rua Magalhaes 350'),
('Samsung', '23403291232123', '11979065932', 'samsungcontato@gmail.com', 'Av Paulista 1000'),
('Complexo Janaúva', '10454392321456', '11970654921', 'complexojanauva@gmail.com', 'Rua Manoel Jardim 3456');

INSERT INTO cargo (cargo) VALUES
('Administrador'),
('Suporte'),
('Gerente'),
('Funcionário');

INSERT INTO usuario (nome, cpf, contato, email, senha, fkCargo, fkEmpresa) VALUES
('Leonardo Pires', '67044302901', '11989456032', 'leonardoresp@gmail.com', 'leopiresmk', 3, 1),
('Manoela Albuquerque', '23400192454', '11988887777', 'manoelaalb@gmail.com', 'manoelaalbufd', 2, 2);

INSERT INTO placa (fkEmpresa, localizacao, descricao) VALUES
(1, 'Setor Norte', 'Placa principal da BYD'),
(2, 'Setor Sul', 'Placa secundária da Samsung');

INSERT INTO grupo_sensor 
(local, tipo, status_sensor, valor_leitura, fkPlaca, fkEmpresa)
VALUES
('Painel A1', 'Controle', 'Ativo', '750', 1, 1),
('Painel A2', 'Ideal', 'Ativo', '820', 1, 1),
('Painel B1', 'Controle', 'Manutenção', '610', 2, 2);

INSERT INTO registro (valor, fkSensor) VALUES
(750, 1),
(820, 2),
(610, 3);

INSERT INTO eficiencia (valor_eficiencia, fkPlaca, fkEmpresa) VALUES
('92%', 1, 1),
('87%', 2, 2);

CREATE VIEW view_detalhamento_sensor AS
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
LEFT JOIN eficiencia ef
ON ef.fkPlaca = p.idPlaca
JOIN grupo_sensor g
ON g.fkPlaca = p.idPlaca;

CREATE VIEW view_registro_ref_empresa AS
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

CREATE VIEW view_funcionario AS
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

CREATE VIEW view_registro AS
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