/****** Object:  StoredProcedure [dbo].[upsertShoppingListItems]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[upsertShoppingListItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[upsertShoppingListItems] AS' 
END
GO


ALTER PROCEDURE [dbo].[upsertShoppingListItems] 
	@id		INT = NULL,
	@TVP	ShoppingListItemTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	--	INSERT
	IF(ISNULL(@id, -1) = -1)
	BEGIN
		INSERT	INTO [dbo].[ShoppingListItem]([subscription_id], [shopping_list_id], [item_id], [is_active])
			SELECT [subscriptionID], [shoppingListID], [itemID], [isActive]
			  FROM	@TVP;
	END

	--	UPDATE
	IF(ISNULL(@id, -1) > -1)
	BEGIN
		-- Existing Shopping List Items
		UPDATE	[dbo].[ShoppingListItem]
		   SET	[is_active] = t.isActive,
				[update_date] = GETDATE()
		  FROM	@TVP t INNER
		  JOIN	[dbo].[ShoppingListItem] sli 
		    ON	sli.[item_id] = t.[itemID] AND 
				sli.[subscription_id] = t.[subscriptionID] AND 
				sli.[shopping_list_id] = t.[shoppingListID];

		--	Any new adds/inserts to shopping list items
		INSERT INTO [dbo].[ShoppingListItem]([subscription_id], [shopping_list_id], [item_id], [is_active])
			SELECT	[subscriptionID], [shoppingListID], [itemID], [isActive]
			  FROM	@TVP t
			 WHERE  [itemID] NOT IN (
					SELECT	[item_id] 
					  FROM	[dbo].[ShoppingListItem] sli 
					 WHERE	sli.[subscription_id] = t.[subscriptionID] AND 
							sli.[shopping_list_id] = t.[shoppingListID]);		 
	END
END
GO
