DROP DATABASE IF EXISTSmy_db;
CREATE DATABASE IF NOT EXISTS my_db;
USE my_db;

CREATE TABLE Person (
    Id INT NOT NULL AUTO_INCREMENT,
    Username NVARCHAR(30),
    Password NVARCHAR(30),
    Email NVARCHAR(30),

    CONSTRAINT PK_Person_Id PRIMARY KEY (Id) 
);

CREATE TABLE Person_extended
(
    Id INT NOT NULL AUTO_INCREMENT,
    PersonId INT,
    Age INT,
    Email NVARCHAR(30),
    Name NVARCHAR(30),
    Surname NVARCHAR(30),
    

    CONSTRAINT PK_Person_extended_Id PRIMARY KEY (Id),
    CONSTRAINT FK_Person_extended_To_Person FOREIGN KEY (PersonId) REFERENCES Person(Id)
 
);

INSERT INTO Person 
VALUES
(1, 'Maelstrom', '12345', "username_1@gmail.com"),
(2, 'Trancey', '12345', "username_2@gmail.com"),
(3, 'Attuition', '12345', "username_3@gmail.com"),
(4, 'Tubthumper', '12345', "username_4@gmail.com"),
(5, 'Rickrack', '12345', "username_5@gmail.com"),
(6, 'Verglas', '12345', "username_6@gmail.com"),
(7, 'Foreshots', '12345', "username_7@gmail.com");

INSERT INTO Person_extended (PersonId, Age, Email, Name, Surname) 
VALUES
(
    1,
    18,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Екатерина',
    'Воробьева'
),
(
    2,
    32,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Сафия',
    'Князева'
),
(
    3,
    19,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Максим',
    'Александров'
),
(
    4,
    43,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Даниил',
    'Медведев'
),
(
    5,
    33,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Вячеслав',
    'Лебедев'
),
(
    6,
    20,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Антон',
    'Пахомов'
),
(
    7,
    23,
    (SELECT Email FROM Person WHERE Id=PersonId),
    'Алиса',
    'Романова'
);

DELIMITER //
CREATE PROCEDURE Task1()
BEGIN
    SELECT * FROM Person ORDER BY Username;
END//

CREATE PROCEDURE Task2()
BEGIN
    SELECT Person.Username, Person_extended.Age FROM Person
    JOIN Person_extended on Person.Id=Person_extended.PersonId
    ORDER BY Person_extended.Age;
END//

CREATE PROCEDURE Task3()
BEGIN
    SELECT * FROM Person
    JOIN Person_extended on Person.Id=Person_extended.PersonId;
END//
DELIMITER ;