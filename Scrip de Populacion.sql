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
('vc',91,100),
('Grifo cocina',2532043,49950),
('Grifo cocina 8 Classic Cromado',2517019,32950),
('Grifo cocina 8 Classic Cuello Alto',2517038,20500),
('Fregadero 1 tanque acero 201',2526169,13950),
('Fregadero 1 tanque acero 304',2526117,27950),
('Kit de Conica Napoles Blanco',2511042,99950),
('2 plafones niquel satinado luz',1510288,12950),
('2 plafones modernos cafe 12x26cm',1510282,11950),
('Ventilador 6 aspas 1 luz bronce',1548266,37950),
('Set 6 piezas cromo galicia baño',2450088,19950),
('Lavamanos de colgar Valino bone'2439421,11950),
('Grifo lavamanos bajo',2432067,19950),
('Grifo lavamanos alto',2432076,29950),
('Mueble de baño + lavamanos',2460082,79950),
('Lavamanos de pedestal',2439750,19950),
('Inodoro Ronco, blanco',2442258,74950),
('Inodoro redondo Laguna, blanco',2420107,34950),
('Ducha tipo telefono, 5kW, 120V',2443049,99950),
('Entrada principal con cerrojo niquel',1936121,16950),
('Manija sin llave cromo satin Kwikset Lido',1927093,7950),
('Cerradura',1942075,8950),
('Puerta Skin 2 tableros',2106008,14950),
('Puerta Alicante wengue',2102063,23500),
('Puerta seguridad roble lineas',2110018,249500),
('Puerta closet PVC cafe',2108064,26950),
('Pintura látex 3000 1gal',272021,11950),
('Pintura elasfomerica Acrilatex 1gal',245151,12950),
('Pintura latex Odor Free 1gal',281072,13950),
('Pintura 3en1 Seal Coat 1gal',281006,14500),
('Pintura latex Goltex 1gal',267008,17950),
('Pomo esfera bronce sin llave',1924100,3350),
('Lamina de Fibrolit 22mm 122x244cm',40500),
('Mueble base para lavaplatos blanco',2510039,56950),
('Kit para cocina Palace color blanco y wengue',2511040,135000),
('Mueble aéreo 2 puertas blanco',2510037,48500),
('Manija tradicional para baño Price Pfister',2648219,4550),
('Rodapié vinílico café 10 cm 1Metro',2234004,2050),
('Inodoro redondo 2 piezas blaco Ecoline',2420104,29900),
('Vigas de concreto',8749576,155379),
('Apagador No52',9868426,870),
('Apagador No54 Doble',3457854,950),
('Arena',6759375,16990)


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