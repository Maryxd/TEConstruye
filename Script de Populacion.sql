USE TEConstruye

INSERT INTO Empleados
VALUES
('Paolo','López','Díaz',12345678,22769696,800),
('Marcelo','Torres','Montes',333567424,87865798,600),
('Marielos','Gutiérrez','Cháves',465780512,22755805,400),
('Francisco','Palma','Solano',200586456,22304569,350),
('Carmen','Aguilar','Fernández',200696412,25758978,800),
('Isabela','Céspedes','Córdoba',400568741,60025898,650),
('Gianluca','Auditore','Di Marzio',800789246,83267224,750),
('Marcos','Torreira','Suárez',104762210,24619874,1000),
('Andrés','Balmaceda','Duarte',574156911,22456987,1500),
('Gustavo','Castro','Zúñiga',698752143,24587410,900),
('Alonso','Martínez','Víctor',457896254,22301245,750),
('Fernanda','Gómez','González',104567845,26523145,775),
('Javier','Pérez','Rodríguez',210456721,60456321,500),
('Clara','Centeno','Aguero',356478961,83456987,450),
('María','Aguirre','Hurtado',452368974,70125896,335)

INSERT INTO Ingenieros
VALUES
('Arquitecto',98990,12345678),
('Ing. Eléctrico',45612,333567424),
('Ing. Civil',34789,465780512),
('Arquitecto',60000,200586456),
('Ing. Eléctrico',14578,200696412),
('Ing. Civil',20453,400568741),
('Arquitecto',97541,800789246),
('Ing. Eléctrico',12589,104762210),
('Ing. Civil',74523,574156911),
('Arquitecto',68452,698752143),
('Ing. Eléctrico',15986,457896254),
('Ing. Civil',20565,104567845),
('Arquitecto',97770,210456721),
('Ing. Eléctrico',47015,356478961),
('Ing. Civil',56214,452368974)

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
('Willian',107230078,22748974),
('Juliana',105430010,22304569),
('Rodolfo',104578045,25704520),
('Andrea',102500999,83185698),
('Omar',176520915,89954102)
INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(630,107230078,'Puntarenas')

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(658,105430010,'Quepos')

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(547,104578045,'Nandayure')

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(139,102500999,'Aserrí')

INSERT INTO Obra(ID,ID_Cliente,Ubicacion)
VALUES
(226,176520915,'San Carlos')

INSERT INTO EtapaXObra(ID,ID_Obra,ID_Etapa,Fecha_Inicio,Fecha_Fin)
VALUES
(60,630,1,'2018-15-10','2018-17-10'),
(61,630,2,'2018-16-10','2018-20-10'),
(62,630,3,'2018-21-10','2018-10-10'),
(63,658,1,'2018-27-11','2018-30-11'),
(64,658,2,'2018-12-01','2018-12-09'),
(54,547,1,'2018-10-01','2018-10-05'),
(10,139,1,'2018-08-08','2018-09-04'),
(11,139,2,'2018-09-07','2018-13-09'),
(26,226,1,'2018-11-01','2018-11-05'),
(27,226,2,'2018-11-07','2018-11-10')

SELECT * FROM EtapaXObra

