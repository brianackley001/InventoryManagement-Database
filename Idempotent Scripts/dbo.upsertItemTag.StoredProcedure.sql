/****** Object:  StoredProcedure [dbo].[upsertItemTag]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertItemTag]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertItemTag] AS' 
END
GO

ALTER PROCEDURE [dbo].[upsertItemTag] 
	@id				INT = NULL,
	@itemID			INT,
	@tagID			INT,
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[ItemTag]([item_id], [tag_id])
		VALUES	(@itemID, @tagID);
	END

	--	UPDATE
	ELSE
	BEGIN
		UPDATE	[dbo].[ItemTag]
		   SET	[item_id]	 = @itemID,
				[tag_id] = @tagID,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id;
	END

END
GO
