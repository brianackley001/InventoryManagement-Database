/****** Object:  StoredProcedure [dbo].[upsertProfile]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertProfile]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertProfile] AS' 
END
GO

ALTER PROCEDURE [dbo].[upsertProfile] 
	@id				INT = NULL,
	@authID			VARCHAR(500),
	@source			VARCHAR(100),
	@name			VARCHAR(255),
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[Profile]([auth_id], [source], [name])
		VALUES	(@authID, @source, @name)
	END

	--	UPDATE
	ELSE
	BEGIN
		UPDATE	[dbo].[Profile]
		   SET	[name]	 = @name,
				[auth_id] = @authID,
		   		[source]	 = @source,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id;
	END

END
GO
