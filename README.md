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