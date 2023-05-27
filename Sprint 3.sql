Create database TeLoVendo_Sprint3

-- Creación del usuario
CREATE USER 'Sprint_3'@'localhost' IDENTIFIED BY 'Sprint3';

-- Otorgar privilegios al usuario
GRANT CREATE, DROP, ALTER, INSERT ON telovendo_sprint3.* TO 'Sprint_3'@'localhost';

-- Actualizar privilegios
FLUSH PRIVILEGES;

-- Telovendo recibe productos de diferentes proveedores, etc...
drop table proveedores

CREATE TABLE Proveedores (
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

DELIMITER //

CREATE TRIGGER validar_categoria_de_productos
BEFORE INSERT ON proveedores
FOR EACH ROW
BEGIN
    DECLARE contador INT;
    SELECT COUNT(*) INTO contador FROM proveedores WHERE id = NEW.id;
    IF contador > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya se ha ingresado una categoria para este proveedor';
    END IF;
END //

DELIMITER ;

INSERT INTO proveedores (representante_legal, nombre_corporativo, telefono_1, nombre_receptor_llamadas_1 ,telefono_2, nombre_receptor_llamadas_2, categoria_de_productos, correo_electronico_factura)
VALUES 
('Representante 1', 'Corporativo 1', '123456789','Receptor 1', '987654321', 'Receptor 1.1', 'Electrónicos', 'correo1@example.com'),
('Representante 2', 'Corporativo 2', '987654321','Receptor 2', '123456789', 'Receptor 2.1', 'Electrónicos', 'correo2@example.com'),
('Representante 3', 'Corporativo 3', '555555555','Receptor 3', '666666666', 'Receptor 3.1', 'Electrónicos', 'correo3@example.com'),
('Representante 4', 'Corporativo 4', '111111111','Receptor 4', '222222222', 'Receptor 4.1', 'Electrónicos', 'correo4@example.com'),
('Representante 5', 'Corporativo 5', '999999999','Receptor 5', '888888888', 'Receptor 5.1', 'Electrónicos', 'correo5@example.com');


-- Telovendo tiene muchos clientes etc..
drop table clientes

CREATE TABLE clientes (
id INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(50),
apellido VARCHAR(50),
Direccion_id int,
FOREIGN KEY (Direccion_id) REFERENCES Direcciones(id)
)

CREATE TABLE Direcciones(
id int auto_increment primary key,
Direccion varchar(40),
Comuna varchar(50)
)

INSERT INTO Direcciones (Direccion, Comuna)
VALUES
('direccion 1', 'comuna 1'),
('direccion 2', 'comuna 2');

/* DELIMITER //

CREATE TRIGGER validar_direccion
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN
    DECLARE contador INT;
    SELECT COUNT(*) INTO contador FROM Clientes WHERE id = NEW.id;
    IF contador > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya se ha ingresado una dirección para este cliente';
    END IF;
END //

DELIMITER ; */

INSERT INTO clientes (nombre, apellido, Direccion_id)
VALUES ('Cliente 1', 'Apellido 1', 1),
       ('Cliente 2', 'Apellido 2', 2),
       ('Cliente 3', 'Apellido 3', 1),
       ('Cliente 4', 'Apellido 4', 1),
       ('Cliente 5', 'Apellido 5', 2);


CREATE TABLE productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    stock INT,
    precio DECIMAL(10, 2),
    proveedor_id INT,
    Categoria_id int,
    color VARCHAR(50),
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id),
    FOREIGN KEY (Categoria_id) REFERENCES Categoria(id)
);

INSERT INTO productos (nombre, stock, precio, categoria_id, proveedor_id, color)
VALUES 
('Producto 1', 100, 19.99, 1, 1, 'Rojo'),
('Producto 2', 50, 49.99, 1, 2, 'Azul'),
('Producto 3', 200, 9.99, 5, 3, 'Verde'),
('Producto 4', 75, 29.99, 5, 4, 'Negro'),
('Producto 5', 150, 14.99, 2, 5, 'Blanco'),
('Producto 1', 80, 39.99, 2, 1, 'Gris'),
('Producto 2', 120, 24.99, 4, 2, 'Morado'),
('Producto 3', 90, 34.99, 4, 3, 'Amarillo'),
('Producto 4', 60, 17.99, 3, 4, 'Naranja'),
('Producto 5', 100, 54.99, 3, 5, 'Rosado');

CREATE TABLE Categoria(
id int auto_increment primary key,
Codigo_categoria int unique,
Nombre_categoria varchar(50)
)

INSERT INTO Categoria(Codigo_categoria, Nombre_categoria)
VALUES
(01, 'ELECTRONICA'),
(02, 'CCTV'),
(03, 'Alarnas'),
(04, 'Pagina web'),
(05, 'Electricidad');

CREATE TABLE Pedidos(
id int auto_increment primary key,
Codigo_pedido int unique,
Fecha_compra date,
Fecha_entrega date,
Cliente_id int,
Total_pedido int,
Estado varchar(20),
foreign key(Cliente_id) references clientes(id)
)

INSERT INTO Pedidos(Codigo_pedido, Fecha_compra, Fecha_entrega, Cliente_id, Total_pedido, Estado)
VALUES
(1, '2023-10-03', '2023-10-04', 1, 30000, 'Pendiente'),
(2, '2023-09-13', '2023-10-10', 1, 50000, 'Pendiente');


CREATE TABLE Detalle_pedido(
id int auto_increment primary key,
Pedido_id int,
Producto_id int,
Cantidad int,
Precio_unitario DECIMAL(10,2),
FOREIGN KEY(Producto_id) REFERENCES productos(id),
FOREIGN KEY(Pedido_id) REFERENCES pedidos(id)
)

INSERT INTO Detalle_pedido(Pedido_id, Producto_id, Cantidad, Precio_unitario)
VALUES
(1, 1, 30, 1500),
(1, 2, 45, 2000),
(2, 5, 10, 500),
(2, 6, 35, 100);

-- Cuál es la categoría de productos que más se repite.
SELECT categoria_de_productos, COUNT(*) AS cantidad
FROM Proveedores
GROUP BY categoria_de_productos
ORDER BY cantidad DESC
LIMIT 1;

-- Cuáles son los productos con mayor stock
SELECT *
FROM Productos
ORDER BY stock DESC
LIMIT 1;

-- Qué color de producto es más común en nuestra tienda.
SELECT color, COUNT(*) AS cantidad
FROM Productos
GROUP BY color
ORDER BY cantidad DESC
LIMIT 1;

-- Cual o cuales son los proveedores con menor stock de productos.
SELECT p.nombre_corporativo, SUM(pr.stock) AS total_stock
FROM Proveedores p
JOIN Productos pr ON p.id = pr.proveedor_id
GROUP BY p.nombre_corporativo
ORDER BY total_stock ASC
LIMIT 1;

-- Por último:
-- Cambien la categoría de productos más popular por ‘Electrónica y computación’.

SELECT detalle_pedido


SET SQL_SAFE_UPDATES = 0;

UPDATE Proveedores
SET categoria_de_productos = 'Electrónica y computación'
WHERE categoria_de_productos = (
    SELECT categoria_de_productos
    FROM (
        SELECT categoria_de_productos, COUNT(*) AS cantidad
        FROM Proveedores
        GROUP BY categoria_de_productos
        ORDER BY cantidad DESC
        LIMIT 1
    ) AS subquery
);

