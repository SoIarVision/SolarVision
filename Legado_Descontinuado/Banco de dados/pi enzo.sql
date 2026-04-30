
CREATE DATABASE projetoPi;
USE projetoPi;

CREATE TABLE paineis(
id INT PRIMARY KEY AUTO_INCREMENT,
kwh_mes int,
eficiencia int,
data date,
constraint check(eficiencia between 0 and 1)
);

CREATE TABLE clientes(
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(50) NOT NULL,
dt_nascimento date,
telefone int NOT NULL,
endereco varchar(50)
);

insert into painel values (
default,
200,
0.8,
'2026-07-03'
);

insert into clientes values (
default,
'Pedro',
'1999-12-02',
11987654321,
'Avenida das avenidas'
);
