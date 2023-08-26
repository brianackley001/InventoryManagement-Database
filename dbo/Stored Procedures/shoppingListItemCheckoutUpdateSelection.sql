
CREATE PROCEDURE [dbo].[shoppingListItemCheckoutUpdateSelection] 
	@itemId int,
	@shoppingListId int,
	@selected bit
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;

	BEGIN TRY;
		BEGIN TRANSACTION;
			UPDATE  [dbo].[ShoppingListItemCheckout]
			   SET	[is_selected] = @selected, 
					[update_date] = GETDATE()
			 WHERE	[item_id] = @itemId AND shopping_list_id = @shoppingListId;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH;
		DECLARE @msg nvarchar(max);
		SET @msg = ERROR_MESSAGE();
		RAISERROR (@msg, 16, 1);
		Set @RetVal = -1;
	
		ROLLBACK TRANSACTION;
	END CATCH;
	
	SELECT	[id], [shopping_list_id] AS ShoppingListId, [item_id] AS ItemId, [is_selected] AS IsSelected
	  FROM	[dbo].[ShoppingListItemCheckout]
	 WHERE	[shopping_list_id] = @shoppingListId;
	RETURN @RetVal;

END