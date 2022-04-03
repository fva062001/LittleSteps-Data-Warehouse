USE master
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'little_steps'
)
CREATE DATABASE little_steps
GO

use little_steps
go


---------------------------------------  Estudiante star scheme  ----------------------------------------------------------------------

-- Dimension compartida que une los estudiantes con el profesor
IF OBJECT_ID('clase', 'U') IS NOT NULL
DROP TABLE clase
GO

CREATE TABLE clase
(
	id_clase int identity(1,1) primary key,
	horario varchar(10),
	materia varchar(20),
	Salon_clase varchar(3)
);
GO

-- Dimension compartida que une los estudiante y tutor
IF OBJECT_ID('tutor', 'U') IS NOT NULL
DROP TABLE tutor
GO

CREATE TABLE tutor
(
	id_tutor int identity(1,1) primary key,
	nombre varchar(30),
	cedula varchar(13),
	numero_de_telefono varchar(12)
);
GO

-- Dimension para notas
IF OBJECT_ID('sel', 'U') IS NOT NULL
DROP TABLE sel
GO
-- Create the table in the specified schema
CREATE TABLE sel
(
	id_sel int identity(1,1) primary key,
	self_awareness tinyint DEFAULT 0,
	self_management tinyint DEFAULT 0,
	social_awareness tinyint DEFAULT 0,
	relationship_skills tinyint DEFAULT 0,
	R_D_M tinyint
);
GO

-- Testing -----
insert into sel (self_awareness, self_management, social_awareness, relationship_skills, R_D_M) values (1, 2, 3, 4, 5)
select * from sel

IF OBJECT_ID('alumno', 'U') IS NOT NULL
DROP TABLE alumno
GO

CREATE TABLE alumno
(
	id_alumno int identity(1,1) primary key,
	nombre varchar(30),
	fecha_nacimiento date,
	fecha_ingreso date DEFAULT GETDATE(),
	fecha_salida date DEFAULT NULL,
	--matricula int 
);
GO

IF OBJECT_ID('estudiante_tiempo', 'U') IS NOT NULL
DROP TABLE estudiante_tiempo
GO

CREATE TABLE estudiante_tiempo
(
	id_tiempo int identity(1,1) primary key,
	ano int,
	semestre tinyint
);
GO

-- fact table estudiante
IF OBJECT_ID('estudiante', 'U') IS NOT NULL
DROP TABLE estudiante
GO

CREATE TABLE estudiante
(
	id_tiempo int foreign key references estudiante_tiempo(id_tiempo),
	id_alumno int foreign key references alumno(id_alumno),
	id_sel int foreign key references sel(id_sel),
	id_clase int foreign key references clase(id_clase), 
	id_tutor int foreign key references tutor(id_tutor)
);
GO

----------------------------------------------------------------------------------- Star scheme Tutor ---------------------------------------

IF OBJECT_ID('tutor_tiempo', 'U') IS NOT NULL
DROP TABLE tutor_tiempo
GO

CREATE TABLE tutor_tiempo
(
	id_tiempo int identity(1,1) primary key,
	fecha date,
	ano int,
	semestre tinyint,
	mes tinyint
);
GO

IF OBJECT_ID('pago', 'U') IS NOT NULL
DROP TABLE pago
GO

CREATE TABLE pago
(
	id_pago int identity(1,1) primary key,
	pago_completo money
	-- pago_mensual money,
);
GO

--- Se debe hacer un trigger para el pago mensual dividiendo el pago completo entre 12

IF OBJECT_ID('fact_tutor', 'U') IS NOT NULL
DROP TABLE fact_tutor
GO

CREATE TABLE fact_tutor
(
	id_tiempo int foreign key references tutor_tiempo(id_tiempo),
	id_pago int foreign key references pago(id_pago),
	id_tutor int foreign key references tutor(id_tutor)
);
GO

-------------------------------------------------------------- profesor star scheme ------------------

IF OBJECT_ID('profesor_tiempo', 'U') IS NOT NULL
DROP TABLE profesor_tiempo
GO

CREATE TABLE profesor_tiempo
(
	id_tiempo int identity(1,1) primary key,
	ano int,
	semestre tinyint
);
GO

IF OBJECT_ID('empleado', 'U') IS NOT NULL
DROP TABLE empleado
GO

CREATE TABLE empleado
(
	id_empleado int identity(1,1) primary key,
	nombre varchar(30),
	fecha_nacimiento date,
	fecha_ingreso date DEFAULT GETDATE(),
	especialida varchar(15),
	fecha_salida date DEFAULT NULL,
	cedula varchar(13),
	--matricula int 
);
GO

