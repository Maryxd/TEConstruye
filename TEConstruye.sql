create database TEConstruye
GO
USE TEConstruye

CREATE TABLE Empleados(
Nombre VARCHAR(50) NOT NULL,
Apellido1 VARCHAR (50) NOT NULL,
Apellido2 VARCHAR (50) NOT NULL,
Cedula INT NOT NULL,
Telefono VARCHAR (50) NOT NULL,
Pago_Hora INT NOT NULL,
PRIMARY KEY (Cedula)
)

CREATE TABLE Ingenieros(
Especialidad VARCHAR (50) NOT NULL,
Codigo INT NOT NULL,
ID_Empleado INT NOT NULL,
PRIMARY KEY (Codigo),
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(Cedula)
)

CREATE TABLE Clientes (
Nombre VARCHAR (50) NOT NULL,
Cedula VARCHAR (50) NOT NULL,
Telefono VARCHAR (50) NOT NULL,
PRIMARY KEY (Cedula),
)

CREATE TABLE Materiales (
Nombre_Material VARCHAR (50),
Codigo VARCHAR (50),
PrecioUnitario  INT,
PRIMARY KEY (Codigo)
)


CREATE TABLE Obra (
ID INT NOT NULL,
ID_Cliente VARCHAR (50) NOT NULL,
Ubicacion VARCHAR (50) NOT NULL,
PRIMARY KEY (ID),
FOREIGN KEY (ID_Cliente) REFERENCES Clientes(Cedula)
)

CREATE TABLE Etapa(
IDEtap int identity(1,1),
Nombre VARCHAR(50) NOT NULL
PRIMARY KEY (IDEtap)
)


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



CREATE TABLE WORKS_ON(
ID_Empleado INT NOT NULL,
ID_Obra INT NOT NULL,
HorasXSemana FLOAT NOT NULL,
Semana INT NOT NULL,
FOREIGN KEY (ID_Empleado) REFERENCES Empleados(Cedula),
FOREIGN KEY (ID_Obra) REFERENCES Obra(ID)

)



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

/*GO
CREATE TRIGGER ActualizarPresupuestoporEtapa
	ON MaterialXEtapa
	AFTER INSERT
		AS
		declare @var int
		select @var=ID_EtapaxObra from inserted
		BEGIN
		UPDATE EtapaXObra
		Set Total=(SELECT sum(TotalMAT) FROM MaterialXEtapa where ID_EtapaxObra=@var)
		Where ID=@var
		END

GO
CREATE TRIGGER ActualizarPresupuestoxObra
	ON MaterialXEtapa
	AFTER INSERT
	AS
	declare @var2 int
	declare @var3 int
	select @var2=ID_EtapaxObra from inserted
	select @var3=ID_Obra FROM (MaterialXEtapa INNER JOIN EtapaXObra ON ID_EtapaxObra=ID) WHERE ID=@var2
	BEGIN
	UPDATE Obra
	Set Total_Materiales=(SELECT sum(TotalMAT) FROM (MaterialXEtapa INNER JOIN EtapaXObra ON ID_EtapaxObra=ID) where ID_Obra=@var3)
	where ID=@var3
	END*/


/*DROP TRIGGER ActualizarPresupuestoporObra
DROP TRIGGER ActualizarPresupuestoporEtapa
SELECT * FROM MaterialXEtapa*/
GO
CREATE PROCEDURE Presupuesto  @IDObra INT
	AS
	SELECT Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON IDEtap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra
	Group by Nombre, Nombre_Material,Cantidad,Precio,TotalMAT
	GO
	
CREATE PROCEDURE Planilla @semana INT
	AS
	SELECT  Nombre, Apellido1, Apellido2, ID as ID_Obra, Ubicacion, SUM(HorasXSemana*Pago_Hora) as Sueldo
	FROM WORKS_ON INNER JOIN Obra ON ID_Obra=ID LEFT JOIN Empleados ON ID_Empleado=Cedula
	Where Semana=@semana
	Group by Nombre, Apellido1, Apellido2, ID, Ubicacion
	GO

CREATE PROCEDURE Gasto @semana INT, @IDObra INT
	AS
	SELECT Numero_Factura,Lugar,Fecha, Nombre as Etapa, Monto
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.ID_Etapa=ID LEFT JOIN Etapa ON EtapaXObra.ID_Etapa=IDEtap
	WHERE Semana=@semana AND Gastos.ID_Obra=@IDObra
	GO


CREATE PROCEDURE Reporte_de_Estado @IDObra INT
	AS
	declare @presupuesto int
	Select @presupuesto=SUM(TotalMAT)
	FROM MaterialXEtapa LEFT JOIN EtapaXObra ON ID_EtapaxObra=ID LEFT JOIN Etapa ON IDEtap=ID_Etapa LEFT JOIN Materiales ON ID_Material=Codigo/* (EtapaXObra INNER JOIN (MaterialXEtapa INNER JOIN Materiales ON Codigo=ID_Material) ON ID_Etapa=ID_EtapaxObra)*/ 
	WHERE ID_Obra=@IDObra

	SELECT Nombre as Etapa,@presupuesto as Presupuesto,SUM(Monto) as Real,@presupuesto-SUM(Monto) as Diferencia
	FROM Gastos INNER JOIN EtapaXObra ON Gastos.ID_Etapa=ID LEFT JOIN Etapa ON EtapaXObra.ID_Etapa=IDEtap
	Where Gastos.ID_Obra=630
	GROUP BY Nombre
	GO


EXEC Planilla 1;
EXEC Presupuesto 630;
EXEC Reporte_de_Estado 630;   

SELECT * FROM Gastos

	SELECT * FROM EtapaXObra
	SELECT * FROM MaterialXEtapa