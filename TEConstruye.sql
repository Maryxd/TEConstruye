create database TEConstruye

CREATE TABLE EMPLEADOS(
Nombre VARCHAR(50),
Cedula VARCHAR(50),
Telefono VARCHAR (50),
Pago_Hora INT,
Apellido1 VARCHAR (50),
Apellido2 VARCHAR (50),
)

CREATE TABLE INGENIEROS(
Especialidad VARCHAR (50),
Codigo INT,
ID_Empleado INT,
)

CREATE TABLE CLIENTES (
Nombre VARCHAR (50),
Cedula VARCHAR (50),
Telefono VARCHAR (50),
PRIMARY KEY (Cedula),
)

CREATE TABLE MATERIALES (
Nombre_Material VARCHAR (50),
Codigo VARCHAR (50),
PrecioUnitario  INT,

)

CREATE TABLE OBRA (
Ubicacion VARCHAR (50),
Presupuesto_Final FLOAT,
ID INT,
ID_Cliente VARCHAR (50),
PRIMARY KEY (ID),
)


