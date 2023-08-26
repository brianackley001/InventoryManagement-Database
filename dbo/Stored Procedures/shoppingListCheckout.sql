
CREATE PROCEDURE [dbo].[shoppingListCheckout] 
	@TVP ShoppingListItemTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;

	BEGIN TRY;
		BEGIN TRANSACTION;
		
		-- Update Item Stocked Quantities
		UPDATE	[dbo].[Item]
		   SET	[amount_value] = 2,			-- 0 = empty, 1 = low, 2 = good
				[update_date] = GETDATE()
		  FROM	@TVP t
		 INNER	JOIN [dbo].[Item] i
		    ON	t.itemID = i.id AND t.subscriptionID = i.subscription_id

		-- Update ItemRestock Table accordingly
		INSERT	INTO [dbo].[ItemRestock]([subscription_id], [item_id])
				SELECT subscriptionID, itemID
				  FROM	@TVP;

		-- Remove from [dbo].[ShoppingListItemCheckout]
		DELETE	[dbo].[ShoppingListItemCheckout] 
		  FROM	[dbo].[ShoppingListItemCheckout] ic INNER
		  JOIN	@TVP t
		    ON	t.itemID = ic.item_id AND t.shoppingListID = ic.shopping_list_id;

		COMMIT TRANSACTION;
	
	END TRY
	BEGIN CATCH;
		DECLARE @msg nvarchar(max);
		SET @msg = ERROR_MESSAGE();
		RAISERROR (@msg, 16, 1);
		Set @RetVal = -1;
	
		ROLLBACK TRANSACTION;
	END CATCH;
	RETURN @RetVal;

END
