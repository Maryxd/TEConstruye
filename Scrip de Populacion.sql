USE TEConstruye

INSERT INTO Empleados
VALUES
('Paolo','López','Díaz',12345678,22769696,800)

INSERT INTO Ingenieros
VALUES
('Arquitecto',98990,12345678)


INSERT INTO Etapa(Nombre)
VALUES
('Trabajo Preliminar'),
('Cimientos'),
('Paredes'),
('Concreto Reforzado'),
('Techos'),
('Cielos'),
('Repello'),
('Entrepisos'),
('Pisos'),
('Enchapes'),
('Instalación Pluvial'),
('Instalación Sanitaria'),
('Instalación Eléctrica'),
('Puertas'),
('Cerrajería'),
('Ventanas'),
('Closets'),
('Mueble de Cocina'),
('Pintura'),
('Escaleras')

INSERT INTO Clientes
VALUES
('Pepito',9876,2274)

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(123,9876,'SJ')

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(133,9876,'SJ')

INSERT INTO EtapaXObra(ID,ID_Obra,ID_Etapa,Fecha_Inicio,Fecha_Fin)
VALUES
(45,133,4,'2018-01-01','2019-01-01'),
(44,133,1,'2018-01-01','2019-01-01'),
(43,133,3,'2018-01-01','2019-01-01'),
(41,123,4,'2018-01-01','2019-01-01'),
(24,123,1,'2018-01-01','2019-01-01'),
(46,123,3,'2018-01-01','2019-01-01')

SELECT * FROM EtapaXObra

INSERT INTO Materiales
VALUES
('clavo',12,100),
('vc',11,100),
('vc',13,100),
('vc',1,100),('vc',14,100),('vc',51,100),('vc',61,100),('vc',18,100),('vc',17,100),
('vc',91,100)


Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(2,12,45,3,100)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(1,12,46,3,100)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(3,12,46,3,100)

SELECT * FROM MaterialXEtapa
DELETE MaterialXEtapa
DELETE EtapaXObra
DELETE Presupuesto


SELECT * FROM Obra

UPDATE Obra
Set Costo_Mano_de_Obra=900
Where ID=123