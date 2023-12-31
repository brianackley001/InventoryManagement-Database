/****** Object:  StoredProcedure [dbo].[upsertProfileSubscription]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertProfileSubscription]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertProfileSubscription] AS' 
END
GO

ALTER PROCEDURE [dbo].[upsertProfileSubscription] 
	@id					INT = NULL,
	@subscriptionID		INT,
	@profileID			INT,
	@isActiveSelection	BIT = 1,
	@isActive			BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[ProfileSubscription]( [profile_id], [subscription_id], [active_selection])
		VALUES	(@profileID, @subscriptionID, @isActiveSelection)
	END

	--	UPDATE
	ELSE
	BEGIN
		UPDATE	[dbo].[ProfileSubscription]
		   SET	[profile_id]	 = @profileID,
				[subscription_id] = @subscriptionID,
		   		[active_selection]	 = @isActiveSelection,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id;
	END

END
GO
