CREATE DATABASE solar_vision;
USE solar_vision;

CREATE TABLE empresa( -- empresa
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(11) UNIQUE,
    contato VARCHAR(50),
    email varchar(80),
    endereco varchar (80)
);

create table usuario( 
id_usuario int auto_increment primary key , 
nome varchar (60) not null , 
cpf char (11) unique,
contato varchar (15),
email varchar (60) not null ,
fk_empresa int , -- se é um funcionario responsavel de tal empresa
constraint fk_empresa_resp foreign key (fk_empresa) references empresa(id_empresa),
senha varchar (50) not null,
permissao tinyint default(0) -- se for 0 responsavel , se for 1 adm
);


create table placa (
id_placa int primary key auto_increment ,
fk_empresa int , constraint fk_empresaplaca foreign key (fk_empresa) references empresa(id_empresa),
localizacao varchar (30), 
tamanho_placa varchar (40)
); 

CREATE TABLE sensores( -- arduino
	id_grupo INT AUTO_INCREMENT,
    tipo varchar (8), constraint ck_limpo check (tipo in ('Controle','Ideal')),    -- 
    fk_placa int , -- qual a placa q ele esta - aqui 
    constraint primary key (id_grupo,fk_placa) , 
    constraint fkdaplaca foreign key (fk_placa) references placa(id_placa)
    );

CREATE TABLE registro ( -- medida 
    id_registro INT auto_increment,
    valorLuminosidade INT,
	fkarduino int, -- qual o arduino 
	data_registro datetime default current_timestamp,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023), 
	constraint primary key (id_registro , fkarduino), 
    constraint arduinofk foreign key (fkarduino) references sensores(id_grupo)
)auto_increment = 0;

insert into empresa (nome,cnpj,contato,email,endereco) values 
('BYD ENERGY','04567898765','11967054392','bydenergy@gmail.com','Rua Magalhaes 350'),
('Complexo Janaúva','10454392321','11970654921','complexojanauva@gmail.com','Rua Manoel Jardim 3456 '),
('Samsung','23403291232','11979065932','samsungcontato@gmail.com',NULL);

 
 
insert into usuario (nome,cpf,contato,email,fk_empresa,senha) values 
('Leonardo Pires','67044302901','11989456032','leonardoresp@gmail.com',1,'leopiresmk'),
('Manoela Albuquerque','23400192454',null,'manoelaalb@gmail.com',2,'manoelaalbufd');

insert into placa (fk_empresa) values 
(1),
(2);

insert into sensores (tipo,fk_placa) values 
('Controle',1),
('Controle',1),
('Controle',1),
('Ideal',1),
('Ideal',1),
('Ideal',1);


insert into registro (valorLuminosidade, fkarduino) values 
(700, 1),
(800, 1);


select e.nome as empresa , u.nome 'Funcionário Responsável' , p.localizacao as 'Localizacao da Placa' , s.tipo as 'Tipo de Dado' , 
r.valorLuminosidade as 'Registro' from empresa as e 
join usuario as u on u.fk_empresa = e.id_empresa 
join placa as p  on p.fk_empresa = e.id_empresa 
join sensores as s on s.fk_placa = p.id_placa 
join registro as r on r.fkarduino = s.id_grupo ; 

select e.nome as 'Empresa', u.nome 'Funcionário Responsável', u.email from empresa as e join usuario as u on fk_empresa = id_empresa
where fk_empresa >= 0;