/****** Object:  StoredProcedure [dbo].[upsertSubscription]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertSubscription]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertSubscription] AS' 
END
GO



ALTER PROCEDURE [dbo].[upsertSubscription] 
	@id				INT = NULL,
	@name			VARCHAR(255),
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO  [dbo].[Subscription]([name])
		VALUES	(@name)
	END

	--	UPDATE
	IF(ISNULL(@id, -1) > -1)
	BEGIN
		UPDATE	[dbo].[Subscription]
		   SET	[name]	 = @name,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id
	END


END
GO
