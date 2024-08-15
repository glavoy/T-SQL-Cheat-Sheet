# T-SQL Cheat Sheet

## Sample Dataset Creation

```sql
-- Create the Participants table
CREATE TABLE Participants (
    ParticipantID INT PRIMARY KEY IDENTITY(1,1),
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    BirthDate DATE,
    JoinDate DATE
);

-- Create the Events table
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    EventName NVARCHAR(100),
    EventDate DATE,
    Capacity INT
);

-- Create the Registrations table (junction table for many-to-many relationship)
CREATE TABLE Registrations (
    RegistrationID INT PRIMARY KEY IDENTITY(1,1),
    ParticipantID INT,
    EventID INT,
    RegistrationDate DATE,
    FOREIGN KEY (ParticipantID) REFERENCES Participants(ParticipantID),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- Insert sample data into Participants table
INSERT INTO Participants (FirstName, LastName, Email, BirthDate, JoinDate)
VALUES 
    ('John', 'Doe', 'john.doe@email.com', '1990-05-15', '2023-01-01'),
    ('Jane', 'Smith', 'jane.smith@email.com', '1988-09-22', '2023-02-15'),
    ('Mike', 'Johnson', 'mike.johnson@email.com', '1995-03-10', '2023-03-20'),
    ('Emily', 'Brown', 'emily.brown@email.com', '1992-11-30', '2023-04-05');

-- Insert sample data into Events table
INSERT INTO Events (EventName, EventDate, Capacity)
VALUES
    ('Summer Workshop', '2023-07-15', 50),
    ('Fall Conference', '2023-09-20', 100),
    ('Winter Seminar', '2023-12-05', 30),
    ('Spring Meetup', '2024-03-10', 75);

-- Insert sample data into Registrations table
INSERT INTO Registrations (ParticipantID, EventID, RegistrationDate)
VALUES
    (1, 1, '2023-06-01'),
    (1, 2, '2023-08-15'),
    (2, 2, '2023-08-20'),
    (3, 3, '2023-11-10'),
    (4, 4, '2024-02-01');
```

## Basic T-SQL Commands
### SELECT Statement

```sql
-- Basic SELECT statement
SELECT * FROM Participants;

-- SELECT specific columns
SELECT FirstName, LastName, Email FROM Participants;

-- SELECT with WHERE clause
SELECT * FROM Participants WHERE BirthDate < '1990-01-01';

-- SELECT with ORDER BY
SELECT * FROM Participants ORDER BY LastName ASC, FirstName DESC;

-- SELECT with TOP clause
SELECT TOP 2 * FROM Events ORDER BY Capacity DESC;

-- SELECT with DISTINCT
SELECT DISTINCT EventID FROM Registrations;
```

### INSERT Statement

```sql
-- Basic INSERT
INSERT INTO Participants (FirstName, LastName, Email, BirthDate, JoinDate)
VALUES ('Sarah', 'Wilson', 'sarah.wilson@email.com', '1993-07-18', '2023-05-01');

-- INSERT multiple rows
INSERT INTO Events (EventName, EventDate, Capacity)
VALUES 
    ('Tech Expo', '2024-06-15', 200),
    ('Data Science Summit', '2024-08-20', 150);
```

### UPDATE Statement

```sql
-- Basic UPDATE
UPDATE Participants
SET Email = 'john.doe.updated@email.com'
WHERE ParticipantID = 1;

-- UPDATE multiple columns
UPDATE Events
SET Capacity = Capacity + 10,
    EventName = EventName + ' (Extended)'
WHERE EventDate > '2023-12-31';
```

### DELETE Statement

```sql
-- Basic DELETE
DELETE FROM Registrations
WHERE RegistrationDate < '2023-01-01';

-- DELETE with subquery
DELETE FROM Participants
WHERE ParticipantID NOT IN (SELECT DISTINCT ParticipantID FROM Registrations);
```

## Intermediate T-SQL Commands
### JOINs

```sql
-- INNER JOIN
SELECT p.FirstName, p.LastName, e.EventName
FROM Participants p
INNER JOIN Registrations r ON p.ParticipantID = r.ParticipantID
INNER JOIN Events e ON r.EventID = e.EventID;

-- LEFT JOIN
SELECT p.FirstName, p.LastName, e.EventName
FROM Participants p
LEFT JOIN Registrations r ON p.ParticipantID = r.ParticipantID
LEFT JOIN Events e ON r.EventID = e.EventID;

-- RIGHT JOIN
SELECT p.FirstName, p.LastName, e.EventName
FROM Registrations r
RIGHT JOIN Participants p ON r.ParticipantID = p.ParticipantID
RIGHT JOIN Events e ON r.EventID = e.EventID;

-- FULL OUTER JOIN
SELECT p.FirstName, p.LastName, e.EventName
FROM Participants p
FULL OUTER JOIN Registrations r ON p.ParticipantID = r.ParticipantID
FULL OUTER JOIN Events e ON r.EventID = e.EventID;
```

### Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) AS TotalParticipants FROM Participants;

-- SUM
SELECT SUM(Capacity) AS TotalCapacity FROM Events;

-- AVG
SELECT AVG(Capacity) AS AverageCapacity FROM Events;

-- MIN and MAX
SELECT 
    MIN(BirthDate) AS OldestParticipant,
    MAX(BirthDate) AS YoungestParticipant