IF OBJECT_ID('salario', 'U') IS NOT NULL
DROP TABLE salario
GO

CREATE TABLE salario
(
	id_salario int identity(1,1) primary key,
	mensual money,
	quincenal money
);
GO

IF OBJECT_ID('fact_profesores', 'U') IS NOT NULL
DROP TABLE fact_profesores
GO

CREATE TABLE fact_profesores
(
	id_tiempo int foreign key references profesor_tiempo(id_tiempo),
	id_empleado int foreign key references empleado(id_empleado),
	id_salario int foreign key references salario(id_salario),
	id_clase int foreign key references clase(id_clase)
);
GO

----------------------------------- star scheme publicidad ---------------------------------

IF OBJECT_ID('publicidad_tiempo', 'U') IS NOT NULL
DROP TABLE publicidad_tiempo
GO

CREATE TABLE publicidad_tiempo
(
	id_tiempo int identity(1,1) primary key,
	ano int,
	mes tinyint
);
GO

IF OBJECT_ID('gasto_publicitario', 'U') IS NOT NULL
DROP TABLE gasto_publicitario
GO

CREATE TABLE gasto_publicitario
(
	id_gasto_publicitario int identity(1,1) primary key,
	nombre varchar(15),
	precio money
);
GO

IF OBJECT_ID('categoria', 'U') IS NOT NULL
DROP TABLE categoria
GO

CREATE TABLE categoria
(
	id_categoria int identity(1,1) primary key,
	tipo bit -- Indica si la publicidad es de tipo digital o fisico
);
GO

IF OBJECT_ID('fact_publicidad', 'U') IS NOT NULL
DROP TABLE fact_publicidad
GO

CREATE TABLE fact_publicidad
(
	id_tiempo int foreign key references publicidad_tiempo(id_tiempo),
	id_categoria int foreign key references categoria(id_categoria),
	id_gasto_publicitario int foreign key references gasto_publicitario(id_gasto_publicitario)
);
GO

---------------------------- Tablas miscelaneas  ------------------------------------------------------
IF OBJECT_ID('users', 'U') IS NOT NULL
DROP TABLE users
GO

CREATE TABLE users
(
	usuario varchar(20),
	contrasena varchar(20),
	fecha_creacion date DEFAULT GETDATE()
);
GO

-- DB de Data Marts

USE master
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'marketing'
)
CREATE DATABASE marketing
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'administracion'
)
CREATE DATABASE administracion
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'direccion'
)
CREATE DATABASE direccion
GO

IF NOT EXISTS (
	SELECT name
		FROM sys.databases
		WHERE name = N'recursos_humanos'
)
CREATE DATABASE recursos_humanos
GO

---------------------------- Insertar Datos  ------------------------------------------------------
use little_steps
-- Clase
INSERT INTO
clase (horario,materia,Salon_clase)
VALUES
	('Matutino','Self-Awareness','B01'),
	('Vespertino','Relationship Skills','A07'),
	('Matutino','Responsible Decision-Making','E03'),
	('Vespertino','Self-Management','B12'),
	('Vespertino','Self-Awareness','C17'),
	('Vespertino','Relationship Skills','A31'),
	('Matutino','Responsible Decision-Making','C14'),
	('Vespertino','Relationship Skills','B14'),
	('Vespertino','Self-Management','A41'),
	('Vespertino','Self-Awareness','D07'),
	('Vespertino','Responsible Decision-Making','F10'),
	('Vespertino','Self-Management','C03'),
	('Matutino','Self-Management','A08'),
	('Matutino','Self-Awareness','A07'),
	('Matutino','Self-Awareness','B12'),
	('Matutino','Relationship Skills','F19'),
	('Matutino','Self-Awareness','B12'),
	('Matutino','Relationship Skills','E04'),
	('Vespertino','Self-Management','C41'),
	('Vespertino','Self-Management','C15'),
	('Matutino','Self-Awareness','A07'),
	('Matutino','Responsible Decision-Making','A20'),
	('Matutino','Relationship Skills','C21'),
	('Matutino','Relationship Skills','F03'),
	('Vespertino','Responsible Decision-Making','F04'),
	('Matutino','Relationship Skills','A10'),
	('Matutino','Self-Management','E04'),
	('Vespertino','Self-Management','E17'),
	('Vespertino','Self-Awareness','B12'),
	('Matutino','Self-Awareness','A05'),
	('Matutino','Relationship Skills','D09'),
	('Vespertino','Relationship Skills','C14'),
	('Matutino','Self-Management','B12'),
	('Matutino','Responsible Decision-Making','B14'),
	('Vespertino','Responsible Decision-Making','C31'),
	('Matutino','Self-Awareness','E03'),
	('Matutino','Self-Management','A07'),
	('Matutino','Relationship Skills','F21'),
	('Vespertino','Responsible Decision-Making','B39'),
	('Vespertino','Self-Awareness','D10'),
	('Matutino','Relationship Skills','F14'),
	('Vespertino','Self-Management','A05'),
	('Matutino','Self-Awareness','B08'),
	('Matutino','Responsible Decision-Making','F20'),
	('Vespertino','Responsible Decision-Making','F16'),
	('Vespertino','Self-Management','A38'),
	('Vespertino','Relationship Skills','D10'),
	('Matutino','Self-Management','C15'),
	('Vespertino','Responsible Decision-Making','B13'),
	('Matutino','Self-Awareness','E18');

