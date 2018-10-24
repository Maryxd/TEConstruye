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
PK_Cedula INT NOT NULL,
Telefono VARCHAR (50) NOT NULL,
Pago_Hora INT NOT NULL,
PRIMARY KEY (PK_Cedula)
)

--Tabla para almacenar los ingenieros y arquitectos
CREATE TABLE Ingenieros(
Especialidad VARCHAR (50) NOT NULL,
PK_Codigo INT NOT NULL,
FK_ID_Empleado INT NOT NULL,
PRIMARY KEY (PK_Codigo),
FOREIGN KEY (FK_ID_Empleado) REFERENCES Empleados(PK_Cedula)
)

--Tabla para almacenar los clientes
CREATE TABLE Clientes (
Nombre VARCHAR (50) NOT NULL,
PK_Cedula VARCHAR (50) NOT NULL,
Telefono VARCHAR (50) NOT NULL,
PRIMARY KEY (PK_Cedula),
)

--Tabla para almacenar los materiales
CREATE TABLE Materiales (
Nombre_Material VARCHAR (50) NOT NULL,
PK_Codigo VARCHAR (50) NOT NULL,
PrecioUnitario  INT NOT NULL,
PRIMARY KEY (PK_Codigo)
)

--Tabla para almacenar las obras
CREATE TABLE Obra (
PK_ID INT NOT NULL,
FK_ID_Cliente VARCHAR (50) NOT NULL,
Ubicacion VARCHAR (50) NOT NULL,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_ID_Cliente) REFERENCES Clientes(PK_Cedula)
)

--Tabla para almacenar las etapas
CREATE TABLE Etapa(
PK_IDEtap int identity(1,1),
Nombre VARCHAR(50) NOT NULL
PRIMARY KEY (PK_IDEtap)
)

--Tabla intermedia entre etapa y obra 
CREATE TABLE EtapaXObra(
PK_ID INT NOT NULL,
FK_ID_Obra INT NOT NULL,
FK_ID_Etapa INT NOT NULL,
Fecha_Inicio DATETIME NOT NULL,
Fecha_Fin DATETIME NOT NULL,
PRIMARY KEY (PK_ID),
FOREIGN KEY (FK_ID_Obra) REFERENCES Obra(PK_ID),
FOREIGN KEY (FK_ID_Etapa) REFERENCES Etapa(PK_IDEtap)
)

--Tabla intermedia entre material y etapa
CREATE TABLE MaterialXEtapa(
PK_ID_ME INT NOT NULL,
FK_ID_Material VARCHAR(50) NOT NULL,
FK_ID_EtapaxObra INT NOT NULL,
Cantidad INT NOT NULL,
Precio INT NOT NULL,
TotalMAT as Cantidad*Precio,
Primary KEY (PK_ID_ME),
FOREIGN KEY (FK_ID_Material) REFERENCES Materiales(PK_Codigo),
FOREIGN KEY (FK_ID_EtapaxObra) REFERENCES EtapaXObra(PK_ID)
)

--Tabla para relacionar a los empleados con las obras
CREATE TABLE WORKS_ON(
FK_ID_Empleado INT NOT NULL,
FK_ID_Obra INT NOT NULL,
HorasXSemana FLOAT NOT NULL,
Semana INT NOT NULL,
FOREIGN KEY (FK_ID_Empleado) REFERENCES Empleados(PK_Cedula),
FOREIGN KEY (FK_ID_Obra) REFERENCES Obra(PK_ID)
)

--Tabla para recopilar los gastos de una obra
CREATE TABLE Gastos(
Numero_Factura INT NOT NULL,
FK_ID_Obra INT NOT NULL,
FK_ID_Etapa INT NOT NULL,
Lugar VARCHAR(50) NOT NULL,
Fecha DATETIME NOT NULL,
Semana INT NOT NULL,
Monto INT NOT NULL,
FOREIGN KEY (FK_ID_Obra) REFERENCES Obra(PK_ID),
FOREIGN KEY (FK_ID_Etapa) REFERENCES EtapaXObra(PK_ID)
)
GO

----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------BLOQUE DE CREACIÓN DE STORED PROCEDURES------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------

--Stored Procedure que genera un presupuesto
CREATE PROCEDURE USP_Presupuesto  @IDObra INT
	AS
	SELECT Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON FK_ID_EtapaxObra=PK_ID LEFT JOIN Etapa ON PK_IDEtap=FK_ID_Etapa LEFT JOIN Materiales ON FK_ID_Material=PK_Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE FK_ID_Obra=@IDObra
	Group by Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	GO

--Stored Procedure que genera una planilla
CREATE PROCEDURE USP_Planilla @semana INT
	AS
	SELECT  Nombre, Apellido1, Apellido2, PK_ID as ID_Obra, Ubicacion, SUM(HorasXSemana*Pago_Hora) as Sueldo
	FROM WORKS_ON INNER JOIN Obra ON FK_ID_Obra=PK_ID LEFT JOIN Empleados ON FK_ID_Empleado=PK_Cedula
	Where Semana=@semana
	Group by Nombre, Apellido1, Apellido2, PK_ID, Ubicacion
	GO

--Stored Procedure que genera recuento de gastos
CREATE PROCEDURE USP_Gasto @semana INT, @IDObra INT
	AS
	SELECT Numero_Factura,Lugar,Fecha, Nombre as Etapa, Monto
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.FK_ID_Etapa=PK_ID LEFT JOIN Etapa ON EtapaXObra.FK_ID_Etapa=PK_IDEtap
	WHERE Semana=@semana AND Gastos.FK_ID_Obra=@IDObra
	GO

--Stored Procedure que genera un reporte de estado
CREATE PROCEDURE USP_Reporte_de_Estado @IDObra INT
	AS
	declare @presupuesto int
	Select @presupuesto=SUM(TotalMAT)
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON FK_ID_EtapaxObra=PK_ID LEFT JOIN Etapa ON PK_IDEtap=FK_ID_Etapa LEFT JOIN Materiales ON FK_ID_Material=PK_Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE FK_ID_Obra=@IDObra

	SELECT Nombre as Etapa,@presupuesto as Presupuesto,SUM(Monto) as Real,@presupuesto-SUM(Monto) as Diferencia
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.FK_ID_Etapa=PK_ID LEFT JOIN Etapa ON EtapaXObra.FK_ID_Etapa=PK_IDEtap
	Where Gastos.FK_ID_Obra=630
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