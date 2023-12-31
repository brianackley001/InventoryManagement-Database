/****** Object:  StoredProcedure [dbo].[upsertShoppingList]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertShoppingList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertShoppingList] AS' 
END
GO


ALTER PROCEDURE [dbo].[upsertShoppingList] 
	@id 			INT,
	@subscriptionID	INT,
	@name			VARCHAR(255),
	@isActive		BIT = 1
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[ShoppingList]([name],[subscription_id])
		VALUES	(@name, @subscriptionID);
	END

	--	UPDATE
	IF(ISNULL(@id, -1) > -1)
	BEGIN
		UPDATE	[dbo].[ShoppingList]
		   SET	[name]	 = @name,
				[is_active] = @isActive,
				[update_date] = GETDATE()
		 WHERE	[id] = @id AND subscription_id = @subscriptionID;
	END
END
GO