-- Tutores
INSERT INTO
tutor(nombre,cedula,numero_de_telefono)
VALUES
	('Bianca Salas','001-0211551-2','829-967-4843'),
	('Naomi Stafford','001-4571828-4','829-938-3912'),
	('Stephanie Maldonado','001-8226104-1','829-173-6272'),
	('Adam Dawson','001-3383227-2','829-548-3951'),
	('Bianca Robinson','001-8737463-4','829-643-6623'),
	('Mauricio Martin','001-3789334-1','829-933-3757'),
	('Leah Wells','001-7667864-1','829-198-2166'),
	('Alan Sutton','001-8384472-5','829-446-7886'),
	('Orson Herman','001-1588295-1','829-768-8014'),
	('Meghan Caldwell','001-7611217-1','829-574-4744'),
	('Gregory Atkinson','001-2528203-3','829-642-9212'),
	('Ryan Carey','001-0177815-2','829-238-5556'),
	('Leandra Mcdonald','001-4293571-4','829-717-3887'),
	('Reagan Gay','001-6117488-6','829-282-8573'),
	('Gregorio Lancaster','001-8026814-9','829-323-1901'),
	('Lillian Caldwell','001-6275827-9','829-237-6531'),
	('Nell Sanford','001-1825434-4','829-894-2491'),
	('Morgan House','001-9472511-8','829-729-3272'),
	('Jaime Richmond','001-3270850-1','829-200-8718'),
	('Lysandra Abreu','001-2284180-6','829-718-6756'),
	('Vernon Glover','001-3758673-5','829-631-9711'),
	('Medge Chavez','001-9352315-5','829-555-6793'),
	('Germane Cannon','001-8277374-3','829-214-1597'),
	('Amy Fischer','001-2172927-7','829-686-1035'),
	('Mercedes Peck','001-0798121-3','829-764-7797'),
	('Amal Schneider','001-0302783-6','829-576-9386'),
	('Malcolm Lawrence','001-4863490-1','829-234-8194'),
	('Anne Nicholson','001-4232364-5','829-653-1344'),
	('Madonna Miranda','001-8442233-5','829-223-4442'),
	('Cesar Kim','001-6871677-1','829-732-2516'),
	('Nehru Gamble','001-2744678-8','829-362-8762'),
	('Brian Sanford','001-8275240-0','829-372-4272'),
	('Dale Saldana','001-4870779-6','829-526-5895'),
	('Zahir Goodman','001-6820778-6','829-575-0281'),
	('Jerome Ferguson','001-3678057-2','829-281-8145'),
	('Kirby Miles','001-5454832-3','829-988-5525'),
	('Illana Rosales','001-3362672-4','829-643-2774'),
	('Iris Vance','001-8046266-5','829-715-7455'),
	('Joelle Maldonado','001-2640582-3','829-543-0267'),
	('Ezekiel Mcneil','001-7311123-9','829-356-2629'),
	('Colt Mckee','001-3125158-4','829-637-1437'),
	('Keagan Rogers','001-0356158-1','829-889-7520'),
	('Urielle Moses','001-2843312-3','829-919-6843'),
	('Wang Mckenzie','001-5222653-7','829-670-5611'),
	('Sylvia Chapman','001-2118316-7','829-212-3377'),
	('Brittany Russo','001-4564781-5','829-326-2527'),
	('Dylan Whitfield','001-2941293-4','829-842-3193'),
	('Zachary Valenzuela','001-3391418-4','829-238-8697'),
	('Lawrence Solomon','001-0866078-0','829-455-6921'),
	('Geraldine Sosa','001-9354864-2','829-145-8982');

