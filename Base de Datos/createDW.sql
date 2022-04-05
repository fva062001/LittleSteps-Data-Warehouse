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

-- fact table estudiante
IF OBJECT_ID('estudiante', 'U') IS NOT NULL
DROP TABLE estudiante
GO

CREATE TABLE fact_estudiante
(
	id_tiempo int foreign key references estudiante_tiempo_DW(id_tiempo),
	id_alumno int foreign key references Alumno_DW(id_alumno),
	id_sel int foreign key references sel_DW(id_sel),
	id_clase int foreign key references clase_DW(id_clase), 
	id_tutor int foreign key references tutor_DW(id_tutor)
);
GO

----------------------------------------------------------------------------------- Star scheme Tutor ---------------------------------------

IF OBJECT_ID('fact_tutor', 'U') IS NOT NULL
DROP TABLE fact_tutor
GO

CREATE TABLE fact_tutor
(
	id_tiempo int foreign key references tutor_tiempo_DW(id_tiempo),
	id_pago int foreign key references pago_DW(id_pago),
	id_tutor int foreign key references tutor_DW(id_tutor)
);
GO

-------------------------------------------------------------- profesor star scheme ------------------

IF OBJECT_ID('fact_profesores', 'U') IS NOT NULL
DROP TABLE fact_profesores
GO

CREATE TABLE fact_profesores
(
	id_tiempo int foreign key references profesor_tiempo_DW(id_tiempo),
	id_empleado int foreign key references empleado_DW(id_empleado),
	id_salario int foreign key references salario_DW(id_salario),
	id_clase int foreign key references clase_DW(id_clase)
);
GO

----------------------------------- star scheme publicidad ---------------------------------

IF OBJECT_ID('fact_publicidad', 'U') IS NOT NULL
DROP TABLE fact_publicidad
GO

