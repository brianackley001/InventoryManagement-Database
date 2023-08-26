
CREATE PROCEDURE [dbo].[shoppingListItemCheckoutSync] 
	@shoppingListId int
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT	[id], [shopping_list_id] AS ShoppingListId, [item_id] AS ItemId, [is_selected] AS IsSelected
	  FROM	[dbo].[ShoppingListItemCheckout]
	 WHERE	[shopping_list_id] = @shoppingListId;

END