INSERT INTO
SEL(self_awareness,self_management,social_awareness,relationship_skills,R_D_M)
VALUES
  (3,4,1,4,1),
  (4,3,1,3,1),
  (5,3,1,5,1),
  (5,1,4,5,2),
  (3,2,2,2,3),
  (0,3,1,5,3),
  (0,2,2,4,4),
  (2,4,5,4,4),
  (5,1,1,2,0),
  (1,2,1,2,2),
  (2,0,5,5,3),
  (1,1,5,3,1),
  (4,3,1,2,3),
  (0,4,1,5,2),
  (4,3,3,4,2),
  (5,0,2,3,0),
  (0,2,5,4,2),
  (1,4,0,4,1),
  (3,2,3,3,4),
  (1,1,2,3,4),
  (2,5,3,2,4),
  (4,2,2,4,1),
  (5,1,5,4,5),
  (5,5,3,5,2),
  (3,4,4,2,0),
  (1,5,3,1,4),
  (5,1,5,3,4),
  (5,4,3,4,3),
  (2,3,0,3,3),
  (5,4,2,3,2),
  (3,4,5,1,0),
  (4,2,1,4,2),
  (1,3,2,2,3),
  (4,2,2,2,1),
  (3,4,4,2,1),
  (4,5,4,4,0),
  (0,2,0,4,1),
  (4,2,2,3,0),
  (0,0,1,4,3),
  (4,4,1,2,2),
  (2,4,5,4,0),
  (1,4,2,0,1),
  (2,5,5,0,1),
  (4,2,0,3,2),
  (1,0,3,1,4),
  (2,3,1,1,3),
  (2,4,5,3,2),
  (2,0,5,1,3),
  (5,4,2,1,2),
  (1,1,3,2,4);

INSERT INTO alumno(nombre,fecha_nacimiento,fecha_ingreso,fecha_salida)
VALUES
	('Whitney Gomez','2010-09-19','2013-09-14','2017-01-07'),
	('Gavin Perkins','2017-08-21','2020-05-02','2024-12-22'),
	('Gabriela Moran','2007-08-19','2010-11-25','2014-01-16'),
	('Christopher Weiss','2010-10-23','2013-05-16','2017-06-05'),
	('Quinn O''donnell','2017-10-14','2020-10-14','2024-06-04'),
	('Drew Hines','2002-05-17','2005-01-24','2009-06-08'),
	('Branden Compton','2018-09-05','2021-01-19','2025-11-21'),
	('Gil Giles','2009-01-01','2012-01-30','2016-04-25'),
	('Coby Kemp','2006-11-29','2009-07-30','2013-06-04'),
	('Wade Harris','2013-04-14','2016-03-30','2021-08-19'),
	('Brynn Rasmussen','2007-06-04','2010-06-02','2014-10-13'),
	('Wanda Mccarty','2003-08-22','2006-12-29','2010-02-06'),
	('Hashim Gibson','2002-12-27','2005-06-20','2009-09-13'),
	('Alec Giles','2014-12-22','2017-02-02','2021-10-14'),
	('Stewart Greer','2011-04-24','2014-05-01','2018-12-17'),
	('Amaya Garrison','2008-10-03','2011-09-06','2015-03-03'),
	('Lamar Dotson','2013-10-05','2007-09-05','2011-05-04'),
	('Armand Waller','2012-11-27','2015-09-20','2019-07-16'),
	('Carl Schmidt','2018-12-07','2021-05-18','2025-12-23'),
	('Vincent Pacheco','2009-10-06','2012-07-20','2016-01-23'),
	('Jack Stevenson','2007-12-04','2010-01-16','2014-08-10'),
	('Dominique Sparks','2012-09-08','2015-01-14','2019-04-08'),
	('Dieter Bush','2000-05-02','2003-03-27','2007-09-21'),
	('Garth Hill','2017-07-08','2020-03-10','2024-12-16'),
	('Omar Casey','2006-02-10','2009-07-02','2013-11-05'),
	('Desirae Lee','2009-02-28','2012-07-06','2016-10-04'),
	('Victor Lambert','2004-11-27','2008-11-07','2012-08-26'),
	('Lara Chen','2017-10-23','2020-03-22','2024-01-20'),
	('Yael Benson','2018-09-08','2021-12-26','2025-03-05'),
	('Nasim Mueller','2011-12-12','2014-07-26','2017-08-11'),
	('Patrick Lara','2016-08-20','2019-02-12','2023-07-14'),
	('Neville Roach','2006-06-09','2009-06-19','2013-06-16'),
	('Ezekiel Mcguire','2018-12-11','2021-11-17','2025-06-07'),
	('Colin Nicholson','2001-09-03','2004-01-19','2007-04-27'),
	('Candice Mckinney','2004-10-17','2018-01-14','2022-08-09'),
	('George Gross','2003-01-18','2006-02-03','2016-01-10'),
	('Vernon Copeland','2000-02-05','2003-03-08','2007-08-27'),
	('Debra Dale','2009-08-19','2012-08-31','2014-03-23'),
	('Kaitlin Hogan','2010-05-10','2013-01-31','2017-04-21'),
	('Louis Sanchez','2003-10-31','2006-10-10','2010-07-07'),
	('Emily Ross','2007-11-18','2010-06-13','2014-04-16'),
	('Cooper Hunt','2006-05-02','2009-01-28','2013-04-08'),
	('Bell Mendoza','2000-12-10','2003-10-16','2007-03-09'),
	('Dylan Schultz','2001-01-30','2004-09-28','2008-12-06'),
	('Colleen Fletcher','2016-03-26','2019-12-31','2023-05-19'),
	('Thomas Ayala','2011-05-02','2014-04-02','2018-10-06'),
	('Amanda Lott','2006-02-10','2009-06-17','2023-05-27'),
	('Abraham Guzman','2010-09-25','2013-02-07','2017-12-11'),
	('Brian Hansen','2014-03-05','2017-02-28','2021-01-04'),
	('Kinisha Mckinney','2007-11-14','2010-12-02','2014-07-09');

