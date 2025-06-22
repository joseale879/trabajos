CREATE DATABASE GestionEstudiantil;
 USE GestionEstudiantil

CREATE TABLE Estudiante (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Profesor (
    id_profesor INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100)
);

CREATE TABLE Aula (
    id_aula INT PRIMARY KEY,
    numero VARCHAR(10)
);

CREATE TABLE Horario (
    id_horario INT PRIMARY KEY,
    diaSemana VARCHAR(20),
    horaInicio TIME,
    horaFin TIME
);

CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_aula INT UNIQUE,
    id_horario INT UNIQUE,
    FOREIGN KEY (id_aula) REFERENCES Aula(id_aula),
    FOREIGN KEY (id_horario) REFERENCES Horario(id_horario)
);

CREATE TABLE Asignatura (
    id_asignatura INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_curso INT,
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);

CREATE TABLE Curso_Estudiante (
    id_curso INT,
    id_estudiante INT,
    PRIMARY KEY (id_curso, id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante)
);

CREATE TABLE Curso_Profesor (
    id_curso INT,
    id_profesor INT,
    PRIMARY KEY (id_curso, id_profesor),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso),
    FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);


--         INSERT


-- Estudiante
INSERT INTO Estudiante VALUES (1, 'Juan Pérez');
INSERT INTO Estudiante VALUES (2, 'Laura Gómez');
INSERT INTO Estudiante VALUES (3, 'Carlos Ramírez');

-- Profesor
INSERT INTO Profesor VALUES (1, 'María Torres', 'Matemáticas');
INSERT INTO Profesor VALUES (2, 'Luis Fernández', 'Historia');
INSERT INTO Profesor VALUES (3, 'Ana Martínez', 'Física');

-- Aula
INSERT INTO Aula VALUES (1, 'A101');
INSERT INTO Aula VALUES (2, 'B202');
INSERT INTO Aula VALUES (3, 'C303');

-- Horario
INSERT INTO Horario VALUES (1, 'Lunes', '08:00:00', '10:00:00');
INSERT INTO Horario VALUES (2, 'Martes', '10:00:00', '12:00:00');
INSERT INTO Horario VALUES (3, 'Miércoles', '14:00:00', '16:00:00');

-- Cursos
INSERT INTO Cursos VALUES (1, 'Curso de Álgebra', 1, 1);
INSERT INTO Cursos VALUES (2, 'Curso de Historia Universal', 2, 2);
INSERT INTO Cursos VALUES (3, 'Curso de Física Básica', 3, 3);

-- Asignatura
INSERT INTO Asignatura VALUES (1, 'Álgebra Lineal', 1);
INSERT INTO Asignatura VALUES (2, 'Historia Moderna', 2);
INSERT INTO Asignatura VALUES (3, 'Mecánica Clásica', 3);

-- Curso_Estudiante
INSERT INTO Curso_Estudiante VALUES (1, 1);
INSERT INTO Curso_Estudiante VALUES (1, 2);
INSERT INTO Curso_Estudiante VALUES (2, 2);
INSERT INTO Curso_Estudiante VALUES (3, 3);

-- Curso_Profesor
INSERT INTO Curso_Profesor VALUES (1, 1);
INSERT INTO Curso_Profesor VALUES (2, 2);
INSERT INTO Curso_Profesor VALUES (3, 3);


--        UPDATE


UPDATE Estudiante SET nombre = 'Juan Carlos Pérez' WHERE id_estudiante = 1;
UPDATE Profesor SET especialidad = 'Geografía' WHERE id_profesor = 2;
UPDATE Aula SET numero = 'A102' WHERE id_aula = 1;
UPDATE Horario SET diaSemana = 'Jueves' WHERE id_horario = 3;
UPDATE Cursos SET nombre = 'Curso de Física Avanzada' WHERE id_curso = 3;

--        DELETE


DELETE FROM Curso_Estudiante WHERE id_curso = 1 AND id_estudiante = 2;
DELETE FROM Curso_Profesor WHERE id_curso = 2 AND id_profesor = 2;
DELETE FROM Asignatura WHERE id_asignatura = 3;
DELETE FROM Aula WHERE id_aula = 3;
DELETE FROM Horario WHERE id_horario = 2;


--      ALTER COLUMN


ALTER TABLE Estudiante ALTER COLUMN nombre VARCHAR(150);
ALTER TABLE Profesor ALTER COLUMN especialidad VARCHAR(150);
ALTER TABLE Aula ALTER COLUMN numero VARCHAR(20);
ALTER TABLE Horario ALTER COLUMN diaSemana VARCHAR(50);
ALTER TABLE Cursos ALTER COLUMN nombre VARCHAR(150);


--       ALTER ADD


ALTER TABLE Estudiante ADD correo VARCHAR(100);
ALTER TABLE Profesor ADD telefono VARCHAR(20);
ALTER TABLE Aula ADD capacidad INT;
ALTER TABLE Horario ADD tipo VARCHAR(20);
ALTER TABLE Cursos ADD descripcion TEXT;


