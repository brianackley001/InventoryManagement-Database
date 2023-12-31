/****** Object:  StoredProcedure [dbo].[getShoppingListItems]    Script Date: 12/1/2019 9:44:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[getShoppingListItems]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[getShoppingListItems] AS' 
END
GO


ALTER PROCEDURE [dbo].[getShoppingListItems] 
	@subscriptionID	INT,
	@shoppingListID	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	sli.[id], sli.[subscription_id], sli.[shopping_list_id], sli.[item_id], sli.[create_date] shopping_list_item_create_date, 
			sli.[update_date], sli.[is_active] shopping_list_item_isactive,
			i.[name] item_name, i.[description] item_description, i.[amount_value], 
			i.[create_date] item_create_date, i.[update_date] item_create_date, i.[is_active] item_isactive
	  FROM	[dbo].[Item] i INNER
	  JOIN	[dbo].[ShoppingListItem] sli
	    ON	i.[id] = sli.[item_id]
	WHERE	sli.[subscription_id] = @subscriptionID AND sli.[shopping_list_id] = @shoppingListID
	ORDER	BY i.[amount_value] ASC, i.[name] ASC;
END
GO
