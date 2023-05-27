/*********************************************
** SPRINT FINAL DEL MODULO 3 BASES DE DATOS **
**********************************************

********GRUPO**********
**	GABRIEL PEREIRA  **
**	CLAUDIO CASTRO   **
**	JAVIER PEREZ     **
**	EDUARDO LARRAIN  **
***********************
*/

-- CREAMOS LA BASE DE DATOS
Create database TELOVENDO_SPRINT3M3;

-- CREAMOS EL USUARIO
CREATE USER 'Sprint_3M3'@'localhost' IDENTIFIED BY 'Sprint3M3';

-- OTORGAMOS PRIVILEGIOS AL USUARIO
GRANT CREATE, DROP, ALTER, INSERT ON TELOVENDO_SPRINT3M3.* TO 'Sprint_3M3'@'localhost';

-- ACTUALIZAMOS LOS PRIVILEGIOS
FLUSH PRIVILEGES;

-- NOS POSICIONAMOS EN LA BASE DE DATOS PARA PODER TRABAJAR EN ELLA
USE TELOVENDO_SPRINT3M3;
-- COMENZAMOS A CREAR TABLAS SI ES QUE NO EXISTEN
CREATE TABLE IF NOT EXISTS proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    representante_legal VARCHAR(20),
    nombre_corporativo VARCHAR(50),
    Telefono_1 INT,
    nombre_receptor_llamadas_1 VARCHAR(50),
    Telefono_2 INT,
    nombre_receptor_llamadas_2 VARCHAR(50),
    categoria_de_productos VARCHAR(20),
    Correo_electronico_factura VARCHAR(50)
  );
-- INSERTAMOS DATOS FICTICIOS
INSERT INTO proveedores (representante_legal, nombre_corporativo, telefono_1, nombre_receptor_llamadas_1 ,telefono_2, nombre_receptor_llamadas_2, categoria_de_productos, correo_electronico_factura)
VALUES 
('Representante 1', 'Corporativo 1', '123456789','Receptor 1', '987654321', 'Receptor 1.1', 'Electrónicos', 'correo1@example.com'),
('Representante 2', 'Corporativo 2', '987654321','Receptor 2', '123456789', 'Receptor 2.1', 'Electrónicos', 'correo2@example.com'),
('Representante 3', 'Corporativo 3', '555555555','Receptor 3', '666666666', 'Receptor 3.1', 'Electrónicos', 'correo3@example.com'),
('Representante 4', 'Corporativo 4', '111111111','Receptor 4', '222222222', 'Receptor 4.1', 'Electrónicos', 'correo4@example.com'),
('Representante 5', 'Corporativo 5', '999999999','Receptor 5', '888888888', 'Receptor 5.1', 'Electrónicos', 'correo5@example.com');


-- Telovendo tiene muchos clientes etc..
-- CREAMOS PRIMERO LA TABLA DIRECCIONES PARA PODER GENERAR LA 
-- RELACION DE LLAVES EN LA TABLA CLIENTES
CREATE TABLE IF NOT EXISTS Direcciones(
id int auto_increment primary key,
Direccion varchar(40),
Comuna varchar(50)
);
-- CREAMOS LA TABLA CLIENTES Y GENERAMOS SUS RELACIONES
CREATE TABLE IF NOT EXISTS clientes (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50),
apellido VARCHAR(50),
Direccion_id int,
FOREIGN KEY (Direccion_id) REFERENCES Direcciones(id)
);
-- INSERTAMOS DIRECCIONES FICTICIAS PARA PODER CREAR LOS PRIMEROS CLIENTES
INSERT INTO Direcciones (Direccion, Comuna)
VALUES
('direccion 1', 'comuna 1'),
('direccion 2', 'comuna 2');
-- AGREGAMOS CLIENTES
INSERT INTO clientes (nombre, apellido, Direccion_id)
VALUES ('Cliente 1', 'Apellido 1', 1),
       ('Cliente 2', 'Apellido 2', 2),
       ('Cliente 3', 'Apellido 3', 1),
       ('Cliente 4', 'Apellido 4', 1),
       ('Cliente 5', 'Apellido 5', 2);
-- CREAMOS LA TABLA CATEGORIA       
CREATE TABLE IF NOT EXISTS Categoria(
id int auto_increment primary key,
Codigo_categoria int unique,
Nombre_categoria varchar(50)
);
-- CREAMOS PRODUCTOS
CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    stock INT,
    precio NUMERIC(10),
    proveedor_id INT,
    Categoria_id int,
    color VARCHAR(50),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    FOREIGN KEY (Categoria_id) REFERENCES Categoria(id)
);
-- AGREGAMOS REGISTROS A LA TABLA CATEGORIAS
INSERT INTO Categoria(Codigo_categoria, Nombre_categoria)
VALUES
(01, 'ELECTRONICA'),
(02, 'CCTV'),
(03, 'Alarnas'),
(04, 'Pagina web'),
(05, 'Electricidad');
-- AGREGAMOS REGISTROS A LA TABLA PRODUCTOS
INSERT INTO productos (nombre, stock, precio, categoria_id, proveedor_id, color)
VALUES 
('Producto 1', 100, 1990, 1, 1, 'Rojo'),
('Producto 2', 50, 4990, 1, 2, 'Azul'),
('Producto 3', 200, 990, 5, 3, 'Verde'),
('Producto 4', 75, 2990, 5, 4, 'Negro'),
('Producto 5', 150, 1490, 2, 5, 'Blanco'),
('Producto 1', 80, 3990, 2, 1, 'Gris'),
('Producto 2', 120, 24990, 4, 2, 'Morado'),
('Producto 3', 90, 34990, 4, 3, 'Amarillo'),
('Producto 4', 60, 17990, 4, 4, 'Naranja'),
('Producto 5', 100, 54990, 3, 5, 'Negro');

