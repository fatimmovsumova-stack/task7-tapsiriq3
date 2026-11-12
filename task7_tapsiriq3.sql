USE UniversityDB;
GO

IF OBJECT_ID('Grades', 'U') IS NOT NULL DROP TABLE Grades;
IF OBJECT_ID('Courses', 'U') IS NOT NULL DROP TABLE Courses;
IF OBJECT_ID('Students', 'U') IS NOT NULL DROP TABLE Students;
IF OBJECT_ID('Faculties', 'U') IS NOT NULL DROP TABLE Faculties;
GO

CREATE TABLE Faculties (
    FacultyId INT PRIMARY KEY IDENTITY(1,1),
    FacultyName NVARCHAR(100) NOT NULL
);

CREATE TABLE Students (
    StudentId INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NULL,
    Age INT NOT NULL,
    FacultyId INT NULL,
    CONSTRAINT FK_Students_Faculties FOREIGN KEY (FacultyId) REFERENCES Faculties(FacultyId)
);

CREATE TABLE Courses (
    CourseId INT PRIMARY KEY IDENTITY(1,1),
    CourseName NVARCHAR(100) NOT NULL
);

CREATE TABLE Grades (
    GradeId INT PRIMARY KEY IDENTITY(1,1),
    StudentId INT NOT NULL,
    CourseId INT NOT NULL,
    Score INT CHECK (Score BETWEEN 0 AND 100),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentId) REFERENCES Students(StudentId) ON DELETE CASCADE,
    CONSTRAINT FK_Grades_Courses FOREIGN KEY (CourseId) REFERENCES Courses(CourseId) ON DELETE CASCADE
);

INSERT INTO Faculties (FacultyName) VALUES
(N'İnformasiya Texnologiyaları'),
(N'İqtisadiyyat və İdarəetmə'),
(N'Mühəndislik');

INSERT INTO Students (FirstName, LastName, Email, Age, FacultyId) VALUES
('Elvin', 'Mammadov', 'elvin.mammadov@bmu.edu.az', 20, 1),
('Aysel', 'Aliyeva', 'aysel.aliyeva@bmu.edu.az', 19, 2),
('Orxan', 'Hasanov', 'orxan.hasanov@bmu.edu.az', 22, 1),
('Murad', 'Musayev', 'murad.musayev@bmu.edu.az', 21, 2),
('Fərid', 'Quliyev', 'farid.guliyev@bmu.edu.az', 20, 3);

INSERT INTO Courses (CourseName) VALUES
(N'C#'),
(N'Verilənlər Bazası'),
(N'Alqoritmlər');

INSERT INTO Grades (StudentId, CourseId, Score) VALUES
(1, 1, 88),
(1, 2, 92),
(2, 1, 95),
(2, 3, 76),
(3, 1, 72),
(3, 2, 84),
(4, 2, 90),
(4, 3, 81);
GO

SELECT 
    s.FirstName AS Ad,
    s.LastName AS Soyad,
    c.CourseName AS FennAdi,
    g.Score AS Qiymet
FROM Grades g
INNER JOIN Students s ON g.StudentId = s.StudentId
INNER JOIN Courses c ON g.CourseId = c.CourseId;

SELECT 
    s.FirstName AS Ad,
    s.LastName AS Soyad,
    c.CourseName AS FennAdi,
    g.Score AS Qiymet
FROM Grades g
INNER JOIN Students s ON g.StudentId = s.StudentId
INNER JOIN Courses c ON g.CourseId = c.CourseId
WHERE c.CourseName = N'C#'
ORDER BY g.Score DESC;

SELECT 
    c.CourseId,
    c.CourseName AS FennAdi,
    CAST(AVG(g.Score * 1.0) AS DECIMAL(5,2)) AS OrtaQiymet
FROM Courses c
INNER JOIN Grades g ON c.CourseId = g.CourseId
GROUP BY c.CourseId, c.CourseName;

SELECT 
    s.StudentId,
    s.FirstName AS Ad,
    s.LastName AS Soyad,
    s.Email
FROM Students s
LEFT JOIN Grades g ON s.StudentId = g.StudentId
WHERE g.GradeId IS NULL;
GO