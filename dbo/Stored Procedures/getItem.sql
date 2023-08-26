

CREATE PROCEDURE [dbo].[getItem] 
	@id	INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [description], [amount_value] AmountValue, [create_date] CreateDate, 
			[update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[Item]
	WHERE	[id] = @id;

	EXECUTE	[dbo].[getItemGroups] @itemId=@id;

	EXECUTE	[dbo].[getItemTags] @itemId=@id;

	SELECT	sl.[id], sl.[name], sl.[subscription_id] SubscriptionId, sli.[item_id] itemId, sl.[create_date] CreateDate, sl.[update_date] UpdateDate, sl.[is_active] IsActive
	 FROM	[dbo].[ShoppingList] sl INNER
	 JOIN	[dbo].[ShoppingListItem] sli
	   ON	sl.[id] = sli.[shopping_list_id]
	 WHERE	sli.[item_id] = @id;

END