INSERT INTO
estudiante_tiempo(ano,semestre)
VALUES
  (2003,2),
  (2017,1),
  (2003,1),
  (2019,2),
  (2014,2),
  (2007,2),
  (2006,1),
  (2015,2),
  (2016,1),
  (2021,1),
  (2002,2),
  (2005,1),
  (2002,2),
  (2018,2),
  (2021,2),
  (2005,2),
  (2014,1),
  (2016,2),
  (2014,1),
  (2020,2),
  (2016,2),
  (2016,1),
  (2014,1),
  (2020,1),
  (2020,1),
  (2007,1),
  (2021,2),
  (2003,2),
  (2007,1),
  (2004,2),
  (2007,1),
  (2008,2),
  (2004,2),
  (2002,1),
  (2012,2),
  (2020,1),
  (2004,1),
  (2019,1),
  (2011,1),
  (2008,2),
  (2013,2),
  (2006,1),
  (2020,2),
  (2015,1),
  (2003,2),
  (2020,1),
  (2003,1),
  (2006,1),
  (2005,1),
  (2009,2);

INSERT INTO
tutor_Tiempo(fecha,ano,semestre,mes)
VALUES
  ('2020-04-12',2020,1,4),
  ('2003-12-17',2003,2,12),
  ('2006-04-22',2006,1,4),
  ('2005-06-10',2005,1,6),
  ('2009-11-12',2009,2,11),
  ('2018-05-17',2018,1,5),
  ('2010-09-21',2010,2,9),
  ('2002-01-14',2002,1,1),
  ('2017-07-08',2017,2,7),
  ('2021-05-30',2021,1,5),
  ('2021-03-19',2021,1,3),
  ('2008-10-22',2008,2,10),
  ('2005-02-09',2005,1,2),
  ('2012-03-29',2012,1,3),
  ('2010-07-21',2010,2,7),
  ('2003-05-30',2003,1,5),
  ('2015-08-25',2015,2,8),
  ('2017-12-02',2017,2,12),
  ('2006-10-16',2006,2,10),
  ('2013-08-31',2013,2,8),
  ('2011-02-20',2011,1,2),
  ('2003-05-21',2003,1,5),
  ('2019-04-05',2019,1,4),
  ('2007-01-26',2007,1,1),
  ('2005-09-18',2005,2,9),
  ('2003-01-03',2003,1,1),
  ('2019-10-15',2019,2,10),
  ('2013-09-15',2013,2,9),
  ('2011-11-25',2011,2,11),
  ('2019-08-03',2019,2,8),
  ('2006-09-06',2006,2,9),
  ('2018-08-14',2081,2,8),
  ('2015-01-15',2015,1,1),
  ('2009-06-03',2009,1,6),
  ('2013-05-09',2013,1,5),
  ('2004-02-03',2004,1,2),
  ('2011-06-30',2011,1,6),
  ('2002-09-05',2002,2,9),
  ('2020-09-21',2020,2,9),
  ('2017-05-23',2017,1,5),
  ('2007-03-25',2007,1,3),
  ('2007-06-27',2007,1,6),
  ('2014-10-14',2014,2,10),
  ('2003-01-21',2003,1,1),
  ('2002-01-16',2002,1,1),
  ('2004-03-14',2004,1,3),
  ('2011-07-19',2011,2,7),
  ('2015-02-11',2015,1,2),
  ('2008-05-27',2008,1,5),
  ('2019-08-24',2019,2,8);