CREATE TABLE fact_publicidad
(
	id_tiempo int foreign key references publicidad_tiempo_DW(id_tiempo),
	id_categoria int foreign key references categoria_DW(id_categoria),
	id_gasto_publicitario int foreign key references gasto_publicitario_DW(id_gasto_publicitario)
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

-------------- INSERCION DE LOS DATOS DE LOS FACTS TABLES -------------------------------------------
 INSERT INTO fact_estudiante (id_tiempo,id_alumno,id_sel,id_clase,id_tutor)
VALUES
  (37,18,15,44,9),
  (49,36,36,22,23),
  (5,49,38,43,40),
  (33,13,17,12,40),
  (2,3,13,27,28),
  (39,32,35,44,40),
  (7,31,39,31,48),
  (31,3,8,46,16),
  (5,4,43,23,30),
  (37,22,29,18,11),
  (47,47,44,45,20),
  (49,9,33,3,19),
  (11,5,38,33,10),
  (44,34,25,14,45),
  (43,2,37,7,5),
  (33,5,7,15,9),
  (21,18,34,40,20),
  (19,29,11,18,32),
  (45,45,35,15,50),
  (3,37,24,9,37),
  (4,32,47,9,46),
  (9,37,37,9,21),
  (29,25,40,27,39),
  (45,47,29,8,42),
  (26,10,23,36,13),
  (23,36,49,29,24),
  (28,13,17,29,2),
  (46,45,2,36,45),
  (47,19,42,39,38),
  (15,41,27,7,44),
  (25,46,26,4,11),
  (44,44,27,41,37),
  (32,35,7,12,38),
  (20,19,40,42,40),
  (3,48,26,43,33),
  (41,8,47,11,20),
  (48,16,24,35,49),
  (43,16,19,19,20),
  (12,34,15,41,39),
  (14,47,20,15,17),
  (42,48,24,36,9),
  (21,13,38,4,22),
  (16,11,42,20,27),
  (31,23,33,49,28),
  (7,9,28,1,36),
  (28,5,20,26,23),
  (25,19,4,27,25),
  (22,13,38,27,12),
  (6,33,6,40,8),
  (24,41,47,7,49);

  --
INSERT INTO fact_tutor (id_tiempo,id_pago,id_tutor)
VALUES
  (3,33,10),
  (31,22,20),
  (29,9,11),
  (16,12,5),
  (20,14,19),
  (46,31,25),
  (26,34,6),
  (2,21,4),
  (21,9,42),
  (14,10,32),
  (37,17,44),
  (11,33,23),
  (23,1,15),
  (16,2,49),
  (32,6,36),
  (42,13,35),
  (9,30,28),
  (38,20,11),
  (44,23,20),
  (35,21,12),
  (28,9,37),
  (13,29,39),
  (42,17,7),
  (48,19,3),
  (50,7,43),
  (14,3,2),
  (39,24,5),
  (15,21,26),
  (3,20,31),
  (7,30,26),
  (13,19,46),
  (35,3,23),
  (3,10,10),
  (43,26,10),
  (3,4,38),
  (8,26,6),
  (18,33,35),
  (11,2,21),
  (48,15,3),
  (17,16,8),
  (19,32,30),
  (42,13,18),
  (28,11,32),
  (11,7,7),
  (15,23,45),
  (36,30,26),
  (19,9,6),
  (34,10,27),
  (18,4,30),
  (12,26,18);


--
INSERT INTO fact_profesores (id_tiempo,id_empleado,id_salario,id_clase)
VALUES
  (26,31,2,23),
  (40,15,10,3),
  (24,22,2,40),
  (11,29,44,23),
  (17,20,34,24),
  (34,7,44,14),
  (47,49,7,10),
  (23,12,24,12),
  (47,34,11,35),
  (20,37,28,10),
  (30,38,15,10),
  (10,47,2,25),
  (27,4,37,33),
  (29,21,43,10),
  (44,6,29,19),
  (3,11,41,19),
  (49,7,13,22),
  (9,24,43,5),
  (49,27,24,13),
  (8,42,9,1),
  (12,2,16,7),
  (24,31,44,5),
  (19,7,37,38),
  (48,12,37,35),
  (22,18,42,30),
  (31,23,3,25),
  (13,48,14,22),
  (28,40,21,11),
  (16,4,35,26),
  (33,49,21,29),
  (44,36,6,8),
  (49,49,2,29),
  (9,19,11,8),
  (38,34,27,13),
  (28,48,45,40),
  (7,24,33,38),
  (30,19,8,28),
  (46,38,18,17),
  (35,26,4,14),
  (10,2,25,34),
  (7,46,28,18),
  (27,24,15,25),
  (18,39,39,7),
  (28,39,17,4),
  (37,25,36,2),
  (20,36,14,21),
  (13,39,26,4),
  (43,32,24,2),
  (3,46,6,7),
  (36,27,1,12);

INSERT INTO fact_publicidad (id_tiempo, id_categoria, id_gasto_publicitario)
VALUES
  (39,41,7),
  (4,11,44),
  (10,46,4),
  (22,45,13),
  (34,37,27),
  (27,45,28),
  (11,26,35),
  (6,30,2),
  (47,26,5),
  (46,39,13),
  (40,11,12),
  (25,26,19),
  (46,28,21),
  (24,28,11),
  (37,7,14),
  (5,37,35),
  (19,37,9),
  (44,29,31),
  (25,24,45),
  (7,6,20),
  (48,11,46),
  (25,38,45),
  (16,48,42),
  (30,42,14),
  (43,23,17),
  (20,10,34),
  (22,18,49),
  (44,11,38),
  (17,10,47),
  (23,17,17),
  (1,38,43),
  (43,5,3),
  (6,2,50),
  (44,1,29),
  (27,4,30),
  (39,44,32),
  (11,15,37),
  (21,48,7),
  (23,44,46),
  (48,43,21),
  (7,22,48),
  (21,49,19),
  (18,36,43),
  (18,12,7),
  (3,6,18),
  (36,19,17),
  (45,21,30),
  (46,17,20),
  (1,10,28),
  (30,32,35);