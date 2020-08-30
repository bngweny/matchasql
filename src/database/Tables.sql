

--CREATE LOGIN matcha
--WITH PASSWORD = '1AM!matchapwd', check_POLICY=OFF;
--GO
-- Create a new database called 'DatabaseName'
-- Connect to the 'master' database to run this snippet
USE master
GO

--DROP DATABASE MatchaDB
--GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT name
        FROM sys.databases
        WHERE name = N'MatchaDB'
)
CREATE DATABASE MatchaDB
GO

USE MatchaDB
GO

-- Create a new table called 'TableName' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('Users', 'U') IS NOT NULL
DROP TABLE Users
GO
-- Create the table in the specified schema
CREATE TABLE Users
(
    [UserId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
    [Name] [NVARCHAR](250) NOT NULL,
    [Surname] [NVARCHAR](250) NOT NULL,
    [Email] [NVARCHAR](250) NOT NULL,
    [Username] [NVARCHAR](250) NOT NULL,
    [Password] [NVARCHAR](Max) NOT NULL,
    [Gender] [NVARCHAR](250),
    [SexualPreference] [NVARCHAR](250),
    [Bio] [NVARCHAR](Max),
    [UserLocation] [NVARCHAR](250),
    [Latitude] [DECIMAL],
    [Longitude] [DECIMAL],
    [Dob] [DATETIME],
    [Lastseen] [DATETIME],
    [Tags] [NVARCHAR](Max),
    [Status] [BIT],
    [Complete] [BIT]
);
GO

-- Create a new table called 'Blocklist' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('Blocklist', 'U') IS NOT NULL
DROP TABLE Blocklist
GO
-- Create the table in the specified schema
CREATE TABLE Blocklist
(
    [BlockId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
    [UserId] [INT] NOT NULL, --FK
    [BlockedUserId] [INT] NOT NULL, --FK
    [Timestamp] [DATETIME] NOT NULL

);
GO

-- Create a new table called 'NotificationTypes' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('NotificationTypes', 'U') IS NOT NULL
DROP TABLE NotificationTypes
GO
-- Create the table in the specified schema
CREATE TABLE NotificationTypes
(
    [NotificationTypeId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
    [NotificationType] [NVARCHAR](45) NOT NULL,
);
GO



-- Create a new table called 'Notifications' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('Notifications', 'U') IS NOT NULL
DROP TABLE Notifications
GO
-- Create the table in the specified schema
CREATE TABLE Notifications
(
    [NotificationId] INT IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
    [From] [INT] NOT NULL, --FK
    [To]   [INT] NOT NULL, --FK
    [NotificationTypeId] [INT] NOT NULL, --FK
    [Timestamp] [DATETIME] NOT NULL,
    [Viewed] [BIT] NOT NULL,

    CONSTRAINT FK_Notifications_To FOREIGN KEY ([To]) REFERENCES Users(UserId),
    CONSTRAINT FK_Notifications_From FOREIGN KEY ([From]) REFERENCES Users(UserId),
    CONSTRAINT FK_Notifications_NotificationTypeId FOREIGN KEY ([NotificationTypeId]) REFERENCES NotificationTypes(NotificationTypeId),
        
);
GO


--Use notifications table to create Likes View, Connected View, Viewed View,
-- Tags 

CREATE
    VIEW [UserViews] 
AS
    SELECT
        [NotificationId],
        [From],
        [To],
        [Timestamp]
    FROM
        [Notifications]
    WHERE
        [NotificationTypeId] = (SELECT [NotificationTypeId] FROM NotificationTypes WHERE NotificationType = 'View')
GO

CREATE
    VIEW [UserConnections] 
AS
    SELECT
        [NotificationId],
        [From],
        [To],
        [Timestamp]
    FROM
        [Notifications]
    WHERE
        [NotificationTypeId] = (SELECT [NotificationTypeId] FROM NotificationTypes WHERE NotificationType = 'Connected')
GO

CREATE
    VIEW [UserLikes] 
AS
    SELECT
        [NotificationId],
        [From],
        [To],
        [Timestamp]
    FROM
        [Notifications]
    WHERE
        [NotificationTypeId] = (SELECT [NotificationTypeId] FROM NotificationTypes WHERE NotificationType = 'View')
GO


-- Create a new table called 'Blocks' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('Messages', 'U') IS NOT NULL
DROP TABLE Messages
GO
-- Create the table in the specified schema
CREATE TABLE Messages
(
    [MessageId] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
    [From] [INT] NOT NULL,--FK
    [To] [INT] NOT NULL, --FK
    [read] [BIT] NOT NULL,
    [Text] [NVARCHAR](MAX) NOT NULL,
    [Timestamp] [DATETIME] NOT NULL,

    CONSTRAINT FK_Messages_To FOREIGN KEY ([To]) REFERENCES Users(UserId),
    CONSTRAINT FK_Messages_From FOREIGN KEY ([From]) REFERENCES Users(UserId)

);
GO




-- Create a new table called 'Blocks' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('Media', 'U') IS NOT NULL
DROP TABLE Media
GO
-- Create the table in the specified schema
CREATE TABLE Media
(
    [MediaId] [INT] IDENTITY(1,1) NOT NULL PRIMARY KEY, -- primary key column
 --   [Type] [NVARCHAR](50) NOT NULL, --Not sure if i'll be needing this. Also it will need a lookup table
    [UserId] [INT] NOT NULL, --userID foreign key
    [Data] [NVARCHAR](MAX) NOT NULL,
 --   [Likes] [NVARCHAR](MAX) NOT NULL,
    [Timestamp] [DATETIME] NOT NULL,

    CONSTRAINT FK_Media_UserId FOREIGN KEY ([UserId]) REFERENCES Users(UserId)

);
GO

-- Create a new table called 'Blocks' in schema 'SchemaName'
-- Drop the table if it already exists
IF OBJECT_ID('MediaLikes', 'U') IS NOT NULL
DROP TABLE MediaLikes
GO
-- Create the table in the specified schema
CREATE TABLE MediaLikes
(
    [MediaId] [INT] NOT NULL, -- primary key column
 --   [Type] [NVARCHAR](50) NOT NULL, --Not sure if i'll be needing this. Also it will need a lookup table
    [UserId] [INT] NOT NULL ,
 --  [Timestamp] [DATETIME] NOT NULL
	PRIMARY KEY ([MediaId], [UserId]),
    CONSTRAINT FK_MediaLikes_UserId FOREIGN KEY ([UserId]) REFERENCES Users(UserId),
    CONSTRAINT FK_MediaLikes_MediaId FOREIGN KEY ([MediaId]) REFERENCES Media(MediaId)

);
GO


/*
SP ideas
    -get users taking sexual preference and blocklist into perspective.
    -get connected users.
    -get 
*/

-- Insert rows into table 'TableName'
INSERT INTO users
( -- columns to insert data into
  --  [UserId],
    [Name],
    [Surname],
    [Email],
    [Username],
    [Password]
 /*   [Gender],
    [SexualPreference],
    [Bio],
    [UserLocation],
    [Latitude],
    [Longitude],
    [Tags],
    [Dob],
    [Lastseen],
    [Status]*/
)
VALUES
( -- first row: values for the columns in the list above
    /*1, */'belindaa', 'ngwenyaa', 'bngweny@stu.co.za','bngweny69','whirlpool$d4436955$1$eeef51013511e16a7df91b99e929b537bc98bafa494e93302a85de8545c169faca7eb4db1469466d01309faff1caea2f30986f4298a1288675d030d9bd64003d'
),
( -- second row: values for the columns in the list above
    /*2, */'jacob', 'Urugu', 'bngweny1@stu.co.za','jurugu69','whirlpool$d4436955$1$eeef51013511e16a7df91b99e929b537bc98bafa494e93302a85de8545c169faca7eb4db1469466d01309faff1caea2f30986f4298a1288675d030d9bd64003d'
)
-- add more rows here
GO


INSERT INTO [Media]
(
	[UserId],[Data],[Timestamp]
)
VALUES
(
	1, 'https://images.unsplash.com/photo-1543085785-51370240a12f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60', GETDATE()
),
(
	1, 'https://images.unsplash.com/photo-1543085785-4b68012ab2c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60', GETDATE()
),
(
	1, 'https://images.unsplash.com/photo-1543085784-0b3c85b4e8ac?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60', GETDATE()
),
(
	2, 'https://images.unsplash.com/photo-1492633516601-3fcc7e7f92cc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60', GETDATE()
),
(
	2, 'https://images.unsplash.com/photo-1492633342445-8408e4c17712?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60', GETDATE()
),
(
	2, 'https://images.unsplash.com/photo-1492633423870-43d1cd2775eb?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60', GETDATE()
)
GO


INSERT INTO [NotificationTypes]
(
	[NotificationType]
)
VALUES
(
	'Connect'
),
(
	'Unconnect'
),
(
	'View'
),
(
	'Like'
),
(
	'Unlike'
)
GO

/*
{
    "_id": {
        "$oid": "5d66582fcf6772666fd09bbd"
    },
    "name": "belindaa",
    "surname": "ngwenyaa",
    "email": "bngweny@stu.co.za",
    "username": "bngweny69",
    "password": "whirlpool$d4436955$1$eeef51013511e16a7df91b99e929b537bc98bafa494e93302a85de8545c169faca7eb4db1469466d01309faff1caea2f30986f4298a1288675d030d9bd64003d",
    "connected": [
        "jurugu",
        "bngweny123",
        "pnyovest"
    ],
    "viewed": [
        "bngweny123",
        "jurugu",
        "pnyovest"
    ],
    "liked": [
        "bngweny123",
        "jurugu",
        "pnyovest"
    ],
    "blocklist": [],
    "additional": {
        "gender": "female",
        "sexualpreference": "both",
        "bio": "Everyday is FRiday. ",
        "tags": [
            "doctor",
            "proffessional",
            "modern art"
        ],
        "userlocation": "Cape Town",
        "latitude": -33.937949,
        "longitude": 18.406265,
        "dob": "1 November, 1997"
    },
    "lastseen": 1590947699,
    "status": "online"
}
*/