INSERT INTO pago(pago_completo)
VALUES
  (50000),
  (150000),
  (100000),
  (150000),
  (50000),
  (150000),
  (50000),
  (100000),
  (150000),
  (50000),
  (50000),
  (100000),
  (100000),
  (150000),
  (50000),
  (100000),
  (50000),
  (150000),
  (50000),
  (100000),
  (150000),
  (100000),
  (50000),
  (150000),
  (50000),
  (100000),
  (100000),
  (50000),
  (50000),
  (150000),
  (50000),
  (50000),
  (150000),
  (100000),
  (50000);

INSERT INTO
profesor_tiempo(ano,semestre)
VALUES
  (2003,2),
  (2017,1),
  (2003,1),
  (2019,2),
  (2014,2),
  (2007,2),
  (2006,1),
  (2015,2),
  (2016,1),
  (2021,1),
  (2002,2),
  (2005,1),
  (2002,2),
  (2018,2),
  (2021,2),
  (2005,2),
  (2014,1),
  (2016,2),
  (2014,1),
  (2020,2),
  (2016,2),
  (2016,1),
  (2014,1),
  (2020,1),
  (2020,1),
  (2007,1),
  (2021,2),
  (2003,2),
  (2007,1),
  (2004,2),
  (2007,1),
  (2008,2),
  (2004,2),
  (2002,2),
  (2012,2),
  (2020,1),
  (2004,1),
  (2019,1),
  (2011,1),
  (2008,2),
  (2013,2),
  (2006,1),
  (2020,2),
  (2015,1),
  (2003,2),
  (2020,1),
  (2003,1),
  (2006,1),
  (2005,1),
  (2009,2);

