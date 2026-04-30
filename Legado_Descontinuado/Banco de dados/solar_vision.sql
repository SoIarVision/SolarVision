drop database solar_vision;
CREATE DATABASE solar_vision;
USE solar_vision;


create table contato ( 
idcontato int primary key auto_increment, 
email varchar (100), 
telprin varchar (11), 
telreserva varchar (13));

create table endereco (
idendereco int primary key auto_increment, 
cep char (8) , 
rua varchar(100), 
bairro varchar (100),
estado varchar (100),
complemento varchar(1000));

CREATE TABLE empresa( -- empresa
	id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    cnpj CHAR(14) UNIQUE,
    email varchar(80),
    fkendereco int , 
    constraint fkdoendereco foreign key (fkendereco) references endereco(idendereco)
);

create table usuario( 
id_usuario int auto_increment primary key , 
nome varchar (60) not null , 
cpf char (11) unique,
fk_empresa int , -- se é um funcionario responsavel de tal empresa
constraint fk_empresa_resp foreign key (fk_empresa) references empresa(id_empresa),
senha varchar (50) not null,
permissao tinyint default(0),-- se for 0 responsavel , se for 1 adm
 fkcontato int, 
    constraint fkcontatousuario foreign key (fkcontato) references contato(idcontato)
);


create table placa (
id_placa int primary key auto_increment ,
fk_empresa int , constraint fk_empresaplaca foreign key (fk_empresa) references empresa(id_empresa),
eficiencia INT,
localizacao varchar (30), 
tamanho_placa varchar (40)
); 

CREATE TABLE sensores( -- arduino
	id_grupo INT AUTO_INCREMENT,
    tipo varchar (8), constraint ck_limpo check (tipo in ('Controle','Ideal')),    -- 
    fk_placa int , -- qual a placa q ele esta - aqui
    status_sensor VARCHAR(50),
    valor_leitura INT,
    constraint primary key (id_grupo,fk_placa) , 
    constraint fkdaplaca foreign key (fk_placa) references placa(id_placa)
    );
    
INSERT INTO placa (id_placa) values 
(1);

INSERT INTO sensores (id_grupo, tipo, fk_placa) values
(1, 'controle', 1),
(2, 'ideal', 1);

CREATE TABLE registro ( -- medida 
    id_registro INT auto_increment,
    valorLuminosidade INT,
	fkarduino int, -- qual o arduino  mudar o nome
	data_registro datetime default current_timestamp,
    CONSTRAINT chk_luminosidade CHECK(valorLuminosidade BETWEEN 0 AND 1023), 
	constraint primary key (id_registro , fkarduino), 
    constraint arduinofk foreign key (fkarduino) references sensores(id_grupo)
)auto_increment = 0;


 insert into endereco(cep,rua,bairro,estado,complemento) values 
 ('12345869','Luis Alexandre','Olimpico','SP','acima do muro'),
 ('10459345','Marques de Andrade','Fernandes','SP',null),
 ('45034569','Martinelli Jaos','Mokfg','RJ','Prédio Roxo');

 select * from usuario ;
 
 insert into empresa (nome,cnpj,fkendereco) values 
 ('SAMSUNG','123694549650',1) ,
 ('APPLE','104569394569',2);
 insert into contato (email,telprin) values 
 ('leonardoresp@gmail.com','11989456032'),
 ('manoelaalb@gmail.com','11945382453');

insert into usuario (nome,cpf,fk_empresa,senha,fkcontato) values 
('Leonardo Pires','67044302901',1,'leopiresmk',1),
('Manoela Albuquerque','23400192454',2,'manoelaalbufd',2);

insert into placa (fk_empresa) values 
(1),
(2);
select * from placa;
update placa set localizacao = '3BA' where id_placa = 1;
update placa set localizacao = 'MSD' where id_placa = 2;
insert into sensores (tipo,fk_placa) values 
('Controle',1),
('Controle',1),
('Controle',1),
('Ideal',1),
('Ideal',1),
('Ideal',1);

select * from sensores;

insert into registro (valorLuminosidade, fkarduino) values 
(700, 1),
(800, 2),
(700,3),
(860,4),
(500,5),
(780,6);

-- Registros e as empresas 
select e.nome as empresa , u.nome 'Funcionário Responsável' , p.localizacao as 'Localizacao da Placa' , s.tipo as 'Tipo de Dado' , 
r.valorLuminosidade as 'Registro' from empresa as e 
join usuario as u on u.fk_empresa = e.id_empresa 
join placa as p  on p.fk_empresa = e.id_empresa 
join sensores as s on s.fk_placa = p.id_placa 
join registro as r on r.fkarduino = s.id_grupo; 


-- Quais os funcionarios responsáveis das empresas e o email deles
select e.nome as 'Empresa', u.nome 'Funcionário Responsável',c.email from empresa as e
 join usuario as u on fk_empresa = id_empresa
 join contato as c on c.idcontato = u.fkcontato;
 
 select * from sensores;
 select * from placa;
 select * from registro;
 