FROM Participants;

-- GROUP BY with aggregate functions
SELECT e.EventName, COUNT(r.RegistrationID) AS Registrations
FROM Events e
LEFT JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.EventName;

-- HAVING clause
SELECT e.EventName, COUNT(r.RegistrationID) AS Registrations
FROM Events e
LEFT JOIN Registrations r ON e.EventID = r.EventID
GROUP BY e.EventName
HAVING COUNT(r.RegistrationID) > 1;
```

### Subqueries

```sql
-- COUNT
-- Subquery in WHERE clause
SELECT * FROM Participants
WHERE ParticipantID IN (
    SELECT ParticipantID
    FROM Registrations
    WHERE EventID = 2
);

-- Subquery in SELECT
SELECT 
    EventName,
    Capacity,
    (SELECT COUNT(*) FROM Registrations WHERE EventID = e.EventID) AS Registrations
FROM Events e;

-- Correlated subquery
SELECT p.FirstName, p.LastName,
    (SELECT COUNT(*) FROM Registrations r WHERE r.ParticipantID = p.ParticipantID) AS EventCount
FROM Participants p;
```

## Advanced T-SQL Commands
### Common Table Expressions (CTE)

```sql
-- Basic CTE
WITH ParticipantEvents AS (
    SELECT p.ParticipantID, p.FirstName, p.LastName, COUNT(r.EventID) AS EventCount
    FROM Participants p
    LEFT JOIN Registrations r ON p.ParticipantID = r.ParticipantID
    GROUP BY p.ParticipantID, p.FirstName, p.LastName
)
SELECT * FROM ParticipantEvents WHERE EventCount > 1;

-- Recursive CTE
WITH NumberSequence AS (
    SELECT 1 AS Number
    UNION ALL
    SELECT Number + 1
    FROM NumberSequence
    WHERE Number < 10
)
SELECT * FROM NumberSequence;
```

### Window Functions
```sql
-- ROW_NUMBER
SELECT 
    ROW_NUMBER() OVER (ORDER BY BirthDate) AS RowNum,
    FirstName,
    LastName,
    BirthDate
FROM Participants;

-- RANK and DENSE_RANK
SELECT 
    FirstName,
    LastName,
    BirthDate,
    RANK() OVER (ORDER BY BirthDate) AS BirthDateRank,
    DENSE_RANK() OVER (ORDER BY BirthDate) AS BirthDateDenseRank
FROM Participants;

-- LEAD and LAG
SELECT 
    EventName,
    EventDate,
    Capacity,
    LAG(Capacity) OVER (ORDER BY EventDate) AS PreviousCapacity,
    LEAD(Capacity) OVER (ORDER BY EventDate) AS NextCapacity
FROM Events;
```

### Pivot and Unpivot
```sql
-- PIVOT
SELECT *
FROM (
    SELECT YEAR(EventDate) AS EventYear, EventName, Capacity
    FROM Events
) AS SourceTable
PIVOT (
    SUM(Capacity)
    FOR EventName IN ([Summer Workshop], [Fall Conference], [Winter Seminar], [Spring Meetup])
) AS PivotTable;

-- UNPIVOT
SELECT EventName, EventType, Capacity
FROM (
    SELECT 
        YEAR(EventDate) AS EventYear,
        'Workshop' AS Workshop,
        'Conference' AS Conference,
        'Seminar' AS Seminar,
        'Meetup' AS Meetup
    FROM Events
) AS SourceTable
UNPIVOT (
    Capacity FOR EventType IN (Workshop, Conference, Seminar, Meetup)
) AS UnpivotTable;
```

### MERGE Statement
```sql
-- MERGE statement for upsert operation
MERGE INTO Participants AS target
USING (VALUES
    (1, 'John', 'Doe', 'john.doe.new@email.com', '1990-05-15', '2023-01-01'),
    (5, 'Alice', 'Johnson', 'alice.johnson@email.com', '1991-08-20', '2023-06-01')
) AS source (ParticipantID, FirstName, LastName, Email, BirthDate, JoinDate)
ON target.ParticipantID = source.ParticipantID
WHEN MATCHED THEN
    UPDATE SET
        FirstName = source.FirstName,
        LastName = source.LastName,
        Email = source.Email,
        BirthDate = source.BirthDate,
        JoinDate = source.JoinDate
WHEN NOT MATCHED THEN
    INSERT (FirstName, LastName, Email, BirthDate, JoinDate)
    VALUES (source.FirstName, source.LastName, source.Email, source.BirthDate, source.JoinDate);
```

### Error Handling
```sql
-- TRY...CATCH block
BEGIN TRY
    -- Intentionally cause a divide-by-zero error
    SELECT 1/0 AS Result;
END TRY
BEGIN CATCH
    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_SEVERITY() AS ErrorSeverity,
        ERROR_STATE() AS ErrorState,
        ERROR_PROCEDURE() AS ErrorProcedure,
        ERROR_LINE() AS ErrorLine,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
```

### Dynamic SQL
```sql
-- Dynamic SQL example
DECLARE @TableName NVARCHAR(50) = 'Participants';
DECLARE @SQL NVARCHAR(MAX);

SET @SQL = N'SELECT * FROM ' + QUOTENAME(@TableName);

EXEC sp_executesql @SQL;
```