INSERT INTO empleado(nombre,fecha_nacimiento,fecha_ingreso,especialida,fecha_salida,cedula)
VALUES
	('Eugenia Garcia','1994-08-10','2020-11-23','Idiomas','2021-01-30','001-8847723-4'),
	('Carlos Gay','1987-06-25','2021-02-21','Psicologia','2022-02-10','001-7427594-2'),
	('Giovanni Curry','1996-10-28','2017-09-23','Nutricion','2019-03-18','001-3481985-5'),
	('Joaquin Acosta','1992-01-04','2007-02-12','Ingenieria Industrial','2010-04-16','001-3930911-4'),
	('Beatrice Glass','1997-07-10','2011-12-10','Idiomas','2020-05-09','001-4086548-6'),
	('Erick Lara','1987-04-23','2008-07-12','Psicologia','2019-06-29','001-5181179-8'),
	('Jonah Smith','1988-10-15','2018-09-24','Educacion Fisica','2020-07-28','001-8183445-5'),
	('Dante Vasquez','1995-11-09','2021-10-22','Psicologia','2022-08-26','001-9049119-8'),
	('Abigail Horne','1999-05-29','2009-03-01','Ingenieria Industrial','2018-09-25','001-2137118-3'),
	('Denise Kaufman','1999-08-05','2013-08-11','Educacion Fisica','2017-08-24','001-7167209-5'),
	('Emerson Garrett','1994-07-07','2017-12-16','Idiomas','2020-09-23','001-1037131-7'),
	('Oliver Hamilton','1993-04-02','2013-07-27','Idiomas','2019-10-12','001-0136074-8'),
	('Naomi Weber','2000-01-28','2011-07-09','Psicologia','2016-11-14','001-1989580-8'),
	('Grady Albert','1993-07-28','2011-07-21','Ingenieria Industrial','2018-12-16','001-8381100-3'),
	('Alexa Camacho','1996-06-30','2008-07-21','Psicologia','2010-01-19','001-7781928-3'),
	('Vladimir Blair','1998-07-09','2005-07-29','Nutricion','2009-02-17','001-4881970-9'),
	('Ambiorix Melton','1993-04-22','2014-09-10','Idiomas','2020-03-09','001-3980795-8'),
	('Ishmael Cortez','1994-04-21','2007-12-16','Ingenieria Industrial','2012-04-08','001-1942973-4'),
	('Benjamin Walls','1997-07-29','2011-05-01','Idiomas','2015-05-07','001-1966555-4'),
	('Leah Hopkins','1996-11-22','2013-07-21','Nutricion','2018-06-05','001-1768690-1'),
	('Gloria Simon','1997-07-19','2020-11-02','Idiomas','2021-07-02','001-1550237-8'),
	('Kay Kramer','1989-04-07','2004-11-06','Psicologia','2008-08-13','001-4143841-5'),
	('Ethan Vance','1998-08-03','2009-10-05','Psicologia','2011-09-12','001-2061694-3'),
	('Ruben Hayes','1994-09-17','2019-08-29','Psicologia','2021-10-11','001-2963528-2'),
	('Brock Leon','1992-01-21','2016-08-30','Psicologia','2020-11-22','001-2477512-9'),
	('Paola Lowe','1990-08-26','2008-12-17','Idiomas','2019-12-14','001-2542359-7'),
	('Brendan Harrington','1987-08-29','2018-02-24','Idiomas','2021-01-29','001-6725846-7'),
	('Uriel Sweeney','2000-08-07','2021-02-14','Educacion Fisica','2022-02-28','001-3464984-1'),
	('Marta Pollard','1995-04-11','2015-12-19','Nutricion','2020-03-25','001-2339897-3'),
	('Judah Ortega','1996-05-15','2019-04-25','Nutricion','2021-04-24','001-5784219-1'),
	('Brett Burch','2000-06-18','2010-10-26','Psicologia','2016-05-03','001-3974709-2'),
	('Carla Hester','1992-12-01','2009-04-06','Idiomas','2014-06-06','001-9077278-5'),
	('Athena Yang','1989-08-02','2012-01-12','Educacion Fisica','2016-07-07','001-4981848-6'),
	('Vivien Moses','1988-08-11','2006-10-10','Idiomas','2010-08-19','001-0349671-4'),
	('Yuka Jensen','1995-09-28','2013-01-23','Ingenieria Industrial','2018-09-18','001-6664773-1'),
	('Amy Hamilton','1990-12-09','2017-07-10','Idiomas','2020-10-27','001-4581656-5'),
	('Joelle Wallace','1994-07-22','2011-03-23','Idiomas','2017-11-30','001-6784658-7'),
	('Yailin Peters','1995-10-02','2011-11-01','Idiomas','2013-12-20','001-25635362-4'),
	('Orlando Lowe','1992-10-30','2003-08-05','Ingenieria Industrial','2010-01-19','001-8254670-3'),
	('Beau Moon','1991-06-28','2018-05-02','Psicologia','2020-02-12','001-9867333-6'),
	('Raul Fowler','1999-10-31','2005-01-03','Idiomas','2011-03-11','001-2360724-6'),
	('Ella Tillman','1991-04-28','2018-07-15','Idiomas','2021-04-10','001-1389288-3'),
	('Seth Floyd','1991-07-14','2012-12-26','Psicologia','2014-05-05','001-8424553-8'),
	('Shana Trujillo','1988-10-21','2013-11-10','Ingenieria Industrial','2018-06-04','001-2256143-4'),
	('Cameron Conrad','1996-06-13','2014-10-17','Idiomas','2016-07-01','001-2434190-2'),
	('Whitney Gomez','1999-07-29','2009-07-21','Educacion Fisica','2012-08-13','001-4163223-9'),
	('Gavin Perkins','1996-09-14','2012-04-24','Psicologia','2014-09-27','001-3168454-6'),
	('Chadwick Moran','1991-02-26','2016-12-27','Ingenieria Industrial','2020-10-23','001-3576642-9'),
	('Christopher Weiss','1989-06-11','2010-03-11','Nutricion','2015-11-15','001-9363243-1'),
	('Porfirio Lara','1990-11-30','2019-06-11','Psicologia','2020-12-02','001-2966737-7');

INSERT INTO salario(mensual,quincenal)
VALUES
  (46700,23350),
  (35900,17950),
  (83100,41550),
  (82000,41000),
  (72600,36300),
  (48000,24000),
  (61100,30550),
  (83600,41800),
  (88500,44250),
  (75300,37650),
  (68600,34300),
  (25000,12500),
  (74100,37050),
  (74500,37250),
  (23400,11700),
  (97000,48500),
  (87900,43950),
  (53900,26950),
  (73900,36950),
  (58700,29350),
  (73000,36500),
  (39000,19500),
  (65800,32900),
  (48700,24350),
  (85400,42700),
  (95900,47950),
  (69300,34650),
  (39100,19550),
  (85300,42650),
  (92100,46050),
  (89000,44500),
  (63400,31700),
  (36800,18400),
  (24600,12300),
  (61100,30550),
  (31400,15700),
  (32300,16150),
  (20200,10100),
  (66700,33350),
  (82500,41250),
  (95700,47850),
  (88700,44350),
  (50400,25200),
  (31500,15750),
  (29800,14900);

