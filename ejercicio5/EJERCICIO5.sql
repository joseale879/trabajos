CREATE DATABASE Universidad;
USE Universidad


-- 1. CREACI�N DE TABLAS


CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Profesor (
    id_profesores INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE Curso (
    id_curso INT PRIMARY KEY,
    titulo VARCHAR(100),
    descripcion TEXT
);

CREATE TABLE Curso_Estudiante (
    id_curso INT,
    id_estudiante INT,
    PRIMARY KEY (id_curso, id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante)
);

CREATE TABLE Curso_Profesor (
    id_curso INT,
    id_profesor INT,
    PRIMARY KEY (id_curso, id_profesor),
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
    FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesores)
);

CREATE TABLE Leccion (
    id_leccion INT PRIMARY KEY,
    titulo VARCHAR(100),
    contenido TEXT,
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

CREATE TABLE Archivo (
    id_archivo INT PRIMARY KEY,
    nombre VARCHAR(100),
    url TEXT,
    id_leccion INT,
    FOREIGN KEY (id_leccion) REFERENCES Leccion(id_leccion)
);

CREATE TABLE Examen (
    id_examen INT PRIMARY KEY,
    titulo VARCHAR(100),
    fecha DATE,
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);


-- 2. INSERCI�N DE DATOS (INSERT)


INSERT INTO Estudiante (id_estudiante, nombre) VALUES
(1, 'Laura Mart�nez'),
(2, 'Carlos G�mez'),
(3, 'Ana Torres');

INSERT INTO Profesor (id_profesores, nombre, especialidad) VALUES
(1, 'Marta Ruiz', 'Matem�ticas'),
(2, 'Luis P�rez', 'Historia'),
(3, 'Julia S�nchez', 'F�sica');

INSERT INTO Curso (id_curso, titulo, descripcion) VALUES
(1, '�lgebra I', 'Curso b�sico de �lgebra para principiantes'),
(2, 'Historia Moderna', 'Estudio de los eventos hist�ricos desde el siglo XVIII'),
(3, 'F�sica General', 'Introducci�n a conceptos fundamentales de la f�sica');

INSERT INTO Curso_Estudiante (id_curso, id_estudiante) VALUES
(1, 1), (2, 1), (2, 2), (3, 2), (3, 3);

INSERT INTO Curso_Profesor (id_curso, id_profesor) VALUES
(1, 1), (2, 2), (3, 3);

INSERT INTO Leccion (id_leccion, titulo, contenido, id_curso) VALUES
(1, 'Introducci�n al �lgebra', 'Contenido sobre variables y ecuaciones', 1),
(2, 'La Revoluci�n Francesa', 'Contenido sobre eventos de 1789', 2),
(3, 'Leyes del Movimiento', 'Contenido sobre Newton y din�mica', 3);

INSERT INTO Archivo (id_archivo, nombre, url, id_leccion) VALUES
(1, 'ejercicios_algebra.pdf', 'http://servidor.com/algebra.pdf', 1),
(2, 'revolucion_francesa.mp4', 'http://servidor.com/rev_francesa.mp4', 2),
(3, 'leyes_movimiento.docx', 'http://servidor.com/leyes_newton.docx', 3);

INSERT INTO Examen (id_examen, titulo, fecha, id_curso) VALUES
(1, 'Examen �lgebra Unidad 1', '2025-07-10', 1),
(2, 'Examen Historia Moderna', '2025-07-15', 2),
(3, 'Examen F�sica Cl�sica', '2025-07-20', 3);


-- 3. UPDATE


UPDATE Estudiante SET nombre = 'Laura M. Mart�nez' WHERE id_estudiante = 1;

UPDATE Profesor SET especialidad = 'Matem�tica Aplicada' WHERE id_profesores = 1;

UPDATE Curso SET titulo = '�lgebra B�sica' WHERE id_curso = 1;

UPDATE Leccion SET contenido = 'Contenido actualizado sobre ecuaciones b�sicas' WHERE id_leccion = 1;

UPDATE Archivo SET nombre = 'algebra_ejercicios.pdf' WHERE id_archivo = 1;


-- 4. DELETE


DELETE FROM Curso_Estudiante WHERE id_estudiante = 3 AND id_curso = 3;
DELETE FROM Curso_Profesor WHERE id_curso = 3 AND id_profesor = 3;
DELETE FROM Archivo WHERE id_archivo = 3;
DELETE FROM Leccion WHERE id_leccion = 3;
DELETE FROM Examen WHERE id_examen = 3;


-- 5. ALTER + ADD


ALTER TABLE Estudiante ADD correo VARCHAR(100);
ALTER TABLE Profesor ADD telefono VARCHAR(20);
ALTER TABLE Curso ADD duracion INT;
ALTER TABLE Leccion ADD fecha_publicacion DATE;
ALTER TABLE Examen ADD puntaje_maximo INT;


-- 6. DROP COLUMN / TABLE


ALTER TABLE Curso DROP COLUMN duracion;
ALTER TABLE Leccion DROP COLUMN fecha_publicacion;
ALTER TABLE Examen DROP COLUMN puntaje_maximo;


-- 7. TRUNCATE


TRUNCATE TABLE Archivo;
TRUNCATE TABLE Examen;
TRUNCATE TABLE Leccion;

-- 8. FUNCIONES DE CADENA


SELECT nombre, LEN(nombre) AS longitud FROM Estudiante;
SELECT UPPER(nombre) AS nombre_mayusculas FROM Profesor;
SELECT LOWER(titulo) AS titulo_minuscula FROM Curso;
SELECT nombre + ' - ' + especialidad AS descripcion FROM Profesor;
SELECT SUBSTRING(titulo, 1, 5) AS abreviatura FROM Curso;
SELECT REPLACE(nombre, 'Laura', 'L.') AS nombre_modificado FROM Estudiante;
SELECT LEFT(titulo, 7) AS inicio_titulo FROM Leccion;
SELECT RIGHT(nombre, 4) AS final_nombre FROM Estudiante;
SELECT LTRIM(RTRIM('   F�sica   ')) AS sin_espacios;
SELECT CHARINDEX('ci�n', descripcion) AS posicion_subcadena FROM Curso;


-- 9. SELECTS ANIDADOS


SELECT nombre FROM Estudiante WHERE id_estudiante = 
(SELECT MAX(id_estudiante) FROM Estudiante);

SELECT titulo FROM Curso WHERE id_curso = 
(SELECT TOP 1 id_curso FROM Examen GROUP BY id_curso ORDER BY COUNT(*) DESC);

SELECT nombre FROM Profesor WHERE id_profesores = 
(SELECT id_profesores FROM Curso_Profesores WHERE id_curso = 1);

SELECT titulo FROM Curso WHERE id_curso =
(SELECT id_curso FROM Leccion WHERE id_leccion = 1);

SELECT nombre FROM Estudiante WHERE id_estudiante IN 
(SELECT id_estudiante FROM Curso_Estudiante WHERE id_curso = 2);

-- 10. JOINS


SELECT E.nombre, C.titulo
FROM Estudiante E
JOIN Curso_Estudiante CE ON E.id_estudiante = CE.id_estudiante
JOIN Curso C ON CE.id_curso = C.id_curso;

SELECT P.nombre, C.titulo
FROM Profesor P
JOIN Curso_Profesor CP ON P.id_profesores = CP.id_profesor
JOIN Curso C ON CP.id_curso = C.id_curso;

SELECT L.titulo, C.titulo AS curso
FROM Leccion L
JOIN Curso C ON L.id_curso = C.id_curso;

SELECT A.nombre, L.titulo AS leccion
FROM Archivo A
JOIN Leccion L ON A.id_leccion = L.id_leccion;

SELECT E.titulo AS examen, C.titulo AS curso
FROM Examen E
JOIN Curso C ON E.id_curso = C.id_curso;

-- ===============================
-- 11. PROCEDIMIENTOS ALMACENADOS
-- ===============================

-- 1. Mostrar estudiantes
CREATE PROCEDURE VerEstudiantes
AS
BEGIN
    SELECT * FROM Estudiante;
END;

-- 2. Cursos con profesores
CREATE PROCEDURE CursosConProfesores
AS
BEGIN
    SELECT C.titulo, P.nombre
    FROM Curso C
    JOIN Curso_Profesor CP ON C.id_curso = CP.id_curso
    JOIN Profesor P ON CP.id_profesor = P.id_profesores;
END;

-- 3. Agregar estudiante
CREATE PROCEDURE AgregarEstudiante
    @id INT,
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Estudiante (id_estudiante, nombre) VALUES (@id, @nombre);
END;

-- 4. Lecciones por curso
CREATE PROCEDURE VerLeccionesPorCurso
    @cursoID INT
AS
BEGIN
    SELECT titulo FROM Leccion WHERE id_curso = @cursoID;
END;

-- 5. Eliminar archivo
CREATE PROCEDURE EliminarArchivo
    @archivoID INT
AS
BEGIN
    DELETE FROM Archivo WHERE id_archivo = @archivoID;
END;