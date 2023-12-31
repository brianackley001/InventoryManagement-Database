/****** Object:  StoredProcedure [dbo].[upsertItemGroup]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertItemGroup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertItemGroup] AS' 
END
GO

ALTER PROCEDURE [dbo].[upsertItemGroup] 
	@id				INT = NULL,
	@itemID			INT,
	@groupID		INT,
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[ItemGroup]([item_id], [group_id])
		VALUES	(@itemID, @groupID);
	END

	--	UPDATE
	ELSE
	BEGIN
		UPDATE	[dbo].[ItemGroup]
		   SET	[item_id]	 = @itemID,
				[group_id] = @groupID,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id;
	END

END
GO
