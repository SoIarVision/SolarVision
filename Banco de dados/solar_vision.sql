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

CREATE TABLE grupo_sensores( -- arduino
	id_grupo INT AUTO_INCREMENT,
    tipo varchar (8), constraint ck_limpo check (tipo in ('Controle','Ideal')),    -- 
    fk_placa int , -- qual a placa q ele esta - aqui 
    fk_registro int,
    constraint primary key (id_grupo,fk_placa) , 
    constraint fkdaplaca foreign key (fk_placa) references placa(id_placa),
    constraint foreign key (fk_registro) references registro(id_registro)
);


CREATE TABLE registro ( -- medida 
    id_registro INT Primary key auto_increment,
    valorLuminosidade INT,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023), 
	fkarduino int, -- qual o arduino 
	constraint primary key (id_registro , fkarduino), 
    constraint arduinofk foreign key (fkarduino) references grupo_sensores(id_grupo),
    data_registro datetime default current_timestamp
);

drop table registro;

insert into empresa (nome,cnpj,contato,email,endereco,senha) values 
('BYD ENERGY','04567898765','11967054392','bydenergy@gmail.com','Rua Magalhaes 350','bydenergy.'),
('Complexo Janaúva','10454392321','11970654921','complexojanauva@gmail.com','Rua Manoel Jardim 3456 ','complexojanauva'),
('Samsung','23403291232','11979065932','samsungcontato@gmail.com',NULL,'samsungbasic');

 
 
insert into usuario (nome,cpf,contato,email,fk_empresa,senha) values 
('Leonardo Pires','67044302901','11989456032','leonardoresp@gmail.com',1,'leopiresmk'),
('Manoela Albuquerque','23400192454',null,'manoelaalb@gmail.com',2,'manoelaalbufd');

insert into grupo_sensores (tipo,fk_placa,fk_registro) values 
('Controle',1,1),
('Ideal',1,2);


insert into registro (valorLuminosidade) value (700),(800);
insert into placa (fk_empresa) values (1),(2);


select e.nome as empresa , u.nome 'Funcionário Responsável' , p.localizacao as 'Localizacao da Placa' , a.tipo as 'Tipo de Dado' , 
r.valorLuminosidade as 'Registro' from empresa as e join usuario as u on u.fk_empresa = e.id_empresa 
join placa as p  on p.fk_empresa = e.id_empresa 
join arduino as a on a.fk_placa = p.id_placa 
join registro as r on a.fk_registro = r.id_registro ; 

select e.nome as 'Empresa', u.nome 'Funcionário Responsável', u.email from empresa as e join usuario as u on fk_empresa = id_empresa
where fk_empresa >= 0; 
