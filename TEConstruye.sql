--Creación de la base de datos
create database TEConstruye
GO
USE TEConstruye

----------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------BLOQUE DE CREACIÓN DE TABLAS---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--Tabla para almacenar los empleados
CREATE TABLE Empleados(
Nombre VARCHAR(50) NOT NULL,
Apellido1 VARCHAR (50) NOT NULL,
Apellido2 VARCHAR (50) NOT NULL,
Cedula INT NOT NULL,
Telefono VARCHAR (50) NOT NULL,
Pago_Hora INT NOT NULL,
PRIMARY KEY (PK_Cedula)
)

--Tabla para almacenar los ingenieros y arquitectos
CREATE TABLE Ingenieros(
Especialidad VARCHAR (50) NOT NULL,
Codigo INT NOT NULL,
ID_Empleado INT NOT NULL,
PRIMARY KEY (Codigo),
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(Cedula)
)

--Tabla para almacenar los clientes
CREATE TABLE Clientes (
Nombre VARCHAR (50) NOT NULL,
Cedula VARCHAR (50) NOT NULL,
Telefono VARCHAR (50) NOT NULL,
PRIMARY KEY (Cedula),
)

--Tabla para almacenar los materiales
CREATE TABLE Materiales (
Nombre_Material VARCHAR (50) NOT NULL,
Codigo VARCHAR (50) NOT NULL,
PrecioUnitario  INT NOT NULL,
PRIMARY KEY (Codigo)
)

--Tabla para almacenar las obras
CREATE TABLE Obra (
ID INT NOT NULL,
ID_Cliente VARCHAR (50) NOT NULL,
Ubicacion VARCHAR (50) NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(Cedula)
)

--Tabla para almacenar las etapas
CREATE TABLE Etapa(
ID_Etap int identity(1,1),
Nombre VARCHAR(50) NOT NULL
PRIMARY KEY (ID_Etap)
)

--Tabla intermedia entre etapa y obra 
CREATE TABLE EtapaXObra(
ID INT NOT NULL,
ID_Obra INT NOT NULL,
ID_Etapa INT NOT NULL,
Fecha_Inicio DATETIME NOT NULL,
Fecha_Fin DATETIME NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (ID_Obra) REFERENCES Obra(ID),
FOREIGN KEY (ID_Etapa) REFERENCES Etapa(IDEtap)
)

--Tabla intermedia entre material y etapa
CREATE TABLE MaterialXEtapa(
ID_ME INT NOT NULL,
ID_Material VARCHAR(50) NOT NULL,
ID_EtapaxObra INT NOT NULL,
Cantidad INT NOT NULL,
Precio INT NOT NULL,
TotalMAT as Cantidad*Precio,
Primary KEY (ID_ME),
FOREIGN KEY (ID_Material) REFERENCES Materiales(Codigo),
FOREIGN KEY (ID_EtapaxObra) REFERENCES EtapaXObra(ID)
)

--Tabla para relacionar a los empleados con las obras
CREATE TABLE WORKS_ON(
ID_Empleado INT NOT NULL,
ID_Obra INT NOT NULL,
HorasXSemana FLOAT NOT NULL,
Semana INT NOT NULL,
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(Cedula),
FOREIGN KEY (ID_Obra) REFERENCES Obra(ID)
)

--Tabla para recopilar los gastos de una obra
CREATE TABLE Gastos(
Numero_Factura INT NOT NULL,
ID_Obra INT NOT NULL,
ID_Etapa INT NOT NULL,
Lugar VARCHAR(50) NOT NULL,
Fecha DATETIME NOT NULL,
Semana INT NOT NULL,
Monto INT NOT NULL,
FOREIGN KEY (ID_Obra) REFERENCES Obra(ID),
FOREIGN KEY (ID_Etapa) REFERENCES EtapaXObra(ID)
)
GO

----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------BLOQUE DE CREACIÓN DE STORED PROCEDURES------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--Stored Procedure que genera un presupuesto
CREATE PROCEDURE USP_Presupuesto  @IDObra INT
	AS
	SELECT Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=PK_ID LEFT JOIN Etapa ON IDEtap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra
	Group by Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	GO

--Stored Procedure que genera una planilla
CREATE PROCEDURE USP_Planilla @semana INT
	AS
	SELECT  Nombre, Apellido1, Apellido2, ID as ID_Obra, Ubicacion, SUM(HorasXSemana*Pago_Hora) as Sueldo
	FROM WORKS_ON INNER JOIN Obra ON ID_Obra=ID LEFT JOIN Empleados ON ID_Empleado=Cedula
	Where Semana=@semana
	Group by Nombre, Apellido1, Apellido2, ID, Ubicacion
	GO

--Stored Procedure que genera recuento de gastos
CREATE PROCEDURE USP_Gasto @semana INT, @IDObra INT
	AS
	SELECT Numero_Factura,Lugar,Fecha, Nombre as Etapa, Monto
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.ID_Etapa=PK_ID LEFT JOIN Etapa ON EtapaXObra.ID_Etapa=IDEtap
	WHERE Semana=@semana AND Gastos.ID_Obra=@IDObra
	GO

--Stored Procedure que genera un reporte de estado
CREATE PROCEDURE USP_Reporte_de_Estado @IDObra INT
	AS
	declare @presupuesto int
	Select @presupuesto=SUM(TotalMAT)
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=PK_ID LEFT JOIN Etapa ON IDEtap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra

	SELECT Nombre as Etapa,@presupuesto as Presupuesto,SUM(Monto) as Real,@presupuesto-SUM(Monto) as Diferencia
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.ID_Etapa=PK_ID LEFT JOIN Etapa ON EtapaXObra.ID_Etapa=PK_IDEtap
	Where Gastos.ID_Obra=630
	GROUP BY Nombre
	GO

----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------BLOQUE DE CREACIÓN DE TRIGGERS---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--Trigger que evita que se realicen reducciones en los salarios
CREATE TRIGGER TR_EvitarReduccionSalario ON Empleados
FOR UPDATE 
AS
	IF UPDATE(Pago_Hora) 
	BEGIN
		DECLARE @pago_Anterior int
		DECLARE @pago_Nuevo int
		SELECT @pago_Anterior = Pago_Hora FROM deleted
		SELECT @pago_Nuevo = Pago_Hora FROM inserted
		IF (@pago_Nuevo < @pago_Anterior)
		RAISERROR(15600,-1,-1,'Cambio no autorizado: los pagos no pueden ser reducidos')
		ROLLBACK
	END
GO

--Trigger que evita que se reporte un material cuyo costo sea cero
CREATE TRIGGER TR_VerificarPrecioMaterial ON Materiales
FOR UPDATE 
AS
	IF UPDATE(PrecioUnitario) 
	BEGIN
		DECLARE @precio_Anterior int
		DECLARE @precio_Nuevo int
		SELECT @precio_Anterior = PrecioUnitario FROM deleted
		SELECT @precio_Nuevo = PrecioUnitario FROM inserted
		IF (@precio_Nuevo = 0)
		RAISERROR(15600,-1,-1,'Cambio no autorizado: los materiales deben tener un precio')
		ROLLBACK
	END
GO

----------------------------------------------------------------------------------------------------------------------------------------------
EXEC USP_Planilla 1;
EXEC USP_Presupuesto 630;
EXEC USP_Reporte_de_Estado 630;

----------------------------------------------------------ÚLTIMA LÍNEA------------------------------------------------------------------------
