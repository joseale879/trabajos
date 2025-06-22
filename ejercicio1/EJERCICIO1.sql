CREATE DATABASE plataforma;
USE plataforma;

CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Genero (
    id_genero INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Artista (
    id_artista INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Album (
    id_album INT PRIMARY KEY,
    titulo VARCHAR(100),
    año INT
);

CREATE TABLE Cancion (
    id_cancion INT PRIMARY KEY,
    titulo VARCHAR(100),
    id_genero INT,
    id_album INT,
    FOREIGN KEY (id_genero) REFERENCES Genero(id_genero),
    FOREIGN KEY (id_album) REFERENCES Album(id_album)
);

CREATE TABLE Playlist (
    id_playlist INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_usuario INT,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

CREATE TABLE Cancion_Artista (
    id_cancion INT,
    id_artista INT,
    PRIMARY KEY (id_cancion, id_artista),
    FOREIGN KEY (id_cancion) REFERENCES Cancion(id_cancion),
    FOREIGN KEY (id_artista) REFERENCES Artista(id_artista)
);

CREATE TABLE Playlist_Cancion (
    id_playlist INT,
    id_cancion INT,
    PRIMARY KEY (id_playlist, id_cancion),
    FOREIGN KEY (id_playlist) REFERENCES Playlist(id_playlist),
    FOREIGN KEY (id_cancion) REFERENCES Cancion(id_cancion)
); 

-- Usuario
INSERT INTO Usuario (id_usuario, nombre) VALUES
(1, 'Ana Gómez'),
(2, 'Carlos Ruiz');

-- Género
INSERT INTO Genero (id_genero, nombre) VALUES
(1, 'Rock'),
(2, 'Pop');

-- Artista
INSERT INTO Artista (id_artista, nombre) VALUES
(1, 'Coldplay'),
(2, 'Shakira');

-- Álbum
INSERT INTO Album (id_album, titulo, año) VALUES
(1, 'Parachutes', 2000),
(2, 'Laundry Service', 2001);

-- Canción
INSERT INTO Cancion (id_cancion, titulo, id_genero, id_album) VALUES
(1, 'Yellow', 1, 1),          -- Rock, Parachutes
(2, 'Whenever, Wherever', 2, 2);  -- Pop, Laundry Service

-- Playlist
INSERT INTO Playlist (id_playlist, nombre, id_usuario) VALUES
(1, 'Favoritas', 1),
(2, 'Workout', 2);

-- Canción-Artista
INSERT INTO Cancion_Artista (id_cancion, id_artista) VALUES
(1, 1),   -- Yellow - Coldplay
(2, 2);   -- Whenever - Shakira

-- Playlist-Canción
INSERT INTO Playlist_Cancion (id_playlist, id_cancion) VALUES
(1, 1),   -- Favoritas - Yellow
(2, 2);   -- Workout - Whenever

-- 1. UPDATE (actualizar datos)

UPDATE Genero SET nombre = 'Rock Alternativo' WHERE id_genero = 1;
UPDATE Album SET titulo = 'A Rush of Blood to the Head' WHERE id_album = 1;
UPDATE Cancion SET titulo = 'Suerte' WHERE id_cancion = 2;
UPDATE Artista SET nombre = 'Coldplay UK' WHERE id_artista = 1;
UPDATE Playlist SET nombre = 'Relajación' WHERE id_playlist = 2;


-- 2. DELETE (eliminar datos)

DELETE FROM Cancion_Artista WHERE id_cancion = 1 AND id_artista = 1;
DELETE FROM Playlist_Cancion WHERE id_playlist = 1 AND id_cancion = 1;
DELETE FROM Artista WHERE id_artista = 2;
DELETE FROM Album WHERE id_album = 2;
DELETE FROM Usuario WHERE id_usuario = 2;


-- 3. ALTER - ADD COLUMN

ALTER TABLE Usuario ADD correo VARCHAR(100);
ALTER TABLE Album ADD descripcion TEXT;
ALTER TABLE Cancion ADD duracion INT;
ALTER TABLE Artista ADD pais VARCHAR(50);
ALTER TABLE Playlist ADD fecha_creacion DATE;


-- 4. ALTER - MODIFY COLUMN

ALTER TABLE Usuario ALTER COLUMN nombre VARCHAR(150);
ALTER TABLE Genero ALTER COLUMN nombre VARCHAR(150);
ALTER TABLE Album ALTER COLUMN titulo VARCHAR(150);
ALTER TABLE Cancion ALTER COLUMN titulo VARCHAR(150);
ALTER TABLE Artista ALTER COLUMN nombre VARCHAR(150);


-- 5. DROP COLUMN

ALTER TABLE Usuario DROP COLUMN correo;
ALTER TABLE Album DROP COLUMN descripcion;
ALTER TABLE Cancion DROP COLUMN duracion;
ALTER TABLE Artista DROP COLUMN pais;
ALTER TABLE Playlist DROP COLUMN fecha_creacion;


-- 6. FUNCIONES DE CADENA

SELECT UPPER(nombre) FROM Usuario;
SELECT LOWER(nombre) FROM Artista;
SELECT SUM(id_genero) FROM Cancion;
SELECT CONCAT(u.nombre, ' - ', p.nombre) AS Info
FROM Usuario u JOIN Playlist p ON u.id_usuario = p.id_usuario;
SELECT SUBSTRING(titulo, 1, 5) FROM Cancion;
SELECT REPLACE(nombre, 'Favoritas', 'Top') FROM Playlist;
SELECT CONCAT('ES ', titulo) AS Cancion FROM Cancion;
SELECT AVG(año) AS promedio_año FROM Album;
SELECT * FROM Cancion WHERE titulo LIKE 'S%';
SELECT TRIM(nombre) FROM Genero;


-- 7. SELECT ANIDADOS

SELECT * FROM Album WHERE id_album = (
    SELECT id_album FROM Cancion GROUP BY id_album ORDER BY COUNT(*) DESC 
);
SELECT * FROM PlayList WHERE id_usuario = (
    SELECT id_usuario FROM Usuario WHERE nombre = 'Ana Gómez'
);
SELECT * FROM Genero WHERE id_genero = (
    SELECT id_genero FROM Cancion WHERE titulo = 'Yellow'
);
SELECT * FROM Cancion WHERE id_album = (
    SELECT id_album FROM Album WHERE titulo = 'Parachutes'
);
SELECT * FROM Cancion WHERE id_cancion IN (
    SELECT id_cancion FROM Cancion_Artista WHERE id_artista = (
        SELECT id_artista FROM Artista WHERE nombre = 'Coldplay'
    )
);

-- 8. JOINS

SELECT c.titulo, g.nombre AS genero
FROM Cancion c
JOIN Genero g ON c.id_genero = g.id_genero;

SELECT c.titulo, a.titulo AS album
FROM Cancion c
JOIN Album a ON c.id_album = a.id_album;

SELECT p.nombre AS playlist, c.titulo AS cancion
FROM Playlist p
JOIN Playlist_Cancion pc ON p.id_playlist = pc.id_playlist
JOIN Cancion c ON pc.id_cancion = c.id_cancion;

SELECT c.titulo AS cancion, a.nombre AS artista
FROM Cancion c
JOIN Cancion_Artista ca ON c.id_cancion = ca.id_cancion
JOIN Artista a ON ca.id_artista = a.id_artista;

SELECT u.nombre AS usuario, p.nombre AS playlist
FROM Usuario u
JOIN Playlist p ON u.id_usuario = p.id_usuario;

--9. PROCEDIMIENTOS


-- 1. Mostrar todas las canciones
CREATE PROCEDURE MostrarCanciones 
AS 
BEGIN
    SELECT * FROM Cancion;
END;
GO

-- 2. Mostrar playlists de un usuario (por ID)
CREATE PROCEDURE PlaylistsPorUsuario
    @id INT
AS
BEGIN
    SELECT * FROM Playlist WHERE id_usuario = @id;
END;
GO

-- 3. Insertar nuevo género
CREATE PROCEDURE InsertarGenero
    @id INT,
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Genero (id_genero, nombre) VALUES (@id, @nombre);
END;
GO

-- 4. Cambiar nombre de un artista
CREATE PROCEDURE CambiarNombreArtista
    @id INT,
    @nuevo_nombre VARCHAR(100)
AS
BEGIN
    UPDATE Artista SET nombre = @nuevo_nombre WHERE id_artista = @id;
END;
GO

-- 5. Eliminar una canción por ID
CREATE PROCEDURE EliminarCancion
    @id INT
AS
BEGIN
    DELETE FROM Cancion WHERE id_cancion = @id;
END;
GO

-- 6. TRUNCATE TABLE (vaciar)

TRUNCATE TABLE Playlist_Cancion;
TRUNCATE TABLE Cancion_Artista;
TRUNCATE TABLE Playlist;
TRUNCATE TABLE Cancion;
TRUNCATE TABLE Artista;