--     ALTER DROP COLUMN


ALTER TABLE Estudiante DROP COLUMN correo;
ALTER TABLE Profesor DROP COLUMN telefono;
ALTER TABLE Aula DROP COLUMN capacidad;
ALTER TABLE Horario DROP COLUMN tipo;
ALTER TABLE Cursos DROP COLUMN descripcion;



--   FUNCIONES DE CADENA
SELECT CONCAT(nombre, ' - ', especialidad) AS Info FROM Profesor;
SELECT nombre, LEN(nombre) AS longitud FROM Estudiante;
SELECT UPPER(nombre) FROM Cursos;
SELECT LOWER(nombre) FROM Profesor;
SELECT SUBSTRING(nombre, 1, 5) AS abreviado FROM Cursos;
SELECT REPLACE(nombre, 'Curso', 'Clase') FROM Cursos;
SELECT LEFT(nombre, 1) AS inicial FROM Estudiante;
SELECT numero + numero AS doble_numero FROM Aula;
SELECT LTRIM(RTRIM(nombre)) AS limpio FROM Profesor;
SELECT nombre, IIF(nombre = 'Juan Pérez', 1, 0) AS es_juan FROM Estudiante;


--    SELECT ANIDADOS


SELECT nombre FROM Estudiante WHERE id_estudiante IN (
  SELECT id_estudiante FROM Curso_Estudiante WHERE id_curso = 1
);

SELECT nombre FROM Profesor WHERE id_profesor IN (
  SELECT id_profesor FROM Curso_Profesor WHERE id_curso IN (
    SELECT id_curso FROM Cursos WHERE id_aula = 2
  )
);

SELECT nombre FROM Cursos WHERE id_horario IN (
  SELECT id_horario FROM Horario WHERE horaInicio = '08:00:00'
);

SELECT nombre FROM Cursos WHERE id_curso IN (
  SELECT id_curso FROM Curso_Estudiante WHERE id_estudiante IN (
    SELECT id_estudiante FROM Estudiante WHERE nombre = 'Laura Gómez'
  )
);

SELECT numero FROM Aula WHERE id_aula = (
  SELECT id_aula FROM Cursos WHERE nombre = 'Curso de Álgebra'
);


--         JOINS


SELECT E.nombre AS estudiante, C.nombre AS curso
FROM Estudiante E
JOIN Curso_Estudiante CE ON E.id_estudiante = CE.id_estudiante
JOIN Cursos C ON CE.id_curso = C.id_curso;

SELECT P.nombre AS profesor, C.nombre AS curso
FROM Profesor P
JOIN Curso_Profesor CP ON P.id_profesor = CP.id_profesor
JOIN Cursos C ON CP.id_curso = C.id_curso;

SELECT C.nombre AS curso, A.numero AS aula
FROM Cursos C
JOIN Aula A ON C.id_aula = A.id_aula;

SELECT C.nombre AS curso, H.diaSemana, H.horaInicio, H.horaFin
FROM Cursos C
JOIN Horario H ON C.id_horario = H.id_horario;

SELECT A.nombre AS asignatura, C.nombre AS curso
FROM Asignatura A
JOIN Cursos C ON A.id_curso = C.id_curso;

--procedimientos

CREATE PROCEDURE InsertarEstudiante
    @pid INT,
    @pnombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Estudiante(id_estudiante, nombre) VALUES (@pid, @pnombre);
END;
GO

CREATE PROCEDURE ActualizarEspecialidadProfesor
    @pid INT,
    @nueva_especialidad VARCHAR(100)
AS
BEGIN
    UPDATE Profesor SET especialidad = @nueva_especialidad WHERE id_profesor = @pid;
END;
GO

CREATE PROCEDURE EliminarAsignatura
    @pid INT
AS
BEGIN
    DELETE FROM Asignatura WHERE id_asignatura = @pid;
END;
GO

CREATE PROCEDURE ListarCursosPorEstudiante
    @pid_estudiante INT
AS
BEGIN
    SELECT C.nombre AS curso
    FROM Cursos C
    JOIN Curso_Estudiante CE ON C.id_curso = CE.id_curso
    WHERE CE.id_estudiante = @pid_estudiante;
END;
GO

CREATE PROCEDURE AsignarProfesorACurso
    @pid_profesor INT,
    @pid_curso INT
AS
BEGIN
    INSERT INTO Curso_Profesor(id_curso, id_profesor)
    VALUES (@pid_curso, @pid_profesor);
END;
GO


--        TRUNCATE


TRUNCATE TABLE Curso_Estudiante;
TRUNCATE TABLE Curso_Profesor;
TRUNCATE TABLE Asignatura;
TRUNCATE TABLE Horario;
TRUNCATE TABLE Aula;

