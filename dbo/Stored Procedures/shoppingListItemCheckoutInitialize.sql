
CREATE PROCEDURE [dbo].[shoppingListItemCheckoutInitialize] 
	@TVP ShoppingListItemTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;

	BEGIN TRY;
		BEGIN TRANSACTION;
			MERGE [dbo].[ShoppingListItemCheckout] ic 
			USING @TVP t
			ON (t.[itemID] = ic.[item_id] AND t.[shoppingListID] = ic.[shopping_list_id])
			WHEN MATCHED THEN 
				UPDATE SET [update_date] = GETDATE()
			WHEN NOT MATCHED BY TARGET THEN 
				INSERT ([shopping_list_id], [item_id])
				VALUES (t.[shoppingListID],t.[itemID]);
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH;
		DECLARE @msg nvarchar(max);
		SET @msg = ERROR_MESSAGE();
		RAISERROR (@msg, 16, 1);
		Set @RetVal = -1;
	
		ROLLBACK TRANSACTION;
	END CATCH;

	SELECT	ic.[id], ic.[shopping_list_id] AS ShoppingListId, ic.[item_id] AS ItemId, ic.[is_selected] AS IsSelected, t.subscriptionID 
	  FROM	[dbo].[ShoppingListItemCheckout] ic INNER
	  JOIN	@TVP t
	    ON	t.[itemID] = ic.[item_id] AND t.[shoppingListID] = ic.[shopping_list_id];

	RETURN @RetVal;

END