-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Coordinates
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		[Latitude],
		[Longitude]
	FROM
		[Users]
	WHERE
		[UserId] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Set_Coordinates
    @UserID /*parameter name*/  INT /*datatype_for_param1*/ = -1, /*default_value_for_param1*/
	@Latitude					DECIMAL,
	@Longitude					DECIMAL
AS
    UPDATE [Users] SET
		[Latitude] = @Latitude,
		[Longitude] = @Longitude
	WHERE
		[UserId] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Profile
    @UserID /*parameter name*/  INT /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		u.[UserId],
        u.[Name],
        u.[Surname],
        u.[Email],
        u.[Username],
        u.[Password],
        u.[Gender],
        u.[SexualPreference],
        u.[Bio],
        u.[UserLocation],
        u.[Latitude],
        u.[Longitude],
        u.[Dob],
		u.[Tags],
        u.[Lastseen],
        u.[Status],
		m.[Data],
		m.[Timestamp]
	FROM
		USERS u
		LEFT JOIN Media m ON m.UserId = u.UserId
	WHERE
		u.UserId = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_AllUsers
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		*
	FROM
		[USERS]
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_User
    @UserID /*parameter name*/  INT /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		u.[UserId],
        u.[Name],
        u.[Surname],
        u.[Email],
        u.[Username],
        u.[Password],
        u.[Gender],
        u.[SexualPreference],
        u.[Bio],
        u.[UserLocation],
        u.[Latitude],
        u.[Longitude],
        u.[Dob],
        u.[Lastseen],
		u.[Tags],
        u.[Status]
	FROM
		[Users] u
	WHERE
		[UserId] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_User_ByUsername
    @Username /*parameter name*/  NVARCHAR(255) /*datatype_for_param1*/ 
AS
    SELECT
		u.[UserId],
        u.[Name],
        u.[Surname],
        u.[Email],
        u.[Username],
        u.[Password],
        u.[Gender],
        u.[SexualPreference],
        u.[Bio],
        u.[UserLocation],
        u.[Latitude],
        u.[Longitude],
        u.[Dob],
        u.[Lastseen],
		u.[Tags],
        u.[Status]
	FROM
		[Users] u
	WHERE
		u.[Username] = @Username
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_User_BySexualPreference
    @SexualPreference /*parameter name*/  NVARCHAR(255) /*datatype_for_param1*/ 
AS
	IF (@SexualPreference = 'Both')
	BEGIN
		SELECT
			*
		FROM
			[Users]
	END
	ELSE
	BEGIN
		SELECT
			u.[UserId],
			u.[Name],
			u.[Surname],
			u.[Email],
			u.[Username],
			u.[Password],
			u.[Gender],
			u.[SexualPreference],
			u.[Bio],
		    u.[UserLocation],
			u.[Latitude],
			u.[Longitude],
			u.[Dob],
			u.[Tags],
			u.[Lastseen],
			u.[Status]
		FROM
			[Users] u
		WHERE
			u.[Gender] = @SexualPreference
	END
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Insert_Media
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param1*/
	@Data					   NVARCHAR(MAX)
AS
    INSERT INTO [Media]
	(
		[UserId],
		[Data],
		[Timestamp]
	)
	VALUES
	(
		@UserID, @Data, GETDATE()
	)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Images
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		*
	FROM
		[Media]
	WHERE
		[UserId] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Messages
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
    @UserID2 /*parameter name*/ int /*datatype_for_param2*/ = -1 /*default_value_for_param2*/
AS
	IF (@UserID1 > 0 AND @UserID2 > 0)
	BEGIN
		SELECT
			*
		FROM
			[Messages]
		WHERE
			([To] = @UserID1 AND [from] = @UserID2)
			OR ([from] = @UserID1 AND [To] = @UserID2)
	END
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_MessageCount
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param2*/
AS
		SELECT
			COUNT(*)
		FROM
			[Messages]
		WHERE
			[To] = @UserID AND
			[read] = 0
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Send_Message
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1,
	@Message					NVARCHAR(Max)
