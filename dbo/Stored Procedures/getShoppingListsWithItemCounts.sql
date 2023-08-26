
CREATE PROCEDURE [dbo].[getShoppingListsWithItemCounts] 
	@subscriptionID		INT,
	@pageNum			INT = 1, 
	@pageSize			INT = 25,
	@sortBy				VARCHAR(50) = 'name',
	@sortAsc			BIT = 1,
	@collectionTotal	INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[ShoppingList]
	 WHERE	subscription_id = @subscriptionID;


	SELECT	sl.[id], sl.[subscription_id] SubscriptionId, sl.[name], sl.[create_date] CreateDate, 
			sl.[update_date] UpdateDate, sl.[is_active] IsActive, COUNT(sli.id) as ItemCount 
	  FROM	[dbo].[ShoppingList] sl LEFT
	  JOIN	[dbo].[ShoppingListItem] sli
	    ON	sl.id = sli.shopping_list_id LEFT 
	  JOIN	[dbo].[Item] i
		ON	i.id = sli.item_id
	 WHERE	sl.[subscription_id] =  @subscriptionID
	 GROUP	BY sl.[name], sl.[id], sl.[subscription_id], sl.[create_date], sl.[update_date], sl.[is_active]
	 ORDER	BY 
			CASE
				WHEN	@sortAsc != 1 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(sli.id)
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN ''
				WHEN	@sortBy = 'name' THEN sl.[name]
			END ASC,
			CASE
				WHEN	@sortAsc != 1 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN sl.[update_date]
			END ASC, 
			CASE
				WHEN	@sortAsc != 0 THEN 0
				WHEN	@sortBy = 'quantity' THEN COUNT(sli.id) 
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN ''
				WHEN	@sortBy = 'name' THEN sl.[name]
			END DESC,
			CASE
				WHEN	@sortAsc != 0 THEN cast(null as date)
				WHEN	@sortBy = 'date' THEN sl.[update_date]
			END DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;
END