-- PARA PODER GENERAR VENTAS NECESITAMOS UNA TABLA DE PEDIDOS
CREATE TABLE IF NOT EXISTS  Pedidos(
id int auto_increment primary key,
Codigo_pedido int unique,
Fecha_compra date,
Fecha_entrega date,
Cliente_id int,
Total_pedido int,
Estado varchar(20),
foreign key(Cliente_id) references clientes(id)
);
-- Y A SU VEZ LA TABLA DEL DETALLE DEL PEDIDO PARA PODER AGREGAR PRODUCTOS
CREATE TABLE IF NOT EXISTS Detalle_pedido(
id int auto_increment primary key,
Pedido_id int,
Producto_id int,
Cantidad int,
Precio_unitario DECIMAL(10,2),
FOREIGN KEY(Producto_id) REFERENCES productos(id),
FOREIGN KEY(Pedido_id) REFERENCES pedidos(id)
);
-- AGREGAMOS ALGUNOS ENCABEZADOS DE PEDIDOS
INSERT INTO Pedidos(Codigo_pedido, Fecha_compra, Fecha_entrega, Cliente_id, Total_pedido, Estado)
VALUES
(1, '2023-10-03', '2023-10-04', 1, 30000, 'Pendiente'),
(2, '2023-09-13', '2023-10-10', 1, 50000, 'Pendiente');
-- AGREGAMOS PRODUCTOS AL PEDIDO
INSERT INTO Detalle_pedido(Pedido_id, Producto_id, Cantidad, Precio_unitario)
VALUES
(1, 1, 30, 1500),
(1, 2, 45, 2000),
(2, 5, 10, 500),
(2, 6, 35, 100),
(1, 2, 3, 1500),
(1, 2, 3, 1500);

-- Cuál es la categoría de productos que más  se repite.
-- TRAEMOS EL NOMBRE DE LA CATEGORIA QUE MAS CONTAMOS DENTRO DE PRODUCTOS
SELECT Categoria.Nombre_categoria, COUNT(*) AS cantidad
FROM productos
JOIN Categoria ON productos.Categoria_id = Categoria.id
GROUP BY Categoria.Nombre_categoria
ORDER BY cantidad DESC LIMIT 1;

-- Cuáles son los productos con mayor stock
-- GENERAMOS UN LISTADO DE STOCK  ORDENADOS POR STOCK EN FORMA DESCENDENTE
SELECT *
FROM Productos
ORDER BY stock DESC;

-- Qué color de producto es más común en nuestra tienda.
-- CONTAMOS CUAL ES EL COLOR QUE MAS REPITE EN LOS PRODUCTOS DE NUESTRA BASE 
-- AGRUPANDOLOS POR COLOR Y ORDENANDOLOS DE FORMA DESCENDENTE LIMITANDO A 1 PARA TRAER EL MAYOR
SELECT color, COUNT(*) AS cantidad
FROM Productos
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos.
-- SELECCIONAMOS EL NOMBRE DEL PROVEEDOR SUMANDO SUS STOCK QUE TENEMOS EN NUESTROS PRODUCTOS 
-- LOS ORDENAMOS EN FORMA ASCENDENTE Y LO LIMITAMOS A 1 PARA TRAER EL MENOR
SELECT p.nombre_corporativo, SUM(pr.stock) AS total_stock
FROM Proveedores p
JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.nombre_corporativo
ORDER BY total_stock ASC
LIMIT 1;

-- Por último:
-- Cambien la categoría de productos más popular por ‘Electrónica y computación’.
-- CREAMOS UN UPDATE CON UNA CONSULTA ANIDADA PARA PODER TRAER LA CATEGORIA MAS VENDIDA
-- EN DETALLE DE PRODUCTOS Y DE ESTA FORMA PODER ACTUALIZAR EL NOMBRE DE LA CATEGORIA
-- MAS VENDIDA O MAS POPULAR ENTRE NUESTROS CLIENTES.
UPDATE Categoria
SET Nombre_categoria = 'Electrónica y computación'
WHERE id = (
    SELECT Categoria_id
    FROM (
        SELECT Categoria_id, COUNT(*) AS cantidad
        FROM Detalle_pedido
        JOIN productos ON Detalle_pedido.Producto_id = productos.id
        GROUP BY Categoria_id
        ORDER BY cantidad DESC
        LIMIT 1
    ) AS subquery
);

/* otra solucion ubiese sido crear una tabla temporal 
y almacenar los resultados en dicha tabla
hacer el update y despues borrar la tabla temporal, 
tambien podriamos haber utilizado una variable de servidor
como grupo encontramos que la forma menos invasiva era crear 
las consultas anidadas ya que no generaron un gran conflicto en su obtencion.*/
