

CREATE PROCEDURE [dbo].[getShoppingLists] 
	@subscriptionID INT,
	@pageNum INT = 1, 
	@pageSize INT = 25,
	@collectionTotal INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT	@collectionTotal = COUNT([id]) 
	  FROM	[dbo].[ShoppingList]
	 WHERE	subscription_id = @subscriptionID AND is_active = 1;

	SELECT	[id], [subscription_id] SubscriptionId, [name], [create_date] CreateDate, [update_date] UpdateDate, [is_active] IsActive
	  FROM	[dbo].[ShoppingList]
	WHERE	[subscription_id] = @subscriptionID
	ORDER	BY [update_date] DESC
	OFFSET  (@pageNum - 1) * @pageSize ROWS
	FETCH	NEXT @pageSize ROWS ONLY;
END
