CREATE DATABASE Biblioteca;
USE Biblioteca

-- 1. CREACION DE TABLAS

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Editorial (
    id_editorial INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Categoria (
    id_categoria INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Libro (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100),
    id_editorial INT,
    id_categoria INT,
    FOREIGN KEY (id_editorial) REFERENCES Editorial(id_editorial),
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

CREATE TABLE Autor (
    id_autor INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Libro_Autor (
    id_libro INT,
    id_autor INT,
    PRIMARY KEY (id_libro, id_autor),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro),
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor)
);

CREATE TABLE Reserva (
    id_reserva INT PRIMARY KEY,
    id_usuario INT,
    fecha DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Reserva_Libro (
    id_reserva INT,
    id_libro INT,
    PRIMARY KEY (id_reserva, id_libro),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva),
    FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

-- 2. INSERCIONES

INSERT INTO Usuario VALUES 
(1, 'Maria Lopez'),
(2, 'Juan Perez'),
(3, 'Ana Torres');

INSERT INTO Editorial VALUES 
(1, 'Planeta'),
(2, 'Santillana'),
(3, 'Alfaguara');

INSERT INTO Categoria VALUES 
(1, 'Novela'),
(2, 'Ciencia'),
(3, 'Historia');

INSERT INTO Libro VALUES 
(1, 'Cien años de soledad', 1, 1),
(2, 'El origen de las especies', 2, 2),
(3, 'La Segunda Guerra Mundial', 3, 3);

INSERT INTO Autor VALUES 
(1, 'Gabriel Garcia Marquez'),
(2, 'Charles Darwin'),
(3, 'Winston Churchill');

INSERT INTO Libro_Autor VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Reserva VALUES 
(1, 1, '2025-06-01'),
(2, 2, '2025-06-05'),
(3, 3, '2025-06-10');

INSERT INTO Reserva_Libro VALUES 
(1, 1),
(2, 2),
(3, 3);

-- 3. SENTENCIAS UPDATE

UPDATE Usuario SET nombre = 'Maria' WHERE id_usuario = 1;
UPDATE Editorial SET nombre = 'Grupo Planeta' WHERE id_editorial = 1;
UPDATE Categoria SET nombre = 'Ciencia Ficcion' WHERE id_categoria = 1;
UPDATE Libro SET titulo = 'Cien años de soledad ' WHERE id_libro = 1;
UPDATE Autor SET nombre = 'Gabriel Marquez' WHERE id_autor = 1;

-- 4. SENTENCIAS DELETE

DELETE FROM Libro_Autor WHERE id_libro = 1 AND id_autor = 1;
DELETE FROM Reserva_Libro WHERE id_reserva = 1 AND id_libro = 1;
DELETE FROM Reserva WHERE id_reserva = 1;
DELETE FROM Usuario WHERE id_usuario = 3;
DELETE FROM Autor WHERE id_autor = 3;

-- 5. ALTER TABLE ... ADD

ALTER TABLE Usuario ADD correo VARCHAR(100);
ALTER TABLE Editorial ADD pais VARCHAR(100);
ALTER TABLE Categoria ADD descripcion VARCHAR(252);
ALTER TABLE Libro ADD anio_publicaTion INT;
ALTER TABLE Autor ADD nacionalidad VARCHAR(100);

-- 6. ALTER TABLE ... DROP COLUMN

ALTER TABLE Usuario DROP COLUMN correo ;
ALTER TABLE Editorial DROP COLUMN pais ;
ALTER TABLE Categoria DROP COLUMN descripcion ;
ALTER TABLE Libro DROP COLUMN anio_publicaTion;
ALTER TABLE Autor DROP COLUMN nacionalidad;

-- 7. FUNCIONES DE CADENA

SELECT UPPER(nombre) AS mayusculas FROM Editorial;
SELECT LOWER(nombre) AS minusculas FROM Editorial;
SELECT LEN(nombre) AS longitud FROM Usuario;
SELECT LEFT(nombre, 5) AS primeros5 FROM Autor;
SELECT RIGHT(nombre, 4) AS ultimos4 FROM Autor;
SELECT LTRIM(RTRIM(nombre)) AS sin_espacios FROM Autor;
SELECT nombre + ' - autor' AS etiqueta FROM Autor;
SELECT REPLACE(nombre, 'Maria', 'M.') FROM Usuario;
SELECT CHARINDEX('de', titulo) AS posicion FROM Libro;
SELECT CONCAT(nombre, ' (Editorial)') FROM Editorial;

-- 8. SUBCONSULTAS (SELECT ANIDADOS)

SELECT nombre FROM Usuario
WHERE id_usuario IN (SELECT id_usuario FROM Reserva);

SELECT titulo FROM Libro
WHERE id_libro IN (SELECT id_libro FROM Reserva_Libro);

SELECT nombre FROM Autor
WHERE id_autor IN (SELECT id_autor FROM Libro_Autor);

SELECT nombre FROM Editorial
WHERE id_editorial IN (SELECT id_editorial FROM Libro);

SELECT nombre FROM Categoria WHERE id_categoria IN (
  SELECT id_categoria FROM Libro
);

--9. JOINS

SELECT L.titulo, E.nombre AS editorial
FROM Libro L
JOIN Editorial E ON L.id_editorial = E.id_editorial;

SELECT L.titulo, C.nombre AS categoria
FROM Libro L
JOIN Categoria C ON L.id_categoria = C.id_categoria;

SELECT L.titulo, A.nombre AS autor
FROM Libro L
JOIN Libro_Autor LA ON L.id_libro = LA.id_libro
JOIN Autor A ON LA.id_autor = A.id_autor;

SELECT R.id_reserva, U.nombre AS usuario
FROM Reserva R
JOIN Usuario U ON R.id_usuario = U.id_usuario;

SELECT U.nombre AS usuario, L.titulo
FROM Usuario U
JOIN Reserva R ON U.id_usuario = R.id_usuario
JOIN Reserva_Libro RL ON R.id_reserva = RL.id_reserva
JOIN Libro L ON RL.id_libro = L.id_libro;

-- 10. PROCEDIMIENTOS ALMACENADOS

-- 1. Agregar nuevo usuario
CREATE PROCEDURE AgregarUsuario
    @Nombre NVARCHAR(100)
AS
BEGIN
    INSERT INTO Usuario (nombre) VALUES (@Nombre);
END;

-- 2. Contar reservas por usuario
CREATE PROCEDURE ContarReservas
    @idUsuario INT
AS
BEGIN
    SELECT COUNT(*) AS total_reservas FROM Reserva WHERE id_usuario = @idUsuario;
END;

-- 3. Libros por categor�a
CREATE PROCEDURE LibrosPorCategoria
    @idCategoria INT
AS
BEGIN
    SELECT titulo FROM Libro WHERE id_categoria = @idCategoria;
END;

-- 4. Mostrar autores de un libro
CREATE PROCEDURE AutoresPorLibro
    @idLibro INT
AS
BEGIN
    SELECT A.nombre FROM Libro_Autor LA
    JOIN Autor A ON A.id_autor = LA.id_autor
    WHERE LA.id_libro = @idLibro;
END;

-- 5. Crear una nueva reserva
CREATE PROCEDURE CrearReserva
    @idUsuario INT,
    @fecha DATE
AS
BEGIN
    INSERT INTO Reserva (id_usuario, fecha)
    VALUES (@idUsuario, @fecha);
END;

-- 11. TRUNCATE

TRUNCATE TABLE Reserva_Libro;
TRUNCATE TABLE Reserva;
TRUNCATE TABLE Libro_Autor;
TRUNCATE TABLE Libro;
TRUNCATE TABLE Usuario;