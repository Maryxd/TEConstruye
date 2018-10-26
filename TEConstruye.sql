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
PRIMARY KEY (Cedula)
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
FOREIGN KEY (ID_Etapa) REFERENCES Etapa(ID_Etap)
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

	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON ID_Etap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra
	Group by Nombre, Nombre_Material,Cantidad,Precio,TotalMAT

	SELECT Nombre,SUM(TotalMAT) as "Presupuesto por Etapa"
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON ID_Etap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra
	Group by Nombre

	SELECT SUM(TotalMAT) as "Presupuesto Total"
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON ID_Etap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra
	GO
	

--Stored Procedure que genera una planilla
CREATE PROCEDURE USP_Planilla @semana INT
	AS
	SELECT  Nombre, Apellido1, Apellido2, ID as ID_Obra, Ubicacion, SUM(HorasXSemana*Pago_Hora) as Sueldo
	FROM WORKS_ON INNER JOIN Obra ON ID_Obra=ID LEFT JOIN Empleados ON ID_Empleado=Cedula
	Where Semana=@semana
	Group by Nombre, Apellido1, Apellido2, ID, Ubicacion

	SELECT  Nombre, Apellido1, Apellido2, SUM(HorasXSemana*Pago_Hora) as "Total Sueldo"
	FROM WORKS_ON INNER JOIN Obra ON ID_Obra=ID LEFT JOIN Empleados ON ID_Empleado=Cedula
	Where Semana=@semana
	Group by Nombre, Apellido1, Apellido2
	GO

--Stored Procedure que genera recuento de gastos
CREATE PROCEDURE USP_Gasto @semana INT, @IDObra INT
	AS
	SELECT Numero_Factura,Lugar,Fecha, Nombre as Etapa, Monto
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.ID_Etapa=ID LEFT JOIN Etapa ON EtapaXObra.ID_Etapa=ID_Etap
	WHERE Semana=@semana AND Gastos.ID_Obra=@IDObra
	GO

--Stored Procedure que genera un reporte de estado
CREATE PROCEDURE USP_Reporte_de_Estado @IDObra INT
	AS
	
	Select Nombre as Etapa,SUM(TotalMAT) as Presupuesto,SUM(Monto) as Real,SUM(TotalMAT)-SUM(Monto) as Diferencia
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON ID_Etap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo LEFT JOIN Gastos ON Gastos.ID_Etapa=ID/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE EtapaxObra.ID_Obra=@IDObra
	Group by Nombre

	SELECT SUM(Diferencia) as Total
	FROM EtapaXObra INNER JOIN (SELECT ID,SUM(TotalMAT)-SUM(Monto) as Diferencia
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON ID_Etap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo LEFT JOIN Gastos ON Gastos.ID_Etapa=ID/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE EtapaxObra.ID_Obra=@IDObra
	Group by ID ) Tabla ON EtapaXObra.ID=Tabla.ID
	
	GO


	--Stored Procedure que despliega la información de ingenieros
CREATE PROCEDURE USP_InfoIngenieros  @id_ing INT
	AS
	SELECT Nombre, Cedula, Especialidad,Codigo
	FROM Ingenieros LEFT JOIN Empleados ON ID_Empleado=Cedula
	WHERE Cedula=@id_ing
 Group by Nombre, Cedula, Especialidad,Codigo
 GO
----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------BLOQUE DE CREACIÓN DE TRIGGERS---------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
GO
--Trigger que evita que se realicen reducciones en los salarios
CREATE TRIGGER TR_EvitarReduccionSalario ON Empleados
AFTER UPDATE 
AS 
BEGIN
 DECLARE @pago_Anterior int
 DECLARE @pago_Nuevo int
 SELECT @pago_Anterior = Pago_Hora FROM deleted
 SELECT @pago_Nuevo = Pago_Hora FROM inserted
 IF (@pago_Nuevo < @pago_Anterior)
 BEGIN
  RAISERROR('Cambio no autorizado: los pagos no pueden ser reducidos',15,0)
  ROLLBACK
 END
END
GO

--Trigger que evita que se introduzcan materiales sin precio
CREATE TRIGGER TR_EvitarMaterialSinPrecio ON Materiales
AFTER UPDATE 
AS 
BEGIN
 DECLARE @precio_Anterior int
 DECLARE @precio_Nuevo int
 SELECT @precio_Anterior = PrecioUnitario FROM deleted
 SELECT @precio_Nuevo = PrecioUnitario FROM inserted
 IF (@precio_Nuevo <= 0)
 BEGIN
  RAISERROR('Cambio no autorizado: los materiales deben tener un precio registrado',15,0)
  ROLLBACK
 END
END
GO



----------------------------------------------------------------------------------------------------------------------------------------------
EXEC USP_Planilla 1;
EXEC USP_Presupuesto 226;
EXEC USP_Reporte_de_Estado 630;
EXEC USP_Gasto 1,226;
EXEC USP_InfoIngenieros 12345678;

SELECT * FROM Gastos

----------------------------------------------------------ÚLTIMA LÍNEA------------------------------------------------------------------------