AS
		INSERT INTO [Messages]
		(
			[From],
			[To],
			[Text],
			[read],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, @Message, 0, GETDATE()
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Read_Message
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
    @UserID2 /*parameter name*/ int /*datatype_for_param2*/ = -1 /*default_value_for_param2*/
AS
	IF (@UserID1 > 0 AND @UserID2 > 0)
	BEGIN
		UPDATE [Messages] SET
			[read] = 1
		WHERE
			([To] = @UserID1 AND [from] = @UserID2)
			OR ([from] = @UserID1 AND [To] = @UserID2)
	END
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_ConnectedUsers
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		*
	FROM
		[UserConnections]
	WHERE
		[from]	= @UserID OR
		[To]	= @UserID
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Users_Connected
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ , /*default_value_for_param1*/
	@UserID2					int
AS
    SELECT
		*
	FROM
		[UserConnections]
	WHERE
		([From]	= @UserID1 AND
		[To]	= @UserID2)
		OR ([From] = @UserID2 AND
		[To]	= @UserID1
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Close_Notifications
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    UPDATE [Notifications] SET
		[Viewed] = 1
	WHERE
		([from]	= @UserID OR
		[To]	= @UserID)
	--	AND [NotificationTypeId] = (SELECT [NotificationTypeId] FROM NotificationTypes WHERE [NotificationType] = 'Connected')
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Notifications
    @UserID /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param1*/
AS
    SELECT
		*
	FROM
		[Notifications]
	WHERE
		[To] = @UserID AND
		[Viewed] = 0
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Add_Notifications
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1,
	@Type						int							= -1
AS
		INSERT INTO [Notifications]
		(
			[From],
			[To],
			[Viewed],
			[NotificationTypeId],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, 0, @Type, GETDATE()
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_NotificationCount
    @UserID  /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param2*/
AS
	SELECT
		COUNT(*)
	FROM
		[Notifications]
	WHERE
		[To] = @UserID AND
		[Viewed] = 0
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_AllNotifications
    @UserID  /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param2*/
AS
	SELECT
		*
	FROM
		[Notifications]
	WHERE
		[To] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Register_User
    @Name /*parameter name*/	NVARCHAR(250) /*datatype_for_param1*/,
	@Surname					NVARCHAR(250),
	@Email						NVARCHAR(MAX),
	@Username					NVARCHAR(MAX),
	@Password					NVARCHAR(MAX)	
AS
		INSERT INTO [Users]
		(
			[Name],
			[Surname],
			[Email],
			[Username],
			[Password]
		)
		VALUES
		(
			@Name, @Surname, @Email, @Username, @Password
		)
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Change_Status
    @UserID /*parameter name*/  int /*datatype_for_param1*/ = -1, /*default_value_for_param1*/
	@Status						BIT
AS
    UPDATE [Users] SET
		[Status] = @Status
	WHERE
		[UserId] = @UserID
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Visit_User
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		INSERT INTO [Notifications]
		(
			[From],
			[To],
			[Viewed],
			[NotificationTypeId],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, 0, (SELECT NotificationTypeId FROM NotificationTypes WHERE NotificationType = 'View'), GETDATE()
		)
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_LikePic
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@MediaId					int							= -1
AS
		INSERT INTO [MediaLikes]
		(
			[MediaId],
			[UserId]
		)
		VALUES
		(
			@MediaId, @UserID1
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_UnlikePic
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@MediaId					int							= -1
AS
		DELETE FROM
			[MediaLikes]
		WHERE
			[MediaId] = @MediaId
			AND [UserId] = @UserID1
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_MediaLikes
    @mediaID /*parameter name*/ int /*datatype_for_param1*/, /*default_value_for_param1*/
	@userID						int
AS
    SELECT
		*
	FROM
		[MediaLikes]
	WHERE
		[mediaId] = @mediaID AND
		[userId] = @userID
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_BlockList
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		INSERT INTO [Blocklist]
		(
			[UserId],
			[BlockedUserId],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, GETDATE()
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_Blocklist
    @UserID  /*parameter name*/ int /*datatype_for_param1*/ = -1 /*default_value_for_param2*/
AS
	SELECT
		*
	FROM
		[Blocklist]
	WHERE
		[UserId] = @UserID
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_UnblockUser
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		DELETE FROM
			[Blocklist]
		WHERE
			[UserId] = @UserID1
			AND [BlockedUserId] = @UserID2
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Like_User
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		INSERT INTO [Notifications]
		(
			[From],
			[To],
			[Viewed],
			[NotificationTypeId],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, 0, (SELECT NotificationTypeId FROM NotificationTypes WHERE NotificationType = 'Like'), GETDATE()
		)
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Unlike_User
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		DELETE FROM	[Notifications]
		WHERE
			[From] =  @UserID1 AND 
			[To] =	@UserID2 AND
			[NotificationTypeId] = (SELECT NotificationTypeId FROM NotificationTypes WHERE NotificationType = 'Like')
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Users_Liked
    @UserID1  /*parameter name*/ int /*datatype_for_param1*/, /*default_value_for_param2*/
	@UserID2					 int
AS
	SELECT
		*
	FROM
		[UserViews]
	WHERE
		([From] = @UserID1 AND [To] = @UserID2) AND
		([From] = @UserID2 AND [To] = @UserID1)
GO


-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Connect
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		INSERT INTO [Notifications]
		(
			[From],
			[To],
			[Viewed],
			[NotificationTypeId],
			[Timestamp]
		)
		VALUES
		(
			@UserID1, @UserID2, 0, (SELECT NotificationTypeId FROM NotificationTypes WHERE NotificationType = 'Connect'), GETDATE()
		)
GO

-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Disconnect
    @UserID1 /*parameter name*/ int /*datatype_for_param1*/ = -1, /*default_value_for_param2*/
	@UserID2					int							= -1
AS
		DELETE FROM	[Notifications]
		WHERE
			[From] =  @UserID1 AND 
			[To] =	@UserID2 AND
			[NotificationTypeId] = (SELECT NotificationTypeId FROM NotificationTypes WHERE NotificationType = 'Connect')
GO



-- Create the stored procedure in the specified schema
CREATE PROCEDURE SP_Get_NotificationTypeId
    @Type  /*parameter name*/ NVARCHAR(255) /*datatype_for_param1*/  /*default_value_for_param2*/
AS
	SELECT
		[NotificationTypeId]
	FROM
		[NotificationTypes]
	WHERE
		NotificationType = @Type
GO