INSERT INTO Materiales
VALUES
('clavo',12,100),
('Grifo cocina',2532043,49950),
('Grifo cocina 8 Classic Cromado',2517019,32950),
('Grifo cocina 8 Classic Cuello Alto',2517038,20500),
('Fregadero 1 tanque acero 201',2526169,13950),
('Fregadero 1 tanque acero 304',2526117,27950),
('Kit de Cocic¿na Napoles Blanco',2511042,99950),
('2 plafones niquel satinado luz',1510288,12950),
('2 plafones modernos cafe 12x26cm',1510282,11950),
('Ventilador 6 aspas 1 luz bronce',1548266,37950),
('Set 6 piezas cromo galicia baño',2450088,19950),
('Lavamanos de colgar Valino bone',2439421,11950),
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
('Lamina de Fibrolit 22mm 122x244cm',1333698,40500),
('Mueble base para lavaplatos blanco',2510039,56950),
('Kit para cocina Palace color blanco y wengue',2511040,135000),
('Mueble aéreo 2 puertas blanco',2510037,48500),
('Manija tradicional para baño Price Pfister',2648219,4550),
('Rodapié vinílico café 10 cm 1Metro',2234004,2050),
('Inodoro redondo 2 piezas blaco Ecoline',2420104,29900),
('Vigas de concreto',8749576,155379),
('Apagador No52',9868426,870),
('Apagador No54 Doble',3457854,950),
('Arena 1 Kg',6759375,16990),
('BALDOSA PREFA 1,95X50MT',56646576,6080),
('BALDOSA PREFA 0,75X0,5MT',95686864,2486),
('BLOQUE CONCRETO 20X20X40CMS',648573648,487),
('BREAKER 1X040AMP',34532124,3624),
('BREAKER 1X015AMP',34532324,2932),
('CABLE THHN/THW NGM.14 1M',88886848,239),
('CABLE TW/THW NO8 1M',88885645,310),
('CANALETA ESTRUCTURAL 0,74X4,57 NO26',45635467,6267),
('CANOA HG 26/30CM',35465768,4402),
('CEMENTO Saco',77756777,4331),
('CERAMICA 33X33 CMS M2',36454637,2339),
('CLAVO DE 38MM ACERO',12323323,11),
('CLAVO PARA TECHO 63MM 1kg',76656466,1219),
('CODO 100MM*90 PVC POTABLE',2335343,5272),
('FRAGUA 1Kg',74646574,786),
('LÁMINA HG TECHO,81X1,83/NO30',22222345,3984),
('LÁMINA PLYWOOD 1,22MX2,44MX12MM/2A',66569896,13296),
('LÁMINA TECHO TRANSP. POLICARB.81X1,83',75998739,61556),
('LLAVE DE CHORRO,12MM',34435454,2707),
('LLAVE DE PASO 12MM',64657474,3173),
('PEGAMENTO P/PVC',17756487,4402),
('PIEDRA VOLCAN m2',23232345,5697),
('PIEDRA QUINTILLA PRIMERA m3',12121343,10682),
('PILA CONCRETO 1BATEA 1X.53MT',36457567,37267),
('PINTURA ANTICORROSIVA',65656748,13542),
('PUERTA INTERIOR ESPECIAL',343453453,18128),
('SOLDADURA 1Kg',99989898,2922),
('TABLA FORMALETA 1X12pulg 1M',77787576,1207),
('TEJA ESMALTADA 2,00M/NO26',11111655,16574),
('TEJA MEDITERRANEO',55545654,5101),
('TINA BAÑO CARIBEÑA',66578678,137251),
('TINA BANO ESPECIAL',66570909,201992),
('TINA BAÑO PLÁSTICA',66570901,56972),
('TOMACORRIENTE DOBLE',99887868,1434),
('VARILLA',90878611,564),
('VIDRIO ACRILICO 1.22X1.83',34567581,17485)


Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(1,12,60,11000,100)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(2,2443049,61,2,99950)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(3,66570901,61,2,56972)


Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(4,99989898,61,2,2922)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(5,76656466,64,150,1219)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(6,36454637,61,8,2339)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(7,1333698,27,18,100)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(8,90878611,60,34,564)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(9,8749576,60,17,155379)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(10,74646574,64,12,786)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(12,648573648,61,78,487)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(11,6759375,11,13,16990)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(13,2420107,54,1,34950)

Insert into MaterialXEtapa(ID_ME,ID_Material,ID_EtapaxObra,Cantidad,Precio)
VALUES
(15,77756777,27,9,4331)


Insert into WORKS_ON
VALUES
(12345678,630,50,1),
(333567424,658,40,1),
(465780512,547,28,1),
(104567845,139,18,1),
(574156911,226,27,1),
(457896254,630,36,1),
(452368974,139,55,1),
(104567845,547,18,1),
(698752143,658,27,1),
(800789246,226,36,1),
(698752143,139,55,1)

INSERT INTO Gastos
VALUES
(12,630,60,'Epa','2018-07-07',1,20000),
(12,547,63,'Walmart','2018-12-01',1,500000),
(12,658,54,'Ferconce','2018-09-05',1,67000),
(12,226,10,'Ferretería Jiménez','2018-15-10',1,35000),
(12,139,26,'Fausto Jara','2018-12-01',1,402000),
(12,226,60,'El Lagar','2018-17-10',1,28900),
(12,547,61,'Materiales La Juana','2018-20-10',1,90500),
(12,658,64,'Fausto Jara','2018-12-01',1,44000),
(12,226,11,'El Lagar','2018-16-10',1,2900),
(12,139,26,'Materiales La Juana','2018-21-10',1,9500)




/*DROP DATABASE TEConstruye*/