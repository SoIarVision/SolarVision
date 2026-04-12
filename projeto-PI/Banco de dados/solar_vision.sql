CREATE DATABASE solar_Vision;
USE solar_Vision;


CREATE TABLE arduino( -- arduino
	idarduino INT PRIMARY KEY AUTO_INCREMENT,
    limpo int, constraint cklimpo check (limpo in (1,0)),   -- 0 é o que vai ser sujo e 1 é o limpo 
    placa varchar (30) , -- qual a placa q ele esta
    fkempresaarduino int , -- qual a empresa 
    constraint fkdaempresa foreign key (fkempresaarduino) references empresa(idempresa)
);

CREATE TABLE empresa( -- empresa
	idempresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(11) UNIQUE,
    contato VARCHAR(50),
    email varchar(80),
    endereco varchar (80), 
    senha varchar (30)
);

create table usuario( 
idusuario int auto_increment primary key , 
nome varchar (60) not null , 
cpf char (11) unique,
contato varchar (15),
email varchar (60) not null ,
fkempresa int , -- se é um funcionario responsavel de tal empresa
constraint empresaresp foreign key (fkempresa) references empresa (idempresa),
senha varchar (50) not null,
permissao tinyint default(0) -- se for 0 responsavel , se for 1 adm
);


CREATE TABLE registro ( -- medida 
    idRegistro INT Primary key auto_increment,
    valorLuminosidade INT,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023), 
    -- fkarduino int, -- qual o arduino 
    -- constraint primary key (idRegistro,fkarduino), 
    -- constraint arduinofk foreign key (fkarduino) references arduino (idarduino),
    data_registro datetime default current_timestamp
    
);

insert into empresa (nome,cnpj,contato,email,endereco,senha) values 
('BYD ENERGY','04567898765','11967054392','bydenergy@gmail.com','Rua Magalhaes 350','bydenergy.'),
('Complexo Janaúva','10454392321','11970654921','complexojanauva@gmail.com','Rua Manoel Jardim 3456 ','complexojanauva'),
('Samsung','23403291232','11979065932','samsungcontato@gmail.com',NULL,'samsungbasic');

 
 
insert into usuario (nome,cpf,contato,email,fkempresa,senha) values 
('Leonardo Pires','67044302901','11989456032','leonardoresp@gmail.com',1,'leopiresmk'),
('Manoela Albuquerque','23400192454',null,'manoelaalb@gmail.com',2,'manoelaalbufd');

insert into arduino (limpo,placa,fkempresaarduino) values 
('1','placaA',1),
('0','placaA',1),
('1','placaB',1),
('0','placaB',1), 
('1','placaAED',2), 
('0','placaAED',2);

select e.nome as 'Empresa', u.nome 'Funcionário Responsável', u.email from empresa as e join usuario as u on fkempresa = idempresa
where fkempresa >= 0; 

select valorLuminosidade,data_registro,nome,idarduino from registro
 join arduino on fkarduino = idarduino join empresa on idempresa = fkempresaarduino;



