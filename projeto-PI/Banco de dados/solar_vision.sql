CREATE DATABASE solar_Vision;
USE solar_Vision;

CREATE TABLE empresa( -- empresa
	idempresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(14) UNIQUE,
    contato VARCHAR(50),
    email varchar(80),
    endereco varchar (80)
);

create table placa (
idplaca int primary key auto_increment ,
fkempresa int , constraint fkempresaplaca foreign key (fkempresa) references empresa(idempresa),
eficiencia INT,
localizacao varchar (30),
descricao VARCHAR(100) /*add descrição*/
); 

CREATE TABLE grupo_sensor( -- grupo_sensor
	id_grupo INT AUTO_INCREMENT,
    tipo varchar (8), constraint cklimpo check (tipo in ('Controle','Ideal')),    -- 
    fkplaca int , -- qual a placa q ele esta - aqui 
    luminosidade_recebida INT, 
    status_sensor VARCHAR (50),
    constraint primary key (id_grupo,fkplaca) , 
    constraint fkdaplaca foreign key (fkplaca) references placa(idplaca) /*tirei o registro do grupo_sensor*/
);



create table usuario( 
idusuario int auto_increment primary key , 
nome varchar (60) not null , 
cpf char (11) unique,
contato varchar (15),
email varchar (60) not null ,
fkempresa int , -- se é um funcionario responsavel de tal empresa
constraint empresaresp foreign key (fkempresa) references empresa (idempresa),
senha varchar (50) not null 
);


CREATE TABLE registro ( -- medida 
    idRegistro INT auto_increment,
    valorLuminosidade INT,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023), 
     fk_grupo int, -- qual o grupo_sensor 
     fkplaca INT,
     constraint primary key (idRegistro,fk_grupo,fkplaca), 
    constraint grupo_fk foreign key (fk_grupo, fkplaca) references grupo_sensor(id_grupo, fkplaca),
    data_registro datetime default current_timestamp
    
);

insert into empresa (nome,cnpj,contato,email,endereco) values 
('BYD ENERGY','04567898765','11967054392','bydenergy@gmail.com','Rua Magalhaes 350'),
('Samsung','23403291232','11979065932','samsungcontato@gmail.com',NULL),
('Complexo Janaúva','10454392321','11970654921','complexojanauva@gmail.com','Rua Manoel Jardim 3456 ')
;

 
 
insert into usuario (nome,cpf,contato,email,fkempresa,senha) values 
('Leonardo Pires','67044302901','11989456032','leonardoresp@gmail.com',1,'leopiresmk'),
('Manoela Albuquerque','23400192454',null,'manoelaalb@gmail.com',2,'manoelaalbufd');

INSERT INTO placa (fkempresa, localizacao, descricao) VALUES
(1, 'Setor Norte', 'Placa principal da byd'),
(2, 'Setor Sul', 'Placa secundaria da Samsung');

insert into grupo_sensor (tipo,fkplaca) values 
('Controle',1),
('Ideal',1);



select e.nome as empresa , u.nome 'Funcionário Responsável' , p.localizacao as 'Localizacao da Placa' , a.tipo as 'Tipo de Dado' , 
r.valorLuminosidade as 'Registro' from empresa as e join usuario as u on u.fkempresa = e.idempresa 
join placa as p  on p.fkempresa = e.idempresa 
join grupo_sensor as a on a.fkplaca = p.idplaca 
join registro as r on r.fk_grupo = a.id_grupo ; 





select e.nome as 'Empresa', u.nome 'Funcionário Responsável', u.email from empresa as e join usuario as u on fkempresa = idempresa;

SELECT r.valorLuminosidade, r.data_registro, e.nome, g.id_grupo
FROM registro as r
JOIN grupo_sensor as g ON r.fk_grupo = g.id_grupo
JOIN placa as p ON g.fkplaca = p.idplaca
JOIN empresa as e ON p.fkempresa = e.idempresa;





