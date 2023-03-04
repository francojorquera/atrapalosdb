/*
Portafolio Módulo 5
Franco Jorquera
*/

-- Creación y llenado de tablas
DROP TABLE IF EXISTS clientes; 
DROP TABLE IF EXISTS compras;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS inventario;

CREATE TABLE usuarios
(
	id serial,
	nombre char varying(255),
	email char varying(255),
	pass char varying(255),
	PRIMARY KEY (id)
);

CREATE TABLE productos
(
	id serial,
	nombre char varying(255),
	descripcion char varying(255),
	PRIMARY KEY (id)
);

CREATE TABLE inventario
(
	id serial,
	cantidad integer,
	precio integer,
	PRIMARY KEY (id),
	FOREiGN KEY (id) REFERENCES productos (id) MATCH SIMPLE
);

CREATE TABLE compras
(
	id serial,
	id_usuario integer,
	id_producto integer,
	fecha date,
	PRIMARY KEY (id),
	FOREIGN KEY (id_usuario) REFERENCES usuarios (id) MATCH SIMPLE,
	FOREIGN KEY (id_producto) REFERENCES productos (id) MATCH SIMPLE
);

INSERT INTO usuarios (nombre, email, pass) values ('Franco','franco@gmail.com','1234');
INSERT INTO usuarios (nombre, email, pass) values ('Sebastián','seba@gmail.com','2233');
INSERT INTO usuarios (nombre, email, pass) values ('Gabriel','gabo@gmail.com','3333');
INSERT INTO usuarios (nombre, email, pass) values ('Alejandra','jandri@gmail.com','4321');
INSERT INTO usuarios (nombre, email, pass) values ('Carlos','krlos@gmail.com','4444');

INSERT INTO productos (nombre, descripcion) values ('Funko Pikachu','coleccionable funko pikachu');
INSERT INTO productos (nombre, descripcion) values ('Funko Charmander','coleccionable funko charmander');
INSERT INTO productos (nombre, descripcion) values ('Funko Lapras','coleccionable funko lapras');
INSERT INTO productos (nombre, descripcion) values ('Funko Flareon','coleccionable funko flareon');
INSERT INTO productos (nombre, descripcion) values ('Funko Mewtwo','coleccionable funko mewtwo');

INSERT INTO inventario (cantidad, precio) values (10, 10000);
INSERT INTO inventario (cantidad, precio) values (7, 20000);
INSERT INTO inventario (cantidad, precio) values (5, 30000);
INSERT INTO inventario (cantidad, precio) values (3, 40000);
INSERT INTO inventario (cantidad, precio) values (1, 50000);

INSERT INTO compras (id_usuario, id_producto, fecha) values (1,1,'2022-12-04');
INSERT INTO compras (id_usuario, id_producto, fecha) values (1,5,'2022-12-04');
INSERT INTO compras (id_usuario, id_producto, fecha) values (2,4,'2022-11-11');
INSERT INTO compras (id_usuario, id_producto, fecha) values (3,2,'2022-10-10');
INSERT INTO compras (id_usuario, id_producto, fecha) values (5,3,'2022-09-09');


--1) 20% descuento 
UPDATE inventario SET precio = ROUND(0.8*precio);

--2) stock crítico <=5
SELECT * FROM inventario WHERE cantidad <= 5;

--3) simular compra de 3 productos (no considera cantidad por unidad; cada unidad se considera una "compra")
INSERT INTO compras (id_usuario, id_producto, fecha) values (3,1,'2023-01-01');
INSERT INTO compras (id_usuario, id_producto, fecha) values (3,2,'2023-01-01');
INSERT INTO compras (id_usuario, id_producto, fecha) values (3,3,'2023-01-01');
UPDATE inventario SET cantidad = (cantidad-1) WHERE id = 1;
UPDATE inventario SET cantidad = (cantidad-1) WHERE id = 2;
UPDATE inventario SET cantidad = (cantidad-1) WHERE id = 3;
SELECT 
	SUM(inv.precio) AS subtotal,
	ROUND(0.19*SUM(inv.precio)) AS subtotal,
	ROUND(1.19*SUM(inv.precio)) AS total
FROM
	inventario inv,
	compras cp,
	productos pd
WHERE
	(inv.id = pd.id) AND (pd.id = cp.id_producto)
	AND cp.id_usuario = 3 AND cp.fecha = '2023-01-01';

--4) Total ventas diciembre 2022
SELECT
	SUM(inv.precio) AS total_ventas_dic_2022
FROM
	inventario inv,
	compras cp,
	productos pd
WHERE
	(inv.id = pd.id) AND (pd.id = cp.id_producto)
	AND EXTRACT('MONTH' FROM cp.fecha) = 12 AND EXTRACT('YEAR' FROM cp.fecha) = 2022;

--5) Listar usario con más compras (más veces compradas, no implica mayor monto)
SELECT id_usuario, COUNT(id_usuario) cuenta 
FROM compras
GROUP BY id_usuario
ORDER BY cuenta DESC
LIMIT 1