-- Publicidad
INSERT INTO publicidad_tiempo(ano,mes)
VALUES
  (2003,2),
  (2017,1),
  (2003,1),
  (2019,2),
  (2014,2),
  (2007,2),
  (2006,1),
  (2015,2),
  (2016,1),
  (2021,1),
  (2002,2),
  (2005,1),
  (2002,2),
  (2018,2),
  (2021,2),
  (2005,2),
  (2014,1),
  (2016,2),
  (2014,1),
  (2020,2),
  (2016,2),
  (2016,1),
  (2014,1),
  (2020,1),
  (2020,1),
  (2007,1),
  (2021,2),
  (2003,2),
  (2007,1),
  (2004,2),
  (2007,1),
  (2008,2),
  (2004,2),
  (2002,2),
  (2012,2),
  (2020,1),
  (2004,1),
  (2019,1),
  (2011,1),
  (2008,2),
  (2013,2),
  (2006,1),
  (2020,2),
  (2015,1),
  (2003,2),
  (2020,1),
  (2003,1),
  (2006,1),
  (2005,1),
  (2009,2);

INSERT INTO
gasto_publicitario(nombre,precio)
VALUES
  ('Promocion Descuento',7452255),
  ('Promocion Descuento Metodo',7619416),
  ('Promocion Beca',6844622),
  ('Promocion Campus',8747949),
  ('Promocion Verano',6239586),
  ('Promocion Invierno',7974057),
  ('Promocion Beca',3450653),
  ('Promocion Lanzamiento',4090850),
  ('Promocion Beca',9541780),
  ('Promocion Descuento',8492845),
  ('Promocion Campus',1106679),
  ('Promocion en Expo',1854269),
  ('Promocion Campus',9483677),
  ('Promocion Verano',1114181),
  ('Promocion Invierno',7640372),
  ('Promocion Lanzamiento',4710882),
  ('Promocion en Expo',2018121),
  ('Promocion Verano',7328616),
  ('Promocion Verano',2113631),
  ('Promocion Invierno',9376772),
  ('Promocion Beca',993962),
  ('Promocion Lanzamiento',8785021),
  ('Promocion Descuento Metodo',5256651),
  ('Promocion Invierno',7656027),
  ('Promocion Invierno',6484196),
  ('Promocion en Expo',6911717),
  ('Promocion Lanzamiento',7374944),
  ('Promocion Campus',6085685),
  ('Promocion en Expo',2942270),
  ('Promocion en Expo',9153788),
  ('Promocion Verano',6602026),
  ('Promocion Lanzamiento',5277399),
  ('Promocion en Expo',6680211),
  ('Promocion Lanzamiento',4312013),
  ('Promocion Descuento',3641783),
  ('Promocion en Expo',7980082),
  ('Promocion Beca',3002880),
  ('Promocion Verano',2954937),
  ('Promocion Invierno',2080784),
  ('Promocion Verano',7322789),
  ('Promocion en Expo',9594806),
  ('Promocion Beca',2798010),
  ('Promocion Beca',1589901),
  ('Promocion Lanzamiento',1526782),
  ('Promocion Verano',5148414),
  ('Promocion Beca',9180543),
  ('Promocion Invierno',8601895),
  ('Promocion Verano',7977121),
  ('Promocion Invierno',3975028),
  ('Promocion Lanzamiento',6860004);

-- Publicidad Digital 1 y Fisica 0
INSERT INTO
categoria(tipo)
VALUES
  (1),
  (1),
  (1),
  (1),
  (0),
  (1),
  (1),
  (1),
  (0),
  (1),
  (1),
  (1),
  (0),
  (0),
  (1),
  (1),
  (0),
  (0),
  (0),
  (1),
  (1),
  (1),
  (0),
  (0),
  (1),
  (0),
  (0),
  (0),
  (1),
  (0),
  (0),
  (0),
  (1),
  (0),
  (1),
  (0),
  (1),
  (0),
  (1),
  (0),
  (1),
  (1),
  (0),
  (1),
  (1),
  (0),
  (0),
  (1),
  (1),
  (0);