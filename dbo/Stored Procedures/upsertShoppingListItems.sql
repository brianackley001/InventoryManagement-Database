

CREATE PROCEDURE [dbo].[upsertShoppingListItems] 
	@id		INT = NULL,
	@TVP	ShoppingListItemTVP READONLY
AS
BEGIN
	SET NOCOUNT ON;
	Declare @RetVal INT;
	Set @RetVal = 0;
	
	BEGIN TRY;
		BEGIN TRANSACTION;

			MERGE [dbo].[ShoppingListItem] sli 
			USING @TVP t
			ON (sli.[subscription_id] = t.[subscriptionID] AND 
				sli.[shopping_list_id] = t.[shoppingListID] AND 
				sli.[item_id] = t.[itemID])
			WHEN MATCHED AND t.[isSelected] = 1 THEN 
				UPDATE SET [update_date] = GETDATE(), [is_active] = t.isActive
			WHEN MATCHED AND t.[isSelected] = 0 THEN 
				DELETE
			WHEN NOT MATCHED BY TARGET AND t.[isSelected] = 1 THEN 
				INSERT ([subscription_id],[shopping_list_id], [item_id], [is_active])
				VALUES (t.[subscriptionID], t.[shoppingListID], t.[itemID], t.[isActive]);

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
