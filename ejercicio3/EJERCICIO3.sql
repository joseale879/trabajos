 CREATE DATABASE TiendaOnline;
USE TiendaOnline

CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Dirección (
    id_direccion INT PRIMARY KEY,
    id_cliente INT,
    direccion VARCHAR(100),
    ciudad VARCHAR(100),
    pais VARCHAR(100),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Categoría (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Producto (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,3),
    stock INT
);

CREATE TABLE Producto_Categoría (
    id_producto INT,
    id_categoria INT,
    PRIMARY KEY (id_producto, id_categoria),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
    FOREIGN KEY (id_categoria) REFERENCES Categoría(id_categoria)
);

CREATE TABLE Pedido (
    id_pedido INT PRIMARY KEY,
    id_cliente INT,
    fecha DATE,
    total DECIMAL(10,3),
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Pedido_Producto (
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_pedido, id_producto),
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Envío (
    id_envio INT PRIMARY KEY,
    id_pedido INT UNIQUE,
    empresaEnvio VARCHAR(100),
    fecha DATE,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

-- ========================
-- INSERT DML
-- ========================

INSERT INTO Cliente VALUES 
(1, 'Juan Pérez'),
(2, 'María Gómez'),
(3, 'Carlos Rodríguez');

INSERT INTO Dirección VALUES
(1, 1, 'Calle 10 #5-20', 'Bogotá', 'Colombia'),
(2, 2, 'Av. Siempre Viva 123', 'Medellín', 'Colombia'),
(3, 3, 'Cra. 15 #45-67', 'Cali', 'Colombia');

INSERT INTO Categoría VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Libros');

INSERT INTO Producto VALUES 
(1, 'Audífonos Bluetooth', 89.990, 100),
(2, 'Camiseta Hombre', 29.900, 150),
(3, 'Novela - Cien años de soledad', 49.500, 60);

INSERT INTO Producto_Categoría VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Pedido VALUES 
(1, 1, '2025-06-20', 119.890),
(2, 2, '2025-06-19', 29.900),
(3, 3, '2025-06-18', 49.500);

INSERT INTO Pedido_Producto VALUES 
(1, 1, 1),
(2, 2, 1),
(3, 3, 1);

INSERT INTO Envío VALUES 
(1, 1, 'Servientrega', '2025-06-21'),
(2, 2, 'Coordinadora', '2025-06-20'),
(3, 3, 'Deprisa', '2025-06-19');

-- ========================
-- UPDATE
-- ========================

UPDATE Cliente SET nombre = 'Juan Pablo Pérez' WHERE id_cliente = 1;
UPDATE Producto SET precio = 79.990 WHERE id_producto = 1;
UPDATE Categoría SET nombre = 'Tecnología' WHERE id_categoria = 1;
UPDATE Pedido SET total = 139.990 WHERE id_pedido = 1;
UPDATE Dirección SET ciudad = 'Barranquilla' WHERE id_direccion = 2;

-- ========================
-- DELETE
-- ========================

DELETE FROM Envío WHERE id_envio = 3;
DELETE FROM Pedido_Producto WHERE id_pedido = 3 AND id_producto = 3;
DELETE FROM Producto_Categoría WHERE id_producto = 2 AND id_categoria = 2;
DELETE FROM Dirección WHERE id_direccion = 3;
DELETE FROM Pedido WHERE id_pedido = 3;

-- ========================
-- ALTER COLUMN
-- ========================

ALTER TABLE Cliente ALTER COLUMN nombre VARCHAR(150);
ALTER TABLE Producto ALTER COLUMN stock BIGINT;
ALTER TABLE Dirección ALTER COLUMN direccion VARCHAR(200);
ALTER TABLE Categoría ALTER COLUMN nombre VARCHAR(150);
ALTER TABLE Pedido ALTER COLUMN total DECIMAL(12,2);

-- ========================
-- ALTER ADD
-- ========================

ALTER TABLE Cliente ADD correo VARCHAR(100);
ALTER TABLE Producto ADD descripcion TEXT;
ALTER TABLE Envío ADD costo DECIMAL(10,2);
ALTER TABLE Pedido ADD estado VARCHAR(50);
ALTER TABLE Categoría ADD descripcion TEXT;

-- ========================
-- DROP COLUMN
-- ========================

ALTER TABLE Cliente DROP COLUMN correo;
ALTER TABLE Producto DROP COLUMN descripcion;
ALTER TABLE Envío DROP COLUMN costo;
ALTER TABLE Pedido DROP COLUMN estado;
ALTER TABLE Categoría DROP COLUMN descripcion;



-- ========================
-- FUNCIONES DE CADENA
-- ========================

SELECT UPPER(nombre) FROM Cliente;
SELECT LOWER(ciudad) FROM Dirección;
SELECT LEN(nombre) FROM Producto;
SELECT nombre + ' - $' + CAST(precio AS VARCHAR) FROM Producto;
SELECT SUBSTRING(nombre, 1, 5) FROM Cliente;
SELECT REPLACE(ciudad, 'a', 'A') FROM Dirección;
SELECT LTRIM(RTRIM(ciudad)) FROM Dirección;
SELECT LEFT(nombre, 3) FROM Categoría;
SELECT RIGHT(nombre, 4) FROM Producto;
SELECT LEN(nombre) FROM Categoría;

-- ========================
-- SELECT ANIDADOS
-- ========================

SELECT nombre FROM Cliente WHERE id_cliente IN (
    SELECT id_cliente FROM Pedido WHERE total > 100
);

SELECT nombre FROM Producto WHERE id_producto IN (
    SELECT id_producto FROM Pedido_Producto WHERE cantidad > 1
);

SELECT nombre FROM Categoría WHERE id_categoria IN (
    SELECT id_categoria FROM Producto_Categoría WHERE id_producto = 1
);

SELECT direccion FROM Dirección WHERE id_cliente = (
    SELECT id_cliente FROM Cliente WHERE nombre = 'María Gómez'
);

SELECT fecha FROM Pedido WHERE id_cliente = (
    SELECT id_cliente FROM Cliente WHERE nombre = 'Carlos Rodríguez'
);

-- ========================
-- JOINS
-- ========================

SELECT c.nombre, d.direccion
FROM Cliente c
INNER JOIN Dirección d ON c.id_cliente = d.id_cliente;

SELECT p.id_pedido, c.nombre
FROM Pedido p
INNER JOIN Cliente c ON p.id_cliente = c.id_cliente;

SELECT pr.nombre, ca.nombre AS categoria
FROM Producto pr
INNER JOIN Producto_Categoría pc ON pr.id_producto = pc.id_producto
INNER JOIN Categoría ca ON pc.id_categoria = ca.id_categoria;

SELECT pe.id_pedido, pr.nombre, pp.cantidad
FROM Pedido pe
INNER JOIN Pedido_Producto pp ON pe.id_pedido = pp.id_pedido
INNER JOIN Producto pr ON pp.id_producto = pr.id_producto;

SELECT e.empresaEnvio, c.nombre
FROM Envío e
INNER JOIN Pedido p ON e.id_pedido = p.id_pedido
INNER JOIN Cliente c ON p.id_cliente = c.id_cliente;

-- ========================
-- PROCEDIMIENTOS ALMACENADOS
-- ========================

CREATE PROCEDURE InsertarCliente
    @nombre_cli VARCHAR(100)
AS
BEGIN
    INSERT INTO Cliente(nombre) VALUES (@nombre_cli);
END
GO

CREATE PROCEDURE ObtenerTotalPedido
    @id INT,
    @totalPedido DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @totalPedido = total FROM Pedido WHERE id_pedido = @id;
END
GO

CREATE PROCEDURE ActualizarStock
    @prod_id INT,
    @nuevo_stock INT
AS
BEGIN
    UPDATE Producto SET stock = @nuevo_stock WHERE id_producto = @prod_id;
END
GO

CREATE PROCEDURE EliminarDirecciones
    @id_cli INT
AS
BEGIN
    DELETE FROM Dirección WHERE id_cliente = @id_cli;
END
GO

CREATE PROCEDURE ProductosPorCategoria
    @id_cat INT
AS
BEGIN
    SELECT pr.nombre
    FROM Producto pr
    INNER JOIN Producto_Categoría pc ON pr.id_producto = pc.id_producto
    WHERE pc.id_categoria = @id_cat;
END
GO

-- ========================
-- TRUNCATE
-- ========================

TRUNCATE TABLE Envío;
TRUNCATE TABLE Pedido_Producto;
TRUNCATE TABLE Producto_Categoría;
TRUNCATE TABLE Dirección;
TRUNCATE TABLE Pedido;