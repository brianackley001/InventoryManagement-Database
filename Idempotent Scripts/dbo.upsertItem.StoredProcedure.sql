/****** Object:  StoredProcedure [dbo].[upsertItem]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertItem]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertItem] AS' 
END
GO

ALTER PROCEDURE [dbo].[upsertItem] 
	@id				INT = NULL,
	@subscriptionID	INT,
	@name			VARCHAR(255),
	@description	VARCHAR(255),
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[Item]([subscription_id], [name], [description])
		VALUES	(@subscriptionID, @name, @description);
	END

	--	UPDATE
	ELSE
	BEGIN
		UPDATE	[dbo].[Item]
		   SET	[name]	 = @name,
				[description] = @description,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id;
	END

END
GO
